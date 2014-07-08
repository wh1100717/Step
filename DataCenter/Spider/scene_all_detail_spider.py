#!/usr/bin/env python
# -*- coding:utf-8 -*-

import sys
reload(sys)
sys.setdefaultencoding('utf-8')

from BeautifulSoup import BeautifulSoup
import urllib2
import requests
import traceback
import time
import json
from util import MongoUtil
from util import ProxyUtil

class SceneAllDetailSpider:
	#初始化
	def __init__(self):
		self._scenes = []
		self._scene_detail = {}
		self._scenes_url_template = "http://lvyou.baidu.com/#{surl}/"
	#获取景点信息
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
	#获取scenes表中的数据
	def _get_scene_list_from_mongo(self):
		ScenesCollection = MongoUtil.db.scenes
		for scene in ScenesCollection.find():
			self._scenes.append(scene)
	#通过beautifulsoup获取网页中景点信息
	def _get_scene_detail(self,surl):
		url = self._scenes_url_template.replace('#{surl}',surl)
		data = self._get_detail(url)
		soup = BeautifulSoup(data)
		parent_scene = soup.findAll("a",attrs={"property":"v:title"})
		self._scene_detail['parent_scene'] = parent_scene[len(parent_scene)-2].next
		has_gone = soup.findAll("span",attrs={"class":"view-head-gray-font"})
		self._scene_detail['has_gone'] = has_gone[1].next[1:-1]
		self._scene_detail['content'] = []
		tmp = soup.findAll("div",attrs={"class":"J-sketch-more-info subview-basicinfo-alert-more"})
		if len(tmp) == 0:
			tmp = soup.findAll("span",attrs={"class":"view-head-scene-abstract"})
		if len(tmp) == 0:
			tmp = soup.findAll("div",attrs={"id":"J_scene-desc-all"})
		
		tmp = tmp[0].findAll("p",attrs={"class":"text-p text-desc-p"})

		# print len(tmp)
		for i in tmp:
			self._scene_detail['content'].append(i.next)
		self._scene_detail['content'] = ''.join(self._scene_detail['content'])
		# for i in tmp[0].findAll("p",attrs={"class":"text-p text-desc-p"}):
		# 	print i.next.next
		# 	scene_detail['content'].append(i.next.next)
		# scene_detail['content'] = ''.join(scene_detail['content'])
		open_time = soup.find("div",attrs={"class":"val opening_hours-value"})
		self._scene_detail['open_time'] = open_time.next.next if open_time != None else ""
		play_time = soup.find("span",attrs={"class":"val recommend_visit_time-value"})
		self._scene_detail['play_time'] = play_time.next if play_time !=None else ""
		address = soup.find("span",attrs={"class":"val address-value"})
		self._scene_detail['address'] = address.next if address != None else ""
		phone = soup.find("span",attrs={"class":"val phone-value"})
		self._scene_detail['phone'] = phone.next if phone != None else ""
		best_visit_time = soup.find("div",attrs={"class":"val best-visit-time-value"})
		self._scene_detail['best_visit_time'] =  best_visit_time.next.next if best_visit_time != None else ""
		self._scene_detail['children_scenes'] = []
		self._get_children_scenes(surl)
		self._scene_detail['remark_num'] = soup.find("a",attrs={"href":"#scene-remark-anchor"}).find("span").next[1:-1]
		for i in self._scene_detail.keys():
			print self._scene_detail[i]
		print self._scene_detail
		return self._scene_detail
	#获取景点子景点
	def _get_children_scenes(self,surl):
		children_url = "http://lvyou.baidu.com/destination/ajax/jingdian?format=ajax&surl=#{1}&pn=#{2}"
		page_index = 1
		while True:
			time.sleep(ProxyUtil.getRandomDelayTime())
			url = children_url.replace('#{1}', surl).replace('#{2}', str(page_index))
			data = self._get_data(url)
			if not self._get_name(data): break
			page_index += 1
	#获取子景点数据
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
	#获取子景点名称
	def _get_name(self, data):
		if data is "": 
			print "Data is Empty!"
			return False
		data = self._to_dict(data)
		if data is None: 
			print "Data is None"
			return False
		try:
			scene_list = data['data']['scene_list']
		except Exception, e:
			print traceback.format_exc()
			return False
		if len(scene_list) <= 0: 
			return False

		for scene in scene_list:
			
			self._scene_detail['children_scenes'].append(scene['sname'].encode('utf-8','ignore'))
		return True
	#str转json
	def _to_dict(self,string):
		try:
			return json.loads(string.encode('utf-8','ignore'))
		except Exception, e:
			print traceback.format_exc()
			return None

	# def _get_remark(self,surl,):
	# 	url = "http://lvyou.baidu.com/search/ajax/search?format=ajax&word=%E9%BC%93%E6%B5%AA%E5%B1%BF&father_place=%E5%8E%A6%E9%97%A8"

	def run(self):
		self._get_scene_list_from_mongo()
		ScenesCollection = MongoUtil.db.scenes
		SceneDetailsCollection = MongoUtil.db.scenedetails
		for scene in self._scenes:
			print scene['surl']
			self._scene_detail = {}
			self._get_scene_detail(scene['surl'])
			print dict(scene, **self._scene_detail)
			SceneDetailsCollection.update({'name': scene['name'],'city_cn': scene['city_cn']}, {'$set': dict(scene, **self._scene_detail)},upsert=True)
		# scene = self._scenes[0]
		# print scene['surl']
		# self._scene_detail = {}
		# self._get_scene_detail(scene['surl'])
		# SceneDetailsCollection.insert(dict(scene, **self._scene_detail))


def populate():
	sal_spider = SceneAllDetailSpider()
	sal_spider.run()
def test():
	sal_spider = SceneAllDetailSpider()
	sal_spider._get_scene_detail("shuangyashan")

populate()
# test()