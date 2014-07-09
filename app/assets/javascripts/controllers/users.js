'use strict';

angular.module('beakerApp.controllers')
  .controller('NewUserCtrl', ['$scope', 'users',
    function($scope, users) {
      $scope.formData = {};

      $scope.submit = function() {
        users
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
