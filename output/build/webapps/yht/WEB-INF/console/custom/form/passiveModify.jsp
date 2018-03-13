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
		.disabled{width:133px;background:#EBEBE4;border:1px solid #7F9DB9;}
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
				url:'${path}/custom/form!modify.qt?chkAccess=${param.chkAccess}&random='+getRandomNum(),
				onSubmit:function(){
					var b = $(this).form('validate');
					if(b) $(el).linkbutton({disabled:true});
					return b;
				},
				success:function(data){
					$(el).linkbutton({disabled:false});
					try{
						var obj = eval(data);
						if(obj.b){
							if(parent&&parent.win) parent.win.refreshParent();
						}else parent.jQuery.messager.alert('错误','保存失败！<br/><br/>'+obj.desc,'error');
					}catch(e){parent.jQuery.messager.alert('错误',e.message+'<br/><br/>保存失败！','error');}
				},
				onLoadError:function(e){
					$(el).linkbutton({disabled:false});
					parent.jQuery.messager.alert('错误',e.message+'<br/><br/>保存失败！','error');
				}
			});
		}
		function reset(){
			newForm.reset();
		}
		function formatData(el){
			if($(el).val()!='nomal') $(el.parentNode.parentNode).find(':input[desc="paramFormat"]').show();
			else $(el.parentNode.parentNode).find(':input[desc="paramFormat"]').hide();
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
						parent.jQuery.messager.alert('提示','SQL语句测试成功！<br/><br/>'+obj.desc,'info');
					}else parent.jQuery.messager.alert('错误','SQL语句测试失败！<br/><br/>'+obj.desc,'error');
				},
				error:function(request, status, errorThrown){
					 parent.jQuery.messager.alert('错误','用户没有权限或登录超时！','error');
				}
			});
		}
		function goTo(str){
			if(str == 'next'){
				if($('#newForm').form('validate')){
					$('#secondPanel').show();
					$('#firstPanel').hide();
				}
			}else if(str == 'prev'){
				$('#secondPanel').hide();
				$('#firstPanel').show();
			}
		}
		function checkNum(el,min,max){
			var name = $(el).attr('name');
			var objs = $(el.parentNode.parentNode.parentNode).find(':checkbox[name="'+$(el).attr('name')+'"]:checked');
			if((typeof(max)=='number'&&typeof(min)=='number'&&objs.length<=max&&objs.length>=min)||(typeof(max)!='number'&&typeof(min)=='number'&&objs.length>=min)){
				if($(el).is(':checked')) $(el.parentNode).find(':hidden[desc="'+name.replace('_checkbox','')+'"]').val(1);
				else $(el.parentNode).find(':hidden[desc="'+name.replace('_checkbox','')+'"]').val(0)
				return true;
			}else{
				return false;
			}
		}
	</script>
	</head>
	<body>
		<form id="newForm" name="newForm" method="post">
			<input type="hidden" name="chkAccess" value="${param.chkAccess }">
			<input type="hidden" name="form.id" value="${item.id }">
			<table class="newForm" style="width:100%;table-layout:fixed;" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<th>别名：</th>
					<td>
						<input type="text" id="form.label" name="form.label" value="${item.label }" class="easyui-validatebox" required="true" maxlength="50" style="width:150px"/>
					</td>
					<th>短信标识：</th>
					<td>
						<input type="text" id="form.name" name="form.name" value="${item.name }" class="easyui-validatebox disabled" validType="exist['${path }/custom/form!isExist.qt?type=2&chkAccess=${param.chkAccess}','${item.name }','^[A-Z]+$']" required="true" maxlength="5" style="width:150px" readonly="readonly"/>
					</td>
					<th>连接：</th>
					<td>
						<select id="form.conn.id" name="form.conn.id" style="width:150px;">
							<option value="0"<c:if test="${item.conn.id eq 0 }"> selected="selected"</c:if>>系统数据源</option><c:forEach var="conn" items="${conns}">
							<option value="${conn.id }"<c:if test="${item.conn.id eq conn.id }"> selected="selected"</c:if>><c:out value="${conn.name}"/></option></c:forEach>
						</select>
					</td>
				</tr>
				<tr>
					<th valign="top">SQL：</th>
					<td colspan="5" style="height:1%">
						<textarea rows="3" id="form.sql" name="form.sql" style="width:80%;" class="easyui-validatebox disabled" validType="length[1,2000]" required="true" readonly="readonly"><c:out value="${item.sql}"/></textarea>
					</td>
				</tr>
				<tr>
					<td colspan="6" style="height:1%;padding:0px 20px;">
					<div id="firstPanel" style="position:relative;">
						<div style="position:absolute;width:100px;left:50%;margin-top:8px;margin-left:-50px;text-align:center;letter-spacing:8px;color:#454545">
							查询条件
						</div>
						<a href="#" onclick="testSM()" class="easyui-linkbutton" plain="true" iconCls="icon-reload" style="margin-left:20px">Test</a>
						<hr/>
						<table class="dataColumns" border="0" cellpadding="0" cellspacing="0">
							<thead>
								<tr>
									<td align="center">名称</td>
									<td align="center">标识</td>
									<td align="center" width="108">类型</td>
									<td align="center" width="100">格式化</td>
									<td align="center" width="100">默认值</td>
								</tr>
							</thead>
							<tbody id="dataColumns"><c:catch><c:forEach var="temp" items="${item.params}">
								<tr>
									<td>
										<input type="text" name="paramLabel_${temp.id }" value="${temp.label }" maxlength="50" class="easyui-validatebox" style="width:100%" required="true"/>
									</td>
									<td>
										<input type="text" name="paramMark_${temp.id }" value="${temp.mark }" maxlength="50" class="easyui-validatebox disabled" validType="existForLocal" required="true" style="width:100%" readonly="readonly"/>
									</td>
									<td>
										<select name="paramType_${temp.id }" onchange="formatData(this)" style="width:100%">
											<option value="nomal"<c:if test="${temp.type eq 'nomal' }"> selected="selected"</c:if>>不做处理</option>
											<option value="date"<c:if test="${temp.type eq 'date' }"> selected="selected"</c:if>>日期格式化</option>
										</select>
									</td>
									<td>
										<input type="text" desc="paramFormat" name="paramFormat_${temp.id }" value="${temp.format }" maxlength="100" class="easyui-validatebox" style="width:100%;<c:if test="${temp.type ne 'date' }">display:none;</c:if>"/>
									</td>
									<td>
										<input type="text" name="paramNomal_${temp.id }" value="${temp.nomal }" maxlength="100" class="easyui-validatebox" style="width:100%;"/>
									</td>
								</tr></c:forEach></c:catch>
							</tbody>
						</table>
						<hr/>
						<table width="100%" border="0" cellpadding="0" cellspacing="0">
							<tr>
								<td style="padding-left:20px">
									查询结果含有多条数据处理方式：
									<select id="form.repeatType" name="form.repeatType">
										<option value="1"<c:if test="${item.repeatType eq 1 }"> selected="selected"</c:if>>取第一条</option>
										<option value="2"<c:if test="${item.repeatType eq 2 }"> selected="selected"</c:if>>分条发送</option>
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
								</tr>
							</thead>
							<tbody id="secondDataColumns"><c:catch><c:forEach var="attr" items="${item.attrs}">
								<tr>
									<td>
										<input type="text" name="attrLabel_${attr.id }" value="${attr.label }" maxlength="50" class="easyui-validatebox" style="width:100%" required="true"/>
									</td>
									<td>
										<input type="text" name="attrName" value="${attr.name }" maxlength="50" class="easyui-validatebox disabled" validType="existForLocal" required="true" style="width:100%" readonly="readonly"/>
									</td>
									<td><c:choose><c:when test="${attr.clazz eq 'java.sql.Date'}">
										日期</c:when><c:when test="${attr.clazz eq 'java.sql.Time'}">
										时间</c:when><c:when test="${attr.clazz eq 'java.sql.Timestamp'}">
										日期时间</c:when><c:when test="${attr.clazz eq 'java.lang.String'}">
										字符串</c:when><c:when test="${attr.clazz eq 'java.lang.Integer'}">
										整数</c:when><c:when test="${attr.clazz eq 'java.lang.Long'}">
										长整数</c:when><c:when test="${attr.clazz eq 'java.lang.Float'}">
										单精度浮点数</c:when><c:when test="${attr.clazz eq 'java.lang.Double'}">
										双精度浮点数</c:when></c:choose>
									</td>
									<td>
										<input type="text" name="attrLength" value="${attr.length }" maxlength="6" class="easyui-validatebox disabled" validType="number" style="width:100%;<c:if test="${attr.clazz ne 'java.lang.String' }">display:none;</c:if>" readonly="readonly"/>
									</td>
									<td>
										<input type="text" name="attrNomal_${attr.id }" value="${attr.nomal }" maxlength="100" style="width:100%;"/>
									</td>
									<td>
										<input type="hidden" desc="attrRequired" name="attrRequired_${attr.id }" value="${attr.required }"/>
										<input type="checkbox" name="attrRequired_checkbox" onclick="return checkNum(this,1)" value="1"<c:if test="${attr.required eq 1 }"> checked="checked"</c:if>/>
									</td>
									<td>
										<input type="hidden" desc="attrUnique" name="attrUnique_${attr.id }" value="${attr.unique }"/>
										<input type="checkbox" name="attrUnique_checkbox" onclick="return checkNum(this,0,1)" value="1"<c:if test="${attr.unique eq 1 }"> checked="checked"</c:if>/>
									</td>
									<td>
										<input type="hidden" desc="attrQuery" name="attrQuery_${attr.id }" value="${attr.query }"/>
										<input type="checkbox" name="attrQuery_checkbox" onclick="return checkNum(this,1,5)" value="1"<c:if test="${attr.query eq 1 }"> checked="checked"</c:if>/>
									</td>
									<td>
										<input type="hidden" desc="attrList" name="attrList_${attr.id }" value="${attr.list }"/>
										<input type="checkbox" name="attrList_checkbox" onclick="return checkNum(this,1,5)" value="1"<c:if test="${attr.list eq 1 }"> checked="checked"</c:if>/>
									</td>
									<td>
										<input type="hidden" desc="attrMobile" name="attrMobile_${attr.id }" value="${attr.mobile }"/>
										<input type="checkbox" name="attrMobile_checkbox" onclick="return checkNum(this,0,1)" value="1"<c:if test="${attr.mobile eq 1 }"> checked="checked"</c:if>/>
									</td>
									<td>
										<input type="text" name="attrFormat_${attr.id }" value="${attr.format }" maxlength="100" style="width:100%;"/>
									</td>
								</tr></c:forEach></c:catch>
							</tbody>
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