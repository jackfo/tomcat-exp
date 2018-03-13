<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/include/include.jsp"%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>新增</title>
	<style type="text/css">
		body{padding:10px;background:#fafafa;}
		.disabled{width:133px;height:19px;height:21px\9;background:#EBEBE4;border:1px solid #7F9DB9;}
		.newForm th{width:80px;height:30px;line-height:30px;font-size:9pt;font-weight:normal;}
		.newForm td{height:30px;line-height:30px;font-size:9pt;}
		.dataColumns{table-layout:fixed;width:100%;border-left:1px solid #ccc;border-top:1px solid #ccc;}
		.dataColumns td{margin:0px;padding:2px;padding-bottom:0px;height:18px;line-height:18px;height:27px\9;line-height:27px\9;border-right:1px solid #ccc;border-bottom:1px solid #ccc;}
		.dataColumns td a{margin:0px;padding:0px;margin-top:2px;margin-top:1px\9;display:inline-block;width:20px;height:20px;line-height:20px;overflow:hidden;border:1px solid #fafafa;}
		.dataColumns td a:hover{border-color:#ccc;}
		.moveUp{background:url(${path}/js/easyui/themes/default/images/accordion_collapse.png) no-repeat 2px 2px;}
		.moveDown{background:url(${path}/js/easyui/themes/default/images/accordion_expand.png) no-repeat 2px 2px;}
		.insertButton{background:url(${path}/js/easyui/themes/default/images/accordion_collapse.png) no-repeat 2px 2px;}
		.deleteButton{background:url(${path}/js/easyui/themes/icons/no.png) no-repeat 2px 2px;}
	</style>
	<script type="text/javascript">
		function submitForm(el){
			$('#newForm').form('submit',{
				url:'${path}/custom/form!newAdd.qt?chkAccess=${param.chkAccess}&random='+getRandomNum(),
				onSubmit:function(){
					if($('#secondDataColumns :hidden[name=\'attrNum\']').length==0){
						parent.parent.jQuery.messager.alert('错误', '对不起！<br/><br/>没有列记录，无法保存！', 'error');
						return false;
					}
					var b = $(this).form('validate');
					if(b) $(el).linkbutton({disabled:true});
					return b;
				},
				success:function(data){
					$(el).linkbutton({disabled:false});
					try{
						var obj = eval(data);
						if(obj.b){
							if(parent&&parent.parent&&parent.parent.win) parent.parent.win.refreshParent();
						}else parent.parent.jQuery.messager.alert('错误','保存失败！<br/><br/>'+obj.desc,'error');
					}catch(e){parent.parent.jQuery.messager.alert('错误',e.message+'<br/><br/>保存失败！','error');}
				},
				onLoadError:function(e){
					$(el).linkbutton({disabled:false});
					parent.parent.jQuery.messager.alert('错误',e.message+'<br/><br/>保存失败！','error');
				}
			});
		}
		function reset(){
			newForm.reset();
		}
		$.extend($.fn.validatebox.defaults.rules, {
			existForLocal:{
				validator:function(value, param, el) {
					value = jQuery.trim(value);
					$(el).val(value);
					var b = /^[a-zA-Z][\w]*$/.test(value);
					if(!b)return false;
					if(value.toUpperCase()=='ID'||value.toUpperCase()=='MOBILE')return false;
					var els = $(el.parentNode.parentNode.parentNode).find(':text[name="'+$(el).attr('name')+'"]');
					var l = els.length;
					var result = 0;
					for(var i=0;i<l;i++){
						if($(els[i]).val().toUpperCase()==value.toUpperCase()){
							result++;
							if(1<result) return false;
						}
					}
					return true;
				},message:'名称只能是字母、数字、“_”且不能重复，第一个字符必须是字母，不区分大小写'
			}
		});
		function insert(el) {
			var myField = document.getElementById('form.sql');
			if(!$(el).find(':input[name="paramMark"]').validatebox('isValid')){
				$(el).find(':input[name="paramMark"]').focus();
				return;
			}
			var value = $(el).find(':input[name="paramMark"]').val();
			if(value=='')return;
			insertAtCursor(myField,'{#'+value.toUpperCase()+'}');
		}
		function formatData(el){
			if($(el).val()!='nomal') $(el.parentNode.parentNode).find(':input[name="paramFormat"]').show();
			else $(el.parentNode.parentNode).find(':input[name="paramFormat"]').hide();
		}
		function move(el,mark){
			var tr = $(el.parentNode.parentNode),next;
			if('up'==mark){
				next = tr.prev();
				if(0<length)next=next[0];
				tr.insertBefore(next);
			}else{
				next = tr.next();
				if(0<length)next=next[0];
				tr.insertAfter(next);
			}
			if(0<tr.prev().length) tr.find('.moveUp').css('visibility','visible');
			else tr.find('.moveUp').css('visibility','hidden');
			if(0<tr.next().length) tr.find('.moveDown').css('visibility','visible');
			else tr.find('.moveDown').css('visibility','hidden');
			
			if(0<next.prev().length) next.find('.moveUp').css('visibility','visible');
			else next.find('.moveUp').css('visibility','hidden');
			if(0<next.next().length) next.find('.moveDown').css('visibility','visible');
			else next.find('.moveDown').css('visibility','hidden');
		}
		function testSM(){
			var connId = $(document.getElementById('form.conn.id')).find('option:selected').val();
			var mark = document.getElementById('form.name');
			var sql = document.getElementById('form.sql');
			var keyEl = $(':input[name="paramMark"]');
			var valueEl = $(':input[name="paramNomal"]');
			if(!$(mark).validatebox('isValid')){
				$(mark).focus();
				return;
			}
			if(!$(sql).validatebox('isValid')){
				$(sql).focus();
				return;
			}
			var value = "sql="+sql.value+"&connId="+connId+"&mark="+mark.value;
			if(0<keyEl.length){
				var b = false;
				keyEl.each(function(i,obj){
					if(!$(obj).validatebox('isValid')){
						obj.focus();
						b = true;
						return false;
					}else {
						value += '&key='+encodeURIComponent($(obj).val())
							+'&value='+encodeURIComponent(valueEl[i].value);
					}
				});
				if(b){
					$('#firstPanel').show();
					$('#secondPanel').hide();
					return;
				}
			}
			jQuery.ajax({
				url:'${path}/custom/form!testSql.qt?chkAccess=${param.chkAccess}&random='+getRandomNum(),
				type:'POST',
				data:value,
				dataType:'json',
				success:function(obj){
					if(obj.b){
						//if(parent&&parent.parent&&parent.parent.win) parent.parent.win.refreshParent();
						parent.parent.jQuery.messager.alert('提示','SQL语句测试成功！<br/><br/>'+obj.desc,'info');
						if(obj.columns) callback(obj.columns);
					}else parent.parent.jQuery.messager.alert('错误','SQL语句测试失败！<br/><br/>'+obj.desc,'error');
				},
				error:function(request, status, errorThrown){
					 parent.parent.jQuery.messager.alert('错误','用户没有权限或登录超时！','error');
				}
			});
		}
		function addParam(){
			var content = $('#dataColumns');
			html = '<tr>'
				 + '	<td>'
				 + '		<input type="text" name="paramLabel" maxlength="50" class="easyui-validatebox" style="width:100%" required="true"/>'
				 + '	</td>'
				 + '	<td>'
				 + '		<input type="text" name="paramMark" maxlength="50" class="easyui-validatebox" validType="existForLocal" required="true" style="width:100%"/>'
				 + '	</td>'
				 + '	<td>'
				 + '		<select name="paramType" onchange="formatData(this)" style="width:100%">'
				 + '			<option value="nomal">不做处理</option>'
				 + '			<option value="date">日期格式化</option>'
				 + '		</select>'
				 + '	</td>'
				 + '	<td>'
				 + '		<input type="text" name="paramFormat" maxlength="100" class="easyui-validatebox" style="width:100%;display:none;"/>'
				 + '	</td>'
				 + '	<td>'
				 + '		<input type="text" name="paramNomal" maxlength="100" class="easyui-validatebox" style="width:100%;"/>'
				 + '	</td>'
				 + '	<td align="center">'
				 + '		<a href="#" class="insertButton" onclick="insert(this.parentNode.parentNode)" style="margin-right:5px;" title="插入SQL语句中"></a>'
				 + '		<a href="#" class="deleteButton" onclick="$(this.parentNode.parentNode).remove()" title="删除"></a>'
				 + '	</td>'
				 + '</tr>';
			content.append(html).find('.easyui-validatebox').validatebox();
		}
		function callback(array){
			var content = $('#secondDataColumns').empty();
			var l = array.length;
			for(var i=0;i<l;i++){
				var obj = array[i];
				html = '<tr>'
					 + '	<td>'
					 + '		<input type="hidden" name="attrNum" value="'+obj.num+'"/>'
					 + '		<input type="hidden" name="attrAlias" value="'+obj.label.toUpperCase()+'"/>'
					 + '		<input type="text" name="attrLabel" value="'+obj.label+'" maxlength="50" class="easyui-validatebox" style="width:100%" required="true"/>'
					 + '	</td>'
					 + '	<td>'
					 + '		<input type="text" name="attrName" value="'+obj.label+'" maxlength="50" class="easyui-validatebox" validType="existForLocal" required="true" style="width:100%"/>'
					 + '	</td>'
					 + '	<td>'
					 + '		<select name="attrClazz" style="width:100%">'
					 + '			<optgroup label="基础数据类型" style="background:#dadada;"></optgroup>'
					 + '			<option value="java.sql.Date"'+('java.sql.Date'==obj.clazz?' selected="selected"':'')+'>日期</option>'
					 + '			<option value="java.sql.Time"'+('java.sql.Time'==obj.clazz?' selected="selected"':'')+'>时间</option>'
					 + '			<option value="java.sql.Timestamp"'+('java.sql.Timestamp'==obj.clazz?' selected="selected"':'')+'>日期时间</option>'
					 + '			<option value="java.lang.String"'+('java.lang.String'==obj.clazz?' selected="selected"':'')+'>字符串</option>'
					 + '			<option value="java.lang.Integer"'+('java.lang.Integer'==obj.clazz?' selected="selected"':'')+'>整数</option>'
					 + '			<option value="java.lang.Long"'+('java.lang.Long'==obj.clazz?' selected="selected"':'')+'>长整数</option>'
					 + '			<option value="java.lang.Float"'+('java.lang.Float'==obj.clazz?' selected="selected"':'')+'>单精度浮点数</option>'
					 + '			<option value="java.lang.Double"'+('java.lang.Double'==obj.clazz?' selected="selected"':'')+'>双精度浮点数</option><c:if test="${not empty forms and false}">'
					 + '			<optgroup label="对象数据类型" style="background:#dadada;"></optgroup><c:forEach var="item" items="${forms}">'
					 + '			<option value="#${item.name}">${item.label}</option></c:forEach></c:if>'
					 + '		</select>'
					 + '	</td>'
					 + '	<td>'
					 + '		<input type="text" name="attrLength" value="'+obj.size+'" maxlength="6" class="easyui-validatebox" validType="number" style="width:100%;'+('java.lang.String'==obj.clazz?'':'display:none;')+'"/>'
					 + '	</td>'
					 + '	<td>'
					 + '		<input type="text" name="attrNomal" maxlength="100" style="width:100%;"/>'
					 + '	</td>'
					 + '	<td>'
					 + '		<input type="hidden" name="attrRequired" value="'+(i<1?'1':'0')+'"/>'
					 + '		<input type="checkbox" name="attrRequired_checkbox" onclick="return checkNum(this,1)" value="1"'+(i<1?' checked="checked"':'')+'/>'
					 + '	</td>'
					 + '	<td>'
					 + '		<input type="hidden" name="attrUnique" value="0"/>'
					 + '		<input type="checkbox" name="attrUnique_checkbox" onclick="return checkNum(this,0,1)" value="1"/>'
					 + '	</td>'
					 + '	<td>'
					 + '		<input type="hidden" name="attrQuery" value="'+(i<3?'1':'0')+'"/>'
					 + '		<input type="checkbox" name="attrQuery_checkbox" onclick="return checkNum(this,1,5)" value="1"'+(i<3?' checked="checked"':'')+'/>'
					 + '	</td>'
					 + '	<td>'
					 + '		<input type="hidden" name="attrList" value="'+(i<3?'1':'0')+'"/>'
					 + '		<input type="checkbox" name="attrList_checkbox" onclick="return checkNum(this,1,5)" value="1"'+(i<3?' checked="checked"':'')+'/>'
					 + '	</td>'
					 + '	<td>'
					 + '		<input type="hidden" name="attrMobile" value="'+(i<1?'1':'0')+'"/>'
					 + '		<input type="checkbox" name="attrMobile_checkbox" onclick="return checkNum(this,0,1)" value="1"'+(i<1?' checked="checked"':'')+'/>'
					 + '	</td>'
					 + '	<td>'
					 + '		<input type="text" name="attrFormat" maxlength="100" style="width:100%;"/>'
					 + '	</td>'
					 + '	<td align="center">'
					 + '		<a href="#" class="moveUp" onclick="move(this,\'up\')"'+(i==0?' style="visibility:hidden;"':'')+'></a>'
					 + '		<a href="#" class="moveDown" onclick="move(this,\'down\')"'+(i==l-1?' style="visibility:hidden;"':'')+'></a>'
					 + '		<a href="#" class="deleteButton" onclick="$(this.parentNode.parentNode).remove()"></a>'
					 + '	</td>'
					 + '</tr>';
				content.append(html).find('.easyui-validatebox').validatebox();
			}
		}
		function goTo(str){
			if(str == 'next'){
			/*
				var b = false;
				$('#firstPanel .easyui-validatebox').each(function(i,obj){
					if(!b&&!$(obj).validatebox('isValid')){
						obj.focus();
						b = true;
					}else $(obj).validatebox('isValid');
				});*/
				if($('#newForm').form('validate')){
					$('#secondPanel').show();
					$('#firstPanel').hide();
				}
			}else if(str == 'prev'){
				$('#secondPanel').hide();
				$('#firstPanel').show();
			}
		}
	</script>
	</head>
	<body>
		<form id="newForm" name="newForm" method="post">
			<input type="hidden" name="chkAccess" value="${param.chkAccess }">
			<input type="hidden" name="form.type" value="2">
			<table class="newForm" style="width:100%;table-layout:fixed;" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<th>别名：</th>
					<td>
						<input type="text" id="form.label" name="form.label" class="easyui-validatebox" required="true" maxlength="50" style="width:150px"/>
					</td>
					<th>短信标识：</th>
					<td>
						<input type="text" id="form.name" name="form.name" class="easyui-validatebox" validType="exist['${path }/custom/form!isExist.qt?type=2&chkAccess=${param.chkAccess}','','^[A-Z]+$']" required="true" maxlength="5" style="width:150px"/>
					</td>
					<th>连接：</th>
					<td>
						<select id="form.conn.id" name="form.conn.id" style="width:150px;">
							<option value="0">系统数据源</option><c:forEach var="item" items="${conns}">
							<option value="${item.id }"><c:out value="${item.name}"/></option></c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<th valign="top">SQL：</th>
					<td colspan="5" style="height:1%">
						<textarea rows="3" id="form.sql" name="form.sql" style="width:80%;" class="easyui-validatebox" validType="length[1,2000]" required="true"></textarea>
					</td>
				</tr>
				<tr>
					<td colspan="6" style="height:1%;padding:0px 20px;">
					<div id="firstPanel" style="position:relative;">
						<div style="position:absolute;width:100px;left:50%;margin-top:8px;margin-left:-50px;text-align:center;letter-spacing:8px;color:#454545">
							查询条件
						</div>
						<a href="#" onclick="testSM()" class="easyui-linkbutton" plain="true" iconCls="icon-reload" style="margin-left:20px">Test</a>
						<a href="#" onclick="addParam()" class="easyui-linkbutton" plain="true" iconCls="icon-add" style="margin-left:5px">添加</a>
						<a href="#" onclick="$('#dataColumns').empty()" class="easyui-linkbutton" plain="true" iconCls="icon-no" style="margin-left:5px;margin-right:20px;">清空</a>
						<a href="#" onclick="insertAtCursor(document.getElementById('form.sql'),'{#MOBILE}')" style="margin-right:5px;" title="插入SQL语句中">插入上行手机号码</a>
						<hr/>
						<table class="dataColumns" border="0" cellpadding="0" cellspacing="0">
							<thead>
								<tr>
									<td align="center">名称</td>
									<td align="center">标识</td>
									<td align="center" width="108">类型</td>
									<td align="center" width="100">格式化</td>
									<td align="center" width="100">默认值</td>
									<td align="center" width="70">&nbsp;</td>
								</tr>
							</thead>
							<tbody id="dataColumns"></tbody>
						</table>
						<hr/>
						<table width="100%" border="0" cellpadding="0" cellspacing="0">
							<tr>
								<td style="padding-left:20px">
									查询结果含有多条数据处理方式：
									<select id="form.repeatType" name="form.repeatType">
										<option value="1">取第一条</option>
										<option value="2">分条发送</option>
									</select>
								</td>
							</tr>
				    		<tr>
				    			<td style="height:1%;line-height:20px;padding-top:5px;">
				    				<ul>
				    					<li>别名为任意字符；短信标识只能是大写字母、且不能重复，用于标识上行短信；系统数据源为当前系统的数据库连接</li>
				    					<li>查询条件中的“标识”用于标识SQL语句中的查询条件，以“{#}”包括，不能是MOBILE</li>
				    					<li>查询条件中的“类型”选为“日期格式化”时，在格式化中必须输入“yyyy-MM-dd”等类似日期格式字符串</li>
				    					<li>查询条件中的“默认值”为测试SQL语句正确性时使用</li>
				    					<li style="color:#f00;">书写完整后可以单击“Test”按钮生成上行短信格式</li>
				    					<li style="color:#f00;">保存成功后会自动创建相应的短信模板分类，请给相应的分类添加短信模板，否则无法自动回复</li>
				    					<li style="color:#f00;">SQL语句中尽量不使用“*”全查询，以避免SQL所访问的表发生变动后造成数据错误</li>
				    				</ul>
				    			</td>
				    		</tr>
				    		<tr>
				    			<td align="center">
				    				<a href="#" onclick="goTo('next')" class="easyui-linkbutton" plain="false" iconCls="icon-redo" style="margin-right:10px">下一步</a>
			    					<a href="javascript:reset();$('#secondPanel').hide();$('#firstPanel').show()" class="easyui-linkbutton" plain="false" iconCls="icon-remove">重置</a>
				    			</td>
				    		</tr>
						</table>
					</div>
					<div id="secondPanel" style="position:relative;display:none;">
						<div style="position:absolute;width:100px;left:50%;margin-top:8px;margin-left:-50px;text-align:center;letter-spacing:8px;color:#454545">列记录</div>
						<a href="#" onclick="testSM()" class="easyui-linkbutton" plain="true" iconCls="icon-reload" style="margin-left:20px">Test</a>
						<a href="#" onclick="$('#secondDataColumns').empty()" class="easyui-linkbutton" plain="true" iconCls="icon-no" style="margin-left:5px">清空</a>
						<hr/>
						<table class="dataColumns" border="0" cellpadding="0" cellspacing="0">
							<thead>
								<tr>
									<td align="center">别名</td>
									<td align="center">列名</td>
									<td align="center" width="108">类型</td>
									<td align="center" width="100">长度</td>
									<td align="center" width="100">默认值</td>
									<td align="center" width="26"><u>R</u></td>
									<td align="center" width="26"><u>U</u></td>
									<td align="center" width="26"><u>Q</u></td>
									<td align="center" width="26"><u>L</u></td>
									<td align="center" width="26"><u>M</u></td>
									<td align="center" width="100">格式化</td>
									<td align="center" width="80">&nbsp;</td>
								</tr>
							</thead>
							<tbody id="secondDataColumns"></tbody>
						</table>
						<hr/>
						<ul>
	    					<li>别名为任意字符；短信标识只能是大写字母、且不能重复，用于标识上行短信；系统数据源为当前系统的数据库连接</li>
	    					<li>列名不区分大小写、不能重复、不能等于“id”、“mobile”、“isSent”和“insertDate”且只能是字母、数字、“_”，第一个字符必须是字母</li>
	    					<li>列为时间类型时，默认值可以为“now”即当前时间</li>
	    					<li>格式化为当该列输出时进行格式化，日期可以是“yyyy-MM-dd”等标记，数字可以为“*0.00”等标记</li>
	    					<li>【<u>Q</u>】在主页做查询条件，【<u>L</u>】在列表中显示，【<u>Q</u>】、【<u>L</u>】各自同时最多只能有5个且至少有1个</li>
	    					<li>【<u>R</u>】不能为空，【<u>U</u>】唯一键且只能有1个</li>
	    					<li>【<u>M</u>】标记该列为手机号码，当用于短信发送必须有1个，否则短信无法发送</li>
	    					<li style="color:#f00;">SQL语句中尽量不使用“*”全查询，以避免SQL所访问的表发生变动后造成数据错误</li>
	    				</ul>
	    				<center>
	    					<a href="#" onclick="goTo('prev')" class="easyui-linkbutton" plain="false" iconCls="icon-undo" style="margin-right:10px">上一步</a>
	    					<a href="#" onclick="submitForm(this);" class="easyui-linkbutton" plain="false" iconCls="icon-save" style="margin-right:10px">保存</a>
	    					<a href="javascript:reset();$('#secondPanel').hide();$('#firstPanel').show()" class="easyui-linkbutton" plain="false" iconCls="icon-remove">重置</a>
	    				</center>
					</div>
					</td>
				</tr>
	    	</table>
	    </form>
	</body>
</html>