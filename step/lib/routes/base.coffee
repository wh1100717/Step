'use strict'

api = require('../controllers/api')
index = require('../controllers')
users = require('../controllers/users')
session = require('../controllers/session')
middleware = require('../middleware')


module.exports = (app) ->
	app.route('/api/awesomeThings')
		.get api.awesomeThings
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

	app.route('/api/jia')
		.get api.jia

	app.route('/api/*')
		.get (req, res) -> res.send 404

	app.route('/partials/*')
		.get index.partials

	app.route('/*')
		.get(middleware.setUserCookie, index.index)
