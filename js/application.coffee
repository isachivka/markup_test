ColorsWidget = ( ->
  l = 'passive'
  position = 0
  r = ''
  
  init = () ->
    $.ajax('colors.json').done (data) ->
      drow(
        {d: color}, '#template', '#colors', 'append'
      ) for color in data["colors"]
      $('#colors').wrap('<div id="wrap"></div>')
      $('#colors').before('<div id="count"></div>')
      drow_stats position + 1
      $('#count').on 'click', 'a', () ->
        position -= 1 if $(this).hasClass 'left'
        position += 1 if $(this).hasClass 'right'
        to()
        false
      $('#colors').on 'swiperight', () ->
        position -= 1
        to()
      $('#colors').on 'swipeleft', () ->
        position += 1
        to()

  to = (n) ->
    position = 0 if position < 0
    position = 2 if position > 2
    if position is 0 then l = 'passive' else l = ''
    if position is 2 then r = 'passive' else r = ''
    $('#colors').animate {
      'margin-left': -1 * position * 100 + '%'
    }, 200
    drow_stats position + 1

  drow_stats = (n) ->
    drow {d: n, l: l, r: r}, '#template1', '#count', 'replace'

  drow = (data, from, to, v) ->
    template = $(from).html()
    Mustache.parse template
    switch v
      when 'append'
        $(to).append Mustache.render(template, data)
      when 'replace'
        $(to).html Mustache.render(template, data)

  init()

)()