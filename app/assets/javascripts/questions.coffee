# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('#trigger_question_edit_form').click (e) ->
    e.preventDefault();
    $(this).hide();
    question_id = $(this).data('questionId');
    $('#edit-question-' + question_id).show();

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)
