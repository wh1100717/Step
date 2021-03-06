// Generated by CoffeeScript 1.7.1
'use strict';
var ScenedetailSchema, Schema, crypto, mongoose;

mongoose = require('mongoose');

crypto = require('crypto');

Schema = mongoose.Schema;

ScenedetailSchema = new Schema({
    content: String,
    play_time: String,
    children_scenes: [],
    name: String,
    phone: String,
    parent_scene: String,
    surl: String,
    city_cn: String,
    best_visit_time: String,
    has_gone: String,
    address: String,
    open_time: String,
    update: String,
    category: String,
    type: String,
    location: [
        new Schema({
            latitude: String,
            longitude: String,
            geo: String,
            area: String,
            addr: String
        })
    ]
});

module.exports = mongoose.model('Scenedetail', ScenedetailSchema);