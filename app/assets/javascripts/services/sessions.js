'use strict';

angular.module('beakerApp.services')
  .factory('sessions', ['$http',
    function($http) {
      var create = function(data) {
        return $http.post("/api/v1/session", data);
      };

      return {
        create: create
      };
    }
  ]);
