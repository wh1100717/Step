'use strict'

mongoose = require('mongoose')
Schema = mongoose.Schema

CitySchema = new Schema({
  name: String
  scenes: []
})

module.exports = mongoose.model 'City', CitySchema
