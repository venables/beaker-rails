'use strict';

angular.module('beakerApp.services')
  .factory('session', ['$http', '$rootScope', 'cookies',
    function($http, $rootScope, cookies) {
      var token;
      var cookieName = '_beaker_session'

      var setSession = function(sessionData) {
        token = sessionData.token;
        $http.defaults.headers.common.Authorization = 'Token token="' + token + '"';
        $rootScope.$broadcast('signin', sessionData);
      }

      var create = function(data) {
        return $http
          .post("/api/v1/session", data)
          .success(function(data) {
            setSession(data.session);
            cookies.set(cookieName, data.session);
          });
      };

      var destroy = function() {
        token = null;
        $http.defaults.headers.common.Authorization = null;
        cookies.clear(cookieName);
      };

      var loadFromCookie = function() {
        var sessionData = cookies.get(cookieName);

        if (sessionData) {
          console.log(sessionData);
          setSession(sessionData);
        }
      };

      return {
        create: create,
        destroy: destroy,
        loadFromCookie: loadFromCookie
      };
    }
  ]);
