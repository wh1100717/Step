// Generated by CoffeeScript 1.7.1
'use strict';
var UPYun, config, fs, md5, mkdirp, path, testCallback;

path = require('path');

fs = require('fs');

config = require('../config/config');

mkdirp = require('mkdirp');

UPYun = require('../util/upyun').UPYun;

md5 = function(str) {
  var crypto, md5sum;
  crypto = require('crypto');
  md5sum = crypto.createHash('md5');
  md5sum.update(str, 'utf8');
  return md5sum.digest('hex');
};

testCallback = function(err, data) {
  if (err) {
    console.log('Error: ');
    return console.log(err);
  } else {
    console.log('Data: ');
    return console.log(data);
  }
};

exports.imgUpload = function(req, res) {
  req.pipe(req.busboy);
  return req.busboy.on('file', function(fieldname, file, filename) {
    var d, localpath, uploadpath;
    console.log("Uploading: " + filename);
    d = new Date();
    uploadpath = "/" + (d.getYear() + 1900) + "/" + (d.getMonth()) + "/";
    localpath = "" + config.root + "/app/upload" + uploadpath;
    return mkdirp(localpath, function(err) {
      var fstream;
      if (err) {
        res.send(500, "internal error when making dirs: " + err);
      }
      filename = md5(d.getTime().toString()) + "." + filename.split('.').pop();
      fstream = fs.createWriteStream(localpath + filename);
      file.pipe(fstream);
      return fstream.on('close', function() {
        var fileContent, img_config, md5Str, upyun;
        console.log("finish file downloading to server");
        img_config = config.upyun.img;
        upyun = new UPYun(img_config.bucketname, img_config.username, img_config.password);
        upyun.getBucketUsage(testCallback);
        fileContent = fs.readFileSync(localpath + filename);
        md5Str = md5(fileContent);
        upyun.setContentMD5(md5Str);
        upyun.writeFile(uploadpath + filename, fileContent, true, function(err, data) {
          console.log("Finish dile uploading to cloud");
          if (err) {
            console.log(err);
            res.send(err.statusCode, err.message + data);
          } else {
            res.send(200, "{\"status\":1,\"type\":null,\"name\":\"" + filename + "\",\"url\":\"" + (img_config.base_url + uploadpath + filename) + "\"}");
          }
        });
      });
    });
  });
};

exports.fileUpload = function(req, res) {
  req.pipe(req.busboy);
  return req.busboy.on('file', function(fieldname, file, filename) {
    var d, localpath, uploadpath;
    console.log("Uploading: " + filename);
    d = new Date();
    uploadpath = "/" + (d.getYear() + 1900) + "/" + (d.getMonth()) + "/";
    localpath = "" + config.root + "/app/upload" + uploadpath;
    return mkdirp(localpath, function(err) {
      var fstream;
      if (err) {
        res.send(500, "internal error when making dirs: " + err);
      }
      filename = md5(d.getTime().toString()) + "." + filename.split('.').pop();
      fstream = fs.createWriteStream(localpath + filename);
      file.pipe(fstream);
      return fstream.on('close', function() {
        var fileContent, file_config, md5Str, upyun;
        console.log("finish file downloading to server");
        file_config = config.upyun.file;
        upyun = new UPYun(file_config.bucketname, file_config.username, file_config.password);
        upyun.getBucketUsage(testCallback);
        fileContent = fs.readFileSync(localpath + filename);
        md5Str = md5(fileContent);
        upyun.setContentMD5(md5Str);
        upyun.writeFile(uploadpath + filename, fileContent, true, function(err, data) {
          console.log("Finish dile uploading to cloud");
          if (err) {
            console.log(err);
            res.send(err.statusCode, err.message + data);
          } else {
            res.send(200, "{\"status\":1,\"type\":null,\"name\":\"" + filename + "\",\"url\":\"" + (file_config.base_url + uploadpath + filename) + "\"}");
          }
        });
      });
    });
  });
};

exports.index = function(req, res) {
  return res.render('partials/index');
};

exports.scene = function(req, res) {
  return res.render('partials/scene');
};

exports.notFound = function(req, res) {
  return res.render('404');
};
