# Step Data Structure


---

```coffee
{
    name: "天安门"                      	#景区名称
    name_en: "Tian An Men"             	#景区英文名称
    city: "北京市"
    province: "北京市"
    category: "人文景观"                	#景区分类
    alias: ["天安门","天安门城楼"]      	#别名 | 关键字
    location: {
        longitude: 39.915               #经度
        latitude: 116.404               #纬度
        altitude: 100                   #海拔
        radius: 10                      #半径，type为1时使用
        geo: "4|12958055.9,4825906.5;12958289.0,4826146.9|1-12958055.9,4826139.0,12958063,4825906.5,12958289.0,4825913.7,12958279.1,4826146.9,12958055.9,4826139.0;"  	#不规则范围，type为2时使用
        type: 1                         #范围类型，默认为1，表示其为圆形范围; 2表示不规则形范围
        addr: "北京市东城区东长安街"    	#地址
    }
    ext: {
        description: "故宫是个好地方"   	#文字描述
        images: [                       #图片
            '/img/a.png'
            '/img/b.png'
        ]
        audio: '/audio/a.amr'           #语音介绍
        open_time: "4：30——17：00"      	#开放时间
        acreage: 2000                   #面积(平方米)
        ticket_price: 15                #门票价格
        phone: 1888888888               #联系电话
    }
    children: [
        {
            name: "天安门西地铁站A口"
            name_en: "balabala"
            type: "出入口"
            category: 同上
            alias: 同上            		#如果没有，则为[]
            location: {
                longtitude: 同上
                latitude: 同上
                altitude: 同上
                radius: 同上
                geo: 同上
                type: 同上
                addr: 同上
            }
            ext: {
                description: 同上
                images: 同上
                audio: 同上
                open_time: 同上
                acreage: 同上
                ticket_price: 同上
                phone: 同上
            }
        }
    ]
}
```


### Baidu Map Hack

#### 1. 根据关键字获取

```
http://map.baidu.com/?qt=s&wd=故宫&l=1
```

#### 2. 获取区域范围坐标：

```
http://map.baidu.com/?qt=ext&uid=65e1ee886c885190f60e77ff&l=1&ext_ver=new
```

>Note: 根据关键字获取的json数据中通过content中的`ext_type`来进行判断:
>如果`ext_type`为4，则在请求中需要增加`ext_ver=new`参数。
