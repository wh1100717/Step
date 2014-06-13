// Generated by CoffeeScript 1.7.1
'use strict';
var bodyParser, compression, config, cookieParser, errorHandler, express, favicon, methodOverride, mongoStore, morgan, passport, path, session;

express = require('express');

favicon = require('static-favicon');

morgan = require('morgan');

compression = require('compression');

bodyParser = require('body-parser');

methodOverride = require('method-override');

cookieParser = require('cookie-parser');

session = require('express-session');

errorHandler = require('errorhandler');

path = require('path');

config = require('./config');

passport = require('passport');

mongoStore = require('connect-mongo')(session);


/*
 * Express 配置文件
 */

module.exports = function(app) {
  var env;
  env = app.get('env');
  switch (env) {
    case 'development':
      app.use(require('connect-livereload')());
      app.use(function(req, res, next) {
        if (req.url.indexOf('/scripts/') === 0) {
          res.header('Cache-Control', 'no-cache, no-store, must-revalidate');
          res.header('Pragma', 'no-cache');
          res.header('Expires', 0);
        }
        next();
      });
      app.use(express["static"](path.join(config.root, '.tmp')));
      app.use(express["static"](path.join(config.root, 'app')));
      app.set('views', config.root + '/app/views');
      break;
    case 'production':
      app.use(compression());
      app.use(favicon(path.join(config.root, 'public', 'favicon.ico')));
      app.use(express["static"](path.join(config.root, 'public')));
      app.set('views', config.root + '/views');
  }
  app.set('view engine', 'jade');
  app.use(morgan('dev'));
  app.use(bodyParser());
  app.use(methodOverride());
  app.use(cookieParser());
  app.use(session({
    secret: 'step secret',
    store: new mongoStore({
      url: config.mongo.uri,
      collection: 'sessions'
    }, function() {
      console.log('db connection open');
    })
  }));
  app.use(passport.initialize());
  app.use(passport.session());
  if ('development' === app.get('env')) {
    app.use(errorHandler());
  }
};
