$(function() {
  var $link = $(".js-toggle-query-form");
  var $queryFormContainer = $(".query-form-container");
  var $closeIcon = $(".js-close-query-form");
  var editor = ace.edit("query-editor");

  $link.on("click", function(e) {
    e.preventDefault();

    $queryFormContainer.toggle();
    $link.toggle();

    if($queryFormContainer.is(":visible")) {
      editor.focus();
    }
  });

  $closeIcon.on("click", function(e) {
    e.preventDefault();

    $queryFormContainer.toggle();
    $link.toggle();
  });
});

