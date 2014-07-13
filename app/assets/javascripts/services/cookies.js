'use strict';

angular.module('beakerApp.services')
  .factory('cookies', ['$cookieStore',
    function($cookieStore) {
      var clear = function(name) {
        $cookieStore.remove(name);
      };

      var get = function(name) {
        return $cookieStore.get(name);
      };

      var set = function(name, val) {
        $cookieStore.put(name, val);
      };

      return {
        clear: clear,
        get: get,
        set: set
      };
    }
  ]);
