'use strict';

/* Helper methods */
function renderImages($scope, results) {

	/*
	var i = 0,j = 0;
	var rows = [], row = [];
	while (i < results.data.length) {

		row.push(results.data[i]);

		j++;

		if (j == 6) {
			j = 0;
			rows.push(row);
			row = [];
		}

		i++;
	}

	$scope.rows = rows;
	*/

	$scope.data = results.data;
}

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
.controller('GalleryCtrl', ['$rootScope', '$scope', 'Instagram', function($rootScope, $scope, Instagram) {
	
	if ($rootScope.instagramToken) {
		
		Instagram.query(function (results) {
			renderImages($scope, results);
		});
	}
	else {
		// No access token found, go back to login
		window.location = '/app/#/login';
	}
}]);

angular.module('myAppToken.controllers', [])
.controller('TokenCtrl', ['$scope', function($scope) {
	
	// Extract access token
    var hash = location.hash;
    var arr = hash.split('=');
    var token = arr[1];

	window.location = '/app/#/login?token=' + token;
}]);