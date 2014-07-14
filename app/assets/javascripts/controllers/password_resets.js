'use strict';

angular.module('beakerApp.controllers')
  .controller('NewPasswordResetCtrl', ['$location', '$scope', 'passwordResets',
    function($location, $scope, passwordResets) {
      $scope.formData = {};

      $scope.submit = function() {
        passwordResets
          .create($scope.formData)
          .success(function(data) {
            $location.path('/');
          });
      };
    }
  ])
  .controller('EditPasswordResetCtrl', ['$location', '$routeParams', '$scope', 'passwordResets',
    function($location, $routeParams, $scope, passwordResets) {
      var resetToken = $routeParams.token;

      $scope.formData = {};

      $scope.submit = function() {
        passwordResets
          .update(resetToken, $scope.formData)
          .success(function(data) {
            $location.path('/signin');
          });
      };
    }
  ]);
