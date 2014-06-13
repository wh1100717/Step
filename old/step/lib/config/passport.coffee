'use strict'

mongoose = require('mongoose')
User = mongoose.model('User')
passport = require('passport')
LocalStrategy = require('passport-local').Strategy

###
 * Passport 配置文件
###

passport.serializeUser (user, done) -> done null, user.id;return

passport.deserializeUser (id, done) ->
  User.findOne {
    _id: id
  }, '-salt -hashedPassword', (err, user) -> done err, user;return
  return
# add other strategies for more authentication flexibility
passport.use new LocalStrategy {
    usernameField: 'email'
    passwordField: 'password'
  }, (email, password, done) ->
    User.findOne {
      email: email.toLowerCase()
    }, (err, user) ->
      return done err if err
      return done null, false, {message: 'This email is not registered'} if not user
      return done null, false, {message: 'This password is not correct'} if not user.authenticate password
      return done null, user
    return
module.exports = passport