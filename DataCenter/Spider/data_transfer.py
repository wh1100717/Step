#!/usr/bin/env python
# -*- coding:utf-8 -*-

import pymongo
import argparse
from pymongo import MongoClient

src_config = {
	'host': '', 				#源数据库IP
	'port': 27017,
	'db': 'step-dev' 			#对应的db name，默认为step-dev
}

des_config = {
	'host': '127.0.0.1', 	#目的数据库IP
	'port': 27017,
	'db': 'step-dev'			#对应的db name，默认为step-dev
}

file_config = {
	path: '/data'			#默认数据文件存储的位置
}

src_client = MongoClient(src_config['host'], src_config['port'])
des_client = MongoClient(des_config['host'], des_config['port'])

def toDB():

	src_db = src_client[src_config['db']]
	des_db = des_client[des_config['db']]

	print "Des DB collections are: ",des_db.collection_names()

	#清空目标数据库
	for collection in des_db.collection_names():
		if collection != "system.indexes":
			des_db.drop_collection(collection)

	print "Empty Operation: ",des_db.collection_names()

	#从源数据库拷贝数据至目标数据库
	for collection in src_db.collection_names():
		if collection != "system.indexes":
			s = src_db[collection]
			d = des_db[collection]
			for i in s.find():
				d.insert(i)

	print "Done: Now Des DB collections are: ", des_db.collection_names()



