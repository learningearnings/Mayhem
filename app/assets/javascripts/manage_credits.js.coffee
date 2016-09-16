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
    when "Add Credits" then $('.control span.secondary.password_field')
    when "Remove Credits" then $('.control span.secondary.password_field')
    else $([])

showAppropriateSecondaryAction = () ->
  $('.control span.secondary').hide()
  whichSecondaryActionElementToShow().show()

shouldShowEdit = ->
  switch chosenAction()
    when "Add Credits" then false
    when "Remove Credits" then false
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
  current_school_bal = parseFloat($('#current_school_bal').val())
  credit_quantity = parseFloat($('#credit_quantity').val())
  result = parseFloat(numberOfTeachers() * credit_quantity)
  test = checkSelectedTeachersCredit()
  if numberOfTeachers() <= 0
    alert 'You must select at least one teacher to modify.'
  else if !$('#credit_quantity').val() or !$.isNumeric($('#credit_quantity').val())
    alert 'You must enter valid credit quantity.'
  else if ($('#controls_action').val() == 'Add Credits' and (result > current_school_bal or credit_quantity > current_school_bal))
    alert 'Credit Quantity must be less than school current credit balance.'
  else if $('#controls_action').val() == 'Remove Credits' and checkSelectedTeachersCredit() == true
    alert 'Selected teacher has less credit balance to remove.'
  else
    performSelectedTeacherAction()
    setFormActionHiddenTag()
    $('#update_teachers_form').submit()
    
setFormActionHiddenTag = () ->
  action = $('#controls_action').val()  
  $('#form_action_hidden_tag').val(action)

checkSelectedTeachersCredit = () ->
  if $('#controls_action').val() == 'Remove Credits' 
    i = 0
    $('.row_checkbox:checked').each ->
      if parseFloat($(this).closest('tr').find('td.credit_balance').text()) < parseFloat($('#credit_quantity').val())
        i = i + 1
    if i > 0
      return true

performSelectedTeacherAction = () ->
  action = $('#credit_quantity').val()  
  $('#credit_qty').val(action)

updatePasswordsToUsername = () ->
  $('input.password').each (elm) ->
    username = $(this).closest("tr").find("input.username").val()
    $(this).val(username)

handleInterfaceState()

$('.edit_control').attr('disabled', 'disabled')
updateNumberOfTeachers()
