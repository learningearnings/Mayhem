/*
Copyright (c) 2003-2012, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/
CKEDITOR.dialog.add("smiley",function(e){var t,n,i=e.config,a=e.lang.smiley,o=i.smiley_images,r=i.smiley_columns||8,s=function(t){var i=t.data.getTarget(),a=i.getName();if("a"==a)i=i.getChild(0);else if("img"!=a)return;var o=i.getAttribute("cke_src"),r=i.getAttribute("title"),s=e.document.createElement("img",{attributes:{src:o,"data-cke-saved-src":o,title:r,alt:r,width:i.$.width,height:i.$.height}});e.insertElement(s),n.hide(),t.data.preventDefault()},l=CKEDITOR.tools.addFunction(function(t,n){t=new CKEDITOR.dom.event(t),n=new CKEDITOR.dom.element(n);var i,a,o=t.getKeystroke(),r="rtl"==e.lang.dir;switch(o){case 38:(i=n.getParent().getParent().getPrevious())&&(a=i.getChild([n.getParent().getIndex(),0]),a.focus()),t.preventDefault();break;case 40:(i=n.getParent().getParent().getNext())&&(a=i.getChild([n.getParent().getIndex(),0]),a&&a.focus()),t.preventDefault();break;case 32:s({data:t}),t.preventDefault();break;case r?37:39:case 9:(i=n.getParent().getNext())?(a=i.getChild(0),a.focus(),t.preventDefault(!0)):(i=n.getParent().getParent().getNext())&&(a=i.getChild([0,0]),a&&a.focus(),t.preventDefault(!0));break;case r?39:37:case CKEDITOR.SHIFT+9:(i=n.getParent().getPrevious())?(a=i.getChild(0),a.focus(),t.preventDefault(!0)):(i=n.getParent().getParent().getPrevious())&&(a=i.getLast().getChild(0),a.focus(),t.preventDefault(!0));break;default:return}}),d=CKEDITOR.tools.getNextId()+"_smiley_emtions_label",c=['<div><span id="'+d+'" class="cke_voice_label">'+a.options+"</span>",'<table role="listbox" aria-labelledby="'+d+'" style="width:100%;height:100%" cellspacing="2" cellpadding="2"',CKEDITOR.env.ie&&CKEDITOR.env.quirks?' style="position:absolute;"':"","><tbody>"],u=o.length;for(t=0;u>t;t++){0===t%r&&c.push("<tr>");var h="cke_smile_label_"+t+"_"+CKEDITOR.tools.getNextNumber();c.push('<td class="cke_dark_background cke_centered" style="vertical-align: middle;"><a href="javascript:void(0)" role="option"',' aria-posinset="'+(t+1)+'"',' aria-setsize="'+u+'"',' aria-labelledby="'+h+'"',' class="cke_smile cke_hand" tabindex="-1" onkeydown="CKEDITOR.tools.callFunction( ',l,', event, this );">','<img class="cke_hand" title="',i.smiley_descriptions[t],'" cke_src="',CKEDITOR.tools.htmlEncode(i.smiley_path+o[t]),'" alt="',i.smiley_descriptions[t],'"',' src="',CKEDITOR.tools.htmlEncode(i.smiley_path+o[t]),'"',CKEDITOR.env.ie?" onload=\"this.setAttribute('width', 2); this.removeAttribute('width');\" ":"",'><span id="'+h+'" class="cke_voice_label">'+i.smiley_descriptions[t]+"</span>"+"</a>","</td>"),t%r==r-1&&c.push("</tr>")}if(r-1>t){for(;r-1>t;t++)c.push("<td></td>");c.push("</tr>")}c.push("</tbody></table></div>");var p={type:"html",id:"smileySelector",html:c.join(""),onLoad:function(e){n=e.sender},focus:function(){var e=this;setTimeout(function(){var t=e.getElement().getElementsByTag("a").getItem(0);t.focus()},0)},onClick:s,style:"width: 100%; border-collapse: separate;"};return{title:e.lang.smiley.title,minWidth:270,minHeight:120,contents:[{id:"tab1",label:"",title:"",expand:!0,padding:0,elements:[p]}],buttons:[CKEDITOR.dialog.cancelButton]}});