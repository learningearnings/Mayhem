/*
Copyright (c) 2003-2012, CKSource - Frederico Knabben. All rights reserved.
For licensing, see LICENSE.html or http://ckeditor.com/license
*/
CKEDITOR.dialog.add("colordialog",function(e){function t(){g.getById(_).removeStyle("background-color"),d.getContentElement("picker","selectedColor").setValue(""),c&&c.removeAttribute("aria-selected"),c=null}function n(e){var t,n=e.data.getTarget();"td"==n.getName()&&(t=n.getChild(0).getHtml())&&(c=n,c.setAttribute("aria-selected",!0),d.getContentElement("picker","selectedColor").setValue(t))}function i(e){e=e.replace(/^#/,"");for(var t=0,n=[];2>=t;t++)n[t]=parseInt(e.substr(2*t,2),16);var i=.2126*n[0]+.7152*n[1]+.0722*n[2];return"#"+(i>=165?"000":"fff")}function a(e){!e.name&&(e=new CKEDITOR.event(e));var t,n=!/mouse/.test(e.name),a=e.data.getTarget();"td"==a.getName()&&(t=a.getChild(0).getHtml())&&(r(e),n?u=a:h=a,n&&(a.setStyle("border-color",i(t)),a.setStyle("border-style","dotted")),g.getById(y).setStyle("background-color",t),g.getById(k).setHtml(t))}function o(){var e=u.getChild(0).getHtml();u.setStyle("border-color",e),u.setStyle("border-style","solid"),g.getById(y).removeStyle("background-color"),g.getById(k).setHtml("&nbsp;"),u=null}function r(e){var t=!/mouse/.test(e.name),n=t&&u;if(n){var i=n.getChild(0).getHtml();n.setStyle("border-color",i),n.setStyle("border-style","solid")}u||h||(g.getById(y).removeStyle("background-color"),g.getById(k).setHtml("&nbsp;"))}function s(t){var i,a,o=t.data,r=o.getTarget(),s=o.getKeystroke(),l="rtl"==e.lang.dir;switch(s){case 38:(i=r.getParent().getPrevious())&&(a=i.getChild([r.getIndex()]),a.focus()),o.preventDefault();break;case 40:(i=r.getParent().getNext())&&(a=i.getChild([r.getIndex()]),a&&1==a.type&&a.focus()),o.preventDefault();break;case 32:case 13:n(t),o.preventDefault();break;case l?37:39:(a=r.getNext())?1==a.type&&(a.focus(),o.preventDefault(!0)):(i=r.getParent().getNext())&&(a=i.getChild([0]),a&&1==a.type&&(a.focus(),o.preventDefault(!0)));break;case l?39:37:(a=r.getPrevious())?(a.focus(),o.preventDefault(!0)):(i=r.getParent().getPrevious())&&(a=i.getLast(),a.focus(),o.preventDefault(!0));break;default:return}}function l(){function e(e,n){for(var a=e;e+3>a;a++){var o=new m(p.$.insertRow(-1));o.setAttribute("role","row");for(var r=n;n+3>r;r++)for(var s=0;6>s;s++)t(o.$,"#"+i[r]+i[s]+i[a])}}function t(e,t){var i=new m(e.insertCell(-1));i.setAttribute("class","ColorCell"),i.setAttribute("tabIndex",-1),i.setAttribute("role","gridcell"),i.on("keydown",s),i.on("click",n),i.on("focus",a),i.on("blur",r),i.setStyle("background-color",t),i.setStyle("border","1px solid "+t),i.setStyle("width","14px"),i.setStyle("height","14px");var o=b("color_table_cell");i.setAttribute("aria-labelledby",o),i.append(CKEDITOR.dom.element.createFromHtml('<span id="'+o+'" class="cke_voice_label">'+t+"</span>",CKEDITOR.document))}p=CKEDITOR.dom.element.createFromHtml('<table tabIndex="-1" aria-label="'+f.options+'"'+' role="grid" style="border-collapse:separate;" cellspacing="0">'+'<caption class="cke_voice_label">'+f.options+"</caption>"+'<tbody role="presentation"></tbody></table>'),p.on("mouseover",a),p.on("mouseout",r);var i=["00","33","66","99","cc","ff"];e(0,0),e(3,0),e(0,3),e(3,3);var o=new m(p.$.insertRow(-1));o.setAttribute("role","row");for(var l=0;6>l;l++)t(o.$,"#"+i[l]+i[l]+i[l]);for(var d=0;12>d;d++)t(o.$,"#000000")}var d,c,u,h,p,m=CKEDITOR.dom.element,g=CKEDITOR.document,f=e.lang.colordialog,v={type:"html",html:"&nbsp;"},b=function(e){return CKEDITOR.tools.getNextId()+"_"+e},y=b("hicolor"),k=b("hicolortext"),_=b("selhicolor");return l(),{title:f.title,minWidth:360,minHeight:220,onLoad:function(){d=this},onHide:function(){t(),o()},contents:[{id:"picker",label:f.title,accessKey:"I",elements:[{type:"hbox",padding:0,widths:["70%","10%","30%"],children:[{type:"html",html:"<div></div>",onLoad:function(){CKEDITOR.document.getById(this.domId).append(p)},focus:function(){(u||this.getElement().getElementsByTag("td").getItem(0)).focus()}},v,{type:"vbox",padding:0,widths:["70%","5%","25%"],children:[{type:"html",html:"<span>"+f.highlight+'</span>												<div id="'+y+'" style="border: 1px solid; height: 74px; width: 74px;"></div>												<div id="'+k+'">&nbsp;</div><span>'+f.selected+'</span>												<div id="'+_+'" style="border: 1px solid; height: 20px; width: 74px;"></div>'},{type:"text",label:f.selected,labelStyle:"display:none",id:"selectedColor",style:"width: 74px",onChange:function(){try{g.getById(_).setStyle("background-color",this.getValue())}catch(e){t()}}},v,{type:"button",id:"clear",style:"margin-top: 5px",label:f.clear,onClick:t}]}]}]}]}});