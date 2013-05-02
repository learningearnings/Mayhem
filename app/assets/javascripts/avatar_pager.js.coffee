update_avatar_results = (_event) ->
  page = 1
  # If a link was clicked, we assume it was a pagination link and we extract the page
  changed_elem = _event.target.tagName.toLowerCase()
  if changed_elem == 'a'
    link_matches = (_event.target.href).match(/page=([0-9]+)/)
    page = link_matches[1] if link_matches
  get_avatar_results(page)
  false

get_avatar_results = (page) ->
  page = page || 1;
  url =  '/people/get_avatar_results?page=' + page;

  $.ajax
    async: true
    url: url
    type: 'GET'
    dataType: 'text'
    success: (response) ->
      $('#avatar_partial').html(response)

$('.pagination a').live('click', update_avatar_results)
