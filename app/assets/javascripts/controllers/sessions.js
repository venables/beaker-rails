'use strict';

angular.module('beakerApp.controllers')
  .controller('NewSessionCtrl', ['$scope', 'session',
    function($scope, session) {
      $scope.formData = {};

      $scope.submit = function() {
        session
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
