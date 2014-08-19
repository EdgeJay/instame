'use strict';


// Declare app level module which depends on filters, and services
angular.module('myApp', [
  'ngRoute',
  'myApp.filters',
  'myApp.services',
  'myApp.directives',
  'myApp.controllers'
]).
config(['$routeProvider', function($routeProvider) {
  // Login route
  $routeProvider.when('/login', {
  	templateUrl: 'partials/login.html',
  	controller: 'LoginCtrl'});
  // Gallery route
  $routeProvider.when('/feed', {
    templateUrl: 'partials/gallery.html',
    controller: 'GalleryCtrl'});
  // Default route
  $routeProvider.otherwise({redirectTo: '/login'});
}]);

angular.module('myAppToken', ['myAppToken.controllers']);
