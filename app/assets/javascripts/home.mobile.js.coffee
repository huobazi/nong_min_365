$(document).live 'pageinit',() ->
  $('#close-flash').live 'click', () ->
    $(this).parent.remove();
