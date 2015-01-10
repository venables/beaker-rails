'use strict'

$(function() {
  var API = {
    headers: function() {
      var result = {};

      if (Session.token) {
        result['Authorization'] =  'Token token=' + Session.token;
      }

      return result
    },


    perform: function(method, url, data, callback) {
      // TODO: ADD HEADERS HERE
      $.ajax({
        type: method,
        url: url,
        data: data,
        dataType: 'text',
        headers: API.headers(),
        success: function(data) {
          var json = null;

          try {
            json = JSON.parse(data);
          } catch(e) {}

          API.handleSuccess(json);

          if (callback) { callback(null, json); }
        },
        error: function(xhr) {
          var json = null;

          try {
            json = JSON.parse(xhr.responseText);
          } catch(e) {}

          var errors = json && json.errors && json.errors.messages || [];
          API.handleError(errors);
          if (callback) { callback(errors); }
        }
      });
    },

    get: function(url, callback) {
      API.perform('GET', url, undefined, callback);
    },

    post: function(url, data, callback) {
      API.perform('POST', url, data, callback);
    },

    put: function(url, data, callback) {
      API.perform('PUT', url, data, callback);
    },

    del: function(url, callback) {
      API.perform('DELETE', url, undefined, callback);
    },

    handleSuccess: function(data) {
      if (!data) { return; }

      if (data.session && data.session.token) {
        Session.signIn(data.session.token, data.user.id);
      }
    },

    handleError: function(errors) {
      if (errors.length > 0) {
        alert(errors.join('. '));
      }
    }
  };

  window.API = API;
});
