'use strict'

path = require('path')
fs = require 'fs'
config = require('../config/config')

exports.index = (req, res) -> res.render 'partials/index'

exports.scene = (req, res) -> res.render 'partials/scene'

exports.imgUpload = (req, res) ->
	req.pipe req.busboy
	req.busboy.on 'file', (fieldname, file, filename) ->
		console.log "Uploading: #{filename}"
		fstream = fs.createWriteStream("#{config.root}/app/upload/#{filename}")
		file.pipe(fstream)
		fstream.on 'close', ->
			res.send 200, """{"status":1,"type":null,"name":"#{filename}","url":"/upload/#{filename}"}"""