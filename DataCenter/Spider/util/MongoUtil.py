#!/usr/bin/env python
# -*- coding: utf-8 -*-

import pymongo
from pymongo import MongoClient

config = {
	# 'host': '10.0.1.202',
	'host': '127.0.0.1',
	'port': 27017,
	'db': 'step-dev',
	}

client = MongoClient(config['host'], config['port'])
db = client[config['db']]