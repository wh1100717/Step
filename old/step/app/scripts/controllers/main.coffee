'use strict'

app = angular.module 'stepApp'

app.controller 'MainCtrl', ($scope, $http) ->
	$http.get('/api/awesomeThings').success (awesomeThings) -> $scope.awesomeThings = awesomeThings

app.controller 'FileUploadCtrl', ($scope, $http, $filter, $window) ->
	$scope.fileList = [];
    $('#fileupload').bind('fileuploadadd', function(e, data){
            $scope.$apply(
            $scope.fileList.push({name: file.name})
            );   
        data.submit();
    });

app.controller 'FileDestroyCtrl', ($scope, $http) ->
	file = $scope.file
	if file.url
		file.$state = -> undefined
		file.$destroy = ->
			state = 'pending'
			return $http({
				url: file.deleteUrl
				method: file.deleteType
			}).then(->
				state = 'resolved'
				$scope.clear file
			,->
				state = 'rejected'
			)
	if not file.$cancel and not file._index
		file.$cancel = ->
			$scope.clear file
