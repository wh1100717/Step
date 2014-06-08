'use strict'

cities = require('../controllers/cities');

console.log cities

module.exports = (app) ->
    app.route('/cities/:city/scenes')
        .get(cities.scenes.list)
    app.route('/cities/:city/scenes/:scenes')
        .get(cities.scenes.show)
        .post(cities.scenes.save)
    # app.route('/cities/:city/scenes/:scenes')
    #     .post(cities.scenes.save)	
    app.route('/cities/:city/scenes/:scene/children')
        .get(cities.scenes.children.show)
    .post(cities.scenes.children.save)
