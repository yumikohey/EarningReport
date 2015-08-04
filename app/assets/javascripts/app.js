earnings = angular.module('earnings',[
	'templates',
  'ui.router',
  'controllers'
])

.config(['$stateProvider', '$urlRouterProvider', '$locationProvider', function($stateProvider, $urlRouterProvider, $locationProvider){
	$stateProvider
	  .state('home', {
	  	url:'/',
	  	templateUrl: 'index.html',
	  	controller: 'calenderCtrl'
	  });

	  $urlRouterProvider.otherwise('/');

	  $locationProvider.html5Mode(true);
}]);

controllers = angular.module('controllers',[])

controllers.controller('calenderCtrl', function($scope){
	$scope.dates = '2015-08-03';
});