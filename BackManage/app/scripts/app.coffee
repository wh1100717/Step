'use strict'

step = angular.module 'stepApp', [
  'ngCookies'
  'ngResource'
  'ngSanitize'
  'ngRoute'
  'blueimp.fileupload'
]
step.config ($routeProvider, $locationProvider, $httpProvider, fileUploadProvider) ->
  $routeProvider
    .when '/',
      templateUrl: 'partials/main'
      controller: 'MainCtrl'
    .when '/login',
      templateUrl: 'partials/login'
      controller: 'LoginCtrl'
    .when '/signup', 
      templateUrl: 'partials/signup'
      controller: 'SignupCtrl'
    .when '/settings',
      templateUrl: 'partials/settings'
      controller: 'SettingsCtrl'
      authenticate: true
    .when '/test',
      templateUrl: 'partials/test1'
      controller: 'MainCtrl'
    .otherwise
      redirectTo: '/'

  $locationProvider.html5Mode true

  # Intercept 401s and redirect you to login
  $httpProvider.interceptors.push ['$q', '$location', ($q, $location) ->
    responseError: (response) ->
      if response.status is 401
        $location.path '/login'
        $q.reject response
      else
        $q.reject response
  ]

  delete $httpProvider.defaults.headers.common['X-Requested-With']
  fileUploadProvider.defaults.redirect = window.location.href.replace(/\/[^\/]*$/,'/cors/result.html?%s')


step.run ($rootScope, $location, Auth) ->
  # Redirect to login if route requires auth and you're not logged in
  $rootScope.$on '$routeChangeStart', (event, next) ->
    $location.path '/login'  if next.authenticate and not Auth.isLoggedIn()