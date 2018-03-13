var DataDictHandle = function(){
	this.setting = {
		service:'',			//后台service名称，可以是class全路劲，也可以是以“#”开头的service ID名称
		queryHtml:'',		//查询条件
		winTitle:'默认窗口',	//窗口标题
		winWidth:620,		//窗口默认宽度
		winHeight:400,		//窗口默认高度
		onClick:function(el){},//当绑定的对象激活单击事件时执行
		allowSelectAll:false,	//是否允许选择所有，默认不允许，只有开放多选是才可以，如果确定选择所有则返回的是JSON字符串
		selectDataTotalKey:'selectDataTotalKey'+Math.floor(Math.random()*10000+1),//选中的记录总数
		table:{
			rownumbers:true,		//显示行号
			clickSingleSelect:true,	//单击时单选
			url:CONTEXT_PATH+'/base/dataDict!list.qt?random='+getRandomNum(),
			idField:"id",			//
			singleSelect:true,		//
			queryParams:{
				service:"",
				attrs:"",
				query:""},			//
			columns:[[]]			//
		}
	};
	for(var i=0,len=arguments.length;i<len;i++){
		var obj = arguments[i];
		if(typeof(obj) == "object"){
			this.setting = jQuery.extend(true, this.setting, obj);
		}else if(typeof(obj) == "function"){
			this.callback = obj;		//回调函数，回传选中行记录
		}
	}
	if(this.setting.table.queryParams.service=='')this.setting.table.queryParams.service = this.setting.service;
	//如果没有配置返回结果集的key值串，则自动生成
	if(this.setting.table.queryParams.attrs==''){
		for(var i=0,len=this.setting.table.columns[0].length;i<len;i++){
			var obj = this.setting.table.columns[0][i];
			if(obj.checkbox)continue;
			if(obj.field) this.setting.table.queryParams.attrs+=","+obj.field;
		}
		if(0<this.setting.table.queryParams.attrs.length)
			this.setting.table.queryParams.attrs = this.setting.table.queryParams.attrs.substring(1);
	}
};
DataDictHandle.ALL_SELECT = 'all';
DataDictHandle.PART_SELECT = 'hand';
DataDictHandle.prototype.bind=function(){
	var _el,_this = this;
	var callback = this.callback;
	for(var i=0,len=arguments.length;i<len;i++){
		var obj = arguments[i];
		if(typeof(obj) == "function"){
			callback = obj;
		}else{
			_el = $(obj);
		}
	}
	_el.click(function(){
		_this.setting.onClick.call(this);
		var _elThis = this;
		if(_this.setting.service==''){
			alert('配置错误！无法访问！');
			return;
		}
		var param = 'win_'+Math.floor(Math.random()*10000+1);
		var win = new Jwindow({parent:parent,destroy:true});
		win.data = _this;
		eval('parent.'+param+'=win');
		var url = CONTEXT_PATH+'/js/dataDict/dataDict.jsp?jsname='+param;
		win.show(_this.setting.winTitle, url, function(items){
			_this.callback(_elThis, items);
		});
		win.reSize(_this.setting.winWidth, _this.setting.winHeight);
	});
}