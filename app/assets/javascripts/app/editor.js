$(function() {
  var editor = ace.edit("query-editor");
  editor.setTheme("ace/theme/monokai");
  editor.getSession().setMode("ace/mode/sql");
  editor.setOptions({
    enableBasicAutocompletion: false,
    enableLiveAutocompletion: false,
    enableSnippets: false
  });

  var $textarea = $("#db_query_body");
  editor.getSession().setValue($textarea.val());
  editor.getSession().on("change", function(){
    $textarea.val(editor.getSession().getValue());
  });
});
