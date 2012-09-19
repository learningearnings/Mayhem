function update_image_results(_event){
  var page = 1;
  // If a link was clicked, we assume it was a pagination link and we extract the page
  var changed_elem = _event.target.tagName.toLowerCase();
  if( changed_elem == 'a' ){
    var page = (_event.target.href).match(/page=([0-9]+)/)[1]
  }
  get_image_results(page);
  return false;
}

function get_image_results(page){
  var page = page || 1;
  var url =  '/get_image_results?page=' +page;

  $.ajax({
    async: true,
    url: url,
    type: 'POST',
    dataType: 'text',
    success: function(response){
      $('#image_partial').html(response);
    }   
  }); 
}

$('.pagination a').live('click', update_image_results);

