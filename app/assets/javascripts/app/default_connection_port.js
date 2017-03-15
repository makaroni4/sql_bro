$(function() {
  var $connectionForm = $("#new_db_connection");

  if($connectionForm.length < 1) {
    return;
  }

  var defaultPorts = $connectionForm.data("defaultPorts");
  var $adapterField = $connectionForm.find("#db_connection_adapter");
  var $portField = $connectionForm.find("#db_connection_port");

  var updatePlacehoder = function($adapterField) {
    if(!$portField.val()) {
      $portField.prop("placeholder", defaultPorts[$adapterField.val()]);
    }
  };

  $adapterField.on("change", function(e) {
    updatePlacehoder($(this));
  });

  updatePlacehoder($adapterField);
});
