$(function() {
  var $currentDbConnection = $(".js-db-connection-selected");
  var $dbConnectionSelect = $(".js-db-connection-select");
  var $dbConnectionId = $("#db_query_db_connection_id");

  $dbConnectionSelect.on("click", function(e) {
    e.preventDefault();

    var $this = $(this);
    $dbConnectionId.val($this.data("connectionId"));
    $currentDbConnection.text($this.text());

    App.setupAutocomplete();
  });
});
