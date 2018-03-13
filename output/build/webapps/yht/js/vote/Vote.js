document.write("<link rel=\"stylesheet\" type=\"text/css\" href=\""+CONTEXT_PATH+"/js/vote/style.css\">");
/**
 * 投票选项操作类
 * 后台获取时
 * @param {} el	选项存放的容器对象
 */
function Vote(el,args) {
	this.items = [];
	if(typeof(args)=='undefined')args={};
	this.param = jQuery.extend({mark:'mark',name:'name',type:'type',typeDefault:'1',length:50},args);
	this.mainContainer = el;
	if(!this.mainContainer.id) this.mainContainer.id = 'VOTE_CONTAINER_'+Math.floor(Math.random()*10000+1);
	this.init();
}
Vote.prototype.init = function() {
	var box = this;
	jQuery('<div class="VOTE_TYPE">可选数目：</div><div class="VOTE_BTN"></div>').appendTo(this.mainContainer);
	this.typeSelect = '<select name="'+this.param.type+'"><option value="0"'+(this.param.typeDefault==0?' selected="selected"':'')+'>不定项</option></select>';
	this.typeSelect = jQuery(this.typeSelect).appendTo($(this.mainContainer).find('.VOTE_TYPE'));
	this.addBtn = '<a href="#" class="easyui-linkbutton" plain="false" iconCls="icon-add">添加选项</a>';
	this.addBtn = jQuery(this.addBtn).appendTo($(this.mainContainer).find('.VOTE_BTN')).click(function(){box.add();});
}
Vote.prototype.add = function(args) {
	var num = this.items.length;
	var isDel = true,vote_item;
	if(typeof(args)=='boolean') isDel = args;
	else if(typeof(args)=='object'){
		vote_item = jQuery.extend({mark:'',name:'',del:true},args);
		isDel = vote_item.del;
	}
	if(num>=26){
		top.jQuery.messager.alert('错误','对不起！<br/><br/>最多允许26个选项！','error');
		return;
	}
	(typeof(isDel)=='undefined'||isDel)
	var box = this;
	var html = '<span class="selectContainer">'
		+ '			<span class="title">选项 '+(typeof(vote_item)!='undefined'?vote_item.mark:String.fromCharCode(num+65))+'：</span>'
		+ '			<input type="hidden" name="'+this.param.mark+'" value="'+(typeof(vote_item)!='undefined'?vote_item.mark:String.fromCharCode(num+65))+'"/>'
		+ '			<input type="text" name="'+this.param.name+'" value="'+(typeof(vote_item)!='undefined'?vote_item.name:'')+'" maxlength="'+this.param.length+'" class="easyui-validatebox" required="true" style="width:100px;"/>'
		+ '			<span class="delSelectSpan">'
		+ ((typeof(isDel)=='undefined'||isDel)?'<a href="#" hidefocus="true">×</a>':'')
		+ '			</span>'
		+ '		</span>';
	var item = jQuery(html).appendTo(this.mainContainer);
	item.find('a').click(function(){box.remove(item);}).end().find(':input').validatebox();
	$('<option value="'+(num+1)+'"'+(this.param.typeDefault==(num+1)?' selected="selected"':'')+'>'+(num==0?'单':Vote.chineseNum(num+1))+' 选</option>').appendTo(this.typeSelect);
	this.items.push(item);
}
Vote.prototype.remove = function(mark) {
	var box = this;
	var num = this.items.length;
	var array = [];
	for(var i=0,n=0;i<num;i++){
		if(this.items[i]==mark){
			this.items[i].remove();
			this.typeSelect.find('option:last').remove();
		}else{
			this.items[i].find('.title').text('选项 '+String.fromCharCode(n+65)+'：').end().find(':hidden').val(String.fromCharCode(n+65));
			array[n]=this.items[i];
			n++;
		}
	}
	this.items = array;
}
Vote.prototype.removeAll = function() {
	$(this.mainContainer).find('.selectContainer').remove().end().find('select option:gt(0)').remove();
	this.items = [];
}
Vote.chineseNum = function(numstr){
	numArray='零,一,二,三,四,五,六,七,八,九,十'.split(',');
	decimalArray='個,十,百,千,萬,十,百,千,億,十,百,千,兆'.split(',');
	tmpstr = new String();
	for(counti=0;counti<numstr.toString().length;counti++){
		decimalPlace=numstr.toString().length-counti-1;
		if(!(decimalPlace==2  && numstr.toString().charAt(counti)!=1 && numstr.toString().length==2) &&  numstr.toString().charAt(counti)!=0){
			tmpstr+=numArray[numstr.toString().charAt(counti)];
		}
		if(decimalPlace>0 ){
			tmpstr+=decimalArray[decimalPlace];
		}
	}
	return tmpstr;
}