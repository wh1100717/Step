'use strict'

path = require 'path'
fs = require 'fs'
config = require '../config/config'
UPYun = require('../util/upyun').UPYun

# 创建多层文件夹 同步
mkdirsSync = (dirpath) ->
	return true if fs.existsSync dirpath
	pathtmp = ""
	for dirname in dirpath.split(path.sep)
		pathtmp = pathtmp + path.sep + dirname
		if not fs.existsSync pathtmp
			fs.mkdirSync pathtmp
	return true

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

exports.index = (req, res) -> res.render 'partials/index'

exports.scene = (req, res) -> res.render 'partials/scene'

exports.imgUpload = (req, res) ->
	req.pipe req.busboy
	req.busboy.on 'file', (fieldname, file, filename) ->
		console.log "Uploading: #{filename}"
		d = new Date()
		uploadpath = "/#{d.getYear()+1900}/#{d.getMonth()}/"
		localpath = "#{config.root}/app/upload#{uploadpath}"
		if not mkdirsSync(localpath)
			res.send 500, "internal error when making dirs"
			return
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








