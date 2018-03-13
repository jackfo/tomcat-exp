<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/include/include.jsp"%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>修改联系人</title>
		<script type="text/javascript" src="${path }/js/sms/validatebox.js"></script>
		<style type="text/css">
			body{padding:10px;background:#fafafa;overflow:hidden;}
			th{width:80px;height:30px;line-height:30px;text-align:right;font-size:9pt;font-weight:normal;}
			td{height:30px;line-height:30px;font-size:9pt;}
		</style>
		<script type="text/javascript">
			jQuery(document).ready(function(){
				$('#groups').combobox({  
					valueField:'id',
					textField:'text',
					multiple:true,
					editable:false,
					panelHeight:180,
					data:[<c:forEach var="group" items="${groups}" varStatus="s"><c:if test="${empty group.type or group.type ne 1 or (group.type eq 1 and fs:isAccess(param.mid,'SHARE')) }"><c:set var="groupId" value=",${group.id},"/>
							{id:'${group.id}',type:'${group.type}',text:'<c:if test="${group.type eq 1}">*</c:if>${group.name}'<c:if test="${fn:contains(itemGroups, groupId)}">,selected:true</c:if>}<c:if test="${not s.last}">,</c:if></c:if></c:forEach>
						],
					formatter:function(row){
						return typeof(row.type)=='string'&&row.type=='1'?'<span style="color:red">[共]</span>'+row.text.replace(/[*]/ig," "):row.text;
					}
				});
			});
			function submitForm(el){
				$('#newForm').form('submit',{
					url:'${path}/base/contacts!modify.qt?random='+getRandomNum(),
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
							}else parent.jQuery.messager.alert('错误','<br/>保存失败！','error');
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
				if(${dateType eq 1 }){
					$('#gl').attr('selected',true);
				}else{
					$('#nl').attr('selected',true);					
				}
			}
			function checkContact(){
				var contactsName = $('input[idName=contactsName]').val();
				var contactsPhone = $('input[idName=contactsPhone]').val();
				if(contactsName && contactsName!='' && contactsPhone && contactsPhone!='' && !(contactsName=='${item.name }' && contactsPhone=='${item.phone }')){
					jQuery.ajax({
						async: false,
						type: "GET",
						url: '${path}/base/contacts!check.qt?contactsName='+encodeURIComponent(contactsName)+'&contactsPhone='+encodeURIComponent(contactsPhone)+'&chkAccess='+encodeURIComponent('${param.chkAccess }')+'&random='+getRandomNum(),
						success: function(data){
							data = eval(data);
							if(data&&data.b){}
							else {
								jQuery.messager.alert('错误',data.desc,'error');
							//	$('input[idName=contactsName]').val('');
							//	$('input[idName=contactsPhone]').val('');
							}
						}
					});
				}
			}
		</script>
	</head>
	<body>
		<form id="newForm" name="newForm" method="post">
			<input type="hidden" name="chkAccess" value="${param.chkAccess }">
			<input type="hidden" name="contacts.id" value="${item.id }">
			<table style="width:100%;table-layout:fixed;" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<th>姓名：</th>
					<td>
						<input type="text" idName="contactsName" id="contacts.name" name="contacts.name" value="${item.name }" class="easyui-validatebox" onblur="checkContact()" required="true" style="width:100%" maxlength="50"/>
					</td>
					<th>编号：</th>
					<td>
						<input type="text" id="contacts.code" name="contacts.code" value="${item.code }" class="easyui-validatebox" style="width:100%" maxlength="50"/>
					</td>
					<td style="width:50px">&nbsp;</td>
				</tr>
				<tr>
					<th>性别：</th>
					<td>
						<input type="radio" id="contacts.sex.1" name="contacts.sex" value="1"<c:if test="${empty item.sex or item.sex eq 1 }"> checked="checked"</c:if> style="cursor:pointer;"/>
						<label for="contacts.sex.1" style="cursor:pointer;">男</label>
						<input type="radio" id="contacts.sex.0" name="contacts.sex" value="0"<c:if test="${item.sex eq 0 }"> checked="checked"</c:if> style="cursor:pointer;"/>
						<label for="contacts.sex.0" style="cursor:pointer;">女</label>
					</td>
					<th>生日：</th>
					<td>
						<select name="dateType" style="width:48px" class="easyui-combobox" panelHeight="auto">
							<option id="gl" value="1"<c:if test="${dateType eq 1 }"> selected="selected"</c:if>>公历</option>
							<option id="nl" value="0"<c:if test="${dateType eq 0 }"> selected="selected"</c:if>>农历</option>
						</select>
						<input id="contacts.birthday" name="contacts.birthday" value="${item.birthday }" type="text"class="easyui-validatebox" methodType="chooseDate{dateFmt:'yyyy-MM-dd'}" style="width:75px" maxlength="50"/>
					</td>
					<td style="width:50px">&nbsp;</td>
	    		</tr>
	    		<tr>
					<th>手机(主)：</th>
					<td>
						<input type="text" idName="contactsPhone" id="contacts.phone" name="contacts.phone" value="${item.phone }" class="easyui-validatebox" validType="mobile" onblur="checkContact()" style="width:100%" maxlength="30"/>
					</td>
					<th>号码(备1)：</th>
					<td>
						<input type="text" id="contacts.phoneBK1" name="contacts.phoneBK1" value="${item.phoneBK1 }" class="easyui-validatebox" style="width:100%" maxlength="30"/>
					</td>
					<td style="width:50px">&nbsp;</td>
				</tr>
				<tr>
					<th>E-mail：</th>
					<td>
						<input type="text" id="contacts.email" name="contacts.email" value="${item.email }" class="easyui-validatebox" style="width:100%" maxlength="30"/>
					</td>
					<th>号码(备2)：</th>
					<td>
						<input type="text" id="contacts.phoneBK2" name="contacts.phoneBK2" value="${item.phoneBK2 }" class="easyui-validatebox" style="width:100%" maxlength="30"/>
					</td>
					<td style="width:50px">&nbsp;</td>
				</tr>
				<tr>
					<th>地址：</th>
					<td colspan="3">
						<input type="text" id="contacts.address" name="contacts.address" value="${item.address }" class="easyui-validatebox" style="width:100%" maxlength="30"/>
					</td>
					<td style="width:50px">&nbsp;</td>
				</tr>
				<tr>
					<th>QQ：</th>
					<td>
						<input type="text" id="contacts.qq" name="contacts.qq" value="${item.qq }" class="easyui-validatebox" style="width:100%" maxlength="30"/>
					</td>
					<th>飞信：</th>
					<td>
						<input type="text" id="contacts.fetion" name="contacts.fetion" value="${item.fetion }" class="easyui-validatebox" style="width:100%" maxlength="30"/>
					</td>
					<td style="width:50px">&nbsp;</td>
				</tr>
				<tr>
					<th>状态：</th>
					<td>
						<input type="checkbox" id="contacts.status" name="contacts.status"<c:if test="${item.status eq 1 }"> checked="checked"</c:if> value="1" style="cursor:pointer;"/>
						<label for="contacts.status" style="cursor:pointer;">不发短信</label>
					</td>
					<th>分组：</th>
					<td>
						<input type="text" id="groups" name="groups" class="easyui-combobox" style="width:127px;*width:126px;">
					</td>
					<td style="width:50px">&nbsp;</td>
				</tr>
	    		<tr>
	    			<td colspan="5" align="center" height="40" valign="bottom">
	    				<a href="#" onclick="submitForm(this);" class="easyui-linkbutton" plain="false" iconCls="icon-save" style="margin-right:10px">保存</a>
	    				<a href="javascript:reset();" class="easyui-linkbutton" plain="false" iconCls="icon-remove">重置</a>
	    			</td>
	    		</tr>
	    	</table>
	    </form>
	</body>
</html>