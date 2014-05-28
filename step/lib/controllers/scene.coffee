'use strict'

mongoose = require('mongoose')
Scene = mongoose.model('Scene')

exports.create = (req, res, next) ->
	newScene = new Scene(req.body)
	newScene.save (err) -> return res.json 400, err if err
	return

exports.show = (req, res, next) ->
	id = res.params.id
	Scene.findById(id, (err, scene) ->
		return next(err) if err
		return res.send(404) if not scene
		res.send {status: 'success', data: scene}
		return
	)
	return

