//= require jquery
//= require jquery_ujs
//= require ICanHaz
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
//= require jquery_nested_form
//= require ckeditor/init
//= require jquery.ui.core.js
//= require jquery.ui.mouse.js
//= require jquery.ui.widget.js
//= require jquery.ui.draggable.js
//= require chosen-jquery
//= require custom
//= require jquery.ui.datepicker
//= require modernizr-special
//= require webshims/polyfiller

$.webshims.debug = true;
$.webshims.setOptions('forms', {
  placeholderType: 'value'
});
$.webshims.setOptions('forms-ext', {
  types: 'range date time number month color'
});
$.webshims.setOptions('basePath', 'assets/webshims/minified/shims/');
$.webshims.polyfill('forms forms-ext');

# Make jquery ajax requests use the csrf token
$ ->
  $.ajaxSetup
    beforeSend: (xhr) ->
      xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))
