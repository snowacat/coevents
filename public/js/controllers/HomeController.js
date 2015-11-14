'use strict';

/* Global params */
// Default page number
var pageNumber = 1;
// Default path for first page
var source = "show";
var categoryId = null;
var idParticipant = null;
// Count events on one page
var COUNT_EVENTS_ON_PAGE = 10;
var DEFAULT_ID_PAGE = 1;

/* Controller */
CoEvents.controller('HomeController', EventsController);

function EventsController($scope, EventsService, $location,  $modal, $route, DataCoords) {

    // Chart config
    $scope.configSummary = {
        title: 'Summary statistics',
        tooltips: true,
        labels: false,
        mouseover: function() {},
        mouseout: function() {},
        click: function() {},
        legend: {
            display: true,
            //could be 'left, right'
            position: 'right'
        }
    };

    $scope.configEventUsers = {
        title: 'Spreading users',
        tooltips: true,
        labels: false,
        mouseover: function() {},
        mouseout: function() {},
        click: function() {},
        legend: {
            display: true,
            //could be 'left, right'
            position: 'right'
        }
    };

    // Get data for charts Summary
    EventsService.query({source: 'statistics'}, function(answer){
        if (answer.length != 0)
        {
            $scope.data = {
                data: [{
                    x: "Events",
                    y: [answer[0].events]
                }, {
                    x: "Categories",
                    y: [answer[0].categories]
                }, {
                    x: "Users",
                    y: [answer[0].users]
                }]
            };
        }
    });

    // Get data for spread user on events
    EventsService.query({source: 'count_users_event'}, function(answer){
        if (answer.length != 0)
        {
            $scope.countUsersEvent = {
                data: answer
            };
        }
    });

    // Get events for default page
    EventsService.query({source:'show', idPage:pageNumber}, function(answer){
        if (answer.length == 0)
        {
            noEvents();
        }
        else
        {
            haveEvents(answer);
        }
    });

    // Get all category for navigation
    EventsService.query({source:'navigation'}, function(answer){
        if (answer.length == 0)
        {
            $scope.categories = "There are no category.";
        }
        else
        {
            $scope.treedata = buildHierarchy(answer);
        }
    });

    // Get all events from category
    $scope.$watch( 'category.currentNode', function(newObj, oldObj){
        if($scope.category && angular.isObject($scope.category.currentNode)){
            EventsService.query({source:'category', id:$scope.category.currentNode.value.id}, function(answer){
                if(answer.length == 0)
                {
                    // Clear events output
                    noEvents();
                }
                else
                {
                    haveEvents(answer);
                    source = "category";
                    pageNumber = DEFAULT_ID_PAGE;
                    idParticipant = null;
                    categoryId = $scope.category.currentNode.value.id
                }
            });
        }
    }, false);

    // Get all participants
    EventsService.query({source:'participants'}, function(answer){
        if (answer.length == 0)
        {
            $scope.authors = "There are no participants.";
        }
        else
        {
            $scope.authors = answer;
            $scope.author = $scope.authors[0];
        }
    });

    // Choose participant events
    $scope.authorChanged = function(value){
        EventsService.query({source:"participant", idUser:$scope.author.id, idPage:DEFAULT_ID_PAGE}, function(answer){
        if (answer.length == 0)
        {
            // Clear events output
            noEvents();
        }
        else
        {
            haveEvents(answer);
            // Initialize for click "More..."
            source = "participant";
            pageNumber = DEFAULT_ID_PAGE;
            idParticipant = $scope.author.id;
            categoryId = null;
        }});
    };

    // Get more events. Click "More"
    $scope.getMore = function(events){
        // Add css class "loading" for image
        $scope.inLoading = "loading";
        // Change text from "More" to "Loading"
        $scope.lblMore = "Loading...";
        // New page number
        pageNumber++;
        // Get next part of events
        // Path for participant: participant/1/null/1 = participant/1/1
        EventsService.query({source:source, idUser:idParticipant, id:categoryId, idPage:pageNumber}, function(answer){
            if (answer.length == 0)
            {
                noEvents();
            }
            else
            {
                haveEvents(answer);
            }
        });
    };

    // If no events
    function noEvents()
    {
        pageNumber = DEFAULT_ID_PAGE;
        $scope.posts = null;
        $scope.lblMore = "There are no more events.";
        $scope.noClickMore = "noClickMore";
        // Remove class for hide loading image
        $scope.inLoading = null;
    }

    // If we have events
    function haveEvents(answer)
    {
        $scope.posts = answer;
        $scope.inLoading = null;
        $scope.noClickMore = null;

        if (answer.length == COUNT_EVENTS_ON_PAGE)
        {
            $scope.lblMore = "More";
        }
        else
        {
            $scope.lblMore = "There are no more events.";
            $scope.noClickMore = "noClickMore";
        }
    }

    function buildHierarchy(arry)
    {
        var roots = [], children = {};

        // find the top level nodes and hash the children based on parent
        for (var i = 0, len = arry.length; i < len; ++i) {
            var item = arry[i],
                p = item.parent,
                target = !p ? roots : (children[p] || (children[p] = []));

            target.push({ value: item });
        }

        // function to recursively build the tree
        var findChildren = function(parent) {
            if (children[parent.value.id])
            {
                parent.children = children[parent.value.id];
                for (var i = 0, len = parent.children.length; i < len; ++i)
                {
                    findChildren(parent.children[i]);
                }
            }
        };

        // enumerate through to handle the case where there are multiple roots
        for (var i = 0, len = roots.length; i < len; ++i)
        {
            findChildren(roots[i]);
        }

        return roots;
    }

    /* Modal map window */
    $scope.open = function (lat, long){

        DataCoords.setProperty = { latitude: lat, longitude: long };

        $modal.open({
            animation: true,
            templateUrl: 'myModalContent.html',
            controller: 'ModalInstanceController',
            resolve: {
                lat: function () {
                    $scope.lat = lat;
                    return $scope.lat;
                },
                lng: function () {
                    $scope.lng = long;
                    return $scope.lng;
                }
            }
        });
    };
}