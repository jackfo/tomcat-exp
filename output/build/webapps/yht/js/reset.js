jQuery(document).ready(function(){
	$('form').bind('reset',function(){
		var _this = $(this);
		if(typeof(_this.attr('id'))=='undefined'||_this.attr('id')=='')
			_this.attr('id','FORM_AUTO_ID_'+Math.floor(Math.random()*10000+1));
		window.setTimeout('restorationResetEvent("'+_this.attr('id')+'")',1);
	});
});
  function restorationResetEvent(el){
	if(typeof(el)!='string') return;
	$('form#'+el).each(function(i,el){
		$(el).find('.easyui-combobox').each(function(j,item){
			var _item = $(item);
			var _opt = _item.combobox('options');
			if(_opt.data!=null){
				var _temp = [];
				for(var i=0,l=_opt.data.length;i<l;i++){
					if(_opt.data[i].selected)
						_temp.push(_opt.data[i][_opt.valueField])
				}
				_item.combobox('setValues', _temp);
			}else _item.combobox('setValues', [_item.val()]);
		});
		$(el).find('.easyui-combotree').each(function(j,item){
			var _item = $(item);
			_item.combotree('setValue',_item.val());
		});
	});
}