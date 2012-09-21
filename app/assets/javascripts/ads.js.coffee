# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
#
$(document).ready ->
  $('select.province').after('<span>省</span>')
  $('select.regions').live 'change',() ->
    el = $(this)
    el.next().nextAll().remove()
    remote_url = el.data('url')
    if( el.val().trim().length <=0 || parseInt(el.data('level')) >= 5 )
      return
    $.ajax
      type: 'POST'
      url: remote_url
      data:
        code: el.val()
        parent_id: el.attr('id')
        css: el.attr('class')
        dataType: 'script'


