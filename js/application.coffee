ColorsWidget = ( ->
  l = 'passive'
  position = 0
  r = ''
  max = 0
  
  init = () ->

    $.ajax('colors.json').done (data) ->

      # dom
      $('#colors').wrap('<div id="wrap"></div>')
      $('#colors').before('<div id="count"></div>')
      drow(
        {d: color}, '#template', '#colors', 'append'
      ) for color in data["colors"]

      # slide width mobile
      set_width()
      $(window).on 'resize', () ->
        set_width()

      # count elems
      max = data["colors"].length
      drow_stats position + 1

      # events
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

  # set slider position to n
  to = (n) ->

    # min/max
    position = 0 if position < 0
    position = max - 1 if position > max - 1

    # passive link status
    if position is 0 then l = 'passive' else l = ''
    if position is max - 1 then r = 'passive' else r = ''

    # move slider
    $('#colors').animate {
      'margin-left': -1 * position * 100 + '%'
    }, 200

    drow_stats position + 1

  # set elems width for mobile
  set_width = () ->
    if $(document).width() < 769
      $('#colors li').css('width', $(document).width())
    else
      $('#colors li').css('width', '')

  drow_stats = (n) ->
    drow {d: n, l: l, r: r, max: max}, '#template1', '#count', 'replace'

  # drow *data* object with *from* template *to* elem 
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