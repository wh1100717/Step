'use strict'

mongoose = require('mongoose')
crypto = require('crypto')
Schema = mongoose.Schema



SceneSchema = new Schema({
  name: String
  name_en: String
  city: String
  province: String
  category: String
  alias: []
  location: {
    latitude: String
    longitude: String
    geo: String
    area: String
    type: Number
    addr: String
  }
  ext: {
    description: String
    images: []
    audio: String
    open_time: String
    acreage: Number
    ticket_price: Number
    phone: String
  }
  
})

module.exports = mongoose.model 'Scene', SceneSchema
