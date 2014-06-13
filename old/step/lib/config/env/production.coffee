'use strict'

module.exports = {
  env: 'production'
  ip: process.env.OPENSHIFT_NODEJS_IP or process.env.IP or '0.0.0.0'
  port: process.env.OPENSHIFT_NODEJS_PORT or process.env.PORT or 8080
  mongo: {
    uri: process.env.MONGOLAB_URI or process.env.MONGOHQ_URL or process.env.OPENSHIFT_MONGODB_DB_URL + process.env.OPENSHIFT_APP_NAME or 'mongodb://localhost/step'
  }
}
