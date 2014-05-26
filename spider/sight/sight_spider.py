#!/usr/bin/env python
# -*- coding:utf-8 -*-


import argparse
import sys
import os
reload(sys)
sys.setdefaultencoding('utf-8')

import requests
import json
from BeautifulSoup import BeautifulSoup
from util import pinyin
from util import AgentPoolUtil


'''
#### 1. 根据城市获取景点

```
http://lvyou.baidu.com/destination/ajax/jingdian?format=ajax&surl=#{1}&pn=#{2}
```


#### 2. 根据关键字获取

```
http://map.baidu.com/?qt=s&wd=故宫&l=1
```

#### 3. 获取区域范围坐标：

```
http://map.baidu.com/?qt=ext&uid=65e1ee886c885190f60e77ff&l=1&ext_ver=new
```

>Note: 根据关键字获取的json数据中通过content中的`ext_type`来进行判断:
>如果`ext_type`为4，则在请求中需要增加`ext_ver=new`参数。
'''

Config = {
	"encoding": 'gbk',
	"scene_file_template": 'scenes/#{1}.json'
}

class Spider:

	def __init__(self, args):
		self._city = args.city
		self._scene = []
		# self.url_template = "http://lvyou.baidu.com/destination/ajax/jingdian?format=ajax&surl=beijing&pn=3"
		self._url_template = "http://lvyou.baidu.com/destination/ajax/jingdian?format=ajax&surl=#{1}&pn=#{2}"

	def _get_url(self, city, page_index):
		return self._url_template.replace('#{1}', city).replace('#{2}',str(page_index))

	def _data(self, url):
		headers = {
			#动态更改userAgent
			'User-Agent': AgentPoolUtil.getRandomUserAgent()
		}
		times = 0
		while times < 10:
			try:
				response  = requests.get(url, headers = headers)
				#设置返回值的编码
				response.encoding = Config['encoding']
				return response.text
			except Exception, e:
				print e
				times += 1
		return ""

	def _dict(self, string):
		try:
			return json.loads(string)
		except Exception, e:
			return None

	def _spot(self, data):
		if data is "": return True
		data = self._dict(data)
		scene_list = data['data']['scene_list']
		if len(scene_list) <= 0:
			return False
		for scene in scene_list:
			s = {}
			s['sname'] = scene['sname'].encode('utf-8','ignore')
			s['surl'] = scene['surl'].encode('utf-8','ignore')
			s['ambiguity_sname'] = scene['ambiguity_sname'].encode('utf-8','ignore')
			s['place_name'] = scene['place_name'].encode('utf-8','ignore')
			s['address'] = scene['ext']['address'].encode('utf-8','ignore')
			s['phone'] = scene['ext']['phone'].encode('utf-8','ignore')
			s['abs_desc'] = scene['ext']['abs_desc'].encode('utf-8','ignore')
			s['sketch_desc'] = scene['ext']['sketch_desc'].encode('utf-8','ignore')
			s['more_desc'] = scene['ext']['more_desc'].encode('utf-8','ignore')
			s['cover'] = scene['cover']['full_url'].encode('utf-8','ignore')

			self._scene.append(s)
		return True

	def _save_to_file(self):
		file_name = Config['scene_file_template'].replace('#{1}',self._city)
		print self._scene
		with open(file_name, 'w') as outfile:
			json.dump(self._scene, outfile, ensure_ascii=False, indent=4)

	def grab(self):
		flag = True
		city = self._city
		page_index = 105

		while(flag):
			url = self._get_url(city, page_index)
			data = self._data(url)
			if not self._spot(data):
				flag = False
			else:
				page_index += 1
			print "The %s page finished!" %(str(page_index-1))
		self._save_to_file()
		print "all finish!"








if __name__ == '__main__':
	#通过argParse进行命令行配置
	parser = argparse.ArgumentParser(description='get sight spot from baidu')

	#设置需要抓取的城市
	parser.add_argument('-c', type=str, dest="city", default="beijing", help="config the city, beijing by default")

	parser.add_argument('-m', type=int, dest="max_spot", help="config the max spot would be crawled")

	args = parser.parse_args()

	if ord(args.city[0]) > 127:
		pinyin = pinyin.PinYin()
		args.city = "".join(pinyin.hanzi2pinyin(args.city))
	print "The crawling city of sight spots is: ", args.city

	spider = Spider(args)
	scene = spider.grab()
