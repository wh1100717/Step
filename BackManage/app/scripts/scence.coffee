"use strict"

root = exports ? this

#初始化
$ ->
	#地图初始化
	root.scene_map = new BMap.Map "allmap"
	root.markpoints= new Array()
	root.markers= new Array()
	scene_map.centerAndZoom new BMap.Point(116.404, 39.915), 5
	scene_map.enableScrollWheelZoom()
	#prov_city typeahead初始化
	city_init()
	$("#bg").addClass("bg")
	$("#first").show()
	$("#loading").hide()


###
 * 在Array原型中定义包含方法，如果该数组包含item则返回true
###
Array.prototype.contains = (item) ->
	for i in @ when i is item
		return true
	return false

substringMatcher = (strs) ->
	(q, cb) ->
		matches = []
		substringRegex = new RegExp(q, "i")
		$.each strs, (i, str) ->
			matches.push {value: str} if substringRegex.test str
		cb(matches)
		return

###
 * 省市信息
###
prov_city = {
	p: ["河北", "山西", "辽宁", "吉林", "黑龙江", "江苏", "浙江", "安徽", "福建", "江西", "山东", "河南", "湖北", "湖南", "广东", "海南", "四川", "贵州", "云南", "陕西", "甘肃", "青海", "西藏", "内蒙古", "广西", "宁夏", "新疆"]
	c: ["北京", "天津", "上海", "重庆", "石家庄", "唐山", "秦皇岛", "邯郸", "邢台", "保定", "张家口", "承德", "沧州", "廊坊", "衡水", "太原", "大同", "阳泉", "长治", "晋城", "朔州", "晋中", "运城", "忻州", "临汾", "吕梁", "沈阳", "大连", "鞍山", "抚顺", "本溪", "丹东", "锦州", "营口", "阜新", "辽阳", "盘锦", "铁岭", "朝阳", "葫芦岛", "长春", "吉林", "四平", "辽源", "通化", "白山", "松原", "白城", "延边", "哈尔滨", "齐齐哈尔", "鸡西", "鹤岗", "双鸭山", "大庆", "伊春", "佳木斯", "七台河", "牡丹江", "黑河", "绥化", "大兴安岭", "南京", "无锡", "徐州", "常州", "苏州", "南通", "连云港", "淮安", "盐城", "扬州", "镇江", "泰州", "宿迁", "杭州", "宁波", "温州", "嘉兴", "湖州", "绍兴", "金华", "衢州", "舟山", "台州", "丽水", "合肥", "芜湖", "蚌埠", "淮南", "马鞍山", "淮北", "铜陵", "安庆", "黄山", "滁州", "阜阳", "宿州", "六安", "亳州", "池州", "宣城", "福州", "厦门", "莆田", "三明", "泉州", "漳州", "南平", "龙岩", "宁德", "南昌", "景德镇", "萍乡", "九江", "新余", "鹰潭", "赣州", "吉安", "宜春", "抚州", "上饶", "济南", "青岛", "淄博", "枣庄", "东营", "烟台", "潍坊", "济宁", "泰安", "威海", "日照", "莱芜", "临沂", "德州", "聊城", "滨州", "菏泽", "郑州", "开封", "洛阳", "平顶山", "安阳", "鹤壁", "新乡", "焦作", "濮阳", "许昌", "漯河", "三门峡", "南阳", "商丘", "信阳", "周口", "驻马店", "武汉", "黄石", "十堰", "宜昌", "襄阳", "鄂州", "荆门", "孝感", "荆州", "黄冈", "咸宁", "随州", "恩施", "长沙", "株洲", "湘潭", "衡阳", "邵阳", "岳阳", "常德", "张家界", "益阳", "郴州", "永州", "怀化", "娄底", "湘西", "广州", "韶关", "深圳", "珠海", "汕头", "佛山", "江门", "湛江", "茂名", "肇庆", "惠州", "梅州", "汕尾", "河源", "阳江", "清远", "东莞", "中山", "潮州", "揭阳", "云浮", "海口", "三亚", "成都", "自贡", "攀枝花", "泸州", "德阳", "绵阳", "广元", "遂宁", "内江", "乐山", "南充", "眉山", "宜宾", "广安", "达州", "雅安", "巴中", "资阳", "阿坝", "甘孜", "凉山", "贵阳", "六盘水", "遵义", "安顺", "毕节", "铜仁", "昆明", "曲靖", "玉溪", "保山", "昭通", "丽江", "普洱", "临沧", "楚雄", "红河", "文山", "西双版纳", "大理", "德宏", "怒江", "迪庆", "西安", "铜川", "宝鸡", "咸阳", "渭南", "延安", "汉中", "榆林", "安康", "商洛", "兰州", "嘉峪关", "金昌", "白银", "天水", "武威", "张掖", "平凉", "酒泉", "庆阳", "定西", "陇南", "临夏", "甘南", "西宁", "海东地区", "海北", "黄南", "果洛", "玉树", "海西", "呼和浩特", "包头", "乌海", "赤峰", "通辽", "鄂尔多斯", "呼伦贝尔", "巴彦淖尔", "乌兰察布", "锡林郭勒盟", "阿拉善盟", "南宁", "柳州", "桂林", "梧州", "北海", "防城港", "钦州", "贵港", "玉林", "百色", "贺州", "河池", "来宾", "崇左", "拉萨", "银川", "石嘴山", "吴忠", "固原", "中卫", "乌鲁木齐", "克拉玛依", "吐鲁番", "哈密", "昌吉", "博尔塔拉", "巴音郭楞"]
}

###
 * 判断名称是否为省份，如果是省份则返回true
###
is_province = (name) -> if name in prov_city.p then true else false


###
 * 判断名称是否为城市，如果是城市名则返回true
###
is_city = (name) -> if name in prov_city.c then true else false

###
 * 判断名称是否为城市或者省份，如果是city或者Province，则返回true
###
is_prov_city = (name) -> if name in prov_city.p  or prov_city.c then true else false

###
 * 省市初始化
###
city_init = ->
	prov_city_typeahead = $("#prov_city").typeahead(
		{
			hint: true
			highlight: true
			minLength: 1
		}
		{
			name: "province"
			displayKey: "value"
			source: substringMatcher(prov_city.p)
			templates: {
				header: "<h3 class='typeahead-city'>省份</h3>"
			}		
		}
		{
			name: "city"
			displayKey: "value"
			source: substringMatcher(prov_city.c)
			templates: {
				header: "<h3 class='typeahead-city'>城市</h3>"
			}
		}
	)
	prov_city_flag = false
	prov_city_typeahead.bind "typeahead:selected", (obj, selected, type) -> 
		prov_city_flag = true
		get_scenes selected.value
		setTimeout ->
			prov_city_flag = false
		,100
	$("#prov_city").focus()
	$("#prov_city").keydown (event)->
		return if event.keyCode isnt 13 or prov_city_flag
		get_scenes event.target.value
	return

###
 * 根据省市名称获取对应的景点列表
###
get_scenes = (name) ->
	return false if not is_prov_city(name)
	# return false if not prov_city.p.contains(name) and not prov_city.c.contains(name)
	scene_map.setZoom if is_province(name) then 7 else 12
	scene_map.setCenter name

	$.ajax {
		type: "GET"
		url: "/cities/#{name}/scenes?timestamp=#{new Date().getTime()}"
		success: (data) ->
			scenes = data.data[0].scenes
			$("#scenes").val("")
			$("#scenes").typeahead "destroy"
			scenes_typeahead = $("#scenes").typeahead(
				{
					hint: true
					highlight: true
					minLength: 1
				}
				{
					name: "scene"
					displayKey: "value"
					source: substringMatcher(scenes)
				}
			)
			scenes_flag = false
			scenes_typeahead.bind "typeahead:selected", (obj, selected, name) ->
				scenes_flag = true
				get_scene selected.value
				setTimeout ->
					scenes_flag = false
				,100
			$("#scenes").keydown (event) ->
				return if event.keyCode isnt 13 or scenes_flag
				get_scene()
			$("#scenes").focus()
			return
	}
	return

###
 * 根据城市和景点名获取详细景点信息
###
get_scene = ->
	scene_name = $("#scenes").val()
	city = $("#prov_city").val()
	return false if not is_prov_city(name)
	# return false if not prov_city.p.contains(city) and not prov_city.c.contains(city)

	$.ajax {
		type: "GET"
		url: "/cities/#{city}/scenes/#{scene_name}"
		data: "timestamp=#{(new Date().getTime())}"
		success: (data) ->
			data = JSON.parse data
			return if data.status isnt "success"
			scene = data.data[0]
			location = scene.location[0]
			if not location
				alert "该景点坐标尚未收录"
				return
			point = new BMap.Point location.longitude, location.latitude
			scene_map.centerAndZoom point, 15
			scene_map.clearOverlays()
			scene_marker = new BMap.Marker point
			scene_marker.enableDragging()
			scene_marker.addEventListener "dragend", (e) -> alert "当前位置：#{e.point.lng}, #{e.point.lat}"
			scene_map.addOverlay scene_marker
			scene_marker.setAnimation BMAP_ANIMATION_BOUNCE
			$("#change").focus()

	}

###
*修改信息后递交
###
save = ->
	provv = $("#provinces").val()
	scene = $("#scenes").val()
	city = $("#cities").val()
	object_id =$("input[name='_id']").val()
	name =$("input[name='name']").val()
	name_en =$("input[name='name_en']").val()
	status =$("input[name='status']").val()
	last_update =$("input[name='last_update']").val()
	last_update_user =$("input[name='last_update_user']").val()
	category =$("input[name='category']").val()
	alias =$("textarea[name='alias']").val()
	longitude =$("input[name='longitude']").val()
	latitude =$("input[name='latitude']").val()
	altitude =$("input[name='altitude']").val()
	radius =$("input[name='radius']").val()
	geo =$("textarea[name='geo']").val()
	type =$("input[name='type']").val()
	addr =$("input[name='addr']").val()
	description =$("textarea[name='description']").val()
	images =$("textarea[name='images']").val()
	open_time =$("input[name='open_time']").val()
	acreage =$("input[name='acreage']").val()
	ticket_price =$("input[name='ticket_price']").val()
	phone =$("input[name='phone']").val()
	$.ajax {
		type: "POST"
		url: "/cities/#{city}/scenes/#{scene}"
		data:{
			object_id: object_id
			name: name
			name_en: name_en
			city: city
			province: provv
			status: status
			last_update: (new Date()).getTime()
			last_update_user: last_update_user
			category: category
			alias: alias
			location: {
				longitude: longitude
				latitude: latitude
				altitude: altitude
				radius: radius
				geo: geo
				type: type
				addr: addr
			}
			ext: {
				description: description
				images: []
				audio: "/audio/a.amr"
				open_time: open_time
				acreage: acreage
				ticket_price: ticket_price
				phone: phone
			}
		}
		success: (result)->
			result = JSON.parse(result)
			if result.status == "success" then $("#myModal").modal("hide")
			alert("success") 
			console.log(result)
		}
###
*景点定位
###
search = ->
	scene = $("#scenes").val()
	city = $("#cities").val()
	$.ajax {
		type: "GET"
		url: "/cities/#{city}/scenes/#{scene}"
		data: "timestamp=#{(new Date().getTime())}"
		success: (data) ->
			console.log(data)
			data = JSON.parse(data)
			locps= data.data[0].loc.geo
			pdeal1= data.data[0].loc.geo.split("|")
			pdeal2= pdeal1[2].substring(0,pdeal1[2].length-1)
			pdeal3= pdeal2.split(",")
			console.log(pdeal3)
			longitude= pdeal3[1]
			atitude=  pdeal3[0]
			p = new ConvertPoint(atitude, longitude)
			pt= new BMap.Point(p.convertMC2LL().lng, p.convertMC2LL().lat)
			thismarker = new BMap.Marker(pt)
			markers[0]= thismarker
			scene_map.addOverlay(thismarker)
			scene_map.setCenter(pt)
			scene_map.setZoom(16)
}


###
 * 绘制坐标点
###
markbiao = (e)->
	xx=e.point.lng
	yy=e.point.lat
	newp= new BMap.Point(xx, yy)
	markpoints.push(newp)
	marker1 = new BMap.Marker(newp) 
	psize= new BMap.Size(5,5)
	Icon= new BMap.Icon("http://pic3.bbzhi.com/jingxuanbizhi/heiseshawenjianyuechunsebizhi/jingxuan_jingxuanyitu_216725_2.jpg", psize);
	marker1.setIcon(Icon)
	scene_map.addOverlay(marker1)            
	drawline= new BMap.Polyline(markpoints)
	scene_map.addOverlay(drawline)
	console.log(marker1.Size)

###
 * 坐标点点击
###
mark = ->
	scene_map.addEventListener("onclick",markbiao)
	

###
 * 返回上一步
###
back = ->
	scene_map.clearOverlays()
	markpoints.pop()
	for p in markpoints
		mark2 = new BMap.Marker(p)
		psize= new BMap.Size(5,5)
		Icon= new BMap.Icon("http://pic3.bbzhi.com/jingxuanbizhi/heiseshawenjianyuechunsebizhi/jingxuan_jingxuanyitu_216725_2.jpg", psize);
		mark2.setIcon(Icon)
		scene_map.addOverlay(mark2)
		drawline= new BMap.Polyline(markpoints)
	scene_map.addOverlay(drawline)
	scene_map.addOverlay(markers[0])
	

###
 * 清空
###
clearmap = ->
	markpoints.splice(0,markpoints.length)
	scene_map.clearOverlays()
	scene_map.addOverlay(markers[0])

###
 * 绘制后递交
###
commit = ->
	scene = $("#scenes").val()
	city = $("#cities").val()
	$.ajax {
		type: "GET"
		url: "/cities/#{city}/scenes/#{scene}"
		data: "timestamp=#{(new Date().getTime())}"
		success: (data) ->
			console.log(data)
			data = JSON.parse(data)
			$("#textare").val (data.data[0].ext.description)
			imgs = data.data[0].ext.images
			alias = data.data[0].alias
			description= data.data[0].ext.description
			name= data.data[0].name
			city = data.data[0].city
			name_en = data.data[0].surl
			phone = data.data[0].ext.phone
			object_id = data.data[0]._id
			geo = data.data[0].loc.geo
			console.log(data)
			console.log(markpoints)

	}
	$.ajax {
		type: "POST"
		url: "/cities/#{city}/scenes/#{scene}"
		data:{
			object_id: object_id
			name: name
			name_en: name_en
			city: city
			province: provv
			status: status
			last_update: (new Date()).getTime()
			last_update_user: last_update_user
			category: category
			alias: alias
			location: {
				longitude: longitude
				latitude: latitude
				altitude: altitude
				radius: radius
				geo: geo
				type: type
				addr: addr
			}
			ext: {
				description: description
				images: []
				audio: "/audio/a.amr"
				open_time: open_time
				acreage: acreage
				ticket_price: ticket_price
				phone: phone
			}
		}
	}
###
 * 页面过渡
###
move = ->
	$("#second").css "animationName" , "moveright"
	$("#second").css "webkitAnimationName" , "moveright"
	$("#first").css "animationName" , "moveleft"
	$("#first").css "webkitAnimationName" , "moveleft"
	$("#second").css "display" , "block"
	
###
 * 回退页面过渡
###
moveback = ->
	$("#first").css "animationName" , "backleft"
	$("#first").css "webkitAnimationName" , "backleft"
	$("#second").css "animationName" , "backright"
	$("#second").css "webkitAnimationName" , "backright"
	setTimeout ->
		$("#second").css "display" , "none"
		console.log()
	,1000
	
	


