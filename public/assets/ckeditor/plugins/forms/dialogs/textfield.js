/*
Copyright (c) 2003-2012, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/
CKEDITOR.dialog.add("textfield",function(e){var t={value:1,size:1,maxLength:1},n={text:1,password:1};return{title:e.lang.textfield.title,minWidth:350,minHeight:150,onShow:function(){var e=this;delete e.textField;var t=e.getParentEditor().getSelection().getSelectedElement();!t||"input"!=t.getName()||!n[t.getAttribute("type")]&&t.getAttribute("type")||(e.textField=t,e.setupContent(t))},onOk:function(){var e,t=this.textField,n=!t;n&&(e=this.getParentEditor(),t=e.document.createElement("input"),t.setAttribute("type","text")),n&&e.insertElement(t),this.commitContent({element:t})},onLoad:function(){var e=function(e){var t=e.hasAttribute(this.id)&&e.getAttribute(this.id);this.setValue(t||"")},n=function(e){var t=e.element,n=this.getValue();n?t.setAttribute(this.id,n):t.removeAttribute(this.id)};this.foreach(function(i){t[i.id]&&(i.setup=e,i.commit=n)})},contents:[{id:"info",label:e.lang.textfield.title,title:e.lang.textfield.title,elements:[{type:"hbox",widths:["50%","50%"],children:[{id:"_cke_saved_name",type:"text",label:e.lang.textfield.name,"default":"",accessKey:"N",setup:function(e){this.setValue(e.data("cke-saved-name")||e.getAttribute("name")||"")},commit:function(e){var t=e.element;this.getValue()?t.data("cke-saved-name",this.getValue()):(t.data("cke-saved-name",!1),t.removeAttribute("name"))}},{id:"value",type:"text",label:e.lang.textfield.value,"default":"",accessKey:"V"}]},{type:"hbox",widths:["50%","50%"],children:[{id:"size",type:"text",label:e.lang.textfield.charWidth,"default":"",accessKey:"C",style:"width:50px",validate:CKEDITOR.dialog.validate.integer(e.lang.common.validateNumberFailed)},{id:"maxLength",type:"text",label:e.lang.textfield.maxChars,"default":"",accessKey:"M",style:"width:50px",validate:CKEDITOR.dialog.validate.integer(e.lang.common.validateNumberFailed)}],onLoad:function(){CKEDITOR.env.ie7Compat&&this.getElement().setStyle("zoom","100%")}},{id:"type",type:"select",label:e.lang.textfield.type,"default":"text",accessKey:"M",items:[[e.lang.textfield.typeText,"text"],[e.lang.textfield.typePass,"password"]],setup:function(e){this.setValue(e.getAttribute("type"))},commit:function(t){var n=t.element;if(CKEDITOR.env.ie){var i=n.getAttribute("type"),a=this.getValue();if(i!=a){var o=CKEDITOR.dom.element.createFromHtml('<input type="'+a+'"></input>',e.document);n.copyAttributes(o,{type:1}),o.replace(n),e.getSelection().selectElement(o),t.element=o}}else n.setAttribute("type",this.getValue())}}]}]}});