//= require jquery
//= require active_admin/base
//= require ckeditor/init
//= require chosen-jquery
//= require modernizr-special
//= require webshims/polyfiller

$.webshims.setOptions('forms-ext', {
  types: 'range date time number month color'
});
$.webshims.polyfill();

$(document).ready(function(){
  $('.chosen-input').chosen();
});
