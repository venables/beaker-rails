'use strict';

angular.module('beakerApp.controllers')
  .controller('SignInCtrl', ['$scope', 'sessions',
    function($scope, sessions) {
      $scope.formData = {};

      $scope.submit = function() {
        sessions
          .signIn($scope.formData)
          .success(function(data) {
            console.log(data);
          })
          .error(function(err) {
            console.log(err);
          });
      };
    }
  ]);
