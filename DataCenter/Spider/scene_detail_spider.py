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
from util import ProxyUtil

'''
#1. 获取 ScenesCollection 中的数据 {name, surl}
#2. 通过 name 模拟查询地图数据
	```
		http://map.baidu.com/?qt=s&wd=#{name}&l=1
	```
	获取对应的uid等信息
#3. 根据对应的 surl 构造请求访问百度旅游中景点详细页
	```
		http://http://lvyou.baidu.com/#{surl}
	```
#4. 对解析出来的数据做格式化处理并更新数据库
'''

ak = "sEMQwtUKqGTucHvsS0ssukrW"

class SceneDetailSpider:

	def __init__(self):
		self._scenes = []
		self._loc_url_template = "http://api.map.baidu.com/geocoder/v2/?address=#{name}&output=json&ak=#{ak}&city=#{city}"
		self._scene_detail_url_template = "http://http://lvyou.baidu.com/#{surl}"
		self._province = ['北京', '天津', '上海', '重庆', '河北', '山西', '辽宁', '吉林', '黑龙江', '江苏', '浙江', '安徽', '福建', '江西', '山东', '河南', '湖北', '湖南', '广东', '海南', '四川', '贵州', '云南', '陕西', '甘肃', '青海']

	def _get_data(self, url):
		headers = {
			#动态更改userAgent
			'User-Agent': ProxyUtil.getRandomUserAgent(),
			'Referer': 'http://127.0.0.1'
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

	def _parse_city(self, city_cn):
		if city_cn in self._province:
			return city_cn + "省"
		else:
			return city_cn + "市"


	def _get_location(self, name, city_cn):
		url = self._loc_url_template.replace('#{name}', name).replace('#{ak}', ak).replace('#{city}', self._parse_city(city_cn))
		print url
		data = self._get_data(url)
		data = self._to_dict(data)
		if data['status'] == 0 and data.has_key('result'):
			print data
			return (data['result']['location']['lng'], data['result']['location']['lat'])
		else:
			print "---------------------------------------------"
			print "Did Not Find Required Data!\n"
			print "The Data is: ", data
			print "---------------------------------------------"
		return (0,0)

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

	def _update_mongo(self):
		ScenesCollection = MongoUtil.db.scene
		for scene in self._scenes:
			ScenesCollection.update({'name': scene['name'],'city_cn': scene['city_cn']}, {'$set': scene})



	def run(self):
		self._get_scene_list_from_mongo()
		print "Scenes Count:", len(self._scenes)
		for scene in self._scenes:
			#如果scene中没有location信息，则获取location
			if not scene.has_key('location'):
				(lng, lat) = self._get_location(scene['name'],scene['city_cn'])
				if (lng, lat) != (0, 0):
					scene['location'] = {'longitude': lng, 'latitude': lat}
		self._update_mongo()





def populate():
	sd_spider = SceneDetailSpider()
	sd_spider.run()

def test():
	sd_spider = SceneDetailSpider()
	sd_spider._get_location("蔚县","河北")

populate()
# test()

