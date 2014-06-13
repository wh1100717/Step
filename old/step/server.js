'use strict';

var express = require('express'),
  path = require('path'),
  fs = require('fs'),
  mongoose = require('mongoose');

/**
 * 主程序入口
 */

// 默认开发环境为 NODE_ENV，如果没有设置则为 `development`
process.env.NODE_ENV = process.env.NODE_ENV || 'development';

// 加载配置信息
var config = require('./lib/config/config');
// 连接数据库
var db = mongoose.connect(config.mongo.uri, config.mongo.options);

// 初始化 models
var modelsPath = path.join(__dirname, 'lib/models');
fs.readdirSync(modelsPath).forEach(function(file) {
  if (/(.*)\.(js$)/.test(file)) {
    require(modelsPath + '/' + file);
  }
});

// 清空数据库并构造假数据
require('./lib/config/dummydata');

// 配置 Passport
var passport = require('./lib/config/passport');

// 配置Express
var app = express();
require('./lib/config/express')(app);
require('./lib/routes')(app);

// 启动服务器
app.listen(config.port, config.ip, function() {
  console.log('Express server listening on %s:%d, in %s mode', config.ip, config.port, app.get('env'));
});

// 作为接口进行对外暴露
exports = module.exports = app;