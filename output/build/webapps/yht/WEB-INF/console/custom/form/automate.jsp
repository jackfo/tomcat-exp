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
		.deleteButton{background:url(${path}/js/easyui/themes/icons/no.png) no-repeat 2px 2px;}
	</style>
	<script type="text/javascript">
		function submitForm(el){
			$('#newForm').form('submit',{
				url:'${path}/custom/form!newAdd.qt?chkAccess=${param.chkAccess}&random='+getRandomNum(),
				onSubmit:function(){
					var b = $(this).form('validate');
					if(b&&$(':hidden[name="attrNum"]').length==0){
						parent.parent.jQuery.messager.alert('错误', '对不起！<br/><br/>没有列记录，无法保存！', 'error');
						return false;
					}
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
					if(value.toUpperCase()=='ID'||value.toUpperCase()=='INSERTDATE'||value.toUpperCase()=='ISSENT')return false;
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
				},message:'名称只能是字母、数字、“_”且不能重复，第一个字符必须是字母'
			}
		});
		function checkNum(el,min,max){
			var name = $(el).attr('name');
			var objs = $(el.parentNode.parentNode.parentNode).find(':checkbox[name="'+$(el).attr('name')+'"]:checked');
			if((typeof(max)=='number'&&typeof(min)=='number'&&objs.length<=max&&objs.length>=min)||(typeof(max)!='number'&&typeof(min)=='number'&&objs.length>=min)){
				if($(el).is(':checked')) $(el.parentNode).find(':hidden[name="'+name.replace('_checkbox','')+'"]').val(1);
				else $(el.parentNode).find(':hidden[name="'+name.replace('_checkbox','')+'"]').val(0)
				return true;
			}else{
				return false;
			}
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
		function testConn(){
			var connId = jQuery.trim(document.getElementById('form.conn.id').value);
			var sql = jQuery.trim(document.getElementById('form.sql').value).replace(/[\n\r\t]/ig,' ');
			if(''==sql)return;
			document.getElementById('form.sql').value=sql;
			
			var param = 'connId='+encodeURIComponent(connId)+'&';
			param += 'sql='+encodeURIComponent(sql)+'&';
			
			jQuery.ajax({
				async: true,
				type: "POST",
				url: '${path}/custom/form!test.qt?chkAccess=${param.chkAccess}&random='+getRandomNum(),
				data: param,
				dataType: "json",
				success: function(obj){
					exceTest = true;
					try{
						if(obj.b){
							callback(obj.columns);
						}else parent.jQuery.messager.alert('错误',obj.desc,'error');
					}catch(e){alert(e);}
				}
			});
		}
		function callback(array){
			var content = $('#dataColumns').empty();
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
					 + '	<td align="center">'
					 + '		<a href="#" class="moveUp" onclick="move(this,\'up\')"'+(i==0?' style="visibility:hidden;"':'')+'></a>'
					 + '		<a href="#" class="moveDown" onclick="move(this,\'down\')"'+(i==l-1?' style="visibility:hidden;"':'')+'></a>'
					 + '		<a href="#" class="deleteButton" onclick="$(this.parentNode.parentNode).remove()"></a>'
					 + '	</td>'
					 + '</tr>';
				content.append(html).find('.easyui-validatebox').validatebox();
			}
		}
	</script>
	</head>
	<body>
		<form id="newForm" name="newForm" method="post">
			<input type="hidden" name="chkAccess" value="${param.chkAccess }">
			<input type="hidden" name="form.type" value="1">
			<table id="step_1" class="newForm" style="width:100%;table-layout:fixed;" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<th>别名：</th>
					<td>
						<input type="text" id="form.label" name="form.label" class="easyui-validatebox" required="true" maxlength="50" style="width:150px"/>
					</td>
					<th>名称：</th>
					<td>
						<input type="text" id="form.name" name="form.name" class="easyui-validatebox" validType="exist['${path }/custom/form!isExist.qt?chkAccess=${param.chkAccess}','','^[A-Z][\\w]*$']" required="true" maxlength="50" style="width:150px"/>
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
					<td colspan="6" style="position:relative;height:1%;padding-left:20px;padding-right:20px;">
						<div style="position:absolute;width:100px;left:50%;margin-top:8px;margin-left:-50px;text-align:center;letter-spacing:8px;color:#454545">列记录</div>
						<a href="#" onclick="testConn()" class="easyui-linkbutton" plain="true" iconCls="icon-reload" style="margin-left:20px">Test</a>
						<a href="#" onclick="$('#dataColumns').empty()" class="easyui-linkbutton" plain="true" iconCls="icon-no" style="margin-left:5px">清空</a>
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
									<td align="center" width="80">&nbsp;</td>
								</tr>
							</thead>
							<tbody id="dataColumns"></tbody>
						</table>
						<hr/>
					</td>
				</tr>
	    		<tr>
	    			<td colspan="6" style="height:1%;line-height:20px;padding-top:5px;">
	    				<ul>
	    					<li>别名为任意字符</li>
	    					<li>名称只能是字母、数字、“_”且不能重复，第一个字符必须是大写字母</li>
	    					<li>系统数据源为当前系统的数据库连接</li>
	    					<li>列名不区分大小写、不能重复、不能等于“id”、“isSent”和“insertDate”且只能是字母、数字、“_”，第一个字符必须是字母</li>
	    					<li>列为时间类型时，默认值可以为“now”即当前时间</li>
	    					<li>【<u>Q</u>】在主页做查询条件，【<u>L</u>】在列表中显示，【<u>Q</u>】、【<u>L</u>】各自同时最多只能有5个且至少有1个</li>
	    					<li>【<u>R</u>】不能为空，【<u>U</u>】唯一键且只能有1个</li>
	    					<li>【<u>M</u>】标记该列为手机号码，当用于短信发送必须有1个，否则短信无法发送</li>
	    					<li style="color:#f00;">SQL语句中尽量不使用“*”全查询，以避免SQL所访问的表发生变动后造成数据错误</li>
	    				</ul>
	    			</td>
	    		</tr>
	    		<tr>
	    			<td colspan="6" align="center" height="40" valign="bottom">
	    				<a href="#" onclick="if($('#newForm').form('validate')){if($(':hidden[name=\'attrNum\']').length==0){parent.parent.jQuery.messager.alert('错误', '对不起！<br/><br/>没有列记录，无法保存！', 'error');}else{$('#step_1').hide();$('#step_2').show();}}" class="easyui-linkbutton" plain="false" iconCls="icon-redo" style="margin-right:10px">下一步</a>
	    				<!-- <a href="javascript:reset();" class="easyui-linkbutton" plain="false" iconCls="icon-remove">重置</a> -->
	    			</td>
	    		</tr>
	    	</table>
	    	<table id="step_2" class="newForm" style="width:100%;table-layout:fixed;display:none;" border="0" cellpadding="0" cellspacing="0">
	    		<tr>
	    			<th>同步时间：</th>
					<td>
						<input type="text" id="form.syncDate" name="form.syncDate" class="easyui-validatebox" validType="decimals['格式错误，请重新输入！','^-1|[0-3][1-9][0-6][0-9]$']" maxlength="4" style="width:150px"/>
					</td>
					<th>同步类型：</th>
					<td>
						<select id="form.syncType" name="form.syncType" style="width:150px;">
							<option value="1">增量同步</option>
							<option value="2">覆盖同步</option>
						</select>
					</td>
					<th>发送时间：</th>
					<td>
						<input type="text" id="form.sendDate" name="form.sendDate" class="easyui-validatebox" validType="decimals['只能输入正整数及0','^[0-9]+$']" maxlength="2" style="width:150px"/>
					</td>
	    		</tr>
	    		<tr>
	    			<td colspan="6" style="height:1%;line-height:20px;padding-top:5px;">
	    				<ul>
	    					<li>同步时间前两位表示日即每月的几号同步，如果为-1表示每天同步，不满两位补0；后面两位表示时，如果为-1表示每小时，不满两位补0</li>
	    					<li>同步类型分增量同步（保留原数据同步）和覆盖同步（清空表后同步）</li>
	    					<li>发送时间表示同步后多久发送短信，如果为0表示同步后立即发送，单位：小时；请保存后添加短信模板，否则无法自动发送；如果不填写表示同步不发送短信！</li>
	    				</ul>
	    			</td>
	    		</tr>
	    		<tr>
	    			<td colspan="6" align="center" height="40" valign="bottom">
	    				<a href="#" onclick="$('#step_2').hide();$('#step_1').show();" class="easyui-linkbutton" plain="false" iconCls="icon-undo" style="margin-right:10px">上一步</a>
	    				<a href="#" onclick="submitForm(this);" class="easyui-linkbutton" plain="false" iconCls="icon-save" style="margin-right:10px">保存</a>
	    				<!-- <a href="javascript:reset();" class="easyui-linkbutton" plain="false" iconCls="icon-remove">重置</a> -->
	    			</td>
	    		</tr>
	    	</table>
	    </form>
	</body>
</html>