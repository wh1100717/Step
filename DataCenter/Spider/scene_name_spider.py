#!/usr/bin/env python
# -*- coding:utf-8 -*-

import sys
reload(sys)
sys.setdefaultencoding('utf-8')

import requests
import json
import traceback
from BeautifulSoup import BeautifulSoup
from util import ProxyUtil
from util import MongoUtil

'''
# 根据城市获取景点名称name及surl(用于构造景点详细页内容的请求)

http://lvyou.baidu.com/destination/ajax/jingdian?format=ajax&surl=#{1}&pn=#{2}
'''

class SceneNameSpider:
	'''
	 # 初始化SceneNameSpider类时，需要指定config的内容，其中包括以下内容：
	 *	city_cn   	城市中文名
	 *	city 		城市中文名对应的拼音
	'''
	def __init__(self, city):
		self._scene_url_template = "http://lvyou.baidu.com/destination/ajax/jingdian?format=ajax&surl=#{1}&pn=#{2}"
		self._city_cn = config._city_cn
		self._city = config.city
		self._scenes = []

	def _get_url(self, city, page_index):
		return self._scene_template.replace('#{1}', city).replace('#{2}', str(page_index))

	def _get_data(self, url):
		headers = {
			#动态更改userAgent
			'User-Agent': ProxyUtil.getRandomUserAgent()
		}
		times = 0
		while times < 10:
			try:
				response = requests.get(url, headers=headers)
				response.encoding = 'gbk'
				return response.text
			except Exception, e:
				print traceback.format_exc()
				times += 1

	def _to_dict(self,string):
		try:
			return json.loads(string.encode('utf-8','ignore'))
		except Exception, e:
			print traceback.format_exc()
			return None

	def _get_name(self, data):
		if data is "": return False
		data = self._to_dict(data)
		if data is None: return False
		try:
			scene_list = data['data']['scene_list']
		except Exception, e:
			print traceback.format_exc()
			return False
		if len(scene_list) <= 0: return False
		for scene in scene_list:
			s = {}
			s['name'] = scene['sname'].encode('utf-8','ignore')
			s['surl'] = scene['surl'].encode('utf-8','ignore')
			self._scenes.append(s)

	def _save_to_mongo(self):
		ScenesCollection = MongoUtil.db.scenes
		CitiesCollection = MongoUtil.db.cities
		s_name_list = set()
		#ScenesCollection insert操作，将抓取到的经典名插入到Mongo中
		for scene in self._scenes:
			s_name_list.add(scene['name'])
			if not ScenesCollection.find({'name':scene['name']}):
				times = 0
				while times < 10:
					try:
						ScenesCollection.save(scene)
						break
					except Exception, e:
						print traceback.format_exc()
						print "ScenesCollection Update Times: ", times
						times += 1
				if times >= 10: return None
		times = 0
		#CitiesCollection update操作，更新对应城市的景点信息
		while times < 10:
			try:
				CitiesCollection.update({'name': self._city_cn},{'$set':{'scenes':list(s_name_list)}}, safe=True, upsert=True)
				break
			except Exception, e:
				print traceback.format_exc()
				print "CitiesCollection Update Times: ", times
				times += 1
		if times >= 10: return None
		print "DataBase Consistent Done!"
		return True

	def run(self):
		city = self._city
		page_index = 1
		while True:
			url = self._get_url(city, page_index)
			data = self._get_data(url)
			if not self._get_name(data): break
			page_index += 1
			print " The %s page finished!" %(str(page_index -1))
		self._save_to_mongo()






