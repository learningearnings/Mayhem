// IE11 link rel="import" svg Polyfill 0.0.1
// Emulates the functionality of using a link tag to include the pds icon sprite
// Index files must include this fill before other js and
// the following link tag should be placed at the top of the <body>
//
//  <link class="pds-icon-src" rel="import" href="/path/to/pds-icons.svg" />
//
document.addEventListener("DOMContentLoaded", function(event) {
  var links = document.querySelectorAll('.pds-icon-src');
  for (var i = 0; i < links.length; i++) {
    if (links[i].getAttribute('href')) {
      let filePath = links[i].getAttribute('href');
      let rawFile = new XMLHttpRequest();
      rawFile.open("GET", filePath, false);
      rawFile.onreadystatechange = function () {
        if(rawFile.readyState === 4) {
          if(rawFile.status === 200 || rawFile.status == 0) {
            //place sprite DOMstring
            var linkContent = rawFile.responseText;               
            //create container
            var iconSprite = document.createElement('div'); 
            iconSprite.setAttribute('class', 'pds-icon-sprite'); 
            iconSprite.innerHTML = linkContent; 
            //Insert right before original link rel element
            var insertionTarget = document.getElementsByClassName('pds-icon-src');
            var insertParent = insertionTarget[0].parentNode;  
            insertParent.insertBefore(iconSprite, insertionTarget[0]);
            //insertParent.removeChild(insertionTarget[0]);
          }
        }
      }
      rawFile.send(null);
    }
  }
});