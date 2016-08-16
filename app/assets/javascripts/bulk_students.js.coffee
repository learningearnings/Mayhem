$(document).ready ->
  $('#students').tablesorter({ headers:{0: { sorter: false} }})
  return

checkUpdateStatus = (delayed_report_id) ->
  $.get '/delayed_reports/' + delayed_report_id + '/status.json', (delayed_report) ->
    if delayed_report.status == 'complete'
      loadResults()
    else
      setTimeout checkUpdateStatus(delayed_report_id), 1000
    return
  return

loadResults = ->
  location.reload()
  return



$('.information-action').click (e) ->
  el = $(e.currentTarget)
  # Set title for modal
  $('#parent-modal .title').html 'Student: ' + el.data('name')
  $.ajax
    url: '/teachers/bulk_students/manage_parents'
    type: 'POST'
    data: student_id: el.data('id')
    success: (data) ->
      $('#parent-information').html data
      return
  return

$('#select_all').change ->
  if $('#select_all').attr('checked')
    $('.edit_control').removeAttr('disabled')
    $('input.selected').attr('checked', true)
  else
    $('input.selected').removeAttr('checked')
    $('.edit_control').attr('disabled', 'disabled')
  updateNumberOfStudents()

$('.students_body').on 'click', (evt) ->
  if $(evt.target).hasClass('row_checkbox')
    children = $(evt.target).closest('tr').find('.edit_control')
    if $(evt.target).attr('checked') == "checked"
      children.removeAttr('disabled')
    else
      $('#select_all').removeAttr('checked')
      children.attr('disabled', 'disabled')
    updateNumberOfStudents()

updateNumberOfStudents = ->
  $('#number_of_students').html(numberOfStudents())

numberOfStudents = ->
  $('.row_checkbox:checked').size()

chosenAction = ->
  $('#controls_action').val()

whichSecondaryActionElementToShow = () ->
  switch chosenAction()
    when "0" then $('.control span.secondary.password_field')
    when "3" then $('.control span.secondary.classroom_field')
    when "4" then $('.parent').show()
    else $([])

showAppropriateSecondaryAction = () ->
  $('.control span.secondary').hide()
  whichSecondaryActionElementToShow().show()

shouldShowEdit = ->
  switch chosenAction()
    when "0" then false
    when "4" then true
    else false

conditionallyShowEditFields = () ->
  if shouldShowEdit()
    $('tbody .edit').show()
    $('tbody .display').hide()
  else
    $('tbody .edit').hide()
    $('tbody .display').show()

  # We also potentially show only the password field, if "as indicated" is chosen
  if chosenAction() == "2"
    $('tbody td.password .edit').show()
    $('tbody td.password .display').hide()

handleInterfaceState = ->
  showAppropriateSecondaryAction()
  conditionallyShowEditFields()

$('#controls_action').on 'change', handleInterfaceState

$('#update_these_students').on 'click', (evt) ->
  evt.preventDefault()
  if numberOfStudents() > 0
    performSelectedStudentAction()
    setFormActionHiddenTag()
    $('#message').modal('show');
    $.ajax '/teachers/bulk_students',
      type: 'POST',
      dataType: 'json',
      data: $('#update_students_form').serialize(), 
      error: (jqXHR, textStatus, errorThrown) ->
        alert('There was an error, please try again.');
      success: (data, textStatus, jqXHR) ->
        setTimeout(checkUpdateStatus(data.delayed_report_id), 1000);
  else
    alert("You must select at least one student to modify.")

setFormActionHiddenTag = () ->
  action = $('#controls_action').val()
  $('#form_action_hidden_tag').val(action)

performSelectedStudentAction = () ->
  switch chosenAction()
    when "0"
      updatePasswordsToPassword($('#controls_password').val())
    when "1"
      updatePasswordsToUsername()
    when "3"
      updateClassroomsToClassroom($('#controls_classroom_selection').val())

updateClassroomsToClassroom = (classroom_id) ->
  $('.edit_control.classroom').val(classroom_id)

updatePasswordsToPassword = (password) ->
  $('input.password').val(password)

updatePasswordsToUsername = () ->
  $('input.password').each (elm) ->
    username = $(this).closest("tr").find("input.username").val()
    $(this).val(username)

handleInterfaceState()

$('.edit_control').attr('disabled', 'disabled')
updateNumberOfStudents()


$('.student-parent-code').on 'click', (e) ->
  el = $(e.currentTarget)
  $.ajax '/teachers/bulk_students/generate_code',
    type: 'POST',
    dataType: 'script',
    data: 
      student_id: el.data('id')
      action_type: "generate_code" 
  return