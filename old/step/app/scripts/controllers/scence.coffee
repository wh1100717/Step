'use strict'

angular.module('stepApp')
  .controller 'ScenceCtrl', ($scope, $http) ->
    $http.get('/api/awesomeThings').success (awesomeThings) ->
      $scope.awesomeThings = awesomeThings

###
 * 省市信息
###
city_info = {
	p: ['北京市', '天津市', '上海市', '重庆市', '河北省', '山西省', '辽宁省', '吉林省', '黑龙江省', '江苏省', '浙江省', '安徽省', '福建省', '江西省', '山东省', '河南省', '湖北省', '湖南省', '广东省', '海南省', '四川省', '贵州省', '云南省', '陕西省', '甘肃省', '青海省', '西藏自治区', '内蒙古自治区', '广西壮族自治区', '宁夏回族自治区', '新疆维吾尔自治区']
	c: {
		'北京市': ['北京']
		'天津市': ['天津']
		'上海市': ['上海']
		'重庆市': ['重庆']
		'河北省': ['石家庄市', '唐山市', '秦皇岛市', '邯郸市', '邢台市', '保定市', '张家口市', '承德市', '沧州市', '廊坊市', '衡水市']
		'山西省': ['太原市', '大同市', '阳泉市', '长治市', '晋城市', '朔州市', '晋中市', '运城市', '忻州市', '临汾市', '吕梁市']
		'辽宁省': ['沈阳市', '大连市', '鞍山市', '抚顺市', '本溪市', '丹东市', '锦州市', '营口市', '阜新市', '辽阳市', '盘锦市', '铁岭市', '朝阳市', '葫芦岛市']
		'吉林省': ['长春市', '吉林市', '四平市', '辽源市', '通化市', '白山市', '松原市', '白城市', '延边朝鲜族自治州']
		'黑龙江省': ['哈尔滨市', '齐齐哈尔市', '鸡西市', '鹤岗市', '双鸭山市', '大庆市', '伊春市', '佳木斯市', '七台河市', '牡丹江市', '黑河市', '绥化市', '大兴安岭地区']
		'江苏省': ['南京市', '无锡市', '徐州市', '常州市', '苏州市', '南通市', '连云港市', '淮安市', '盐城市', '扬州市', '镇江市', '泰州市', '宿迁市']
		'浙江省': ['杭州市', '宁波市', '温州市', '嘉兴市', '湖州市', '绍兴市', '金华市', '衢州市', '舟山市', '台州市', '丽水市']
		'安徽省': ['合肥市', '芜湖市', '蚌埠市', '淮南市', '马鞍山市', '淮北市', '铜陵市', '安庆市', '黄山市', '滁州市', '阜阳市', '宿州市', '六安市', '亳州市', '池州市', '宣城市']
		'福建省': ['福州市', '厦门市', '莆田市', '三明市', '泉州市', '漳州市', '南平市', '龙岩市', '宁德市']
		'江西省': ['南昌市', '景德镇市', '萍乡市', '九江市', '新余市', '鹰潭市', '赣州市', '吉安市', '宜春市', '抚州市', '上饶市']
		'山东省': ['济南市', '青岛市', '淄博市', '枣庄市', '东营市', '烟台市', '潍坊市', '济宁市', '泰安市', '威海市', '日照市', '莱芜市', '临沂市', '德州市', '聊城市', '滨州市', '菏泽市']
		'河南省': ['郑州市', '开封市', '洛阳市', '平顶山市', '安阳市', '鹤壁市', '新乡市', '焦作市', '濮阳市', '许昌市', '漯河市', '三门峡市', '南阳市', '商丘市', '信阳市', '周口市', '驻马店市', '省直辖县级行政区划']
		'湖北省': ['武汉市', '黄石市', '十堰市', '宜昌市', '襄阳市', '鄂州市', '荆门市', '孝感市', '荆州市', '黄冈市', '咸宁市', '随州市', '恩施土家族苗族自治州', '省直辖县级行政区划']
		'湖南省': ['长沙市', '株洲市', '湘潭市', '衡阳市', '邵阳市', '岳阳市', '常德市', '张家界市', '益阳市', '郴州市', '永州市', '怀化市', '娄底市', '湘西土家族苗族自治州']
		'广东省': ['广州市', '韶关市', '深圳市', '珠海市', '汕头市', '佛山市', '江门市', '湛江市', '茂名市', '肇庆市', '惠州市', '梅州市', '汕尾市', '河源市', '阳江市', '清远市', '东莞市', '中山市', '潮州市', '揭阳市', '云浮市']
		'海南省': ['海口市', '三亚市', '省直辖县级行政区划']
		'四川省': ['成都市', '自贡市', '攀枝花市', '泸州市', '德阳市', '绵阳市', '广元市', '遂宁市', '内江市', '乐山市', '南充市', '眉山市', '宜宾市', '广安市', '达州市', '雅安市', '巴中市', '资阳市', '阿坝藏族羌族自治州', '甘孜藏族自治州', '凉山彝族自治州']
		'贵州省': ['贵阳市', '六盘水市', '遵义市', '安顺市', '毕节市', '铜仁市', '黔西南布依族苗族自治州', '黔东南苗族侗族自治州', '黔南布依族苗族自治州']
		'云南省': ['昆明市', '曲靖市', '玉溪市', '保山市', '昭通市', '丽江市', '普洱市', '临沧市', '楚雄彝族自治州', '红河哈尼族彝族自治州', '文山壮族苗族自治州', '西双版纳傣族自治州', '大理白族自治州', '德宏傣族景颇族自治州', '怒江傈僳族自治州', '迪庆藏族自治州']
		'陕西省': ['西安市', '铜川市', '宝鸡市', '咸阳市', '渭南市', '延安市', '汉中市', '榆林市', '安康市', '商洛市']
		'甘肃省': ['兰州市', '嘉峪关市', '金昌市', '白银市', '天水市', '武威市', '张掖市', '平凉市', '酒泉市', '庆阳市', '定西市', '陇南市', '临夏回族自治州', '甘南藏族自治州']
		'青海省': ['西宁市', '海东地区', '海北藏族自治州', '黄南藏族自治州', '海南藏族自治州', '果洛藏族自治州', '玉树藏族自治州', '海西蒙古族藏族自治州']
		'内蒙古自治区': ['呼和浩特市', '包头市', '乌海市', '赤峰市', '通辽市', '鄂尔多斯市', '呼伦贝尔市', '巴彦淖尔市', '乌兰察布市', '兴安盟', '锡林郭勒盟', '阿拉善盟']
		'广西壮族自治区': ['南宁市', '柳州市', '桂林市', '梧州市', '北海市', '防城港市', '钦州市', '贵港市', '玉林市', '百色市', '贺州市', '河池市', '来宾市', '崇左市']
		'西藏自治区': ['拉萨市', '昌都地区', '山南地区', '日喀则地区', '那曲地区', '阿里地区', '林芝地区']
		'宁夏回族自治区': ['银川市', '石嘴山市', '吴忠市', '固原市', '中卫市']
		'新疆维吾尔自治区': ['乌鲁木齐市', '克拉玛依市', '吐鲁番地区', '哈密地区', '昌吉回族自治州', '博尔塔拉蒙古自治州', '巴音郭楞蒙古自治州', '阿克苏地区', '克孜勒苏柯尔克孜自治州', '喀什地区', '和田地区', '伊犁哈萨克自治州', '塔城地区', '阿勒泰地区', '自治区直辖县级行政区划']
	}
	get_cities: (province)-> this.c[province]
}

###
 * 获取省份
###
get_provinces = ->
	$("#prov").typeahead({
		hint: false
		highlight: true
		minLength: 1
	},{
		name: "states1"
		displayKey: 'value'
		source: substringMatcher(city_info.p)
	}).bind('typeahead:selected',(obj, selected, name) -> get_cities(false))

###
 * 根据所选省份获取城市
###
get_cities = (flag) ->
	$("#cities").show()
	pp=$('#prov').val()
	map.setCenter(pp)
	map.setZoom(7)
	
	return if flag and event.keyCode isnt 13
	for province in city_info.p when $('#prov').val() is province
		$("#cities").val ""
		$("#scenes").val ""
		$("#cities").typeahead 'destroy'
		$("#cities").typeahead({
			hint: false
			highlight: true
			minLength: 1
		}, {
			name: 'states2'
			displayKey: 'value'
			source: substringMatcher(city_info.c[province])
		}).bind('typeahead:selected', (obj, selected, name) -> get_scenes(false))

		
	

###
 * 根据所选城市获取该城市的旅游景点
###
get_scenes = (flag)->
	$("#scenes").show()
	return if flag and event.keyCode isnt 13

	c = $("#cities").val()
	map.setCenter(c)
	map.setZoom(12);
	
	for city in city_info.c[$('#prov').val()] when c is city
		$.ajax {
			type: "GET"
			url: "/cities/#{c}/scenes"
			data: "timestamp=#{(new Date().getTime())}"
			success: (data) ->
				scenes = data.data[0].scenes
				$("#scenes").typeahead 'destroy'
				$("#scenes").typeahead({
					hint: false
					highlight: true
					minLength: 1
				},{
					name: 'staes3'
					displayKey: 'value'
					source: substringMatcher(scenes)
			}).bind('typeahead:selected', (obj, selected, name)  -> show_sub())
				
				
				
		}

###
 * 根据城市和景点名获取详细景点信息
###
get_scene = ->
	
	scene = $("#scenes").val()
	city = $("#cities").val()
	$.ajax {
		type: "GET"
		url: "/cities/#{city}/scenes/#{scene}"
		data: "timestamp=#{(new Date().getTime())}"
		success: (data) ->
			console.log(data)
			data = JSON.parse(data)
			imgs = data.data[0].ext.images
			alias = data.data[0].alias
			geo =data.data[0].loc.geo
			$("#textare").val (data.data[0].ext.description)
			$("#textare").val (data.data[0].ext.description)
			$("textarea[name='images']").val (imgs)
			$("textarea[name='alias']").val (alias)
			$("textarea[name='geo']").val(geo)
			$("input[name='name']").val (data.data[0].name)
			$("input[name='city']").val (data.data[0].city)
			$("input[name='name_en']").val (data.data[0].surl)
			$("input[name='phone']").val (data.data[0].ext.phone)
			$("input[name='_id']").val (data.data[0]._id)
			console.log(data)

	}

###
*修改信息后递交
###
save = ->
	provv = $("#prov").val()
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
			audio: '/audio/a.amr'
			open_time: open_time
			acreage: acreage
			ticket_price: ticket_price
			phone: phone
			}
		}
		success: (result)->
			result = JSON.parse(result)
			if result.status == 'success' then $('#myModal').modal('hide')
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
			map.setCenter(pt)
			map.setZoom(16)
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
	map.addOverlay(marker1)            
	drawline= new BMap.Polyline(markpoints)
	map.addOverlay(drawline)
	console.log()
###
 * 坐标点点击
###
mark = ->
	
	map.addEventListener("onclick",markbiao)
	console.log()

###
 * 返回上一步
###
back = ->
	
	markpoints.pop()
	map.clearOverlays()
	drawline= new BMap.Polyline(markpoints)
	map.addOverlay(drawline)
	console.log()

###
 * 清空
###
clearmap = ->
	markpoints.splice(0,markpoints.length)
	map.clearOverlays()

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
			audio: '/audio/a.amr'
			open_time: open_time
			acreage: acreage
			ticket_price: ticket_price
			phone: phone
			}
		}
	}
###
 * 隐藏城市及景点选择框
###
hide_cities = ->
	$("#cities").fadeOut(500)
	$("#scenes").fadeOut(500)
	$("#sub").fadeOut(500)
	$("#change").fadeOut(500)

###
 * 隐藏景点选择框
###
hide_scenes = ->
	$("#scenes").val("")
	$("#scenes").fadeOut(500)

hide_sub = ->
	$("#sub").val("")
	$("#sub").fadeOut(500)
	$("#change").fadeOut(500)
show_sub = ->
	
	$("#sub").fadeIn(500)
	$("#change").fadeIn(500)

substringMatcher = (strs) ->
	(q, cb) ->
		matches = []
		substringRegex = new RegExp(q, 'i')
		$.each strs, (i, str) ->
			matches.push {value: str} if substringRegex.test str
		cb(matches)
		return
