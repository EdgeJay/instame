'use strict';

/* Services */


// Demonstrate how to register services
// In this case it is a simple value service.
angular.module('myApp.services', ['ngResource'])
.value('version', '0.1')
.factory('Instagram', ['$rootScope', '$resource', '$q', function ($rootScope, $resource, $q) {
	//return $resource('https://api.instagram.com/v1/users/self/feed?access_token=:accessToken', {}, {});
	return $resource('https://api.instagram.com/v1/users/self/feed', {}, {
				query: {
					method:'jsonp',
					params: {
						access_token: $rootScope.instagramToken,
						callback: 'JSON_CALLBACK'
					}
				}
			});/*function () {
			
			var url = 'https://api.instagram.com/v1/users/self/feed?access_token=' + $rootScope.instagramToken;
			
			$http.jsonp(url, { params: { callback: 'JSON_CALLBACK' } })
			.success(function (data, status, headers, config) {
				console.log(data);
			})
			.error(function (data, status, headers, config) {
				console.log(data);
			});
		}*/
}]);
