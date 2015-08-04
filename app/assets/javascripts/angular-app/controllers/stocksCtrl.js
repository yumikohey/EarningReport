controllers.controller('stocksCtrl', function($scope, Stock){
	Stock.all()
	.success(function(data) {
		$scope.monday = data.ereports[0];
		$scope.tuesday = data.ereports[1];
		$scope.wednesday = data.ereports[2];
		$scope.thursday = data.ereports[3];
		$scope.friday = data.ereports[4];
	})
	$scope.order = function(predicate) {
    $scope.reverse = ($scope.predicate === predicate) ? !$scope.reverse : false;
    $scope.predicate = predicate;
  };
});