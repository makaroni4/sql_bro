$(function() {
  var $queryForm = $("#new_db_query");

  if($queryForm.length < 1) {
    return;
  }

  var editor = ace.edit("query-editor");

  jQuery.hotkeys.options.filterInputAcceptingElements = false;
  jQuery.hotkeys.options.filterContentEditable = false;
  jQuery.hotkeys.options.filterTextInputs = false;

  var $link = $(".js-toggle-query-form");

  editor.commands.addCommand({
    name: "toggleQueryForm",
    bindKey: {win: "Ctrl-n", mac: "Ctrl-n"},
    exec: function(editor) {
      $link.click();
    }
  });

  $(document).on("keydown", null, "Ctrl+n", function(e) {
    $link.click();
  });

  var $runQueryButton = $queryForm.find(".js-run-query");

  var submitQueryForm = function() {
    if($queryForm.is(":visible")) {
      $runQueryButton.click();
    }
  };

  editor.commands.addCommand({
    name: "submitQueryForm",
    bindKey: {win: "Ctrl-return", mac: "Ctrl-Enter"},
    exec: submitQueryForm
  });

  $(document).on("keydown", null, "Ctrl+return", function(e) {
    submitQueryForm();
  });

  var $clearLink = $queryForm.find(".js-clear-query-form");

  editor.commands.addCommand({
    name: "clearQueryForm",
    bindKey: {win: "Ctrl-c", mac: "Ctrl-c"},
    exec: function(editor) {
      $clearLink.click();
    }
  });

  $(document).on("keydown", null, "Ctrl+c", function(e) {
    $clearLink.click();
  });
});
