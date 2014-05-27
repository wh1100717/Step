'use strict'

mongoose = require('mongoose')
User = mongoose.model('User')
passport = require('passport')
LocalStrategy = require('passport-local').Strategy

###
 * Passport configuration
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


# 'use strict';

# var mongoose = require('mongoose'),
#     User = mongoose.model('User'),
#     passport = require('passport'),
#     LocalStrategy = require('passport-local').Strategy;

# /**
#  * Passport configuration
#  */
# passport.serializeUser(function(user, done) {
#   done(null, user.id);
# });
# passport.deserializeUser(function(id, done) {
#   User.findOne({
#     _id: id
#   }, '-salt -hashedPassword', function(err, user) { // don't ever give out the password or salt
#     done(err, user);
#   });
# });

# // add other strategies for more authentication flexibility
# passport.use(new LocalStrategy({
#     usernameField: 'email',
#     passwordField: 'password' // this is the virtual field on the model
#   },
#   function(email, password, done) {
#     User.findOne({
#       email: email.toLowerCase()
#     }, function(err, user) {
#       if (err) return done(err);
      
#       if (!user) {
#         return done(null, false, {
#           message: 'This email is not registered.'
#         });
#       }
#       if (!user.authenticate(password)) {
#         return done(null, false, {
#           message: 'This password is not correct.'
#         });
#       }
#       return done(null, user);
#     });
#   }
# ));

# module.exports = passport;
