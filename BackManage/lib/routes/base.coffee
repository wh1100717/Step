'use strict'

base = require '../controllers/base'
users = require '../controllers/users'
session = require '../controllers/session'
middleware = require '../middleware'

module.exports = (app) ->

	app.route('/upload/img')
		.post base.imgUpload

	app.route('/api/users')
		.get users.create
		.put users.changePassword
	app.route('/api/users/me')
		.get users.me
	app.route('/api/users/:id')
		.get users.show
	app.route('/api/session')
		.post session.login
		.delete session.logout
	app.route('/scene')
		.get base.scene
	app.route('/*')
		.get(middleware.setUserCookie, base.index)
