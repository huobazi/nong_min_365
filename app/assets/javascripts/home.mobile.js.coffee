$(document).live 'pageinit',() ->
  $('#close-flash').on'click', () ->
    $(this).parent.remove();
