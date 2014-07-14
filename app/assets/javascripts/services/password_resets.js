'use strict';

angular.module('beakerApp.services')
  .factory('passwordResets', ['$http',
    function($http) {
      var show = function(id) {
        return $http.get("/api/v1/password_resets/" + id);
      };

      var create = function(data) {
        return $http.post("/api/v1/password_resets", data);
      };

      var update = function(id, data) {
        return $http.put("/api/v1/password_resets/" + id, data);
      }

      return {
        create: create,
        show: show,
        update: update
      };
    }
  ]);
