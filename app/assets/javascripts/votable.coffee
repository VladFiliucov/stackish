ready = ->
  $(".update_rating_button").bind 'ajax:success', (e, data, status, xhr) ->
    response = xhr.responseJSON
    resource = response.model + "_" + response.id
    $(".rating p").load("#" + resource + " p#" + resource + "_rating");
    if response.rating != "0"
      $(".withdraw_" + resource + "_rating").show();
    else if response.rating == "0"
      $(".withdraw_" + resource + "_rating").hide();


$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)
