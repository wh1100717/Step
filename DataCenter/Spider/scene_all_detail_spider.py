#!/usr/bin/env python
# -*- coding:utf-8 -*-

import sys
reload(sys)
sys.setdefaultencoding('utf-8')

from BeautifulSoup import BeautifulSoup
import urllib2
import requests
import traceback
from util import MongoUtil
from util import ProxyUtil

class SceneAllDetailSpider:
	def __init__(self):
		self._scenes=[]
		self._scenes_url_template = "http://lvyou.baidu.com/#{surl}/"
	def _get_detail(self,url):
		headers = {
			#动态更改userAgent
			'User-Agent': ProxyUtil.getRandomUserAgent(),
			'Referer': 'http://127.0.0.1'
		}
		times = 0
		while times < 10:
			try:
				req = urllib2.Request(url, headers=headers)
				
				return urllib2.urlopen(req).read()
			except Exception, e:
				print traceback.format_exc()
				times += 1
	def _get_scene_list_from_mongo(self):
		ScenesCollection = MongoUtil.db.scenes
		for scene in ScenesCollection.find():
			self._scenes.append(scene)

	def _get_scene_detail(self,surl):
		url = self._scenes_url_template.replace('#{surl}',surl)
		data = self._get_detail(url)
		soup = BeautifulSoup(data)
		scene_detail = {}
		scene_detail['outline'] = soup.find("p", attrs={"class": "text-p text-desc-p"}).next
		print scene_detail['outline']
		print scene_detail
		return scene_detail



	def run(self):
		self._get_scene_list_from_mongo()
		ScenesCollection = MongoUtil.db.scenes
		for scene in self._scenes:
			print scene['surl']
			scene_detail = self._get_scene_detail(scene['surl'])
			ScenesCollection.update({'name': scene['name'],'city_cn': scene['city_cn']}, {'$set': scene_detail})


def populate():
	sal_spider = SceneAllDetailSpider()
	sal_spider.run()
def test():
	sal_spider = SceneAllDetailSpider()
	sal_spider._get_scene_detail("gulangyu")

test()
