<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/include/include.jsp"%>     
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>操作员管理</title>
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
			height: document.body.clientHeight-$('.buttonPanel').height()-9,
			nowrap: true,
			fitColumns:true,
			striped: true,
			collapsible:false,
			url:'${path}/base/account!list.qt?random='+getRandomNum(),
			pagination:true,
			border:false,
			rownumbers:true,
			remoteSort: false,
			clickSingleSelect:true,
			sortName: 'id',
			sortOrder: 'asc',
			idField:'id',
			columns:[[
				{field:'ck',checkbox:true,width:100},
				{title:'编号',field:'scode',width:60},
				{title:'账号',field:'account',width:150},
				{title:'姓名',field:'userName',width:120},
				{title:'性别',field:'sex',width:60,formatter:function(value,node){return 0==node.id?'':(1==value?'男':'女')}},
				{title:'手机',field:'mobile',width:120},
				{title:'生日',field:'birthday',width:100},
				{title:'组织',field:'organName',width:120},
				{title:'角色',field:'role',width:120},
				{title:'状态',field:'status',width:60,formatter:function(value,node){return 0==node.id?'':(1==value?'正常':'禁用')}}
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
			$("#deleteTrueButton").css("display","none");
			$("#activeButton").css("display","none");
			$("#deleteButton").css("display","block");
			$("#resetPassButton").css("display","block");
		}else{
			$("#deleteButton").css("display","none");
			$("#resetPassButton").css("display","none");
			$("#deleteTrueButton").css("display","block");
			$("#activeButton").css("display","block");
		}
	}
//-->	
</script>
</head>
<body>
	<div class="buttonPanel">
		<div class="formPanel">
			<label for="account">账号：</label>
			<input type="text" name="account" id="account" maxlength="10" style="float:left;"/>
			<label for="userName">姓名：</label>
			<input type="text" name="userName" id="userName" style="float:left;"/>
			<label for="sex">性别：</label>
			<select name="sex" id="sex" style="width:80px;float:left;">
				<option value="">--请选择--</option>
				<option value="1">男</option>
				<option value="0">女</option>
			</select>
			<label for="status">状态：</label>
			<select name="status" id="status" style="width: 80px;float:left;">
				<option value="1">正常</option>
				<option value="0">禁用</option>
			</select>
			<div class="clear"></div>
		</div>
		<div class="datagrid-btn-separator" style="visibility:hidden;"></div>
		<fs:button key="NEWADD" id="addButton" name="新增" iconCls="icon-add">
			function(){
				win.show('新增操作员','${path}/base/account!preAdd.qt?chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum(),table);
				win.reSize(500,450);
			}
		</fs:button>
		<fs:button key="MODIFY" id="modifyButton" name="修改" iconCls="icon-edit">
			function(){
				var rows = table.datagrid('getSelections');
				if(rows && 1!=rows.length){parent.jQuery.messager.alert('错误','对不起！请选择将要修改的一条记录！','error');return;}
				win.show('修改操作员','${path}/base/account!preModify.qt?id='+rows[0].id+'&chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum(),table);
				win.reSize(500,400);
			}
		</fs:button>
		<fs:button key="DISABLE" id="deleteButton" name="禁用" iconCls="icon-remove">
			function(){
				var rows = table.datagrid('getSelections');
				if(rows && 1!=rows.length) parent.jQuery.messager.alert('错误','对不起！请选择将要禁用的一条记录！','error');
				else if(rows[0].id=='${SUPER_MAN }') parent.jQuery.messager.alert('错误','对不起！超级管理员不允许禁用！','error');
				else{
					jQuery.messager.confirm('提示','确定禁用操作员: '+rows[0].userName+' 吗？',function(b){
						if(b){
							jQuery.ajax({
								async: false,
								type: "GET",
								url: '${path}/base/account!delete.qt?id='+rows[0].id+'&chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum(),
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
			}
		</fs:button>
		<fs:button key="ACTIVE" id="activeButton" name="激活" iconCls="icon-undo">
			function(){
				var rows = table.datagrid('getSelections');
				if(rows && 1!=rows.length) parent.jQuery.messager.alert('错误','对不起！请选择将要激活的一条记录！','error');
				else{
					jQuery.messager.confirm('提示','确定激活操作员: '+rows[0].userName+' 吗？',function(b){
						if(b){
							jQuery.ajax({
								async: false,
								type: "GET",
								url: '${path}/base/account!active.qt?id='+rows[0].id+'&chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum(),
								success: function(data){
									data = eval(data);
									if(data&&data.b){}else jQuery.messager.alert('错误','激活失败，请刷新页面重试！','error');
									table.datagrid('reload');
									table.datagrid('clearSelections');
								}
							});
						}
					});
				}
			}
		</fs:button>
		<fs:button key="DELETE" id="deleteTrueButton" name="删除" iconCls="icon-no">
			function(){
				var rows = table.datagrid('getSelections');
				if(rows && 1!=rows.length) parent.jQuery.messager.alert('错误','对不起！请选择将要删除的一条记录！','error');
				else{
					jQuery.messager.confirm('提示','确定删除操作员: '+rows[0].userName+' 吗？',function(b){
						if(b){
							jQuery.ajax({
								async: false,
								type: "GET",
								url: '${path}/base/account!deleteTrue.qt?id='+rows[0].id+'&chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum(),
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
			}
		</fs:button>
		<fs:button key="RESETPASS" id="resetPassButton" name="重置密码" iconCls="icon-redo">
			function(){
				var rows = table.datagrid('getSelections');
				if(rows && 1!=rows.length) parent.jQuery.messager.alert('错误','对不起！请选择将要重置密码的一条记录！','error');
				else{
					jQuery.messager.confirm('提示','确定重置操作员: '+rows[0].userName+' 的密码吗？<br/><br/>重置后密码与账号相同！',function(b){
						if(b){
							jQuery.ajax({
								async: false,
								type: "GET",
								url: '${path}/base/account!resetPass.qt?id='+rows[0].id+'&chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum(),
								success: function(data){
									data = eval(data);
									if(data&&data.b){}else jQuery.messager.alert('错误','重置密码失败，请刷新页面重试！','error');
									table.datagrid('reload');
									table.datagrid('clearSelections');
								}
							});
						}
					});
				}
			}
		</fs:button>
		<fs:button key="SETROLE" id="setRoleBtn" name="授权" iconCls="icon-ok">
			function(){
				var rows = table.datagrid('getSelections');
				if(rows && 1!=rows.length) {parent.jQuery.messager.alert('错误','对不起！请选择将要授权操作员的一条记录！','error');return;}
				win.show('设置操作员角色','${path}/base/account!preSetRole.qt?id='+rows[0].id+'&chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum(),table);
				win.reSize(500,400);
			}
		</fs:button>
		<div class="datagrid-btn-separator"></div>
		<fs:button key="QUERY" id="queryBtn" name="查询" iconCls="icon-search">
			function(){
				if(!$(this).linkbutton("options").disabled){
					var params = getURLParams();
					if($("#searchForm").form('validate')){
						$(this).linkbutton({disabled:true});
						table.datagrid('options').url='${path}/base/account!list.qt?chkAccess='+encodeURIComponent('{#chkAccess}')+'random='+getRandomNum()+params;
						table.datagrid('reload');
						table.datagrid('clearSelections');
						setTimeout("buttonDisable()",BUTTON_WAIT_TIME);
					};
					changeDel();
				}
			}
		</fs:button>
		<div class="clear"></div>
	</div>
	<table id="dataList"></table>
</body>
</html>