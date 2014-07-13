'use strict';

angular.module('beakerApp.controllers')
  .controller('NewSessionCtrl', ['$location', '$scope', 'session', 'users',
    function($location, $scope, session, users) {
      $scope.formData = {};

      $scope.submit = function() {
        session
          .create($scope.formData)
          .success(function(data) {
            $location.path('/');

            users
              .show(data.session.user_id)
              .success(function(data) {
                $scope.setCurrentUser(data.user);
              });
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
