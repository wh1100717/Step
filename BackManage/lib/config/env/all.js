// Generated by CoffeeScript 1.7.1
'use strict';
var path, rootPath;

path = require('path');

rootPath = path.normalize(__dirname + '/../../..');

module.exports = {
  root: rootPath,
  ip: '0.0.0.0',
  port: process.env.PORT || 80,
  mongo: {
    options: {
      db: {
        safe: true
      }
    }
  }
};