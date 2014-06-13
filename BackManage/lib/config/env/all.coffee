'use strict'

path = require('path')
rootPath = path.normalize(__dirname + '/../../..')

module.exports = {
  root: rootPath
  ip: '0.0.0.0'
  port: process.env.PORT or 80
  mongo: {
    options: {
      db: {safe: true}
    }
  }
}
