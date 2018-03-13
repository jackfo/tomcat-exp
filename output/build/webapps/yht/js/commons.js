function iframeAutoHeight(obj){
	var win=obj;
	if (document.getElementById){
	       if (win && !window.opera){
	        if (win.contentDocument && win.contentDocument.body.offsetHeight) 
	
	         win.height = win.contentDocument.body.offsetHeight; 
	        else if(win.Document && win.Document.body.scrollHeight)
	         win.height = win.Document.body.scrollHeight;
	       }
	}
}

String.prototype.trim = function() { 
    return this.replace(/(^[\s]*)|([\s]*$)/g, ""); 
} 
String.prototype.lTrim = function() { 
    return this.replace(/(^[\s]*)/g, ""); 
} 
String.prototype.rTrim = function() { 
    return this.replace(/([\s]*$)/g, ""); 
}
String.prototype.strLen=function(){
	var sString = this;
	var sStr,iCount,i,strTemp ; 

	iCount = 0 ;
	sStr = sString.split("");
	for (i = 0 ; i < sStr.length ; i ++){
		strTemp = escape(sStr[i]); 
		if (strTemp.indexOf("%u",0) == -1){ 
			iCount = iCount + 1 ;
		}else{
			iCount = iCount + 2 ;
		}
	}
	return iCount ;
}
/* 字符串替换 
* @param arrSearch 原来的元素组成的数组，不能是单个字符串 
* @param arrReplace 数组元素要和 arrSearch 一一对应, 
* add by  
* 2010/10/18 
*/  
String.prototype.replaceAll = function(arrSearch, arrReplace){
	var search
	if(typeof(arrSearch)!='string')
		search = arrSearch.join('|');
	var regexp = new RegExp(search, "g" );  
	var str = this.replace( regexp, function(MatchStr){  
		var arrNum = arrSearch.length;  
		for(var i=0;i<arrNum;i++){  
			if(arrSearch[i]==MatchStr){  
				return arrReplace[i];  
			}  
		}  
	});  
	return str;  
}

function $p(el) {
	var ua = navigator.userAgent.toLowerCase();
	var isOpera = (ua.indexOf('opera') != -1);
	var isIE = (ua.indexOf('msie') != -1 && !isOpera); // not opera spoof
	if(el.parentNode === null || el.style.display == 'none') {
		return false;
	}      
	var parent = null;
	var pos = [];     
	var box;     
	if(el.getBoundingClientRect){    //IE      
	  box = el.getBoundingClientRect();
	  var scrollTop = Math.max(document.documentElement.scrollTop, document.body.scrollTop);
	  var scrollLeft = Math.max(document.documentElement.scrollLeft, document.body.scrollLeft);
	  return {x:box.left + scrollLeft, y:box.top + scrollTop};
	}else if(document.getBoxObjectFor){    // gecko    
	 
	  box = document.getBoxObjectFor(el); 
	  var borderLeft = (el.currentStyle.borderLeftWidth)?parseInt(el.currentStyle.borderLeftWidth):0; 
	  var borderTop = (el.currentStyle.borderTopWidth)?parseInt(el.currentStyle.borderTopWidth):0; 
	  pos = [box.x - borderLeft, box.y - borderTop];
	} else{    // safari & opera    
		pos = [el.offsetLeft, el.offsetTop];  
		parent = el.offsetParent;     
		if (parent != el) { 
			while (parent) {  
				pos[0] += parent.offsetLeft; 
				pos[1] += parent.offsetTop; 
				parent = parent.offsetParent;
			}  
		}   
		if (ua.indexOf('opera') != -1 || ( ua.indexOf('safari') != -1 
				&& el.style.position == 'absolute' )) { 
			pos[0] -= document.body.offsetLeft;
			pos[1] -= document.body.offsetTop;         
		}    
	}              
	if (el.parentNode) { 
		parent = el.parentNode;
	} else {
		parent = null;
	}
	while (parent && parent.tagName != 'BODY' && parent.tagName != 'HTML') { // account for any scrolled ancestors
		pos[0] -= parent.scrollLeft;
		pos[1] -= parent.scrollTop;
		if (parent.parentNode) {
			parent = parent.parentNode;
		} else {
			parent = null;
		}
	}
	return {x:pos[0], y:pos[1]};
}

var Container = function(obj){
	this.obj = obj;
	obj.className = "Container";
}
Container.prototype.init = function(){
	this.right = document.createElement("div");
	this.right.className = "Container_right";
	document.body.appendChild(this.right);
	var mobj = this;
	this.obj.parentNode.onresize = function(){
		mobj.resize();
	}
	this.resize();
}
Container.prototype.resize= function(){
	var p = $p(this.obj);
	with(this.right){
		style.left = p.x + this.obj.offsetWidth;
		style.top = p.y;
	}
}

function divMouseOver(obj){
	$(obj).removeClass("divMouseOut");
	$(obj).toggleClass("divMouseOver");
}

function divMouseOut(obj){
	$(obj).removeClass("divMouseOver");
	$(obj).toggleClass("divMouseOut");
}

function getURLParams(){
	var params = '';
	$(".formPanel :input").each(function(i,obj){
		if('radio' == $(obj).attr('type').toLowerCase()){
			if($(obj).attr('checked'))
				params += '&' + $(obj).attr('name') + '=' + encodeURIComponent($(obj).val());
		}else{
			params += '&' + $(obj).attr('name') + '=' + encodeURIComponent($(obj).val());
		}
	});
	return params;
}

function getURLParamsForObj(){
	var params = '';
	$(".formPanel :input").each(function(i,obj){
		params += '"'+$(obj).attr('name') + '":"' + $(obj).val() + '",';
	});
	params = "({"+params.replace(/(^[,]*)|([,]*$)/ig,'')+"})";
	return eval(params);
}
function insertAtCursor(myField,myValue) {
	//IE support
	if (document.selection) {
		myField.focus();
		sel = document.selection.createRange();
		sel.text = myValue;
		sel.select();
	}
	//MOZILLA/NETSCAPE support
	else if (myField.selectionStart || myField.selectionStart == '0') {
		var startPos = myField.selectionStart;
		var endPos = myField.selectionEnd;
		// save scrollTop before insert
		var restoreTop = myField.scrollTop;
		myField.value = myField.value.substring(0, startPos) + myValue + myField.value.substring(endPos, myField.value.length);
		if (restoreTop > 0) {
			// restore previous scrollTop
			myField.scrollTop = restoreTop;
		}
		myField.focus();
		myField.selectionStart = startPos + myValue.length;
		myField.selectionEnd = startPos + myValue.length;
  	} else {
		myField.value += myValue;
		myField.focus();
	}
	myField.blur();
}
/**
 * 获取URL上的参数值
 * @param {} paras
 * @return {String}
 */
function request(paras){ 
	var url = location.href;  
	var paraString = url.substring(url.indexOf("?")+1,url.length).split("&");  
	var paraObj = {}  
	for (i=0; j=paraString[i]; i++){  
		paraObj[j.substring(0,j.indexOf("=")).toLowerCase()] = j.substring(j.indexOf("=")+1,j.length);  
	}
	var returnValue = paraObj[paras.toLowerCase()];
	if(typeof(returnValue)=="undefined"){
		return "";
	}else{
		return returnValue;
	}
}

/**
*
*将js数值转成json对象的字符串
*/
function obj2Str(obj){  
	switch(typeof(obj)){  
	   case 'object':  
	   		var ret = [];  
	    	if(obj instanceof Array){  
		     	for (var i = 0, len = obj.length; i < len; i++){  
		      		ret.push(obj2Str(obj[i]));  
		     	}  
		     	return '[' + ret.join(',') + ']';  
	    	}else if (obj instanceof RegExp){  
		     	return obj.toString();  
		    }else{  
			    for (var a in obj){  
			      	ret.push(a + ':' + obj2Str(obj[a]));  
			    }  
		     	return '{' + ret.join(',') + '}';  
		    }  
	   case 'function':  
	    	return 'function() {}';  
	   case 'number':  
	    	return obj.toString();  
	   case 'string':  
	    	return "\"" + obj.replace(/(\\|\")/g, "\\$1").replace(/\n|\r|\t/g, function(a) {return ("\n"==a)?"\\n":("\r"==a)?"\\r":("\t"==a)?"\\t":"";}) + "\"";  
	   case 'boolean':  
	    	return obj.toString();  
	   default:  
	    	return obj.toString();  
	}  
}

/**
  * 如果当前的浏览器是IE6，则打开一个iframe层，用于遮挡select组件，
  * 本组件用于解决IE6中，div层挡不住select组件的bug
  *
  * @param parentDivId  iframe所依赖的父窗口div层的id，要遮挡的select组件
  *       便在该div中(如果select组件不在一个div中，请放入一个div中
  *       并定义一个id作为该参数的值）
  *       
  */
function openIframeDiv(parentDivId) {
	if($.browser.msie && $.browser.version=='6.0'){
	    var iframeHtml = '<iframe id="iframeDivUsedForCoverSelect" scrolling="auto" width="100%" height="100%" '
	    	+ 'frameborder="0" framespacing="0" style="filter:alpha(opacity:0);'
	        + 'opacity:0;left:0px;top:0px;position:absolute;z-index:1;"></iframe>';
	    $("#"+parentDivId).append(iframeHtml);
	}
}
 
 /**
  * 移除iframe层，与方法openIframeDiv(parentDivId)配对使用
  * 
  * 
  */
function removeIframe() {
	//获取以前的查询窗口对象
	var searchObj = document.getElementById("iframeDivUsedForCoverSelect");
	//如果对应id的组件已经存在则将其删除
	if (null != searchObj && typeof(searchObj) != "undefined") {
		$("#iframeDivUsedForCoverSelect").remove();
	}
}

/**
*创建一个dataList的column菜单，并控制column的显示影藏
*	
*/
function createColumnMenu(obj){
	var tmenu = $('<div id="tmenu" style="width:100px;"></div>').appendTo('body');
	var columns = $(obj).datagrid('getColumns');
	for(var i=0; i<columns.length; i++){
		var div = '<div iconCls="icon-ok" id="id-'+columns[i].field+'"/>';
		$(div).html(columns[i].title).appendTo(tmenu);
	}
	tmenu.menu({
		onClick: function(item){
			if (item.iconCls=='icon-ok'){
				$(obj).datagrid('hideColumn', item.id.substring(3));
				tmenu.menu('setIcon', {
					target: item.target,
					iconCls: 'icon-empty'
				});
			} else {
				$(obj).datagrid('showColumn', item.id.substring(3));
				tmenu.menu('setIcon', {
					target: item.target,
					iconCls: 'icon-ok'
				});
			}
		}
	});
}

	
function getColorStyle(){
	$('.styleswitch').click(function()
	{
		switchStylestyle(this.getAttribute("rel"));
		return false;
	});
	var c = readCookie('style');
	if (c) switchStylestyle(c);
}
function switchStylestyle(styleName)
 {
 	$('link[rel=stylesheet][title]').each(function(i) 
	{
		this.disabled = true;
		if (this.getAttribute('title') == styleName) this.disabled = false;
	});
	
	$("iframe").contents().find('link[rel=stylesheet][title]').each(function(i) 
	{
		this.disabled = true;
		if (this.getAttribute('title') == styleName) this.disabled = false;
	});
	
	createCookie('style', styleName, 365);
 }
 
 function createCookie(name,value,days)
 {
	if (days)
	{
		var date = new Date();
		date.setTime(date.getTime()+(days*24*60*60*1000));
		var expires = "; expires="+date.toGMTString();
	}
	else var expires = "";
	document.cookie = name+"="+value+expires+"; path=/";
 }
 
 function readCookie(name)
 {
	var nameEQ = name + "=";
	var ca = document.cookie.split(';');
	for(var i=0;i < ca.length;i++)
	{
		var c = ca[i];
		while (c.charAt(0)==' ') c = c.substring(1,c.length);
		if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
	}
	return null;
 }
 
 function eraseCookie(name)
 {
	createCookie(name,"",-1);
 }