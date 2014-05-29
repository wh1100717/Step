'use strict';

var mongoose = require('mongoose'),
  Thing = mongoose.model('Thing');

/**
 * Get awesome things
 */
exports.awesomeThings = function(req, res) {
  return Thing.find(function(err, things) {
    if (!err) {
      return res.json(things);
    } else {
      return res.send(err);
    }
  });
};

exports.jia = function(req, res) {
  return res.json({
    state: 1,
    data: ["h1", "h2"]
  });
};

exports.jia2 = function(req, res) {
  return res.json({
    state: 1,
    data: "haha"
  })
}