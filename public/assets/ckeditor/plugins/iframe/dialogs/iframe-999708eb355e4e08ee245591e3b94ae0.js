/*
Copyright (c) 2003-2012, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/
!function(){function e(e){var t=this,i=t instanceof CKEDITOR.ui.dialog.checkbox;if(e.hasAttribute(t.id)){var a=e.getAttribute(t.id);i?t.setValue(n[t.id]["true"]==a.toLowerCase()):t.setValue(a)}}function t(e){var t=this,i=""===t.getValue(),a=t instanceof CKEDITOR.ui.dialog.checkbox,o=t.getValue();i?e.removeAttribute(t.att||t.id):a?e.setAttribute(t.id,n[t.id][o]):e.setAttribute(t.att||t.id,o)}var n={scrolling:{"true":"yes","false":"no"},frameborder:{"true":"1","false":"0"}};CKEDITOR.dialog.add("iframe",function(n){var i=n.lang.iframe,a=n.lang.common,o=n.plugins.dialogadvtab;return{title:i.title,minWidth:350,minHeight:260,onShow:function(){var e=this;e.fakeImage=e.iframeNode=null;var t=e.getSelectedElement();if(t&&t.data("cke-real-element-type")&&"iframe"==t.data("cke-real-element-type")){e.fakeImage=t;var i=n.restoreRealElement(t);e.iframeNode=i,e.setupContent(i)}},onOk:function(){var e,t=this;e=t.fakeImage?t.iframeNode:new CKEDITOR.dom.element("iframe");var i={},a={};t.commitContent(e,i,a);var o=n.createFakeElement(e,"cke_iframe","iframe",!0);o.setAttributes(a),o.setStyles(i),t.fakeImage?(o.replace(t.fakeImage),n.getSelection().selectElement(o)):n.insertElement(o)},contents:[{id:"info",label:a.generalTab,accessKey:"I",elements:[{type:"vbox",padding:0,children:[{id:"src",type:"text",label:a.url,required:!0,validate:CKEDITOR.dialog.validate.notEmpty(i.noUrl),setup:e,commit:t}]},{type:"hbox",children:[{id:"width",type:"text",style:"width:100%",labelLayout:"vertical",label:a.width,validate:CKEDITOR.dialog.validate.htmlLength(a.invalidHtmlLength.replace("%1",a.width)),setup:e,commit:t},{id:"height",type:"text",style:"width:100%",labelLayout:"vertical",label:a.height,validate:CKEDITOR.dialog.validate.htmlLength(a.invalidHtmlLength.replace("%1",a.height)),setup:e,commit:t},{id:"align",type:"select","default":"",items:[[a.notSet,""],[a.alignLeft,"left"],[a.alignRight,"right"],[a.alignTop,"top"],[a.alignMiddle,"middle"],[a.alignBottom,"bottom"]],style:"width:100%",labelLayout:"vertical",label:a.align,setup:function(t,n){if(e.apply(this,arguments),n){var i=n.getAttribute("align");this.setValue(i&&i.toLowerCase()||"")}},commit:function(e,n,i){t.apply(this,arguments),this.getValue()&&(i.align=this.getValue())}}]},{type:"hbox",widths:["50%","50%"],children:[{id:"scrolling",type:"checkbox",label:i.scrolling,setup:e,commit:t},{id:"frameborder",type:"checkbox",label:i.border,setup:e,commit:t}]},{type:"hbox",widths:["50%","50%"],children:[{id:"name",type:"text",label:a.name,setup:e,commit:t},{id:"title",type:"text",label:a.advisoryTitle,setup:e,commit:t}]},{id:"longdesc",type:"text",label:a.longDescr,setup:e,commit:t}]},o&&o.createAdvancedTab(n,{id:1,classes:1,styles:1})]}})}();