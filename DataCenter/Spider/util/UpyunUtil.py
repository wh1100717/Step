#!/usr/bin/env python
# -*- coding:utf-8 -*-

import upyun

img_up = upyun.UpYun('westep-img', 'westep', 'westep0000', timeout=60, endpoint=upyun.ED_AUTO)
file_up = upyun.UpYun('westep-file', 'westep', 'westep0000', timeout=60, endpoint=upyun.ED_AUTO)

def img_upload(img_path,remote_dir):
	img_name = img_path.split("/")[-1]
	print "Start upload image '%s' to remote_dir '%s'" %(img_name, remote_dir)
	with open(img_path, 'rb') as f:
		res = img_up.put(remote_dir + img_name, f, checksum=True)
	print "Image Upload Finish"

def file_upload(file_path,remote_dir):
	file_name = file_path.split("/")[-1]
	print "Start upload file '%s' to remote_dir '%s'" %(file_name, remote_dir)
	with open(file_path, 'rb') as f:
		res = file_up.put(remote_dir + file_name, f, checksum=True)
	print "File Upload Finish"

#test
img_upload("30adcbef76094b360e2afd4ba3cc7cd98c109dd8.jpg", "/test/30adcbef76094b360e2afd4ba3cc7cd98c109dd8.jpg")
file_upload("30adcbef76094b360e2afd4ba3cc7cd98c109dd8.jpg", "/test/30adcbef76094b360e2afd4ba3cc7cd98c109dd8.jpg")

#访问以下网址来查看上传是否成功
#http://westep-img.b0.upaiyun.com/test/30adcbef76094b360e2afd4ba3cc7cd98c109dd8.jpg
#http://westep-file.b0.upaiyun.com/test/30adcbef76094b360e2afd4ba3cc7cd98c109dd8.jpg
