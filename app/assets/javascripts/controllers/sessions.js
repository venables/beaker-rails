'use strict';

angular.module('beakerApp.controllers')
  .controller('NewSessionCtrl', ['$location', '$scope', 'session',
    function($location, $scope, session) {
      $scope.formData = {};

      $scope.submit = function() {
        session
          .create($scope.formData)
          .success(function(data) {
            $location.path('/');
            console.log(data);
          })
          .error(function(err) {
            console.log(err);
          });
      };
    }
  ])
  .controller('DestroySessionCtrl', ['$location', 'session',
    function($location, session) {
      session.destroy();
      $location.replace().path('/');
    }
  ]);
