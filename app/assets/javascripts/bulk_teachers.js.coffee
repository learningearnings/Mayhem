  $(document).ready ->
    $('#teachers_header_sort').tablesorter({ headers:{0: { sorter: false} }})
    return
    
  $('#select_all').on 'click', ->
    if $('#select_all').attr('checked')
      $('.edit_control').removeAttr('disabled')
      $('input.selected').attr('checked', true)
    else
      $('input.selected').removeAttr('checked')
      $('.edit_control').attr('disabled', 'disabled')
    updateNumberOfTeachers()

  $('.teachers_body').on 'click', (evt) ->
    if $(evt.target).hasClass('row_checkbox')
      children = $(evt.target).closest('tr').find('.edit_control')
      if $(evt.target).attr('checked') == "checked"
        children.removeAttr('disabled')
      else
        $('#select_all').removeAttr('checked')
        children.attr('disabled', 'disabled')
      updateNumberOfTeachers()

  updateNumberOfTeachers = ->
    $('#number_of_teachers').html(numberOfTeachers())

  numberOfTeachers = ->
    $('.row_checkbox:checked').size()

  chosenAction = ->
    $('#controls_action').val()

  whichSecondaryActionElementToShow = () ->
    switch chosenAction()
      when "Update Passwords to this Password" then $('.control span.secondary.password_field')
      else $([])

  showAppropriateSecondaryAction = () ->
    $('.control span.secondary').hide()
    whichSecondaryActionElementToShow().show()

  shouldShowEdit = ->
    switch chosenAction()
      when "Update Passwords to this Password" then false
      when "Edit Teachers Information" then true
      else false

  conditionallyShowEditFields = () ->
    if shouldShowEdit()
      $('tbody .edit').show()
      $('tbody .display').hide()
    else
      $('tbody .edit').hide()
      $('tbody .display').show()

    # We also potentially show only the password field, if "as indicated" is chosen
    if chosenAction() == 'Update Passwords as Indicated'
      $('tbody td.password .edit').show()

  handleInterfaceState = ->
    showAppropriateSecondaryAction()
    conditionallyShowEditFields()

  $('#controls_action').on 'change', handleInterfaceState

  $('#update_these_teachers').on 'click', (evt) ->
    evt.preventDefault()
    if numberOfTeachers() > 0
      performSelectedTeacherAction()
      setFormActionHiddenTag()
      $('#update_teachers_form').submit()
    else
      alert("You must select at least one teacher to modify.")

  setFormActionHiddenTag = () ->
    action = $('#controls_action').val()  
    $('#form_action_hidden_tag').val(action)

  performSelectedTeacherAction = () ->
    switch chosenAction()
      when "Update Passwords to this Password"
        updatePasswordsToPassword($('#controls_password').val())
      when "Update Passwords = Usernames"
        updatePasswordsToUsername()

  updatePasswordsToPassword = (password) ->
    $('input.password').val(password)

  updatePasswordsToUsername = () ->
    $('input.password').each (elm) ->
      username = $(this).closest("tr").find("input.username").val()
      $(this).val(username)

  handleInterfaceState()

  $('.edit_control').attr('disabled', 'disabled')
  updateNumberOfTeachers()
