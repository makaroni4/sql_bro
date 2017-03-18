$(function() {
  var $link = $(".js-toggle-query-form");
  var $queryFormContainer = $(".query-form-container");
  var $closeIcon = $(".js-close-query-form");
  var editor = ace.edit("query-editor");
  var $queryForm = $("#new_db_query");
  var $clearLink = $queryForm.find(".js-clear-query-form");
  var $queryFormErrorContainer = $queryForm.find(".query-form__error");

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

  $clearLink.on("click", function(e) {
    e.preventDefault();

    $queryForm[0].reset();
    editor.setValue("");
    editor.focus();
    $queryFormErrorContainer.hide();
  });
});

