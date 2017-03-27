$(function() {
  var $searchForm = $(".js-header-search-form");
  var $searchIcon = $searchForm.find(".js-header-search-form-search-icon");
  var $spinner = $searchForm.find(".js-header-search-form-spinner");
  var $input = $searchForm.find(".js-header-search-form-input");

  $input.on("keyup", function(e) {
    $spinner.addClass("header-search-form__spinner--active");
    $searchIcon.hide();
  });
})
