var homeServices = angular.module('homeServices', ['ngResource']);

homeServices.factory('EventsService', ['$resource',
    function($resource, $path, $userId, $pageId, $categoryId){
            return $resource('events/:source/:idUser/:id/:idPage', {source: $path, idUser:$userId, id: $categoryId, idPage:$pageId},  {
        });
    }]);

homeServices.factory('DataCoords', function(){
    var property = null;
    return {
        getProperty: function () {
            return property;
        },
        setProperty: function(value) {
            property = value;
        }
    };
});
