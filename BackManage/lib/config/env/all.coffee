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
  upyun: {
    img: {
      bucketname: 'westep-img'
      username: 'westep'
      password: 'westep0000'
      base_url: 'http://westep-img.b0.upaiyun.com'
    }
    file: {
      bucketname: 'westep-file'
      username: 'westep'
      password: 'westep0000'
      base_url: 'http://westep-file.b0.upaiyun.com'
    }
  }
}
