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
    alert "Remove IT!"
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
    $.post('/add_locker_sticker_to_locker_commands',
      {
        id: id
      },
      (data, textStatus, jqXHR) ->
        # On success, add the sticker to the locker on-page exactly as it's done
        # on the backend, so that it's a very responsive interface and we don't
        # have to refresh
        link_id = data.id
        locker = $('.locker_wrapper.editable')
        sticker_div = ich["sticker_template"](
          x: 0
          y: 0
          id: link_id
          image_url: sticker_image_url
        )
        locker.append(sticker_div)
        make_draggable(sticker_div)
        sticker_div.click -> click_to_remove
    )

  $('.locker_wrapper .locker_sticker .remove').click -> click_to_remove(event)

  make_draggable('.locker_wrapper.editable .locker_sticker')
