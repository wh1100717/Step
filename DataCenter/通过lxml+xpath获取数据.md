
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
    a = soup.findAll('body')
    b = a[0].findAll('section')
    c = b[3].findAll('div')
    print c[2].next
```
还有更快的搜索方式，尝试中
