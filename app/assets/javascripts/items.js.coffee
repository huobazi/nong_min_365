# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


new_item_form_select_change = () ->
  $('#new_item_form').on 'change', 'select.regions',() ->
    el = $(this)
    remote_url = el.data('url')
    if( el.val().trim().length <= 0 || parseInt(el.data('level')) >= 5 )
      return
    $.ajax
      type: 'POST'
      dataType: 'script'
      url: remote_url
      data:
        code: el.val()
        parent_id: el.attr('id')
        css: el.attr('class')

$(document).ready ->
  new_item_form_select_change()

$(document).on 'page:change', ->
  new_item_form_select_change()
