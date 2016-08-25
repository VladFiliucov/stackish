# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  PrivatePub.subscribe "/comments", (data, channel) ->
    author = $.parseJSON(data['comment_author'])
    body = $.parseJSON(data['comment_body'])
    commentable_id = $.parseJSON(data['commentable_id'])
    commentable_type = $.parseJSON(data['commentable_type'])

    $('.' + commentable_type + '_' + commentable_id + '_comments').append("<div id=comment_" + commentable_id + ">" + author + ": " + body + "</div>")
    $('textarea#comment_body').val('')

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)
