'use strict'

angular.module('stepApp')
  .factory 'Session', ($resource) ->
    $resource '/api/session/'
