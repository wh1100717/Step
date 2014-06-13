'use strict'

path = require('path')

###
 * Send partial, or 404 if it doesn't exist
###
exports.partials = (req, res) ->
  stripped = req.url.split('.')[0]
  requestedView = path.join './', stripped
  res.render requestedView, (err, html) ->
    if err
      console.log "Error rendering partials '#{requestedView}'\n#{err}"
      res.status 404
      res.send 404
    else
      console.log requestedView
      res.send html

###
 * Send our single page app
###
exports.index = (req, res) -> res.render 'index'

exports.scene = (req, res) -> res.render 'scene'
