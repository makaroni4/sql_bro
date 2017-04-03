$(function() {
  var $tables = $(".js-db-tables");

  $tables.on("draw.dt", function() {
    var $refreshButton = $(".js-refresh-db-tables");
    $refreshButton.appendTo($(".js-tables-actions"));
    $refreshButton.removeClass("hidden");
  });

  $tables.dataTable({
    dom: "<'db-tables-controls'<'js-tables-actions'><f>>" +
         "<'row'<'col-sm-12'tr>>"
  });
});
