'use strict'

path = require 'path'
fs = require 'fs'
config = require '../config/config'
mkdirp = require 'mkdirp'
UPYun = require('../util/upyun').UPYun

# 求文件字符串 md5 值
md5 = (str) ->
	crypto = require 'crypto'
	md5sum = crypto.createHash 'md5'
	md5sum.update str, 'utf8'
	md5sum.digest 'hex'

testCallback = (err, data) ->
	if err
		console.log 'Error: '
		console.log err
	else
		console.log 'Data: '
		console.log data

exports.imgUpload = (req, res) ->
	req.pipe req.busboy
	req.busboy.on 'file', (fieldname, file, filename) ->
		console.log "Uploading: #{filename}"
		d = new Date()
		uploadpath = "/#{d.getYear()+1900}/#{d.getMonth()}/"
		localpath = "#{config.root}/app/upload#{uploadpath}"
		mkdirp localpath, (err) ->
			res.send 500, "internal error when making dirs: #{err}" if err
			filename = md5(d.getTime().toString()) + "." + filename.split('.').pop()
			fstream = fs.createWriteStream localpath + filename
			file.pipe fstream
			fstream.on 'close', ->
				console.log "finish file downloading to server"
				img_config = config.upyun.img
				upyun = new UPYun(img_config.bucketname, img_config.username, img_config.password)
				upyun.getBucketUsage(testCallback)
				fileContent = fs.readFileSync(localpath + filename)
				md5Str = md5(fileContent)
				upyun.setContentMD5(md5Str)
				upyun.writeFile uploadpath + filename, fileContent, true, (err, data) ->
					console.log "Finish dile uploading to cloud"
					if err
						console.log err
						res.send err.statusCode, err.message + data
					else
						res.send 200, """{"status":1,"type":null,"name":"#{filename}","url":"#{img_config.base_url + uploadpath + filename}"}"""
					return
				return

exports.fileUpload = (req, res) ->
	req.pipe req.busboy
	req.busboy.on 'file', (fieldname, file, filename) ->
		console.log "Uploading: #{filename}"
		d = new Date()
		uploadpath = "/#{d.getYear()+1900}/#{d.getMonth()}/"
		localpath = "#{config.root}/app/upload#{uploadpath}"
		mkdirp localpath, (err) ->
			res.send 500, "internal error when making dirs: #{err}" if err
			filename = md5(d.getTime().toString()) + "." + filename.split('.').pop()
			fstream = fs.createWriteStream localpath + filename
			file.pipe fstream
			fstream.on 'close', ->
				console.log "finish file downloading to server"
				file_config = config.upyun.file
				upyun = new UPYun(file_config.bucketname, file_config.username, file_config.password)
				upyun.getBucketUsage(testCallback)
				fileContent = fs.readFileSync(localpath + filename)
				md5Str = md5(fileContent)
				upyun.setContentMD5(md5Str)
				upyun.writeFile uploadpath + filename, fileContent, true, (err, data) ->
					console.log "Finish dile uploading to cloud"
					console.log uploadpath + filename
					if err
						console.log err
						res.send err.statusCode, err.message + data
					else
						res.send 200, """{"status":1,"type":null,"name":"#{filename}","url":"#{file_config.base_url + uploadpath + filename}"}"""
					return
				return

exports.index = (req, res) -> res.render 'partials/index'

exports.scene = (req, res) -> res.render 'partials/scene'

exports.notFound = (req, res) -> res.render '404'








