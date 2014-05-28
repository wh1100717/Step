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
    longtitude: Number
    latitude: Number
    altitude: Number
    radius: Number
    geo: String
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
  children: [
    {
      name: String
      name_en: String
      type: String
      category: String
      alias: []
      location: {
        longtitude: Number
        latitude: Number
        altitude: Number
        radius: Number
        geo: String
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
    }
  ]
})

module.exports = mongoose.model 'Scene', SceneSchema
