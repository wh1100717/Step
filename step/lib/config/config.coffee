'use strict'

_ = require('lodash')

###
 * 加载环境配置信息，根据prcoess.env.NODE_ENV来决定加载何种配置信息，默认为 `development`
###
module.exports = _.merge(
	require('./env/all.js'), 
	require('./env/' + process.env.NODE_ENV + '.js') || {})