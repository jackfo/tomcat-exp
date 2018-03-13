<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/include/include.jsp"%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>修改联系人</title>
		<script type="text/javascript" src="${path }/js/sms/validatebox.js"></script>
		<style type="text/css">
			body{padding:10px;background:#fafafa;overflow:hidden;}
			.form_table th{width:80px;height:30px;line-height:30px;text-align:right;font-size:9pt;font-weight:normal;}
			.form_table td{height:30px;line-height:30px;font-size:9pt;}
		</style>
		<script type="text/javascript">
			jQuery(document).ready(function(){
				table=$("#dataList").datagrid({
					width:'100%',
					height:200,
					nowrap: true,
					idField:'id',
					fitColumns:true,
					singleSelect:true,
					columns:[[
						{field:'code',width:80,title:'编号',formatter:function(value,node){
							return '<input type="hidden" name="conId" value="'+node.id+'">'+(typeof(value)!='undefined'?value:"");
						}},
						{field:'name',width:80,title:'名称'},
						{field:'sex',width:40,align:'center',title:'性别',formatter:function(value,node){return typeof(value)=='undefined'||value==1?'男':'女'}},
						{field:'birthday',width:100,title:'生日',formatter:function(value,node){
							if(typeof(value)=='undefined'||9>value.length) return'';
							if(value.substring(0,1)=='0') return value.replace(/^\d/,'农历 ').replace(/([\d]{4})([\d]{2})([\d]{2})/ig,'$1-$2-$3');
							else return value.replace(/^\d/,'公历 ').replace(/([\d]{4})([\d]{2})([\d]{2})/ig,'$1-$2-$3');
						}},
						{field:'phone',width:120,title:'手机 (主)'},
						{field:'status',width:65,title:'状态',formatter:function(value,node){
							return value&&value==1?'<span style="color:red;">不发短信</span>':'';
						}}
					]],
					onHeaderContextMenu: function(e, field){
						e.preventDefault();
						if (!$('#tmenu').length){
							createColumnMenu(table);
						}
						$('#tmenu').menu('show', {
							left:e.pageX,
							top:e.pageY
						});
					}
				});
				//将父窗口中选中的项目设置到当前窗口中
				var rows = parent.table.datagrid('getSelections');
				table.datagrid('loadData', {'total':rows.length,'rows':rows});
				
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
					url:'${path}/base/contacts!mutilModify.qt?random='+getRandomNum(),
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
			}
		</script>
	</head>
	<body>
		<form id="newForm" name="newForm" method="post">
			<input type="hidden" name="chkAccess" value="${param.chkAccess }">
			<input type="hidden" name="currentGid" value="${param.gid }">
			<table id="dataList"></table>
			<table class="form_table" style="width:100%;table-layout:fixed;" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td></td>
					<th>操作类型：</th>
					<td colspan="3">
						<input type="radio" id="operatType_1" name="operatType" value="1" checked="checked"/>
						<label for="operatType_1">复制到新组</label>
						<c:if test="${not empty param.gid}">
						<input type="radio" id="operatType_2" name="operatType" value="2"/>
						<label for="operatType_2">移动到新组</label></c:if>
					</td>
				</tr>
				<tr>
					<th>状态：</th>
					<td>
						<input type="checkbox" id="contacts.status" name="contacts.status"<c:if test="${item.status eq 1 }"> checked="checked"</c:if> value="1" style="cursor:pointer;"/>
						<label for="contacts.status" style="cursor:pointer;">不发短信</label>
					</td>
					<th>新分组：</th>
					<td colspan="2">
						<input type="text" id="groups" name="groups" style="width:127px;*width:126px;" required="true">
					</td>
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