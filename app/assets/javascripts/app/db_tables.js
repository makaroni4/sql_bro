$(function() {
  $(document).on("draw.dt", "#js-db-tables", function() {
    var $refreshButton = $(".js-refresh-db-tables");
    $refreshButton.appendTo($(".js-tables-actions"));
    $refreshButton.removeClass("hidden");
  });
});
