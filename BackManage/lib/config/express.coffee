'use strict'

express = require('express')
favicon = require('static-favicon')
morgan = require('morgan')
compression = require('compression')
bodyParser = require('body-parser')
methodOverride = require('method-override')
cookieParser = require('cookie-parser')
session = require('express-session')
errorHandler = require('errorhandler')
path = require('path')
config = require('./config')
passport = require('passport')
mongoStore = require('connect-mongo')(session)

###
 * Express 配置文件
###

module.exports = (app) ->
  env = app.get('env')
  switch env
    when 'development'
      app.use require('connect-livereload')()
      # 开发环境下，取消Cache缓存功能，方便调试。
      app.use (req, res, next) ->
        if req.url.indexOf('/scripts/') is 0
          res.header('Cache-Control', 'no-cache, no-store, must-revalidate')
          res.header('Pragma', 'no-cache')
          res.header('Expires', 0)
        next()
        return
      app.use express.static(path.join(config.root, '.tmp'))
      app.use express.static(path.join(config.root, 'app'))
      app.set 'views', config.root + '/app/views'
    when 'production'
      app.use compression()
      app.use favicon(path.join(config.root, 'public', 'favicon.ico'))
      app.use express.static(path.join(config.root, 'public'))
      app.set 'views', config.root + '/views'
  # app.engine 'html', require('ejs').renderFile
  app.set 'view engine', 'jade'
  app.use morgan('dev')
  app.use bodyParser()
  app.use methodOverride()
  app.use cookieParser()

  # Psersist sessions with mongoStore
  app.use session {
    secret: 'step secret'
    store: new mongoStore {
      url: config.mongo.uri
      collection: 'sessions'
    }, ->
      console.log 'db connection open'
      return
  }

  # User passport session
  app.use passport.initialize()
  app.use passport.session()

  # Error handler - has to be last
  if 'development' is app.get('env')
    app.use errorHandler()
  return
