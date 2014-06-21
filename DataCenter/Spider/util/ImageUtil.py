#!/usr/bin/env python
# -*- coding:utf-8 -*-
import urllib2

def download(url, path):
	file_name = url.split('/')[-1]
	print "Start downloading image '%s' to path '%s'" %(file_name, path)
	socket = urllib2.urlopen(url)
	data = socket.read()
	with open(path + file_name, "wb") as f:
		f.write(data)
	socket.close()
	print "Download Finish!"


#Test
url = "http://hiphotos.baidu.com/lvpics/pic/item/30adcbef76094b360e2afd4ba3cc7cd98c109dd8.jpg"
path = "./"
download(url, path)
