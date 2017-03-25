//= require action_cable
//= require_self
//= require_tree ./channels

(function() {
  this.App || (this.App = {});

  App.setupAutocompleteLog = {};
  App.setupAutocomplete = function(dbConnectionId) {
    var $queryForm = $("#new_db_query");

    if(!App.setupAutocompleteLog[dbConnectionId]) {
      App.setupAutocompleteLog[dbConnectionId] = new Date();
    } else if(new Date() - App.setupAutocompleteLog[dbConnectionId] > 10000) {
      App.setupAutocompleteLog[dbConnectionId] = new Date();
    } else {
      return;
    }

    $.ajax({
      url: "/db/queries/setup_autocomplete",
      dataType: "json",
      data: {
        db_connection_id: dbConnectionId
      }
    });
  }

  App.cable = ActionCable.createConsumer("ws://" + window.location.host + "/websocket");
}).call(this);
