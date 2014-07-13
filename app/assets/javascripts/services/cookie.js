'use strict';

angular.module('beakerApp.services')
  .factory('cookie', ['$location', 'ipCookie',
    function($location, ipCookie) {
      var defaults = { path: '/', secure: $location.protocol() === 'https' };

      var get = function(name) {
        return ipCookie(name);
      };

      var set = function(name, val, opts) {
        opts = _.extend({}, defaults, opts);

        return ipCookie(name, val, opts);
      };

      var unset = function(name, opts) {
        opts = _.extend({}, defaults, opts);

        return ipCookie.remove(name, opts);
      };

      return {
        get: get,
        set: set,
        unset: unset
      };
    }
  ]);
