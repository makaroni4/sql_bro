$(function() {
  var $queryForm = $("#new_db_query");

  if($queryForm.length < 1) {
    return;
  }

  var $toggleLink = $(".js-toggle-query-form");
  var editor = ace.edit("query-editor");
  var $submitButton = $queryForm.find(".js-run-query");

  $queryForm.on("submit", function(e) {
    e.preventDefault();

    var $this = $(this);

    $submitButton.prop("disabled", true);

    var dbConnectionId = $(this).find("#db_query_db_connection_id").val();
    var description = $(this).find("#db_query_description").val();
    var sqlBody = $(this).find("#db_query_body").val();

    App.query.run(dbConnectionId, sqlBody, description);
  });
});
