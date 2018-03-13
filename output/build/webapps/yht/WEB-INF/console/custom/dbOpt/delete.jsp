<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/include/include.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>数据批量删除</title>
	<style type="text/css">
		body{margin: 0px;padding:0px;background:#fafafa;overflow:hidden;}
		.tip{color: red;font-weight: bold;}
		desc{height: 22px;line-height: 22px;}
	</style>
	<script type="text/javascript">
		var table;
		$(document).ready(function(){
			table=$("#dataList").datagrid({
				width: '100%',
				height: document.body.clientHeight - $('div[region=north]').height(),
				nowrap: true,
				fitColumns: true,
				striped: true,
				collapsible:false,
				border:false,
				rownumbers:true,
				remoteSort: false,
				clickSingleSelect:true,
				sortName: 'fieldName',
				sortOrder: 'asc',
				idField:'fieldName',
				columns:[[
					{title:'字段名称',field:'fieldName',width:120},
					{title:'中文别名',field:'label',width:80},
					{title:'数据类型',field:'fieldType',width:120},
					{title:'数据长度',field:'fieldLength',width:60},
					{title:'必填',field:'required',width:60,formatter:function(value,node){return 0==node.id?'':(1==value?'<font color=red>否</font>':'<font color=green>是</font>')}},
					{title:'查询条件',field:'fieldValue',width:200,editor:'text'}
				]],
				onHeaderContextMenu: function(e, field){
					e.preventDefault();
					if (!$('#tmenu').length){
						createColumnMenu($("#dataList"));
					}
					$('#tmenu').menu('show', {
						left:e.pageX,
						top:e.pageY
					});
				}
			});
			$("#dataList").datagrid("loadData",eval('(${jsonData})'));
		});
		
		function clearData(){
			jQuery.messager.confirm('提示','确定要清空该表所有数据吗？请慎重！',function(b){
				$("#deleteBtn").linkbutton({disabled:true});
				jQuery.ajax({
					async: false,
					type: "GET",
					url: '${path}/db/dataOpt!delete.qt?dbid='+$('#dbid').val()+'&tableName='+$('#tableName').val()+'&random='+getRandomNum()+'&chkAccess='+encodeURIComponent('${param.chkAccess}'),
					success: function(data){
						var obj = eval(data);
						if(obj.b){
							if(parent&&parent.win) parent.win.refreshParent();
						}else parent.jQuery.messager.alert('错误','<br/>清空失败！','error');
					}
				});
				setTimeout("$('#deleteBtn').linkbutton({disabled:false})",BUTTON_WAIT_TIME);
			});	
		}
	</script>
	</head>
	<body class="easyui-layout">
		<div region="north" title="清空数据" split="false" style="height:120px;overflow: hidden;">
			<div>
				当前数据库：<span  class="tip">${dbCon.name }</span>
				当前数据表：<span class="tip">${tableName }</span>
				<input type="hidden" id="dbid" name="dbid" value="${dbCon.id }"/>
				<input type="hidden" id="dbName" name="dbName" value="${dbCon.name }"/>
				<input type="hidden" id="tableName" name="tableName" value="${tableName }"/>
			</div>
			<div style="width: 100%;text-align: center;">
				<a href="#" id="deleteBtn" onclick="clearData()" class="easyui-linkbutton" plain="false" iconCls="icon-no" style="">一键清空所有数据</a>
			</div>
			<div style="width: 100%;color: red;">
				<div class="desc"><b>注意：</b></div>
				<div class="desc">1、：如果您不是数据库管理员，请慎重操作！</div>
				<div class="desc">2、：建议您先备份该数据库，以免误删造成系统无法正常删除！</div>
			</div>
		</div>
		
		<div region="center" title="批量删除" style="overflow:hidden;">
			<table id="dataList"></table>
		</div>
	</body>
</html>
