'use strict';

/* Helper methods */
function renderImages($scope, results) {

	$scope.data = results.data;
}

/* Controllers */

angular.module('myApp.controllers', [])
.controller('LoginCtrl', ['$rootScope', '$scope', 'clientId', 'authURL', 'redirectURI', '$window',
	function($rootScope, $scope, clientId, authURL, redirectURI, $window) {
		
		if ($window.location.href.indexOf('?token=') !== -1) {
			$rootScope.instagramToken = $window.location.href.split('?token=')[1];
		}

		if ($rootScope.instagramToken) {
			alert('found existing token: ' + $rootScope.instagramToken);
			$window.location = '#/feed';
		}
		else {
			//$window.location = authURL + '?client_id=' + clientId + '&redirect_uri=' + redirectURI + '&response_type=token';
			var win = window.open(
				authURL + '?client_id=' + clientId + '&redirect_uri=' + redirectURI + '&response_type=token', 
				'_blank',
				'location=no');
			
			win.addEventListener('loadstart', function (evt) {
				
				var url = evt.url;
				if (url.indexOf('access_token=') !== -1) {

					var arr = url.split('access_token=');
					$rootScope.instagramToken = arr[1];
					//alert($rootScope.instagramToken);
					win.close();

					$window.location = '#/feed';
				}

				/*
				var str = '';
				for (var k in evt) {
					str += k + ':' + evt[k] + '\n';
				}
				alert(str);
				*/
			});
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
		$window.location = '#/login';
	}
}]);

angular.module('myAppToken.controllers', [])
.controller('TokenCtrl', ['$scope', function($scope) {
	
	// Extract access token
    var hash = location.hash;
    var arr = hash.split('=');
    var token = arr[1];

	window.location = '#/login?token=' + token;
}]);