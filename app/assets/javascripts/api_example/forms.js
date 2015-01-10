'use strict';

$(function() {
  $(document).on('submit', 'form#register', function(e) {
    e.preventDefault();

    var data = $(this).serializeObject();
    if (data.password != data.password_confirmation) {
      alert('Passwords must match');
      return
    }

    API.post('/api/v1/users', { user: data });
  });

  $(document).on('submit', 'form#signin', function(e) {
    e.preventDefault();

    API.post('/api/v1/sessions', $(this).serializeObject());
  });

  $(document).on('submit', 'form#forgot-password', function(e) {
    e.preventDefault();

    API.post('/api/v1/password_resets', $(this).serializeObject(), function(err) {
      if (!err) {
        $('form#reset-password').show();
      }
    });
  });

  $(document).on('submit', 'form#reset-password', function(e) {
    e.preventDefault();

    var data = $(this).serializeObject();

    if (data.password != data.password_confirmation) {
      alert('Passwords must match');
      return;
    }

    API.put('/api/v1/password_resets/' + data.token, data, function(err) {
      if (!err) {
        $('form#reset-password').hide();
        $('form#signin input#signin-email').val($('form#forgot-password input#forgot-password-email').val());
        $('form#signin input#signin-password').focus();
      }
    });
  });

  $(document).on('submit', 'form#signout', function(e) {
    e.preventDefault();

    API.del('/api/v1/sessions', function(err) {
      if (!err) {
        Session.signOut();
      }
    });
  });

  $(document).on('submit', 'form#list-users', function(e) {
    e.preventDefault();

    API.get('/api/v1/users', function(err, data) {
      if (!err) {
        $('ul#list-users-results').html('');
        for(var i=0; i<data.users.length; i++) {
          var user = data.users[i];
          $('ul#list-users-results').append('<li>' + user.email + '</li>');
        }
      }
    });
  });

  $(document).on('submit', 'form#get-user', function(e) {
    e.preventDefault();

    API.get('/api/v1/users/' + Session.userId, function(err, data) {
      if (!err) {
        $('#get-user-results').html(
          '<strong>id:</strong> ' + data.user.id + '<br>' +
          '<strong>email:</strong> ' + data.user.email + '<br>'
        );
      }
    });
  });

});
