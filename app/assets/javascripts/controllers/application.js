'use strict';

angular.module('beakerApp.controllers')
  .controller('ApplicationCtrl', ['$scope', 'session', 'users',
    function($scope, session, users) {
      $scope.currentUser = null;

      $scope.$on('currentUser', function(event, user) {
        $scope.currentUser = user;
      });

      $scope.$on('signin', function(event, sessionData) {
        users
          .show(sessionData.user_id)
          .success(function(data) {
            session.setCurrentUser(data.user);
          });
      });

      // Load the customer from a cookie upon page load, if possible
      session.loadFromCookie();
    }
  ]);
