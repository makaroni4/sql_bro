$(function() {
  var $queryForm = $(".new_db_query");
  var $toggleLink = $(".js-toggle-query-form");

  $queryForm.on("submit", function(e) {
    e.preventDefault();

    var $this = $(this);

    var dbConnectionId = $(this).find("#db_query_db_connection_id").val();
    var description = $(this).find("#db_query_description").val();
    var sqlBody = $(this).find("#db_query_body").val();

    App.query.run(dbConnectionId, sqlBody, description);

    // TODO: show spinner when query is running and close form from React Component
    $toggleLink.click();
  });
});
