$ ->
  make_draggable = (el) ->
    $(el).draggable
      containment: 'parent'
      stop: (event, ui) ->
        x = ui.position.left
        y = ui.position.top
        id = $(this).data().id
        $.post('/update_locker_sticker_link_positions_commands',
          x: x
          y: y
          id: id
        )

  click_to_remove = (event) ->
    locker_sticker = $(event.target).closest('.locker_sticker')
    id = locker_sticker.data().id
    $.post('/remove_locker_sticker_from_locker_commands',
      {
        id: id
      },
      (data, textStatus, jqXHR) ->
        locker_sticker.remove()
    )

  $('.locker_edit .locker_interface .available_stickers').click (event) ->
    sticker = $(event.target).closest('.sticker')
    id = sticker.data().id
    sticker_image = $('img', sticker)
    sticker_image_url = sticker_image.attr('src')
    width = 814
    height = 334
    # Don't allow stickers to have coordinates too near the far edges
    available_width = width - 100
    available_height = height - 100
    # Get a random x and y position within the image
    x = Math.floor(Math.random() * available_width)
    y = Math.floor(Math.random() * available_height)
    $.post('/add_locker_sticker_to_locker_commands',
      {
        id: id,
        x: x,
        y: y
      },
      (data, textStatus, jqXHR) ->
        # On success, add the sticker to the locker on-page exactly as it's done
        # on the backend, so that it's a very responsive interface and we don't
        # have to refresh
        link_id = data.id
        locker = $('.locker_wrapper.editable')
        sticker_div = ich["sticker_template"](
          x: x
          y: y
          id: link_id
          image_url: sticker_image_url
        )
        locker.append(sticker_div)
        make_draggable(sticker_div)
        sticker_div.first(".remove").click (event) -> click_to_remove(event)
    )

  $('.locker_wrapper .locker_sticker .remove').click (event) -> click_to_remove(event)

  make_draggable('.locker_wrapper.editable .locker_sticker')
