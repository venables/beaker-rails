'use strict';

angular.module('beakerApp.services')
  .factory('sessions', ['$http', 'users',
    function($http, users) {
      var token;
      var user;

      var create = function(data) {
        return $http
          .post("/api/v1/session", data)
          .success(function(data) {
            token = data.token;
          });
      };

      return {
        create: create,
        token: token,
        user: user
      };
    }
  ]);
