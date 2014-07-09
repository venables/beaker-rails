'use strict';

angular.module('beakerApp.controllers')
  .controller('NewSessionCtrl', ['$scope', 'sessions',
    function($scope, sessions) {
      $scope.formData = {};

      $scope.submit = function() {
        sessions
          .create($scope.formData)
          .success(function(data) {
            console.log(data);
          })
          .error(function(err) {
            console.log(err);
          });
      };
    }
  ]);
