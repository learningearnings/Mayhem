/*
Copyright (c) 2003-2012, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/
!function(){function e(e){var t=e.getStyle("overflow-y"),n=e.getDocument(),i=CKEDITOR.dom.element.createFromHtml('<span style="margin:0;padding:0;border:0;clear:both;width:1px;height:1px;display:block;">'+(CKEDITOR.env.webkit?"&nbsp;":"")+"</span>",n);n[CKEDITOR.env.ie?"getBody":"getDocumentElement"]().append(i);var a=i.getDocumentPosition(n).y+i.$.offsetHeight;return i.remove(),e.setStyle("overflow-y",t),a}var t=function(t){if(t.window){var n=t.document,i=(new CKEDITOR.dom.element(n.getWindow().$.frameElement),n.getBody()),a=n.getDocumentElement(),o=t.window.getViewPaneSize().height,r="BackCompat"==n.$.compatMode?i:a,s=e(r);s+=t.config.autoGrow_bottomSpace||0;var l=void 0!=t.config.autoGrow_minHeight?t.config.autoGrow_minHeight:200,d=t.config.autoGrow_maxHeight||1/0;s=Math.max(s,l),s=Math.min(s,d),s!=o&&(s=t.fire("autoGrow",{currentHeight:o,newHeight:s}).newHeight,t.resize(t.container.getStyle("width"),s,!0)),r.$.scrollHeight>r.$.clientHeight&&d>s?r.setStyle("overflow-y","hidden"):r.removeStyle("overflow-y")}};CKEDITOR.plugins.add("autogrow",{init:function(e){e.addCommand("autogrow",{exec:t,modes:{wysiwyg:1},readOnly:1,canUndo:!1,editorFocus:!1});var n={contentDom:1,key:1,selectionChange:1,insertElement:1,mode:1};e.config.autoGrow_onStartup&&(n.instanceReady=1);for(var i in n)e.on(i,function(n){var i=e.getCommand("maximize");"wysiwyg"!=n.editor.mode||i&&i.state==CKEDITOR.TRISTATE_ON||setTimeout(function(){t(n.editor),t(n.editor)},100)})}})}();