'use strict';

/* Controllers */

angular.module('myApp.controllers', [])
.controller('LoginCtrl', ['$rootScope', '$scope', function($rootScope, $scope) {
	
	if (location.href.indexOf('?token=') !== -1) {
		$rootScope.instagramToken = location.href.split('?token=')[1];
	}

	if ($rootScope.instagramToken) {
		window.location = '/app/#/feed';
	}
	else {
		window.location = 'https://api.instagram.com/oauth/authorize/?client_id=8b5caf25183041c1bc0856cbd2a6b4bc&redirect_uri=http://localhost:8000/app/token.html&response_type=token';
	}
}])
.controller('GalleryCtrl', ['$rootScope', '$scope', function($rootScope, $scope) {
	console.log('got access token: ' + $rootScope.instagramToken);
}]);

angular.module('myAppToken.controllers', [])
.controller('TokenCtrl', ['$scope', function($scope) {
	
	// Extract access token
    var hash = location.hash;
    var arr = hash.split('=');
    var token = arr[1];

	window.location = '/app/#/login?token=' + token;
}]);