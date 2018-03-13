//document.write("<script language='javascript' src='"+CONTEXT_PATH+"/js/calendar/WdatePicker.js'></script>");
if(typeof(Jwindow)=='undefined'){document.write("<script language='javascript' src='"+CONTEXT_PATH+"/js/easyui/window.js'></script>");}
if(typeof(WdatePicker)=='undefined'){document.write("<script language='javascript' src='"+CONTEXT_PATH+"/js/calendar/WdatePicker.js'></script>");}
/**
 * Form表单验证扩展
 * 必须为要验证的地方添加easyui-validatebox的class属性，如下
 * <input class="easyui-validatebox"/>
 * 
 * 本库扩展以下验证：
 * 	1.mobile	手机号验证
 * 	2.exist		是否存在验证，后台统一用mark取输入的值，并且返回json串中必须包含b<boolean>属性，不存在返回真
 * 	3.equalTo	输入比较验证，参数为要比较的控件的id字符串或者是该控件的对象（非jQuery对象），比较两者值是否相同，相同返回为真
 * 	4.number	数字验证(正整数)
 */
$.extend($.fn.validatebox.defaults.rules, {
	username:{
		validator:function(value, param, el) {
			return /^[a-zA-Z0-9_\u4E00-\uFA29]+$/.test(value);
		},message: '用户名格式不正确，只能包含中文、字母、数字和_'
	},
	/**
	 * 手机号验证，并将以,，.。隔开的非手机号清除
	 * e.g:<input class="easyui-validatebox" validType="mobile"/>
	 */
	mobile:{
		validator:function(value, param, el) {
			var regex = /^(1[0-9]{1}[0-9]{1}[\d]{8})$/;
			if(PHONE_REGEX) regex = new RegExp(PHONE_REGEX,"ig");
			var phones = value.replace(/[\n\r\s]+/ig,'').replace(/[，]+/ig,',').split(',');
			var length = phones.length;
			if(el.tagName.toLowerCase() != 'textarea'){
				return regex.test(value.replace(/(^[\s]*)|([\s]*$)/,''));
			}else{
				var str = ',',other;
				for(var i=0; i<length; i++){
					regex = new RegExp(PHONE_REGEX,"ig");
					if(param) other = new RegExp(param,"ig"); 
					var phone = phones[i];
					if(phone=='' || 0 <= str.indexOf(","+phone+",")){
						continue;
					}else if(regex.test(phone)){
						str += phone+',';
					}else if(other&&other.test(phone)){
						str += phone+',';
					}
				}
				$(el).val(str.replace(/(^[\s,]*)|([\s,]*$)/g, ""));
				$.cookie('COOKIE_'+$(el).attr('name')+'_value',$(el).val()+"",{path:CONTEXT_PATH,expires:1/24});
				return true;
			}
		},message: '手机号码格式不正确'
	},
	/**
	 * 数字验证(正整数)
	 * e.g:<input class="easyui-validatebox" validType="number"/>
	 */
	number: {
		validator:function(value, param) {
			if(param&&0<param.length){
				regex = new RegExp(param[0],"g");
				if(!regex.test(value)) return false;
				else return true;
			}
			return /^[0-9]*[1-9][0-9]*$/.test(value);
		},message: '输入格式不正确，请输入整数!'
	},
	decimals: {
		validator:function(value, param) {
			if(param&&1<param.length){
				$.fn.validatebox.defaults.rules.decimals.message=param[0];
				regex = new RegExp(param[1],"g");
				if(!regex.test(value)) return false;
				else return true;
			}else if(param&&0<param.length){
				$.fn.validatebox.defaults.rules.decimals.message=param[0];
			}
			return /^[0-9]*[1-9][0-9]*$/.test(value);
		},message: '输入格式不正确，请重新输入!'
	},
	/**
	 * 验证两次输入是否相同
	 * e.g:<input class="easyui-validatebox" validType="equalTo[a]"/>
	 * @type 
	 */
	equalTo:{
		validator: function (value, param) {
			if(typeof(param[0])=="string"){
				return value == $(document.getElementById(param[0])).val();
			}else return value == $(param[0]).val();
		},message: '两次输入的字符不一致'
	},
	/**
	 * 是否存在验证，后台统一用mark取输入的值，并且返回json串中必须包含b<boolean>属性，不存在返回真
	 * e.g:<input class="easyui-validatebox" validType="exist['${path }/base/menu!btnExist.qt?id=${param.id }','test']"/>
	 */
	exist:{
		/**
		 * 验证数据是否存在 后台统一取mark为输入的值
		 * @param {} value	控件输入的值
		 * @param {} param	至少一个参数，第一个为URL地址即验证是否存在的地址，第二个参数为改控件的原始值，当等于原始值时不直接通过
		 * @param {} el		待验证的控件对象
		 */
		validator:function(value, param, el){
			var b = false,_el = $(el),regex;
			//value = jQuery.trim(value);
			//当该值等于原始值时不验证
			if(param.length>1&&param[1]==value)return true;
			//当该值与上一次相同时取上次验证结果
			if(_el.attr('beforeValue')&&_el.attr('beforeValue').trim()==value){
				if(_el.hasClass("validatebox-invalid"))return false;
				else return true;
			}
			if(param.length>2){
				regex = new RegExp(param[2],"g");
				if(!regex.test(value)) return false;
			}
			if(/^[\S]+$/.test(value)&&param.length>0&&param[0]!=''){
				jQuery.ajax({
					async: false,
					type: "GET",
					url: param[0],
					data: 'mark='+encodeURIComponent(value),
					success: function(data){
						try{
							b=eval(data).b;
							_el.attr('beforeValue',value);
						}catch(e){b=false;_el.attr('beforeValue','');}
					}
				});
			}
			return b;
		},message: '已存在或格式错误，请更换！'
	},
	/**
	 * 过滤字符，并提示文本的输入长度 
	 * e.g:<input class="easyui-validatebox" validType="filterWord[minlen,maxlen]"/>
	 */
	filterWord:{
		validator:function(value, param, el) {
			var flag = false;
			value=encodeURI(value);
			if(value != "") {
				$.ajax({
					async:false,
					type:"POST",
					url:CONTEXT_PATH+'/source/forbiddenWord!filterWord.qt?random='+getRandomNum(),
					data: "content="+value,
					success:function(data) {
						var filterData = eval(data);
						var filter = eval(filterData.desc);
						if(filter.length > 0){							
							flag=false;
							var fliterStr = '';
							for(var i = 0 ; i < filter.length ; i++){
								if(fliterStr != '')fliterStr+=',';
								fliterStr +=  filter[i].w;
							}
							$.fn.validatebox.defaults.rules.filterWord.message='您输入的文本含有过滤字符，请重新整理！过滤字符如下：</br>'+fliterStr;
						//	jQuery.messager.alert('错误','短信内容包含过滤字符！','error');
						}else{							
							flag=true;
						}
						if(flag && param && param.length==2){
							var len = el.value.length;
							flag = (len >= param[0] && len <= param[1]);
							$.fn.validatebox.defaults.rules.filterWord.message='您输入的文本必须介于'+param[0]+'和'+param[1]+'之间';
						}
					}
				});
			}
			return flag;
		},message: '您输入字符有过滤字符，请重新输入!'
	}
});


/*
 *通过javascript获得url参数 
 *	
*/
function GetUrlParms() 
{
    var args = new Object();   
    var query = location.search.substring(1);//获取查询串   
    var pairs = query.split("&");//在逗号处断开   
    for(var i = 0;i < pairs.length;i++)   
    {   
        var pos = pairs[i].indexOf('=');//查找name=value   
        if(pos == -1)   continue;//如果没有找到就跳过   
        var argname = pairs[i].substring(0,pos);//提取name   
        var value = pairs[i].substring(pos + 1);//提取value   
        args[argname] = unescape(value);//存为属性   
    }
    return args;
}


/**
 * 扩展验证的事件，主要是初始化事件(init)、焦点事件(focus)、失去焦点事件(blur)、鼠标经过事件(mousemove)、鼠标移出事件(mouseout)
 * 不扩展的为空即可，方法执行时自动传入事件源元素及第一个不符合[a-zA-Z_]+之后的字符串
 * chooseUser等命名只能符合[a-zA-Z_]+
 * 必须为扩展元素添加easyui-validatebox的class属性，如下
 * <input class="easyui-validatebox" methodType="chooseUser[a]"/>
 */
$.extend($.fn.validatebox.defaults.methods, {
	/**
	 * 使用该方法的地方必须加载该JS以及在按钮权限设置中添加/sms/template!choose的访问权限
	 * @type 
	 */
	chooseTemplate:{
		init:function(el,arg){
			if($(el).attr('tagName')=='A'){
				this.b = false;
				$(el).click(function(){
					el.blur();
					var box = parent,args;
					if(ROOT_WINDOW == box.name){box = window;}
					getColorStyle();
					var win = new Jwindow({parent:box,destroy:true,resizable:false});
					var winHandle = 'win_'+getRandomNum();
					eval('box.'+winHandle+'=win');
					if(arg&&arg!=''){
						try{
							args = eval(arg);
						}catch(e){args=['']}
					}
					win.show('选择短信模板',CONTEXT_PATH+'/sms/template!choose.qt?win='+winHandle+'&chkAccess='+(args&&0<args.length?encodeURIComponent(args[0]):request('chkAccess'))+'&random='+getRandomNum(),function(res){
						if(args&&args.length>1)$(args[1]).val(res.content);
					});
					win.reSize('80%','80%');
				});
			}
		},
		focus:function(el,arg){
			el.blur();
			if(typeof(this.b)=='boolean'&&!this.b)return;
			var box = parent,args;
			if(ROOT_WINDOW == box.name){box = window;}
			var win = new Jwindow({parent:box,destroy:true,resizable:false});
			var winHandle = 'win_'+getRandomNum();
			eval('box.'+winHandle+'=win');
			if(arg&&arg!=''){
				try{
					args = eval(arg);
				}catch(e){args=['']}
			}
			win.show('选择短信模板',CONTEXT_PATH+'/sms/template!choose.qt?win='+winHandle+'&chkAccess='+(args&&0<args.length?encodeURIComponent(args[0]):request('chkAccess'))+'&random='+getRandomNum(),function(res){
				$(el).val(res.content);
			});
			win.reSize('80%','80%');
		}
	},
	/**
		选择模板新版
		2012-2-6
		TiddlerCj
	**/
	chooseTemplateNew:{
		init:function(el,arg){
			if($(el).attr('tagName')=='A'){
				this.b = false;
				$(el).click(function(){
					el.blur();
					var box = parent,args;
					if(ROOT_WINDOW == box.name){box = window;}
					getColorStyle();
					var win = new Jwindow({parent:box,destroy:true,resizable:false});
					var winHandle = 'win_'+getRandomNum();
					eval('box.'+winHandle+'=win');
					if(arg&&arg!=''){
						try{
							args = eval(arg);
						}catch(e){args=['']}
					}
					win.show('选择短信模板',CONTEXT_PATH+'/sms/template!choose.qt?win='+winHandle+'&chkAccess='+(args&&0<args.length?encodeURIComponent(args[0]):request('chkAccess'))+'&version=new&random='+getRandomNum(),function(res){
						if(args&&args.length>1)$(args[1]).val(res.content);
					});
					win.reSize('80%','80%');
				});
			}
		},
		focus:function(el,arg){
			el.blur();
			if(typeof(this.b)=='boolean'&&!this.b)return;
			var box = parent,args;
			if(ROOT_WINDOW == box.name){box = window;}
			var win = new Jwindow({parent:box,destroy:true,resizable:false});
			var winHandle = 'win_'+getRandomNum();
			eval('box.'+winHandle+'=win');
			if(arg&&arg!=''){
				try{
					args = eval(arg);
				}catch(e){args=['']}
			}
			win.show('选择短信模板',CONTEXT_PATH+'/sms/template!choose.qt?win='+winHandle+'&chkAccess='+(args&&0<args.length?encodeURIComponent(args[0]):request('chkAccess'))+'&version=new&random='+getRandomNum(),function(res){
				$(el).val(res.content);
			});
			win.reSize('80%','80%');
		}
	},
	/**
		选择模板适用于信息任务
		2012-2-6
		liyafei
	**/
	chooseTemplatePublicMsg:{
		init:function(el,arg){
			if($(el).attr('tagName')=='A'){
				this.b = false;
				$(el).click(function(){
					el.blur();
					var box = parent,args;
					if(ROOT_WINDOW == box.name){box = window;}
					getColorStyle();
					var win = new Jwindow({parent:box,destroy:true,resizable:false});
					var winHandle = 'win_'+getRandomNum();
					eval('box.'+winHandle+'=win');
					if(arg&&arg!=''){
						try{
							args = eval(arg);
						}catch(e){args=['']}
					}
					win.show('选择短信模板',CONTEXT_PATH+'/sms/template!choose.qt?win='+winHandle+'&chkAccess='+(args&&0<args.length?encodeURIComponent(args[0]):request('chkAccess'))+'&version=publicTask&random='+getRandomNum(),function(res){
						if(args&&args.length>1)$(args[1]).val(res.content);
					});
					win.reSize('80%','80%');
				});
			}
		},
		focus:function(el,arg){
			el.blur();
			if(typeof(this.b)=='boolean'&&!this.b)return;
			var box = parent,args;
			if(ROOT_WINDOW == box.name){box = window;}
			var win = new Jwindow({parent:box,destroy:true,resizable:false});
			var winHandle = 'win_'+getRandomNum();
			eval('box.'+winHandle+'=win');
			if(arg&&arg!=''){
				try{
					args = eval(arg);
				}catch(e){args=['']}
			}
			win.show('选择短信模板',CONTEXT_PATH+'/sms/template!choose.qt?win='+winHandle+'&chkAccess='+(args&&0<args.length?encodeURIComponent(args[0]):request('chkAccess'))+'&version=publicTask&random='+getRandomNum(),function(res){
				$(el).val(res.content);
			});
			win.reSize('80%','80%');
		}
	},
	/**
	 * 人员选择
	 * e.g:<input class="easyui-validatebox" methodType="chooseUser"/>
	 */
	chooseUser:{
		init:function(el,arg){
			if($(el).attr('tagName')=='A'){
				this.b = false;
				$(el).click(function(){
					el.blur();
					var box = parent,args;
					if(ROOT_WINDOW == box.name){box = window;}
					getColorStyle();
					var win = new Jwindow({parent:box,destroy:true,resizable:false});
					var winHandle = 'win_'+getRandomNum();
					eval('box.'+winHandle+'=win');
					if(arg&&arg!=''){
						try{
							args = eval(arg);
						}catch(e){args=['']}
					}
					win.show('人员选择',CONTEXT_PATH+'/sms/sendMsg!userList.qt?win='+winHandle+'&chkAccess='+(args&&0<args.length?encodeURIComponent(args[0]):request('chkAccess'))+'&random='+getRandomNum(),function(res){
						if(args&&args.length>1)$(args[1]).val($(args[1]).val()+","+res).blur();
					});
					win.reSize('80%','80%');
				});
			}
		},
		focus:function(el,arg){
			el.blur();
			if(typeof(this.b)=='boolean'&&!this.b)return;
			var box = parent,args;
			if(ROOT_WINDOW == box.name){box = window;}
			var win = new Jwindow({parent:box,destroy:true,resizable:false});
			var winHandle = 'win_'+getRandomNum();
			eval('box.'+winHandle+'=win');
			if(arg&&arg!=''){
				try{
					args = eval(arg);
				}catch(e){args=['']}
			}
			win.show('人员选择',CONTEXT_PATH+'/sms/sendMsg!userList.qt?win='+winHandle+'&chkAccess='+(args&&0<args.length?encodeURIComponent(args[0]):request('chkAccess'))+'&random='+getRandomNum(),function(res){
				$(el).val($(el).val()+","+res).blur();
			});
			win.reSize('80%','80%');
		}
	},
	/**
	 * 通讯录
	 * e.g:<input class="easyui-validatebox" methodType="chooseAddressBook"/>
	 */
	chooseAddressBook:{
		init:function(el,arg){
			if($(el).attr('tagName')=='A'){
				this.b = false;
				$(el).click(function(){
					el.blur();
					var box = parent,args;
					if(ROOT_WINDOW == box.name){box = window;}
					getColorStyle();
					var win = new Jwindow({parent:box,destroy:true,resizable:false});
					var winHandle = 'win_'+getRandomNum();
					eval('box.'+winHandle+'=win');
					if(arg&&arg!=''){
						try{
							args = eval(arg);
						}catch(e){args=['']}
					}
					win.show('人员通讯录选择',CONTEXT_PATH+'/sms/sendMsg!preAddressBook.qt?win='+winHandle+'&chkAccess='+(args&&0<args.length?encodeURIComponent(args[0]):request('chkAccess'))+'&random='+getRandomNum(),function(res){
						if(args&&args.length>1)$(args[1]).val($(args[1]).val()+","+res).blur();
					});
					win.reSize('90%','80%');
				});
			}
		},
		focus:function(el,arg){
			el.blur();
			if(typeof(this.b)=='boolean'&&!this.b)return;
			var box = parent,args;
			if(ROOT_WINDOW == box.name){box = window;}
			var win = new Jwindow({parent:box,destroy:true,resizable:false});
			var winHandle = 'win_'+getRandomNum();
			eval('box.'+winHandle+'=win');
			if(arg&&arg!=''){
				try{
					args = eval(arg);
				}catch(e){args=['']}
			}
			win.show('人员通讯录选择',CONTEXT_PATH+'/sms/sendMsg!preAddressBook.qt?win='+winHandle+'&chkAccess='+(args&&0<args.length?encodeURIComponent(args[0]):request('chkAccess'))+'&random='+getRandomNum(),function(res){
				$(el).val($(el).val()+","+res).blur();
			});
			win.reSize('80%','80%');
		}
	},
	/**
	 * 黏贴号码
	 * e.g:<input class="easyui-validatebox" methodType="pastePhone"/>
	 */
	pastePhone:{
		init:function(el,arg){
			if($(el).attr('tagName')=='A'){
				this.b = false;
				$(el).click(function(){
					el.blur();
					var box = parent,args;
					if(ROOT_WINDOW == box.name){box = window;}
					getColorStyle();
					var win = new Jwindow({parent:box,destroy:true,resizable:false});
					var winHandle = 'win_'+getRandomNum();
					eval('box.'+winHandle+'=win');
					if(arg&&arg!=''){
						try{
							args = eval(arg);
						}catch(e){args=['']}
					}
					win.show('黏贴号码',CONTEXT_PATH+'/sms/sendMsg!prePastePhone.qt?win='+winHandle+'&chkAccess='+(args&&0<args.length?encodeURIComponent(args[0]):request('chkAccess'))+'&random='+getRandomNum(),function(res){
						if(args&&args.length>1)$(args[1]).val($(args[1]).val()+","+res).focus();
					});
					win.reSize('70%','60%');
				});
			}
		},
		focus:function(el,arg){
			el.blur();
			if(typeof(this.b)=='boolean'&&!this.b)return;
			var box = parent,args;
			if(ROOT_WINDOW == box.name){box = window;}
			var win = new Jwindow({parent:box,destroy:true,resizable:false});
			var winHandle = 'win_'+getRandomNum();
			eval('box.'+winHandle+'=win');
			if(arg&&arg!=''){
				try{
					args = eval(arg);
				}catch(e){args=['']}
			}
			win.show('黏贴号码',CONTEXT_PATH+'/sms/sendMsg!prePastePhone.qt?win='+winHandle+'&chkAccess='+(args&&0<args.length?encodeURIComponent(args[0]):request('chkAccess'))+'&random='+getRandomNum(),function(res){
				$(el).val($(el).val()+","+res).blur();
			});
			win.reSize('70%','60%');
		}
	},
	chooseDate:{
		init:function(el,arg){
			var obj = {/*lang:'zh-cn',readOnly:true*/
				onpicked:function(){$(this).validatebox("validate");},	//单击选择日期后自动验证文本框
				oncleared:function(){$(this).validatebox("validate");}	//清除日期后自动验证文本框
			};
			try{
				jQuery.extend(obj,eval('('+arg+')'));
			}catch (e) {}
			$(el).click(function(){
				//WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss',minDate:'2008-03-08 11:30:00',maxDate:'2079-03-22 20:59:30'});
				WdatePicker(obj);
			});
		}
	},
	importPhone:{
		init:function(el,arg){
			if($(el).attr('tagName')=='A'){
				$(el).click(function(){
					var box = parent,args;
					if(ROOT_WINDOW == box.name){box = window;}
					getColorStyle();
					var win = new Jwindow({parent:box,destroy:true,resizable:false});
					var winHandle = 'win_'+getRandomNum();
					eval('box.'+winHandle+'=win');
					if(arg&&arg!=''){
						try{
							args = eval(arg);
						}catch(e){args=['']}
					}
					win.show('导入手机号码',CONTEXT_PATH+'/sms/sendMsg!updateFile.qt?win='+winHandle+'&chkAccess='+(args&&0<args.length?encodeURIComponent(args[0]):request('chkAccess'))+'&random='+getRandomNum(),function(res){
						$(args[1]).val($(args[1]).val()+',<att:'+res.id+'>').blur();
						//$(args[1]).val($(args[1]).val()+","+res).blur();
					});
					win.reSize(500,240);
				});
			}
		}
	},
	
	/**
	 * 菜单图标选择
	 * e.g:<input class="easyui-validatebox" methodType="chooseIcon"/>
	 */
	chooseIcon:{
		init:function(el,arg){
			$(el).hide();
			var pn = el.parentNode;
			jQuery('<div style="vertical-align:middle;margin-left:5px;*margin-top:9px" class="iconMain '+$(el).attr('showText')+'"></div>').prependTo(pn);
			jQuery('<a href="#" style="text-decoration:underline;" hidefocus="true">点击选择</a>').appendTo(pn).click(function(){
				var param = 'win_'+Math.floor(Math.random()*10000+1);
				var win = new Jwindow({parent:parent,destroy:true});
				eval('parent.'+param+'=win');
				win.show('图标选择',CONTEXT_PATH+'/js/menu/chooseIcon.jsp?jsname='+param,function(value){
					$(el).val(value.iconVal);
					$(pn).find('div').remove().end().prepend('<div style="vertical-align:middle;margin-left:5px;*margin-top:9px" class="iconMain '+value.iconVal+'"></div>');
				});
				win.reSize(620,400);
			});
		}
	}
});