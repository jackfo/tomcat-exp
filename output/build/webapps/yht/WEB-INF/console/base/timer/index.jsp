<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/include/include.jsp"%>     
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>定时器管理</title>
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
			url:'${path}/base/timer!list.qt?random='+getRandomNum()+'&chkAccess='+encodeURIComponent('${param.chkAccess }'),
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
				{title:'定时器名称',field:'name',width:150},
				{title:'类型',field:'type',width:100,formatter:function(value,node){return 1==value?'定点执行':'定时轮询'}},
				{title:'时间设置',field:'cronExpression',width:130},
				{title:'挂载任务',field:'service',width:170},
				{title:'描述',field:'describe',width:200},
				{title:'更新时间',field:'updateTime',width:150},
				{title:'级别',field:'level',width:60,formatter:function(value,node){return 1==value?'<font color=red>系统</font>':'<font color=black>客户</font>'}},
				{title:'状态',field:'status',width:60,formatter:function(value,node){return 1==value?'<font color=green>启用</font>':'<font color=red>停用</font>'}}
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
		$("#queryBtn").linkbutton({disabled:false});
	}
	
//-->	
</script>
</head>
<body>
	<div class="buttonPanel">
		<div class="formPanel">
			<label for="name">定时器名称：</label>
			<input type="text" name="timerData.name" id="name" maxlength="50" style="float:left;"/>
			<label for="status">角色状态：</label>
			<select name="timerData.status" id="status" style="float:left;width: 100px;">
				<option value="">--请选择--</option>
				<option value="1">启用</option>
				<option value="0">停用</option>
			</select>
			<div class="clear"></div>
		</div>
		<div class="datagrid-btn-separator" style="visibility:hidden;"></div>
		<fs:button key="NEWADD" id="addBtn" name="新增" iconCls="icon-add">
			function(){
				win.show('新增定时器','${path}/base/timer!preAdd.qt?random='+getRandomNum()+'&chkAccess='+encodeURIComponent('{#chkAccess}'),table);
				win.reSize(600,400);
			}
		</fs:button>
		<fs:button key="MODIFY" id="modifyBtn" name="修改" iconCls="icon-edit">
			function(){
				var rows = table.datagrid('getSelections');
				if(rows && 1!=rows.length){
					parent.jQuery.messager.alert('错误','对不起！请选择将要修改的一条记录！','error');
					return;
				}
				win.show('修改定时器','${path}/base/timer!preModify.qt?id='+rows[0].id+'&chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum(),table);
				win.reSize(600,400);
			}
		</fs:button>
		<fs:button key="DELETE" id="deleteBtn" name="删除" iconCls="icon-no">
			function(){
				var rows = table.datagrid('getSelections');
				if(rows && 1!=rows.length) parent.jQuery.messager.alert('错误','对不起！请选择将要删除的一条记录！','error');
				if(rows && 1==rows[0].level) parent.jQuery.messager.alert('错误','对不起！系统级别的定时任务不可删除！','error');
				else jQuery.messager.confirm('提示','确定禁用定时器：'+rows[0].name+'吗？',function(b){
					if(b){
						jQuery.ajax({
							async: false,
							type: "GET",
							url: '${path}/base/timer!delete.qt?id='+rows[0].id+'&chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum(),
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
		<fs:button key="QUERY" id="queryBtn" name="查询" iconCls="icon-search">
			function(){
				if(!$(this).linkbutton("options").disabled){
					var params = getURLParams();
					if($("#searchForm").form('validate')){
					$(this).linkbutton({disabled:true});
						table.datagrid('options').url='${path}/base/timer!list.qt?random='+getRandomNum()+params;
						table.datagrid('options').queryParams={};
						table.datagrid('reload');
						table.datagrid('clearSelections');
						setTimeout("buttonDisable()",BUTTON_WAIT_TIME);
					}
				}
			}
		</fs:button>
		<div class="clear"></div>
	</div>
	<table id="dataList"></table>
</body>
</html>
