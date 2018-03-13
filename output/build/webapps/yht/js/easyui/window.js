/**
 * 实现两种参数初始化窗口
 * 	1.对象——easyUI Window对象参数	例如：{collapsible:true}
 * 		destroy:true 当窗口关闭时会自动销毁
 * 		parent:parent 在父窗口创建窗口
 * 	2.方法——刷新父窗口时默认调用的方法
 */
function Jwindow(){
	var userSettings = {};
	var length = arguments.length;
	for(var i=0;i<length&&length<3;i++){
		var obj = arguments[i];
		if(typeof(obj) == "object"){
			userSettings = obj;
		}else if(typeof(obj) == "function"){
			this.defaultFun = obj;
		}
	}
	this.jQuery = jQuery;
	this.container = document.body;
	this.document = document;
	if(userSettings.parent&&userSettings.parent.window&&userSettings.parent.window.jQuery){
		this.jQuery = userSettings.parent.window.jQuery;
		this.container = userSettings.parent.document.body;
		this.document = userSettings.parent.document;
	}
	
	var html = '<div class="easyui-window"></div>';
	this._width = this.jQuery(this.document).width();
	this._height = this.jQuery(this.document).height();
	if(typeof(this.defaultFun)!="function")this.defaultFun = function(){};
	this.fun = null;
	this.argument = {};
	var settings = {closed:true,minimizable:false,maximizable:false,collapsible:false,modal:true,width:this._width*0.5,height:this._height*0.5,left:this._width*0.25,top:this._height*0.25};
	this.jQuery.extend(settings,userSettings);
	this.obj = this.jQuery(html).appendTo(this.container).window(settings);
	var random = Math.floor(Math.random()*10000+1);
	this.iframe = this.jQuery('<iframe name="windowIframe-'+random+'" src="" frameborder="0" width="100%" height="100%"></iframe>').appendTo(this.obj);
}
/**
 * 显示窗口的方法
 * @param {} title	窗口标题
 * @param {} href	链接地址
 * @param {} fun	方法：刷新父窗口的方法	不传递则调用默认方法
 * 					对象：为调用默认刷新方法的参数
 */
Jwindow.prototype.show = function(title,href,fun){
	this.reSize();
	if(typeof(fun) == "function") this.fun = fun;
	else this.argument = fun;
	var obj = this.obj.window({closed:false,'title':title});
	var iframe = obj.find('iframe').css('visibility','hidden');
	this.iframe.attr('src',href).load(function(){
		iframe.css('visibility','visible');
	});
}
/**
 * 关闭窗口
 */
Jwindow.prototype.hide = function(){
	this.obj.window('close');
}
/**
 * 重置窗口大小
 * @param {} w 数字或百分比 默认50%
 * @param {} h 数字或百分比 默认50%
 */
Jwindow.prototype.reSize = function(w,h){
	this._width = this.jQuery(this.document).width();
	this._height = this.jQuery(this.document).height();
	if(arguments.length>1){
		if(typeof(w)=="number"){
		}else if(w.toString().lastIndexOf('%')){
			w = parseInt(w)*0.01*this._width;
		}else{
			w = parseInt(w);
		}
		if(typeof(h)=="number"){
		}else if(h.toString().lastIndexOf('%')){
			h = parseInt(h)*0.01*this._height;
		}else{
			h = parseInt(h);
		}
		this.obj.window({width:w,height:h,left:(this._width-w)*0.5,top:(this._height-h)*0.5});
	}else{
		this.obj.window({width:this._width*0.5,height:this._height*0.5,left:this._width*0.25,top:this._height*0.25});
	}
}
/**
 * 刷新父窗口，一般为子页面调用刷新本窗口
 * param 当该参数为空时自动传递show方法传递的参数
 */
Jwindow.prototype.refreshParent = function(param){
	this.hide();
	if(param) this.argument = param;
	if(typeof(this.fun) == "function") this.fun(this.argument);
	else this.defaultFun(this.argument);
	this.fun = null;
}