$(function() {
  var $dbConnectionSelect = $(".js-db-connection-select");

  if(!$dbConnectionSelect.length) {
    return;
  }

  var $currentDbConnection = $(".js-db-connection-selected");
  var $dbConnectionId = $("#db_query_db_connection_id");
  var setDbConnectionFromUrlParam = function() {
    var url = new Url(window.location.href);
    if(url.query.db_connection_id) {
      var $selectOption = $(".js-db-connection-select[data-connection-id=" + url.query.db_connection_id + "]");
      $selectOption.click();
    }
  }

  $dbConnectionSelect.on("click", function(e) {
    e.preventDefault();

    var $this = $(this);
    $dbConnectionId.val($this.data("connectionId"));
    $currentDbConnection.text($this.text());

    App.setupAutocomplete();
  });

  setDbConnectionFromUrlParam();
});
