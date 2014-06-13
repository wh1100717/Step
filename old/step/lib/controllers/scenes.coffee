'use strict'

mongoose = require('mongoose')
Scene = mongoose.model('Scene')

exports.create = (req, res, next) ->
	newScene = new Scene(req.body)
	newScene.save (err) -> return res.json 400, err if err
	return

exports.show_by_id = (req, res, next) ->
	id = req.params.id
	Scene.findById(id, (err, scene) ->
		return next(err) if err
		return res.send(404) if not scene
		res.send {status: 'success', data: scene}
		return
	)
	return

exports.show_all = (req,res,next) ->
	Scene.find((err,scene) ->
		return next(err) if err
		return res.send(404) if not scene
		res.send {status: 'success', data: scene}
		return
	)

exports.show_by_name = (req, res, next) ->
	name = req.params.name
	console.log(name)
	Scene.find({sname:name}, (err, scene) ->
		return next(err) if err
		return res.send(404) if not scene
		res.send {status: 'success', data: scene}
		return
	)
	return

exports.save_scene = (req,res,next) ->
	return

