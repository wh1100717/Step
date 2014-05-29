'use strict'

mongoose = require('mongoose')
City = mongoose.model('City')



exports.show = (req, res, next) ->
	
	City.find( (err, city) ->
		return next(err) if err
		return res.send(404) if not city
		res.send {status: 'success', data: city}
		return
	)
	return

exports.show_city_by_name = (req, res, next) ->
	name = req.params.name
	console.log(name)
	City.find({name:name}, (err, scene) ->
		return next(err) if err
		return res.send(404) if not scene
		res.send {status: 'success', data: scene}
		return
	)
	return
