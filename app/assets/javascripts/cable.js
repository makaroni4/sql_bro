//= require action_cable
//= require_self
//= require_tree ./channels

(function() {
  this.App || (this.App = {});

  App.setupAutocompleteLog = {};
  App.setupAutocomplete = function() {
    var $queryForm = $("#new_db_query");
    var currentDbConnectionId = $queryForm.find("#db_query_db_connection_id").val();

    if(!App.setupAutocompleteLog[currentDbConnectionId]) {
      App.setupAutocompleteLog[currentDbConnectionId] = new Date();
    } else if(new Date() - App.setupAutocompleteLog[currentDbConnectionId] > 10000) {
      App.setupAutocompleteLog[currentDbConnectionId] = new Date();
    } else {
      return;
    }

    $.ajax({
      url: "/db/queries/setup_autocomplete",
      dataType: "json",
      data: {
        db_connection_id: currentDbConnectionId
      }
    });
  }

  App.cable = ActionCable.createConsumer("ws://" + window.location.host + "/websocket");
}).call(this);
