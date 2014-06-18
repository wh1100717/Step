#!/usr/bin/env python
# -*- coding:utf-8 -*-

import sys
reload(sys)
sys.setdefaultencoding('utf-8')

import requests
import json
import time
import traceback
from util import ProxyUtil
from util import MongoUtil
from util import PinyinUtil

'''
# 根据城市获取景点名称name及surl(用于构造景点详细页内容的请求)

http://lvyou.baidu.com/destination/ajax/jingdian?format=ajax&surl=#{1}&pn=#{2}
'''
class SceneNameSpider:
	'''
	 # 初始化SceneNameSpider类时，需要指定config的内容，其中包括以下内容：
	 *	city_cn   	城市中文名
	 *	city 		城市中文名对应的拼音
	'''
	def __init__(self, config):
		self._scene_url_template = "http://lvyou.baidu.com/destination/ajax/jingdian?format=ajax&surl=#{1}&pn=#{2}"
		self._city_cn = config['city_cn']
		self._city = config['city']
		self._scenes = []

	def _get_url(self, page_index):
		print self._city
		url = self._scene_url_template.replace('#{1}', self._city).replace('#{2}', str(page_index))
		print "Paring url: ",url
		return url

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

	def _to_dict(self,string):
		try:
			return json.loads(string.encode('utf-8','ignore'))
		except Exception, e:
			print traceback.format_exc()
			return None

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
			s = {}
			s['name'] = scene['sname'].encode('utf-8','ignore')
			s['surl'] = scene['surl'].encode('utf-8','ignore')
			s['city_cn'] = self._city_cn
			self._scenes.append(s)
		return True

	def _save_to_mongo(self):
		ScenesCollection = MongoUtil.db.scenes
		CitiesCollection = MongoUtil.db.cities
		s_name_list = set()
		#ScenesCollection insert操作，将抓取到的经典名插入到Mongo中
		for scene in self._scenes:
			s_name_list.add(scene['name'])
			if not ScenesCollection.find_one({'name':scene['name'],'city_cn': scene['city_cn']}):
				times = 0
				while times < 10:
					try:
						ScenesCollection.save(scene)
						break
					except Exception, e:
						print traceback.format_exc()
						print "ScenesCollection Update Times: ", times
						times += 1
				if times >= 10: return None
		times = 0
		#CitiesCollection update操作，更新对应城市的景点信息
		while times < 10:
			try:
				CitiesCollection.update({'name': self._city_cn},{'$set':{'scenes':list(s_name_list)}}, safe=True, upsert=True)
				break
			except Exception, e:
				print traceback.format_exc()
				print "CitiesCollection Update Times: ", times
				times += 1
		if times >= 10: return None
		print "DataBase Consistent finished!"
		return True

	def run(self):
		page_index = 1
		while True:
			time.sleep(ProxyUtil.getRandomDelayTime())
			url = self._get_url(page_index)
			data = self._get_data(url)
			if not self._get_name(data): break
			page_index += 1
			print " The %s page finished!" %(str(page_index -1))
		self._save_to_mongo()
		return False if page_index == 1 else True

def populate():
	prov_city = {
		'p': ['河北', '山西', '辽宁', '吉林', '黑龙江', '江苏', '浙江', '安徽', '福建', '江西', '山东', '河南', '湖北', '湖南', '广东', '海南', '四川', '贵州', '云南', '陕西', '甘肃', '青海', '西藏', '内蒙古', '广西', '宁夏', '新疆'],
		'c': ['北京', '天津', '上海', '重庆', '石家庄', '唐山', '秦皇岛', '邯郸', '邢台', '保定', '张家口', '承德', '沧州', '廊坊', '衡水', '太原', '大同', '阳泉', '长治', '晋城', '朔州', '晋中', '运城', '忻州', '临汾', '吕梁', '沈阳', '大连', '鞍山', '抚顺', '本溪', '丹东', '锦州', '营口', '阜新', '辽阳', '盘锦', '铁岭', '朝阳', '葫芦岛', '长春', '吉林', '四平', '辽源', '通化', '白山', '松原', '白城', '延边', '哈尔滨', '齐齐哈尔', '鸡西', '鹤岗', '双鸭山', '大庆', '伊春', '佳木斯', '七台河', '牡丹江', '黑河', '绥化', '大兴安岭', '南京', '无锡', '徐州', '常州', '苏州', '南通', '连云港', '淮安', '盐城', '扬州', '镇江', '泰州', '宿迁', '杭州', '宁波', '温州', '嘉兴', '湖州', '绍兴', '金华', '衢州', '舟山', '台州', '丽水', '合肥', '芜湖', '蚌埠', '淮南', '马鞍山', '淮北', '铜陵', '安庆', '黄山', '滁州', '阜阳', '宿州', '六安', '亳州', '池州', '宣城', '福州', '厦门', '莆田', '三明', '泉州', '漳州', '南平', '龙岩', '宁德', '南昌', '景德镇', '萍乡', '九江', '新余', '鹰潭', '赣州', '吉安', '宜春', '抚州', '上饶', '济南', '青岛', '淄博', '枣庄', '东营', '烟台', '潍坊', '济宁', '泰安', '威海', '日照', '莱芜', '临沂', '德州', '聊城', '滨州', '菏泽', '郑州', '开封', '洛阳', '平顶山', '安阳', '鹤壁', '新乡', '焦作', '濮阳', '许昌', '漯河', '三门峡', '南阳', '商丘', '信阳', '周口', '驻马店', '武汉', '黄石', '十堰', '宜昌', '襄阳', '鄂州', '荆门', '孝感', '荆州', '黄冈', '咸宁', '随州', '恩施', '长沙', '株洲', '湘潭', '衡阳', '邵阳', '岳阳', '常德', '张家界', '益阳', '郴州', '永州', '怀化', '娄底', '湘西', '广州', '韶关', '深圳', '珠海', '汕头', '佛山', '江门', '湛江', '茂名', '肇庆', '惠州', '梅州', '汕尾', '河源', '阳江', '清远', '东莞', '中山', '潮州', '揭阳', '云浮', '海口', '三亚', '成都', '自贡', '攀枝花', '泸州', '德阳', '绵阳', '广元', '遂宁', '内江', '乐山', '南充', '眉山', '宜宾', '广安', '达州', '雅安', '巴中', '资阳', '阿坝', '甘孜', '凉山', '贵阳', '六盘水', '遵义', '安顺', '毕节', '铜仁', '昆明', '曲靖', '玉溪', '保山', '昭通', '丽江', '普洱', '临沧', '楚雄', '红河', '文山', '西双版纳', '大理', '德宏', '怒江', '迪庆', '西安', '铜川', '宝鸡', '咸阳', '渭南', '延安', '汉中', '榆林', '安康', '商洛', '兰州', '嘉峪关', '金昌', '白银', '天水', '武威', '张掖', '平凉', '酒泉', '庆阳', '定西', '陇南', '临夏', '甘南', '西宁', '海东地区', '海北', '黄南', '果洛', '玉树', '海西', '呼和浩特', '包头', '乌海', '赤峰', '通辽', '鄂尔多斯', '呼伦贝尔', '巴彦淖尔', '乌兰察布', '锡林郭勒盟', '阿拉善盟', '南宁', '柳州', '桂林', '梧州', '北海', '防城港', '钦州', '贵港', '玉林', '百色', '贺州', '河池', '来宾', '崇左', '拉萨', '银川', '石嘴山', '吴忠', '固原', '中卫', '乌鲁木齐', '克拉玛依', '吐鲁番', '哈密', '昌吉', '博尔塔拉', '巴音郭楞']
	}
	piny = PinyinUtil.PinYin()
	for place in prov_city['p'] + prov_city['c']:
		config = {'city': piny.hanzi2pinyin_split(place), 'city_cn': place}
		print config
		sn_spider = SceneNameSpider(config)
		state = sn_spider.run()
		print "state: ",state
		if not state:
			with open('wrong_city_name.txt','a') as outfile:
				outfile.write(place + "\n")
	print "All cities grab has been Done! WOW"

populate()



