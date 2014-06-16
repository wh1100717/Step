#!/usr/bin/env python
# -*- coding:utf-8 -*-

import sys
reload(sys)
sys.setdefaultencoding('utf-8')

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
