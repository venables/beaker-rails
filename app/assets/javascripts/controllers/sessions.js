'use strict';

angular.module('beakerApp.controllers')
  .controller('NewSessionCtrl', ['$location', '$scope', 'session',
    function($location, $scope, session) {
      $scope.formData = {};

      $scope.submit = function() {
        session
          .create($scope.formData, $scope.remember)
          .success(function(data) {
            $location.path('/');
          });
      };
    }
  ])
  .controller('DestroySessionCtrl', ['$location', '$scope', 'session',
    function($location, $scope, session) {
      session.destroy();
      $scope.setCurrentUser(null);

      $location.replace().path('/');
    }
  ]);
