'use strict';

angular.module('beakerApp.services')
  .factory('session', ['$http', 'users',
    function($http, users) {
      var token;
      var user;

      var create = function(data) {
        return $http
          .post("/api/v1/session", data)
          .success(function(data) {
            token = data.session_token;
            $http.defaults.headers.common.Authorization = 'Token token="' + token + '"';
          });
      };

      return {
        create: create,
        token: token,
        user: user
      };
    }
  ]);
