update_transactions = (_event, selector, url) ->
  page = 1
  # If a link was clicked, we assume it was a pagination link and we extract the page
  changed_elem = _event.target.tagName.toLowerCase()
  if changed_elem == 'a'
    link_matches = (_event.target.href).match(/page=([0-9]+)/)
    page = link_matches[1] if link_matches
  get_transactions(page, selector, url)
  false

get_transactions = (page, selector, url) ->
  page = page || 1;
  url =  "/bank/#{url}?page=" + page;

  $.ajax
    async: true
    url: url
    type: 'GET'
    dataType: 'text'
    success: (response) ->
      $(selector).html(response)

$('#checking-history .pagination a').live('click', (_event) ->
  update_transactions(_event, '#checking-history', 'checking_transactions')
)

$('#savings-history .pagination a').live('click', (_event) ->
  update_transactions(_event, '#savings-history', 'savings_transactions')
)
