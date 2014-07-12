'use strict';

angular.module('beakerApp.services')
  .factory('users', ['$http',
    function($http) {
      var show = function(id) {
        return $http.get("/api/v1/users/" + id);
      };

      var create = function(data) {
        return $http.post("/api/v1/users", { user: data });
      };

      return {
        create: create,
        show: show
      };
    }
  ]);
