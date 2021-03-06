// Generated by CoffeeScript 1.7.1
'use strict';
var app;

app = angular.module('stepApp');

app.controller('MainCtrl', function($scope, $http) {
  return $http.get('/api/awesomeThings').success(function(awesomeThings) {
    return $scope.awesomeThings = awesomeThings;
  });
});

app.controller('FileUploadCtrl', function($scope, $http, $filter, $window) {
  $scope.options = {
    url: '/upload/img'
  };
  $scope.loadingFiles = true;
  return $http.get('/upload/img').then(function(response) {
    $scope.loadingFiles = false;
    return $scope.queue = response.data.files || [];
  }, function() {
    return $scope.loadingFiles = false;
  });
});

app.controller('FileDestroyCtrl', function($scope, $http) {
  var file;
  file = $scope.file;
  if (file.url) {
    file.$state = function() {
      return void 0;
    };
    file.$destroy = function() {
      var state;
      state = 'pending';
      return $http({
        url: file.deleteUrl,
        method: file.deleteType
      }).then(function() {
        state = 'resolved';
        return $scope.clear(file);
      }, function() {
        return state = 'rejected';
      });
    };
  }
  if (!file.$cancel && !file._index) {
    return file.$cancel = function() {
      return $scope.clear(file);
    };
  }
});
