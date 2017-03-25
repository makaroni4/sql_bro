$(function() {
  App.query = App.cable.subscriptions.create("QueryChannel", {
    run: function(db_connection_id, sql_body, description) {
      return this.perform("run_query", {
        db_connection_id: db_connection_id,
        sql_body: sql_body,
        description: description
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
        // insert query to QueryList
        // insert query to Query
        $queryFormErrorContainer.hide();
      }

      $formOverlay.removeClass("query-form__active-overlay--active");
      $submitButton.show();
      $cancelButton.removeClass("query-form__cancel-button--active");
    }
  });
});
