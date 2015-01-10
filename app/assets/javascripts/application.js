// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require_tree .
//= require_self

'use strict';

$(function() {
  var Session = {
    token: null,

    signIn: function(token) {
      Session.token = token;
      Session.toggleViews();
    },

    signOut: function() {
      Session.token = null;
      Session.toggleViews();
    },

    toggleViews: function() {
      if (Session.token) {
        $('#not-authenticated').hide();
        $('#authenticated').show();
      } else {
        $('#not-authenticated').show();
        $('#authenticated').hide();
      }
    }
  };

  var api = {
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
        headers: api.headers(),
        success: function(data) {
          var json = null;

          try {
            json = JSON.parse(data);
          } catch(e) {}

          api.handleSuccess(json);

          if (callback) { callback(null, json); }
        },
        error: function(xhr) {
          var json = null;

          try {
            json = JSON.parse(xhr.responseText);
          } catch(e) {}

          var errors = json && json.errors && json.errors.messages || [];
          api.handleError(errors);
          if (callback) { callback(errors); }
        }
      });
    },

    post: function(url, data, callback) {
      api.perform('POST', url, data, callback);
    },

    put: function(url, data, callback) {
      api.perform('PUT', url, data, callback);
    },

    del: function(url, callback) {
      api.perform('DELETE', url, {}, callback);
    },

    handleSuccess: function(data) {
      if (!data) { return; }

      if (data.session && data.session.token) {
        Session.signIn(data.session.token);
      }
    },

    handleError: function(errors) {
      if (errors.length > 0) {
        alert(errors.join('. '));
      }
    }
  };

  $(document).on('submit', 'form#register', function(e) {
    e.preventDefault();

    api.post('/api/v1/users', { user: $(this).serializeObject() });
  });

  $(document).on('submit', 'form#signin', function(e) {
    e.preventDefault();

    api.post('/api/v1/sessions', $(this).serializeObject());
  });

  $(document).on('submit', 'form#forgot-password', function(e) {
    e.preventDefault();

    api.post('/api/v1/password_resets', $(this).serializeObject(), function(err) {
      if (!err) {
        $('form#reset-password').show();
      }
    });
  });

  $(document).on('submit', 'form#reset-password', function(e) {
    e.preventDefault();

    var data = $(this).serializeObject();
    var token = data['token'];
    delete data['token'];

    api.put('/api/v1/password_resets/' + token, data, function(err) {
      if (!err) {
        $('form#reset-password').hide();
        $('form#signin input#signin-email').val($('form#forgot-password input#forgot-password-email').val());
        $('form#signin input#signin-password').focus();
      }
    });
  });

  $(document).on('submit', 'form#signout', function(e) {
    e.preventDefault();

    api.del('/api/v1/sessions', function(err) {
      if (!err) {
        Session.signOut();
      }
    });
  });

  $.fn.serializeObject = function() {
    var o = {};
    var a = this.serializeArray();
    $.each(a, function() {
      if (o[this.name] !== undefined) {
        if (!o[this.name].push) {
          o[this.name] = [o[this.name]];
        }
        o[this.name].push(this.value || '');
      } else {
        o[this.name] = this.value || '';
      }
    });
    return o;
  };

});
