'use strict';

/* Global params */
var MAP_ZOOM = 13;

/* Controller */
CoEvents.controller('ModalInstanceController', DrawMap);

function DrawMap ($scope, $modalInstance, DataCoords) {
    var coords = DataCoords.setProperty;
    $scope.map = { center: { latitude: coords.latitude, longitude:  coords.longitude }, zoom: MAP_ZOOM };

    $scope.marker = {
        id: 0,
        coords: {
            latitude: coords.latitude,
            longitude: coords.longitude
        }
    };

    $scope.ok = function () {
        $modalInstance.close();
    };
}
