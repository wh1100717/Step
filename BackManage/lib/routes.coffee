'use strict'

module.exports = (app) ->

	require('./routes/cities')(app)
	#base route module should ALWAYS be the last one!
	require('./routes/base')(app)