// Generated by CoffeeScript 1.7.1
'use strict';
var cities;

cities = require('../controllers/cities');

module.exports = function(app) {
  app.route('/cities/:city/scenes').get(cities.scenes.list);
  app.route('/cities/:city/scenes/:scenes').get(cities.scenes.show).post(cities.scenes.save);
  return app.route('/cities/:city/scenes/:scene/children').get(cities.scenes.children.show).post(cities.scenes.children.save);
};
