/*
Copyright (c) 2003-2012, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/
CKEDITOR.dialog.add("form",function(e){var t={action:1,id:1,method:1,enctype:1,target:1};return{title:e.lang.form.title,minWidth:350,minHeight:200,onShow:function(){var e=this;delete e.form;var t=e.getParentEditor().getSelection().getStartElement(),n=t&&t.getAscendant("form",!0);n&&(e.form=n,e.setupContent(n))},onOk:function(){var e,t=this.form,n=!t;n&&(e=this.getParentEditor(),t=e.document.createElement("form"),!CKEDITOR.env.ie&&t.append(e.document.createElement("br"))),n&&e.insertElement(t),this.commitContent(t)},onLoad:function(){function e(e){this.setValue(e.getAttribute(this.id)||"")}function n(e){var t=this;t.getValue()?e.setAttribute(t.id,t.getValue()):e.removeAttribute(t.id)}this.foreach(function(i){t[i.id]&&(i.setup=e,i.commit=n)})},contents:[{id:"info",label:e.lang.form.title,title:e.lang.form.title,elements:[{id:"txtName",type:"text",label:e.lang.common.name,"default":"",accessKey:"N",setup:function(e){this.setValue(e.data("cke-saved-name")||e.getAttribute("name")||"")},commit:function(e){this.getValue()?e.data("cke-saved-name",this.getValue()):(e.data("cke-saved-name",!1),e.removeAttribute("name"))}},{id:"action",type:"text",label:e.lang.form.action,"default":"",accessKey:"T"},{type:"hbox",widths:["45%","55%"],children:[{id:"id",type:"text",label:e.lang.common.id,"default":"",accessKey:"I"},{id:"enctype",type:"select",label:e.lang.form.encoding,style:"width:100%",accessKey:"E","default":"",items:[[""],["text/plain"],["multipart/form-data"],["application/x-www-form-urlencoded"]]}]},{type:"hbox",widths:["45%","55%"],children:[{id:"target",type:"select",label:e.lang.common.target,style:"width:100%",accessKey:"M","default":"",items:[[e.lang.common.notSet,""],[e.lang.common.targetNew,"_blank"],[e.lang.common.targetTop,"_top"],[e.lang.common.targetSelf,"_self"],[e.lang.common.targetParent,"_parent"]]},{id:"method",type:"select",label:e.lang.form.method,accessKey:"M","default":"GET",items:[["GET","get"],["POST","post"]]}]}]}]}});