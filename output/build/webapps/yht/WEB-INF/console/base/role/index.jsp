<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/include/include.jsp"%>     
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>角色管理</title>
<script type="text/javascript" src="${path }/js/easyui/window.js"></script>
<link rel="stylesheet" type="text/css" href="${path }/css/buttonPanel.css">
<style>
	*{margin:0px;padding:0px}
	ul{list-style:none;}
	.mytable{padding:5px 5px;}
	input{height:21px;line-height:21px;font-size:9pt;}
	.formField dt,dd{float:left;}
	.buttonPanel .formPanel{margin-left:10px;}
	.buttonPanel .formPanel label{float:left;line-height:28px;width:80px;text-align:right;}
</style>
<script type="text/javascript">
<!--
	var win,table; 
	$(document).ready(function(){
		getColorStyle();
		win = new Jwindow(function(table){table.datagrid('reload');});
		table=$("#dataList").datagrid({
			width:'100%',
			height:document.body.clientHeight-$('.buttonPanel').height()-9,
			nowrap: true,
			fitColumns:true,
			striped: true,
			collapsible:false,
			url:'${path}/base/role!list.qt?random='+getRandomNum()+'&chkAccess='+encodeURIComponent('${param.chkAccess }'),
			border:false,
			pagination:true,
			rownumbers:true,
			remoteSort: false,
			clickSingleSelect:true,
			sortName: 'id',
			sortOrder: 'asc',
			idField:'id',
			columns:[[
				{field:'ck',checkbox:true,width:100},
				{title:'角色名称',field:'roleName',width:150},
				{title:'所属组织',field:'orgnName',width:150},
				{title:'角色状态',field:'status',width:100,formatter:function(value,node){return 0==node.id?'':(1==value?'启用':'禁用')}},
				{title:'角色描述',field:'roleDesc',width:500}
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
		changeDel();
	});
	function buttonDisable(){
		$("#queryBtn").linkbutton({disabled:false});
	}
	
	function changeDel(){
		if($("#status").val()==1){
			$("#deleteBtn").css("display","block");
			$("#deleteTrueBtn").css("display","none");
		}else{
			$("#deleteBtn").css("display","none");
			$("#deleteTrueBtn").css("display","block");
		}
	}
//-->	
</script>
</head>
<body>
	<div class="buttonPanel">
		<div class="formPanel">
			<label for="roleName">角色名称：</label>
			<input type="text" name="roleName" id="roleName" maxlength="50" style="float:left;"/>
			<label for="roleDesc">角色描述：</label>
			<input type="text" name="roleDesc" id="roleDesc" style="float:left;"/>
			<label for="status">角色状态：</label>
			<select name="status" id="status" style="float:left;">
				<option value="1">启用</option>
				<option value="0">禁用</option>
			</select>
			<div class="clear"></div>
		</div>
		<div class="datagrid-btn-separator" style="visibility:hidden;"></div>
		<fs:button key="NEWADD" id="addBtn" name="新增" iconCls="icon-add">
			function(){
				win.show('新增角色','${path}/base/role!preAdd.qt?random='+getRandomNum()+'&chkAccess='+encodeURIComponent('{#chkAccess}'),table);
				win.reSize(500,300);
			}
		</fs:button>
		<fs:button key="MODIFY" id="modifyBtn" name="修改" iconCls="icon-edit">
			function(){
				var rows = table.datagrid('getSelections');
				if(rows && 1!=rows.length){
					parent.jQuery.messager.alert('错误','对不起！请选择将要修改的一条记录！','error');
					return;
				}
				win.show('修改角色','${path}/base/role!preModify.qt?id='+rows[0].id+'&chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum(),table);
				win.reSize(500,300);
			}
		</fs:button>
		<fs:button key="DISABLE" id="deleteBtn" name="禁用" iconCls="icon-remove">
			function(){
				var rows = table.datagrid('getSelections');
				if(rows && 1!=rows.length) parent.jQuery.messager.alert('错误','对不起！请选择将要禁用的一条记录！','error');
				else if(rows[0].id=='1') parent.jQuery.messager.alert('错误','对不起！超级管理员不允许禁用！','error');
				else jQuery.messager.confirm('提示','确定禁用角色：'+rows[0].roleName+'吗？',function(b){
					if(b){
						jQuery.ajax({
							async: false,
							type: "GET",
							url: '${path}/base/role!delete.qt?id='+rows[0].id+'&chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum(),
							success: function(data){
								data = eval(data);
								if(data&&data.b){}else jQuery.messager.alert('错误','禁用失败，请刷新页面重试！','error');
								table.datagrid('reload');
								table.datagrid('clearSelections');
							}
						});
					}
				});
			}
		</fs:button>
		<fs:button key="DELETE" id="deleteTrueBtn" name="删除" iconCls="icon-no">
			function(){
				var rows = table.datagrid('getSelections');
				if(rows && 1!=rows.length) parent.jQuery.messager.alert('错误','对不起！请选择将要删除的一条记录！','error');
				else if(rows[0].id=='1') parent.jQuery.messager.alert('错误','对不起！超级管理员不允许删除！','error');
				else jQuery.messager.confirm('提示','确定删除角色：'+rows[0].roleName+'吗？',function(b){
					if(b){
						jQuery.ajax({
							async: false,
							type: "GET",
							url: '${path}/base/role!deleteTrue.qt?id='+rows[0].id+'&chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum(),
							success: function(data){
								data = eval(data);
								if(data&&data.b){}else jQuery.messager.alert('错误','删除失败，请刷新页面重试！','error');
								table.datagrid('reload');
								table.datagrid('clearSelections');
							}
						});
					}
				});
			}
		</fs:button>
		<fs:button key="SETROLE" id="SETROLE" name="授权" iconCls="icon-ok">
			function setRole(){
				var rows = table.datagrid('getSelections');
				if(!rows||rows && 1!=rows.length) parent.jQuery.messager.alert('错误','对不起！请选择将要授权的一条记录！','error');
				else{
					if(rows[0].id == '${Operator.role.id}'){
						if(rows[0].id != '${SUPER_MAN }'){
							jQuery.messager.confirm('提示','您正在尝试修改自己的角色授权，如果您去掉了部分权限，将需要上级管理员重新开放这些权限！<center style="margin:10px 0;font-size:14px;font-weight:900;color:red">确定修改麽？</center>',function(b){
								if(b){
									win.show('授权','${path}/base/role!preAuthorize.qt?roleId='+rows[0].id+'&chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum(),table);
									win.reSize('50%',300);
								}
							});
						}else{
							jQuery.messager.alert('不能授权','当前是超级管理员角色，具有所有权限，不能修改权限！','info');
						}
					}else{
						win.show('授权','${path}/base/role!preAuthorize.qt?roleId='+rows[0].id+'&chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum(),table);
						win.reSize('50%',300);
					}
				}
			}
		</fs:button>
		<div class="datagrid-btn-separator"></div>
		<fs:button key="QUERY" id="queryBtn" name="查询" iconCls="icon-search">
			function(){
				if(!$(this).linkbutton("options").disabled){
					var params = getURLParams();
					if($("#searchForm").form('validate')){
					$(this).linkbutton({disabled:true});
						table.datagrid('options').url='${path}/base/role!list.qt?random='+getRandomNum()+params;
						table.datagrid('options').queryParams={};
						table.datagrid('reload');
						table.datagrid('clearSelections');
						setTimeout("buttonDisable()",BUTTON_WAIT_TIME);
					}
					changeDel();
				}
			}
		</fs:button>
		<div class="clear"></div>
	</div>
	<table id="dataList"></table>
</body>
</html>
