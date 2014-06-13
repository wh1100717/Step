'use strict'

path = require('path')

exports.index = (req, res) -> res.render 'partials/index'

exports.scene = (req, res) -> res.render 'partials/scene'
