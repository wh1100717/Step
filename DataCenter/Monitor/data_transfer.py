#!/usr/bin/Python python
# -*- coding:utf-8 -*-

import pymongo
import argparse
import json
import os
import platform
import traceback
from pymongo import MongoClient

def emptyDB(config):
	try:
		client = MongoClient(config['host'], config['port'])
		db = client[config['db']]
		for collection in db.collection_names():
			if "system" in collection: continue
			db.drop_collection(collection)
	except Exception, e:
		print traceback.format_exc()
		return False
	return True

def toDB(src_config, des_config):
	src_client = MongoClient(src_config['host'], src_config['port'])
	des_client = MongoClient(des_config['host'], des_config['port'])

	src_db = src_client[src_config['db']]
	des_db = des_client[des_config['db']]

	print "Des DB collections are: ",des_db.collection_names()

	#清空目标数据库
	if not emptyDB(des_config): return False
	print "Empty Operation: ",des_db.collection_names()

	#从源数据库拷贝数据至目标数据库
	for collection in src_db.collection_names():
		if "system" in collection: continue
		s = src_db[collection]
		d = des_db[collection]
		for i in s.find():
			d.insert(i)
	print "Done: Now Des DB collections are: ", des_db.collection_names()
	return True

def toFile(src_config, file_config):
	src_client = MongoClient(src_config['host'], src_config['port'])
	src_db = src_client[src_config['db']]
	sysstr = platform.system()
	print sysstr
	if sysstr == "Darwin" or sysstr == "Linux":
		command = src_config['mongo_path'] + "/bin/mongoexport"
		host = src_config['host'] + ":" + str(src_config['port'])
		db = src_config['db']
	
	elif sysstr == "Windows":
		command = src_config['mongo_path'] + "/bin/mongoexport.exe"
		host = src_config['host'] + ":" + str(src_config['port'])
		db = src_config['db']
	else:
		print "Unsupport Operating System! Only Support Mac OS、windows、Ubuntu now."
		return
	for collection in src_db.collection_names():
		if "system" in collection: continue
		outfile = file_config['dir'] + collection + ".json"
		os.system('%s --host %s -d %s -c %s --out %s' %(command, host, db, collection, outfile))
	return True

def fromFile(des_config, file_config):
	des_client = MongoClient(des_config['host'], des_config['port'])
	des_db = des_client[des_config['db']]
	sysstr = platform.system()
	if sysstr == "Darwin" or sysstr == "Linux":
		command = des_config['mongo_path'] + "/bin/mongoimport"
		host = des_config['host'] + ":" + str(des_config['port'])
		db = des_config['db']
	elif sysstr == "Windows":
		command = src_config['mongo_path'] + "/bin/mongoexport.exe"
		host = src_config['host'] + ":" + str(src_config['port'])
		db = src_config['db']
	else:
		print "Unsupport Operating System! Only Support Mac OS、windows、Ubuntu  now."
		return

	file_list = os.listdir(file_config['dir'])
	file_list = [f for f in file_list if f[0] != '.' and f.split('.')[1] == 'json']
	if len(file_list) == 0:
		print "There is no file in the dir %s, are you sure you set a right dir in file_config?" %file_config['dir']
		return False

	#清空数据库
	if not emptyDB(des_config):
		return False

	#遍历目标文件并导入数据库
	for filename in file_list:
		filepath = file_config['dir'] + filename
		collection = filename.split(".")[0]
		os.system("%s --host %s -d %s -c %s --file %s" %(command, host, db, collection, filepath))
	return True

if __name__ == '__main__':
	# 通过argParse进行命令行配置
	localhost_config = {
	'mongo_path':'/home/georgeliang/server/mongodb/',
	'host':'192.168.1.121', 		#源数据库IP
	'port': 27017,
	'db': 'step-dev' 			#对应的db name，默认为step-dev
	}

	remotehost_config = {
<<<<<<< Updated upstream
	'host': '0.0.0.0',
	# 'host': '192.168.1.136', 			#目的数据库IP
=======
	# 'host': '0.0.0.0'
	'host': '127.0.0.1', 			#目的数据库IP
>>>>>>> Stashed changes
	'port': 27017,
	'db': 'step-dev'			#对应的db name，默认为step-dev
	}

	file_config = {
	'dir': 'data/'				#默认数据文件存储的位置
	}

	print "----------------------"
	print "Usage:"
	print "e.g: python data_transfer.py -o someOperation"
	print "-o means operation and you should always point a specific operation."
	print "----------------------"
	print "Available operations are listed below:"
	print "* toFile -> Export data from db to file"
	print "* fromFile -> Import data from file to db"
	print "* emptyDB -> Empty all collection in db"
	print "* localToRemote -> Transfer data from local db to remote db"
	print "* remoteToLocal -> Transfer data from remote db to local db"
	print "----------------------"
	print "**Note**: You should edit the config settings in file by yourself."
	print "----------------------"

	parser = argparse.ArgumentParser(description='Data Transfer Tool')
	parser.add_argument('-o', type=str, dest="operation", default="none", help= "choose which operation you will take, toFile by default")
	args = parser.parse_args()
	if args.operation == "none":
		print "You should use `-o operation` to tell me which operation you want to take."
		exit()
	if args.operation == 'toFile':
		toFile(localhost_config, file_config)
	elif args.operation == 'fromFile':
		fromFile(localhost_config, file_config)
	elif args.operation == 'emptyDB':
		emptyDB(remotehost_config)
	elif args.operation == 'localToRemote':
		toDB(localhost_config, remotehost_config)
	elif args.operation == 'remoteToLocal':
		toDB(remotehost_config, localhost_config)
	else:
		print "Unsupport operation!"
