// Generated by CoffeeScript 1.7.1
'use strict';
var _;

_ = require('lodash');


/*
 * Load environment configuration
 */

module.exports = _.merge(require('./env/all.js'), require('./env/' + process.env.NODE_ENV + '.js') || {});
