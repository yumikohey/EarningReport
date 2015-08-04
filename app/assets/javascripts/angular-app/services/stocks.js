angular.module("earnings")
.factory("Stock", function StockFactory($http){
	return {
		all: function() {
			return $http({method: "GET", url:"/er"});
		}
	}
});