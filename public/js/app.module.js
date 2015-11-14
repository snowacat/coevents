var CoEvents = angular.module('app', [
    /* Angular default */
    'ngRoute',
    'ngAnimate',
    /* Third part */
    'angularTreeview',
    'ui.bootstrap',
    'uiGmapgoogle-maps',
    'angularCharts',
    /* My  */
    'homeServices'
]);

CoEvents.config(function($routeProvider) {
    $routeProvider
        .when('/graphics', {
            templateUrl: 'views/graphics.html',
            controller: 'HomeController'
        })
        .when('/events', {
            templateUrl: 'views/index.html',
            controller: 'HomeController'
        })
        .otherwise({
            templateUrl: 'views/index.html',
            controller: 'HomeController'
        });
});

//CoEvents.controller('aboutController', function($scope) {
//    $scope.message = 'Look! I am an about page.';
//});