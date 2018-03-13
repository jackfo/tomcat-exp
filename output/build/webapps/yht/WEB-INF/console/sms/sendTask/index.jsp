<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="/include/include.jsp"%>     
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>待发信箱</title>
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
			striped: true,
			collapsible:false,
			url:'${path}/sms/sendTask!list.qt?random='+getRandomNum(),
			border:false,
			pagination:true,
			rownumbers:true,
			remoteSort: false,
			sortName: 'id',
			sortOrder: 'asc',
			fitColumns:true,
			idField:'id',
			clickSingleSelect:true,
			columns:[[
				{field:'ck',checkbox:true,width:100},
				{title:'用户姓名',field:'consName',width:15},
				{title:'接收号码',field:'destAddr',width:15},
				{title:'短信内容',field:'smContent',width:35,formatter:function(val,node){return val.replace(/<(.+?)>/gi,"&lt;$1&gt;");}},
				{title:'发送时间',field:'sendTime',width:15},
				{title:'用电地址',field:'elecAddr',width:15},
				{title:'供电所名称',field:'orgName',width:15}
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
	});
	function buttonDisable(){
		$("#queryBtn").linkbutton({disabled:true});
	}
//-->	
</script>
</head>
<body>
	<div class="buttonPanel">
		<div class="formPanel">
			<label for="taskName">任务名称：</label>
			<input type="text" name="taskName" id="taskName" maxlength="50" style="float:left;"/>
			<label for="consName">用户姓名：</label>
			<input type="text" name="consName" id="consName" style="float:left;"/>
			<label for="orgName">供电所名称：</label>
			<input type="text" name="orgName" id="orgName" style="float:left;"/>
			<div class="clear"></div>
		</div>
		<div class="datagrid-btn-separator" style="visibility:hidden;"></div>
		<fs:button key="DELETE" id="DELETE_BTN" name="删除" iconCls="icon-no">
			function(){
				var rows = table.datagrid('getSelections');
				if(rows && 1!=rows.length) parent.jQuery.messager.alert('错误','对不起！请选择将要删除的一条记录！','error');
				else jQuery.messager.confirm('提示','确定删除任务:'+rows[0].taskName+'吗？',function(b){
					if(b){
						jQuery.ajax({
							async: false,
							type: "GET",
							url: '${path}/sms/sendTask!delete.qt?id='+rows[0].id+'&chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum(),
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
		<div class="datagrid-btn-separator"></div>
		<fs:button key="QUERY" id="queryBtn" name="查询" iconCls="icon-search">
			function(){
				table.datagrid('options').url='${path}/sms/sendTask!list.qt';
				table.datagrid('options').queryParams = getURLParamsForObj();
				table.datagrid('reload');
				table.datagrid('clearSelections');
			}		
		</fs:button>
		<div class="clear"></div>
	</div>
	<table id="dataList"></table>
</body>
</html>
