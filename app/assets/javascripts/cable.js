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
  };

  App.cable = ActionCable.createConsumer("ws://" + window.location.host + "/websocket");

  App.query = App.cable.subscriptions.create("QueryChannel", {
    run: function(dbConnectionId, sqlBody, description, autoLimit) {
      return this.perform("run_query", {
        db_connection_id: dbConnectionId,
        sql_body: sqlBody,
        description: description,
        auto_limit: autoLimit
      });
    },
    received: function(query) {
      query = JSON.parse(query);

      var $queryForm = $(".query-form");
      var $submitButton = $queryForm.find(".js-run-query");
      var $cancelButton = $queryForm.find(".js-cancel-query");
      var $queryFormErrorContainer = $queryForm.find(".query-form__error");

      var $formContainer = $queryForm.parent(".query-form-container");
      var $formOverlay = $formContainer.find(".query-form__active-overlay")

      if(query.error) {
        $queryFormErrorContainer.text(query.error);
        $queryFormErrorContainer.show();
      } else {
        var queryComponent = React.createElement(QueryResultTable, {
          fields: query.fields,
          results: query.result,
          resultsCount: query.results_count
        });

        ReactDOM.render(queryComponent, document.getElementsByClassName("js-query-result-container")[0]);

        $queryFormErrorContainer.hide();
      }

      $formOverlay.removeClass("query-form__active-overlay--active");
      $submitButton.show();
      $cancelButton.removeClass("query-form__cancel-button--active");
    }
  });
}).call(this);
