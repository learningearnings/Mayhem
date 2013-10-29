//= require jquery
//= require active_admin/base
//= require ckeditor/init
//= require chosen-jquery
//= require modernizr-special
//= require webshims/polyfiller

$.webshims.setOptions('forms-ext', {
  types: 'range date time number month color'
});
$.webshims.setOptions('basePath', 'assets/webshims/minified/shims/');
$.webshims.polyfill();

$(document).ready(function(){
  $('.chosen-input').chosen();
});
