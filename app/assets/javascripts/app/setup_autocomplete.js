$(function() {
  $(".js-setup-autocomplete").on("click", function(e) {
    e.preventDefault();

    App.setupAutocomplete($(this).data("dbConnectionId"));
  });
});

