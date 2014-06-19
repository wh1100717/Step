#!/usr/bin/env python
# -*- coding:utf-8 -*-

import sys
reload(sys)
sys.setdefaultencoding('utf-8')

import scene_detail_spider
import scene_name_spider

scene_name_spider.populate()
scene_detail_spider.populate()