# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('#trigger_question_edit_form').click (e) ->
    e.preventDefault();
    $(this).hide();
    question_id = $(this).data('questionId');
    $('#edit-question-' + question_id).show();

  PrivatePub.subscribe "/questions", (data, channel) ->
    question = $.parseJSON(data['question'])
    users_email = $.parseJSON(data['users_email'])
    $("table#main-question-list").append("<tr><td id=question-#{question.id}>
      <a href=/questions/#{question.id}>" + question.title + "</a></td><td>#{users_email}</td></tr>")

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)
