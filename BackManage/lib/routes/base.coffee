'use strict'

base = require '../controllers/base'
users = require '../controllers/users'
session = require '../controllers/session'
middleware = require '../middleware'
timeout = require 'connect-timeout'

module.exports = (app) ->

	app.post '/upload/img', timeout(45000), base.imgUpload
	app.post '/upload/file', timeout(45000), base.fileUpload

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
	app.route('/photo')
		.get base.photo

	app.route('/my')
		.get base.my


	app.route('/')
		.get(base.index)
	app.route('/*')
		.get(base.notFound)
