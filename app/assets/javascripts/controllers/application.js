'use strict';

angular.module('beakerApp.controllers')
  .controller('ApplicationCtrl', ['$scope', 'session', 'users',
    function($scope, session, users) {
      $scope.currentUser = null;

      $scope.setCurrentUser = function(user) {
        $scope.currentUser = user;
      };

      $scope.$on('signin', function(event, sessionData) {
        console.log(sessionData);
        users
          .show(sessionData.user_id)
          .success(function(data) {
            $scope.setCurrentUser(data.user);
          });
      });

      session.loadFromCookie();
    }
  ]);
