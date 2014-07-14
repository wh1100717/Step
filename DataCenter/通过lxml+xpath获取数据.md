
#百度旅游
##一个景点要有的数据
###exp1:日光岩 http://lvyou.baidu.com/riguangyan/
```python
	{
	'parent_scene':['guliangyu',...],//父景点名称 type=list
	'children_scene':['shuicaotai',...],//子景点名称 type=list
	'suggest_play_time':'无',//建议游玩时间
	'Best_tourist_season':'四季皆宜。但是八月份是台风季，出游需要注意安全。',//建议游玩季节
    'Travel_notes':[],//游记 type=list
    'user_Reviews':[],//点评 type=list
    'has_gone':'415',//多少人去过
    'Cultural_Geography':'历史文化俗称“岩仔山...',//文化地理
    'Traffic':'轮船    从鹭江道中山路的轮渡站坐船到鼓浪屿...',//交通
    'Activity'：'鼓浪洞天    日光岩东面巨石匾...',//活动
    'Tickets':'60.00元联票...',//票价
    'Outline':'日光岩位于厦门市鼓...',//摘要
    'address':'福建省厦门市思明区',//地址
    'phone':'咨询：0592-2060777；投诉：0592-2571226',//电话
    'website':'http://www.gly.cn/'//官网
    }
```


##利用lxml+Xpath获取数据
```python
    import urllib2
    from lxml import etree
    response = urllib2.urlopen('http://lvyou.baidu.com/shuicaotai/')
    result = response.read()
    tree=etree.HTML(result)
    content = tree.xpath('//*[@id="J-aside-info-address"]/span[2]/text()')
    
    
```
##利用beautifulSoup获取数据

```python
    from BeautifulSoup import BeautifulSoup
    import urllib2
    response = urllib2.urlopen('http://lvyou.baidu.com/shuicaotai/')
    result = response.read()
    soup = BeautifulSoup(result)
    print soup.find("p", attrs={"class": "text-p text-desc-p"}).next
```

获取景点上级节点
a = soup.findAll("a",attrs={"property":"v:title"})
b = a[len(a)-2].next
去过的人数
a = soup.findAll("span",attrs={"class":"view-head-gray-font"})
a[1].next[1:-1]

景点详细描述
a = soup.findAll("div",attrs={"class":"J-sketch-more-info subview-basicinfo-alert-more"})
for i in a:
    i.next.next

开放时间
a = soup.findAll("div",attrs={"class":"val opening_hours-value"})
建议游玩时间
a = soup.findAll("span",attrs={"class":"val recommend_visit_time-value"})
地址

a = soup.findAll("span",attrs={"class":"val address-value“}）
电话
a = soup.findAll("span",attrs={"class":"val phone-value"}）
最佳旅游时间
a = soup.findAll("span",attrs={"div":"val best-visit-time-value"})


##当前景点数据如下（7-6）
```
    {
    "_id": ObjectId("53a26134d15036291815847c"),
    "content": "秦皇岛，因公元前215年中国的第一个皇帝秦始皇东巡至此，并派人入海求仙而得名，是中国唯一一个因皇帝尊号而得名的城市。万里长城的“龙头”也是在这里入海。",
    "play_time": "2-3天",
    "children_scenes": [
        "北戴河",
        "山海关",
        "南戴河",
        "黄金海岸",
        "燕塞湖",
        "南戴河国际娱乐中心",
        "翡翠岛",
        "鸽子窝公园",
        "老龙头",
        "秦皇求仙入海处",
        "怪楼奇园",
        "怪楼",
        "联峰山",
        "老虎石海上公园",
        "花果山",
        "祖山",
        "新澳海底世界",
        "天下第一关",
        "国际滑沙活动中心",
        "孟姜女庙",
        "角山",
        "秦皇岛野生动物园",
        "桃林口水库",
        "中海滩",
        "秦行宫遗址",
        "望海寺",
        "碧螺塔酒吧公园",
        "抚宁",
        "集发生态农业观光园",
        "昌黎葡萄沟",
        "长寿山",
        "天马山",
        "仙螺岛游乐中心",
        "中华荷园",
        "奥林匹克大道公园",
        "碣石山",
        "北戴河影视城",
        "南戴河海上乐园",
        "山海关海洋水族馆",
        "角山长城",
        "天女峰",
        "源影寺塔",
        "乐岛海洋公园",
        "望海长廊",
        "南戴河国际滑沙中心",
        "浅水湾",
        "画廊谷",
        "山海关古城景区",
        "海上运动场",
        "悬阳洞",
        "仙螺岛",
        "海浴场",
        "黄金溶洞",
        "鹰角亭",
        "金山嘴",
        "板厂峪",
        "碧螺湾乐园",
        "金沙湾海滨浴场",
        "北戴河集发生态农业观光园",
        "董家口长城",
        "飞瀑谷",
        "山海国际冰雪大世界",
        "背牛顶",
        "紫云山滑雪场",
        "秦皇岛龙潭峡",
        "渔岛",
        "传奇小鱼温泉景区",
        "沙雕大世界",
        "求仙入海处",
        "宝峰禅寺",
        "乱刀峪",
        "万博文化城",
        "山海关王家大院民俗博物馆",
        "天马公园",
        "燕塞山滑雪场",
        "月亮湾温泉度假酒店",
        "北戴河自然生态公园",
        "望龟亭",
        "长城文化奇观园",
        "金海湾森林公园",
        "碧水湾浴场",
        "海豚表演馆",
        "李大钊革命活动旧址",
        "华夏长城庄园",
        "澄海楼",
        "秦皇岛奥体中心",
        "鲍子沟",
        "奇岩峡景区",
        "五佛森林公园",
        "神龟探海",
        "柳江国家地质公园",
        "秦皇行宫遗址",
        "桃林湖",
        "六峪山庄",
        "老岭",
        "望峪山庄",
        "国际滑沙娱乐中心",
        "平水桥公园",
        "海滨国家森林公园",
        "汤河公园",
        "法云寺",
        "水岩寺",
        "葡萄沟风景区",
        "华夏庄园",
        "白鹭岛",
        "英武山拓展培训基地",
        "长城号游船",
        "昌黎国际滑沙活动中心",
        "天马山摩崖石刻"
    ],
    "name": "秦皇岛",
    "phone": "",
    "parent_scene": "河北",
    "surl": "qinhuangdao",
    "city_cn": "河北",
    "best_visit_time": "夏秋两季更适宜旅行。但四季各有特色。",
    "has_gone": "6261",
    "location": {
        "latitude": 39.945461565898,
        "longitude": 119.60436761612
    },
    "address": "",
    "open_time": ""
}
```

##需要添加
```
prevince：省
update：更新时间
user：管理员          //我感觉可有可无
category：分类
type：出/入口
acreage：面积
name_en：英文名
location：
    altitude：海拔
    radius：面积
    geo               //当为圆形时，使用radius，不规则图形使用geo
```