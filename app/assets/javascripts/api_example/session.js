'use strict';

$(function() {
  var Session = {
    token: null,
    userId: null,

    signIn: function(token, userId) {
      Session.token = token;
      Session.userId = userId;
      Session.toggleViews();
    },

    signOut: function() {
      Session.token = null;
      Session.userId = null;
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

  window.Session = Session;
});
