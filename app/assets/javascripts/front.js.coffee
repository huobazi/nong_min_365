$(document).ready ->
  # Choose 样式
  #$('select.chosen').chosen()

  $('a.go-top').click -> 
    $('html, body').animate({ scrollTop: 0 },300)
    return false

  $(window).bind 'scroll  resize', ->
    btn = $('#go-top')
    el = $('html')[0]
    if $.browser.webkit
      el = $('body')[0]
    if el.scrollTop > 160 
      btn.show('slow')
    else
      btn.hide('slow')
    return false


(->
  ClientSideValidations.formBuilders['SimpleForm::FormBuilder']['wrappers']["prepend"] =
    ClientSideValidations.formBuilders['SimpleForm::FormBuilder']['wrappers']["bootstrap"]
).call(this)
