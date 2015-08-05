earnings = angular.module('earnings',[
	'templates',
  'ui.router'
])

.config(['$stateProvider', '$urlRouterProvider', '$locationProvider', function($stateProvider, $urlRouterProvider, $locationProvider){
	template_url = 'angular-app/templates/'
	$stateProvider
	  .state('home', {
	  	url:'/',
	  	templateUrl: template_url + 'earnings_calender/index.html',
	  	controller: 'stocksCtrl'
	  });

	  $urlRouterProvider.otherwise('/');

	  $locationProvider.html5Mode(true);
}]);


