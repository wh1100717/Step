// Generated by CoffeeScript 1.7.1
'use strict';
var Scene, mongoose;

mongoose = require('mongoose');

Scene = mongoose.model('Scene');

exports.create = function(req, res, next) {
  var newScene;
  newScene = new Scene(req.body);
  newScene.save(function(err) {
    if (err) {
      return res.json(400, err);
    }
  });
};

exports.show_by_id = function(req, res, next) {
  var id;
  id = req.params.id;
  Scene.findById(id, function(err, scene) {
    if (err) {
      return next(err);
    }
    if (!scene) {
      return res.send(404);
    }
    res.send({
      status: 'success',
      data: scene
    });
  });
};

exports.show_all = function(req, res, next) {
  return Scene.find(function(err, scene) {
    if (err) {
      return next(err);
    }
    if (!scene) {
      return res.send(404);
    }
    res.send({
      status: 'success',
      data: scene
    });
  });
};

exports.show_by_name = function(req, res, next) {
  var name;
  name = req.params.name;
  console.log(name);
  Scene.find({
    sname: name
  }, function(err, scene) {
    if (err) {
      return next(err);
    }
    if (!scene) {
      return res.send(404);
    }
    res.send({
      status: 'success',
      data: scene
    });
  });
};

exports.save_scene = function(req, res, next) {};
