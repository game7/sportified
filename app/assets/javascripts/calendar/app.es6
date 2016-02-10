const CalendarApp = angular.module('CalendarApp', ['ui.calendar', 'ui.router', 'ui.bootstrap', 'templates']);

CalendarApp.config(['$stateProvider', '$urlRouterProvider', ($stateProvider, $urlRouterProvider) => {
  $urlRouterProvider.otherwise('/');
  $stateProvider.state('index', {
    url: '/',
    templateUrl: '/assets/calendar/index.html',
    controller: IndexCtrl
  });
}]);