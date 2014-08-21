'use strict';

/* Services */


// Demonstrate how to register services
// In this case it is a simple value service.
angular.module('myApp.services', ['ngResource'])
.value('version', '0.1')
.value('feedUri', 'https://api.instagram.com/v1/users/self/feed')
.value('clientId', '6275c75255724021ba00e59b410413b2')
.value('redirectURI', 'http://localhost:8100/token.html')
.value('defaultCount', 32)
.value('pagesToPreload', 3)
.factory('Instagram', ['$rootScope', '$resource', '$q', 'feedUri', 'defaultCount',
	function ($rootScope, $resource, $q, feedUri, count) {

		var nextMaxId = null;

		return $resource(feedUri, {}, {
					query: {
						method:'jsonp',
						params: {
							access_token: $rootScope.instagramToken,
							count: count,
							callback: 'JSON_CALLBACK'
						}
					}
				});
}]);
