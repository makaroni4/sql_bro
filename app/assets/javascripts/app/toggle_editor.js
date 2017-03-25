$(function() {
  var $queryForm = $("#new_db_query");

  if(!$queryForm.length) {
    return;
  }

  var editor = ace.edit("query-editor");
  var $clearLink = $queryForm.find(".js-clear-query-form");
  var $queryFormErrorContainer = $queryForm.find(".query-form__error");

  $clearLink.on("click", function(e) {
    e.preventDefault();

    $queryForm[0].reset();
    editor.setValue("");
    editor.focus();
    $queryFormErrorContainer.hide();
  });
});

