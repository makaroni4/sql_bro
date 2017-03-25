$(function() {
  var $queryForm = $("#new_db_query");

  if($queryForm.length < 1) {
    return;
  }

  var editor = ace.edit("query-editor");
  var $submitButton = $queryForm.find(".js-run-query");
  var $cancelButton = $queryForm.find(".js-cancel-query");
  var $formContainer = $queryForm.parent(".query-form-container");
  var $formOverlay = $formContainer.find(".query-form__active-overlay");
  var $queryFormErrorContainer = $queryForm.find(".query-form__error");

  $queryForm.on("click", ".js-cancel-query", function(e) {
    e.preventDefault();

    var dbConnectionId = $queryForm.find("#db_query_db_connection_id").val();
    var sqlBody = $queryForm.find("#db_query_body").val();

    $.ajax({
      url: "/db/queries/cancel",
      dataType: "json",
      data: {
        db_query: {
          db_connection_id: dbConnectionId,
          body: sqlBody
        }
      }
    });
  });

  $queryForm.on("submit", function(e) {
    e.preventDefault();

    var $this = $(this);

    var dbConnectionId = $this.find("#db_query_db_connection_id").val();
    var description = $this.find("#db_query_description").val();
    var sqlBody = $this.find("#db_query_body").val();

    if(sqlBody) {
      $submitButton.hide();
      $cancelButton.addClass("query-form__cancel-button--active");
      $formOverlay.addClass("query-form__active-overlay--active");
      $queryFormErrorContainer.hide();

      App.query.run(dbConnectionId, sqlBody, description);
    } else {
      $queryFormErrorContainer.text("Please, enter a query");
      $queryFormErrorContainer.show();
    }
  });
});
