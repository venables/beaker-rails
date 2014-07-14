'use strict';

angular.module('beakerApp.services')
  .factory('session', ['$http', '$rootScope', 'cookie',
    function($http, $rootScope, cookie) {
      var token;
      var user;
      var cookieName = '_beaker_session'

      var setSession = function(sessionData) {
        token = sessionData.token;
        $http.defaults.headers.common.Authorization = 'Token token="' + token + '"';
        $rootScope.$broadcast('signin', sessionData);
      }

      var create = function(data, remember) {
        return $http
          .post("/api/v1/session", data)
          .success(function(data) {
            var cookieOpts = remember ? { expires: 30 } : {};

            setSession(data.session);

            cookie.set(cookieName, data.session, cookieOpts);
          });
      };

      var destroy = function() {
        token = null;
        $http.defaults.headers.common.Authorization = null;
        cookie.unset(cookieName);
      };

      var loadFromCookie = function() {
        var sessionData = cookie.get(cookieName);

        if (sessionData) {
          setSession(sessionData);
        }
      };

      var setCurrentUser = function(newUser) {
        user = newUser;
        $rootScope.$broadcast('currentUser', user);
      };

      return {
        create: create,
        destroy: destroy,
        loadFromCookie: loadFromCookie,
        setCurrentUser: setCurrentUser
      };
    }
  ]);
