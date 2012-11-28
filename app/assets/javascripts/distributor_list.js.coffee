jQuery ->
  configure_distributor_links = ->
    ($ ".toggle").bind "ajax:complete", (et, e) ->
      ($ "#distributor-list").html e.responseText
      configure_distributor_links()
  configure_distributor_links()
