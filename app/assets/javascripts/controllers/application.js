'use strict';

angular.module('beakerApp.controllers')
  .controller('ApplicationCtrl', ['$scope',
    function($scope) {
      $scope.currentUser = null;

      $scope.setCurrentUser = function(user) {
        $scope.currentUser = user;
      };
    }
  ]);
