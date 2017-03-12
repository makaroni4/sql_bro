$(function() {
  var $link = $(".js-toggle-query-form");
  var $queryForm = $(".query-form");

  $link.on("click", function(e) {
    e.preventDefault();

    $queryForm.toggle();
    $link.text(function(i, text){
      return text === "New Query" ? "^ Hide" : "New Query";
    })
  });
});

