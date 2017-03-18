$(function() {
  if($("#query-editor").length < 1) {
    return;
  }

  var editor = ace.edit("query-editor");

  editor.setTheme("ace/theme/monokai");
  editor.getSession().setMode("ace/mode/sql");
  editor.setOptions({
    enableBasicAutocompletion: true,
    enableLiveAutocompletion: true,
    enableSnippets: true,
    highlightActiveLine: false,
    theme: "ace/theme/textmate"
  });

  var queryAutoCompleter = {
    getCompletions: function(editor, session, pos, prefix, callback) {
      if (prefix.length === 0) { callback(null, []); return }

      var dbConnectionId = $("#db_query_db_connection_id").val();

      $.getJSON(
        "/db/queries/autocomplete?q=" + prefix + "&db_connection_id=" + dbConnectionId,
        function(wordList) {
          callback(null, wordList.map(function(ea) {
              return {
                name: ea.word,
                value: ea.word,
                score: ea.score,
                meta: ea.meta
              }
          }));
        }
      )
    }
  }

  editor.completers = [queryAutoCompleter];

  var $textarea = $("#db_query_body");
  editor.getSession().setValue($textarea.val());
  editor.getSession().on("change", function(){
    $textarea.val(editor.getSession().getValue());
  });
});
