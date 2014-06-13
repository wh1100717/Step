'use strict'

module.exports = (app) ->
	# 配置文件上传
	upload = require 'jquery-file-upload-middleware'
	upload.configure {
		uploadDir: __dirname + '/public/uploads'
		uploadUrl: '/uploads'
		imageVersions: {
			thumbnail: {
				width: 80
				height: 80
			}
		}
	}

	app.use '/uploads', upload.fileHandler()

	require('./routes/cities')(app)
	#base route module should ALWAYS be the last one!
	require('./routes/base')(app)