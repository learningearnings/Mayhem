/*
Copyright (c) 2003-2012, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/
!function(){CKEDITOR.plugins.add("ajax",{requires:["xml"]}),CKEDITOR.ajax=function(){var e=function(){if(!CKEDITOR.env.ie||"file:"!=location.protocol)try{return new XMLHttpRequest}catch(e){}try{return new ActiveXObject("Msxml2.XMLHTTP")}catch(t){}try{return new ActiveXObject("Microsoft.XMLHTTP")}catch(n){}return null},t=function(e){return 4==e.readyState&&(e.status>=200&&e.status<300||304==e.status||0===e.status||1223==e.status)},n=function(e){return t(e)?e.responseText:null},i=function(e){if(t(e)){var n=e.responseXML;return new CKEDITOR.xml(n&&n.firstChild?n:e.responseText)}return null},a=function(t,n,i){var a=!!n,o=e();return o?(o.open("GET",t,a),a&&(o.onreadystatechange=function(){4==o.readyState&&(n(i(o)),o=null)}),o.send(null),a?"":i(o)):null};return{load:function(e,t){return a(e,t,n)},loadXml:function(e,t){return a(e,t,i)}}}()}();