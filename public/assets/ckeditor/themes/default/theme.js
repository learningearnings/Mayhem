/*
Copyright (c) 2003-2012, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/
CKEDITOR.themes.add("default",function(){function e(e,t){var n,i;if(i=e.config.sharedSpaces,i=i&&i[t],i=i&&CKEDITOR.document.getById(i)){var a='<span class="cke_shared " dir="'+e.lang.dir+'"'+">"+'<span class="'+e.skinClass+" "+e.id+" cke_editor_"+e.name+'">'+'<span class="'+CKEDITOR.env.cssClass+'">'+'<span class="cke_wrapper cke_'+e.lang.dir+'">'+'<span class="cke_editor">'+'<div class="cke_'+t+'">'+"</div></span></span></span></span></span>",o=i.append(CKEDITOR.dom.element.createFromHtml(a,i.getDocument()));i.getCustomData("cke_hasshared")?o.hide():i.setCustomData("cke_hasshared",1),n=o.getChild([0,0,0,0]),!e.sharedSpaces&&(e.sharedSpaces={}),e.sharedSpaces[t]=n,e.on("focus",function(){for(var e,t=0,n=i.getChildren();e=n.getItem(t);t++)e.type==CKEDITOR.NODE_ELEMENT&&!e.equals(o)&&e.hasClass("cke_shared")&&e.hide();o.show()}),e.on("destroy",function(){o.remove()})}return n}var t={};return{build:function(n){var i=n.name,a=n.element,o=n.elementMode;if(a&&o!=CKEDITOR.ELEMENT_MODE_NONE){o==CKEDITOR.ELEMENT_MODE_REPLACE&&a.hide();var r=n.fire("themeSpace",{space:"top",html:""}).html,s=n.fire("themeSpace",{space:"contents",html:""}).html,l=n.fireOnce("themeSpace",{space:"bottom",html:""}).html,c=s&&n.config.height,d=n.config.tabIndex||n.element.getAttribute("tabindex")||0;s?isNaN(c)||(c+="px"):c="auto";var u="",h=n.config.width;h&&(isNaN(h)||(h+="px"),u+="width: "+h+";");var p=r&&e(n,"top"),m=e(n,"bottom");p&&(p.setHtml(r),r=""),m&&(m.setHtml(l),l="");var g="<style>."+n.skinClass+"{visibility:hidden;}</style>";t[n.skinClass]?g="":t[n.skinClass]=1;var f=CKEDITOR.dom.element.createFromHtml(['<span id="cke_',i,'" class="',n.skinClass," ",n.id," cke_editor_",i,'" dir="',n.lang.dir,'" title="',CKEDITOR.env.gecko?" ":"",'" lang="',n.langCode,'"'+(CKEDITOR.env.webkit?' tabindex="'+d+'"':"")+' role="application"'+' aria-labelledby="cke_',i,'_arialbl"'+(u?' style="'+u+'"':"")+">"+'<span id="cke_',i,'_arialbl" class="cke_voice_label">'+n.lang.editor+"</span>"+'<span class="',CKEDITOR.env.cssClass,'" role="presentation"><span class="cke_wrapper cke_',n.lang.dir,'" role="presentation"><table class="cke_editor" border="0" cellspacing="0" cellpadding="0" role="presentation"><tbody><tr',r?"":' style="display:none"',' role="presentation"><td id="cke_top_',i,'" class="cke_top" role="presentation">',r,"</td></tr><tr",s?"":' style="display:none"',' role="presentation"><td id="cke_contents_',i,'" class="cke_contents" style="height:',c,'" role="presentation">',s,"</td></tr><tr",l?"":' style="display:none"',' role="presentation"><td id="cke_bottom_',i,'" class="cke_bottom" role="presentation">',l,"</td></tr></tbody></table>"+g+"</span>"+"</span>"+"</span>"].join(""));f.getChild([1,0,0,0,0]).unselectable(),f.getChild([1,0,0,0,2]).unselectable(),o==CKEDITOR.ELEMENT_MODE_REPLACE?f.insertAfter(a):a.append(f),n.container=f,f.disableContextMenu(),n.on("contentDirChanged",function(e){var t=(n.lang.dir!=e.data?"add":"remove")+"Class";f.getChild(1)[t]("cke_mixed_dir_content");var i=this.sharedSpaces&&this.sharedSpaces[this.config.toolbarLocation];i&&i.getParent().getParent()[t]("cke_mixed_dir_content")}),n.fireOnce("themeLoaded"),n.fireOnce("uiReady")}},buildDialog:function(e){var t=CKEDITOR.tools.getNextNumber(),n=CKEDITOR.dom.element.createFromHtml(['<div class="',e.id,"_dialog cke_editor_",e.name.replace(".","\\."),"_dialog cke_skin_",e.skinName,'" dir="',e.lang.dir,'" lang="',e.langCode,'" role="dialog" aria-labelledby="%title#"><table class="cke_dialog'," "+CKEDITOR.env.cssClass," cke_",e.lang.dir,'" style="position:absolute" role="presentation"><tr><td role="presentation"><div class="%body" role="presentation"><div id="%title#" class="%title" role="presentation"></div><a id="%close_button#" class="%close_button" href="javascript:void(0)" title="'+e.lang.common.close+'" role="button"><span class="cke_label">X</span></a>'+'<div id="%tabs#" class="%tabs" role="tablist"></div>'+'<table class="%contents" role="presentation">'+"<tr>"+'<td id="%contents#" class="%contents" role="presentation"></td>'+"</tr>"+"<tr>"+'<td id="%footer#" class="%footer" role="presentation"></td>'+"</tr>"+"</table>"+"</div>"+'<div id="%tl#" class="%tl"></div>'+'<div id="%tc#" class="%tc"></div>'+'<div id="%tr#" class="%tr"></div>'+'<div id="%ml#" class="%ml"></div>'+'<div id="%mr#" class="%mr"></div>'+'<div id="%bl#" class="%bl"></div>'+'<div id="%bc#" class="%bc"></div>'+'<div id="%br#" class="%br"></div>'+"</td></tr>"+"</table>",CKEDITOR.env.ie?"":"<style>.cke_dialog{visibility:hidden;}</style>","</div>"].join("").replace(/#/g,"_"+t).replace(/%/g,"cke_dialog_")),i=n.getChild([0,0,0,0,0]),a=i.getChild(0),o=i.getChild(1);if(CKEDITOR.env.ie&&!CKEDITOR.env.ie6Compat){var r=CKEDITOR.env.isCustomDomain(),s="javascript:void(function(){"+encodeURIComponent("document.open();"+(r?'document.domain="'+document.domain+'";':"")+"document.close();")+"}())",l=CKEDITOR.dom.element.createFromHtml('<iframe frameBorder="0" class="cke_iframe_shim" src="'+s+'"'+' tabIndex="-1"'+"></iframe>");l.appendTo(i.getParent())}return a.unselectable(),o.unselectable(),{element:n,parts:{dialog:n.getChild(0),title:a,close:o,tabs:i.getChild(2),contents:i.getChild([3,0,0,0]),footer:i.getChild([3,0,1,0])}}},destroy:function(e){var t=e.container,n=e.element;t&&(t.clearCustomData(),t.remove()),n&&(n.clearCustomData(),e.elementMode==CKEDITOR.ELEMENT_MODE_REPLACE&&n.show(),delete e.element)}}}()),CKEDITOR.editor.prototype.getThemeSpace=function(e){var t="cke_"+e,n=this._[t]||(this._[t]=CKEDITOR.document.getById(t+"_"+this.name));return n},CKEDITOR.editor.prototype.resize=function(e,t,n,i){var a=this,o=a.container,r=CKEDITOR.document.getById("cke_contents_"+a.name),s=CKEDITOR.env.webkit&&a.document&&a.document.getWindow().$.frameElement,l=i?o.getChild(1):o;l.setSize("width",e,!0),s&&(s.style.width="1%");var c=n?0:(l.$.offsetHeight||0)-(r.$.clientHeight||0);r.setStyle("height",Math.max(t-c,0)+"px"),s&&(s.style.width="100%"),a.fire("resize")},CKEDITOR.editor.prototype.getResizable=function(e){return e?CKEDITOR.document.getById("cke_contents_"+this.name):this.container};