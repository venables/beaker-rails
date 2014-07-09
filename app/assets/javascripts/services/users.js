'use strict';

angular.module('beakerApp.services')
  .factory('users', ['$http',
    function($http) {
      var create = function(data) {
        return $http.post("/api/v1/users", { user: data });
      };

      return {
        create: create
      };
    }
  ]);
