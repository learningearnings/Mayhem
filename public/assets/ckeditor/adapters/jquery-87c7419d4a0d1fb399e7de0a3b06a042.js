/*
Copyright (c) 2003-2012, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/
!function(){CKEDITOR.config.jqueryOverrideVal="undefined"==typeof CKEDITOR.config.jqueryOverrideVal?!0:CKEDITOR.config.jqueryOverrideVal;var e=window.jQuery;"undefined"!=typeof e&&(e.extend(e.fn,{ckeditorGet:function(){var e=this.eq(0).data("ckeditorInstance");if(!e)throw"CKEditor not yet initialized, use ckeditor() with callback.";return e},ckeditor:function(t,n){if(!CKEDITOR.env.isCompatible)return this;if(!e.isFunction(t)){var i=n;n=t,t=i}return n=n||{},this.filter("textarea, div, p").each(function(){var i=e(this),r=i.data("ckeditorInstance"),o=i.data("_ckeditorInstanceLock"),a=this;r&&!o?t&&t.apply(r,[this]):o?CKEDITOR.on("instanceReady",function(e){var n=e.editor;setTimeout(function(){return n.element?(n.element.$==a&&t&&t.apply(n,[a]),void 0):(setTimeout(arguments.callee,100),void 0)},0)},null,null,9999):((n.autoUpdateElement||"undefined"==typeof n.autoUpdateElement&&CKEDITOR.config.autoUpdateElement)&&(n.autoUpdateElementJquery=!0),n.autoUpdateElement=!1,i.data("_ckeditorInstanceLock",!0),r=CKEDITOR.replace(a,n),i.data("ckeditorInstance",r),r.on("instanceReady",function(e){var n=e.editor;setTimeout(function(){if(!n.element)return setTimeout(arguments.callee,100),void 0;if(e.removeListener("instanceReady",this.callee),n.on("dataReady",function(){i.trigger("setData.ckeditor",[n])}),n.on("getData",function(e){i.trigger("getData.ckeditor",[n,e.data])},999),n.on("destroy",function(){i.trigger("destroy.ckeditor",[n])}),n.config.autoUpdateElementJquery&&i.is("textarea")&&i.parents("form").length){var r=function(){i.ckeditor(function(){n.updateElement()})};i.parents("form").submit(r),i.parents("form").bind("form-pre-serialize",r),i.bind("destroy.ckeditor",function(){i.parents("form").unbind("submit",r),i.parents("form").unbind("form-pre-serialize",r)})}n.on("destroy",function(){i.data("ckeditorInstance",null)}),i.data("_ckeditorInstanceLock",null),i.trigger("instanceReady.ckeditor",[n]),t&&t.apply(n,[a])},0)},null,null,9999))}),this}}),CKEDITOR.config.jqueryOverrideVal&&(e.fn.val=CKEDITOR.tools.override(e.fn.val,function(t){return function(n,i){var r,o="undefined"!=typeof n;return this.each(function(){var a=e(this),s=a.data("ckeditorInstance");if(!i&&a.is("textarea")&&s){if(!o)return r=s.getData(),null;s.setData(n)}else{if(!o)return r=t.call(a),null;t.call(a,n)}return!0}),o?this:r}})))}();