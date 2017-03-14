$(function() {
  var $link = $(".js-toggle-query-form");
  var $queryFormContainer = $(".query-form-container");
  var $closeIcon = $(".js-close-query-form");

  $link.on("click", function(e) {
    e.preventDefault();

    $queryFormContainer.toggle();
    $link.toggle();
  });

  $closeIcon.on("click", function(e) {
    e.preventDefault();

    $queryFormContainer.toggle();
    $link.toggle();
  });
});

