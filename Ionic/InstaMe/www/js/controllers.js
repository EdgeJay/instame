'use strict';

/* Helper methods */
function renderImages($scope, results) {

	$scope.data = results.data;
}

/* Controllers */

angular.module('myApp.controllers', [])
.controller('LoginCtrl', ['$rootScope', '$scope', 'clientId', 'redirectURI', '$window',
	function($rootScope, $scope, clientId, redirectURI, $window) {
		
		$window.alert('login!');
		$window.alert($window.location.href.indexOf('?token='));

		if ($window.location.href.indexOf('?token=') !== -1) {
			$rootScope.instagramToken = $window.location.href.split('?token=')[1];
		}

		if ($rootScope.instagramToken) {
			$window.location = '/#/feed';
		}
		else {
			$window.location = 'https://api.instagram.com/oauth/authorize/?client_id=' + clientId + '&redirect_uri=' + redirectURI + '&response_type=token';
		}
	}
])
.controller('GalleryCtrl', ['$rootScope', '$scope', 'Instagram', '$window', function($rootScope, $scope, Instagram, $window) {
	
	if ($rootScope.instagramToken) {
		
		Instagram.query(function (results) {
			renderImages($scope, results);
		});
	}
	else {
		// No access token found, go back to login
		$window.location = '/#/login';
	}
}]);

angular.module('myAppToken.controllers', [])
.controller('TokenCtrl', ['$scope', function($scope) {
	
	// Extract access token
    var hash = location.hash;
    var arr = hash.split('=');
    var token = arr[1];

	window.location = '/#/login?token=' + token;
}]);