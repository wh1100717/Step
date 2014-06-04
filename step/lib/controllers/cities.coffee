'use strict'

mongoose = require('mongoose')
cityUtil = require('../util/cityUtil')
City = mongoose.model('City')
Scene = mongoose.model('Scene')

cities = {}
cities.scenes = {
	list: (req, res, next)->
		city = req.params.city
		City.find {name:city}, (err, scene_list) ->
			return next(err) if err
			return res.send(404) if not scene_list
			res.send {status: 'success', data: scene_list}
			return
		return
	show: (req, res, next)->
		city = req.params.city
		console.log city
		scene = req.params.scenes
		console.log scene
		Scene.find {name:scene}, (err, scene) ->
			return next(err) if err
			return res.send(404) if not scene

			console.log scene
			res.send JSON.stringify({status: 'success', data: scene})
			return
		return
	save: ->
		return
	children: {
		show: ->
			return
		save: ->
			return
	}

}

module.exports = cities

# exports.show = (req, res, next) ->
# 	province = req.param('province')
# 	if province
# 		cities = cityUtil.get_cities_by_province(province) 
# 		res.send JSON.stringify({status: 'success', data: cities})
# 		return
# 	else

# 	return

# exports.show_city_by_name = (req, res, next) ->
# 	name = req.params.name
# 	console.log(name)
# 	City.find({name:name}, (err, scene) ->
# 		return next(err) if err
# 		return res.send(404) if not scene
# 		res.send {status: 'success', data: scene}
# 		return
# 	)
# 	return
# exports.get_cities = (req,res,next) ->
# 	name = req.params.province
# 	console.log "name"
# 	tmp = cityUtil.get_cities_by_province(name)
# 	console.log(tmp)
# 	res.send {status: 'success', data: tmp }
# 	return
	
