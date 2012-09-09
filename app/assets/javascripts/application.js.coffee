//= require jquery
//= require ICanHaz
//= require jquery_ujs
//= require init
//= require bootstrap-modal
//= require bootstrap-dropdown
//= require bootstrap-scrollspy
//= require bootstrap-tab
//= require bootstrap-tooltip
//= require bootstrap-popover
//= require bootstrap-alert
//= require bootstrap-button
//= require bootstrap-collapse
//= require bootstrap-carousel
//= require bootstrap-typeahead
//= require bootstrap-transition
//= require jquery.html5-placeholder-shim
//= require jquery_nested_form
//= require ckeditor/init

# Make jquery ajax requests use the csrf token
$ ->
  $.ajaxSetup
    beforeSend: (xhr) ->
      xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
