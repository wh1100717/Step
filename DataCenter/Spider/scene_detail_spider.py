#!/usr/bin/env python
# -*- coding:utf-8 -*-

import sys
reload(sys)
sys.setdefaultencoding('utf-8')

import requests
import json
import traceback
from BeautifulSoup import BeautifulSoup
from util import MongoUtil

'''
#1. 获取 ScenesCollection 中的数据 {name, surl}
#2. 通过 name 模拟查询地图数据
	```
		http://map.baidu.com/?qt=s&wd=#{name}&l=1
	```
	获取对应的uid等信息
#3. 通过 uid 来查询区域范围坐标等信息
	```
		http://map.baidu.com/?qt=ext&uid=#{uid}&l=1&ext_ver=new
	```
#4. 根据对应的 surl 构造请求访问百度旅游中景点详细页
	```
		http://http://lvyou.baidu.com/#{surl}
	```
#5. 对解析出来的数据做格式化处理并更新数据库
'''

class SceneDetailSpider:

	def __init__(self):
		self._scenes = []
		self._loc_url_template = "http://map.baidu.com/?qt=s&wd=#{name}&l=1"
		self._area_url_template = "http://map.baidu.com/?qt=ext&uid=#{uid}&l=1&ext_ver=new"
		self._scene_detail_url_template = "http://http://lvyou.baidu.com/#{surl}"

	def _get_area_url(self, uid):
		return self._area_url_template.replace('#{uid}', uid)

	def _get_scene_detail_url(self, surl):
		return self._scene_detail_url_template.replace('#{surl}', surl)

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
	def _to_dict(self, string):
		try:
			return json.loads(string.encode('utf-8','ignore'))
		except Exception, e:
			print traceback.format_exc()
			return None

	def _get_loc(self, name):
		url = self._loc_url_template.replace('#{name}', name)
		data = self._get_data(url)
		print data

	def _get_area(self, uid):
		url = self._area_url_template.replace('#{uid}', uid)
		data = self._get_data(url)
		print data

	def _get_scene_detail(self, surl):
		url = self._scene_detail_url_template.replace('#{surl}', surl)
		data = self._get_data(url)
		print data

	def _get_scene_list_from_mongo(self):
		ScenesCollection = MongoUtil.db.scenes
		for scene in ScenesCollection.find():
			self._scenes.append(scene)

	def run(self):
		self._get_scene_list_from_mongo()
		print "Scenes Count:", len(self._scenes)
		for scene in self._scenes:
			name = scene['name']


def populate():
	sd_spider = SceneDetailSpider()
	sd_spider.run()

def test():
	sd_spider = SceneDetailSpider()
	sd_spider._get_loc("故宫")



