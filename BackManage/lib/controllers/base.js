// Generated by CoffeeScript 1.7.1
'use strict';
var config, fs, path;

path = require('path');

fs = require('fs');

config = require('../config/config');

exports.index = function(req, res) {
  return res.render('partials/index');
};

exports.scene = function(req, res) {
  return res.render('partials/scene');
};

exports.imgUpload = function(req, res) {
  req.pipe(req.busboy);
  return req.busboy.on('file', function(fieldname, file, filename) {
    var fstream;
    console.log("Uploading: " + filename);
    fstream = fs.createWriteStream("" + config.root + "/app/upload/" + filename);
    file.pipe(fstream);
    return fstream.on('close', function() {
      return res.send(200, "{\"status\":1,\"type\":null,\"name\":\"" + filename + "\",\"url\":\"/upload/" + filename + "\"}");
    });
  });
};
