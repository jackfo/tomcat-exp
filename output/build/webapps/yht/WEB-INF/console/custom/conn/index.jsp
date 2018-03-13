<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/include/include.jsp"%>     
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>连接管理</title>
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
			url:'${path}/db/conn!list.qt?random='+getRandomNum()+'&chkAccess='+encodeURIComponent('${param.chkAccess }'),
			border:false,
			pagination:true,
			rownumbers:true,
			remoteSort: false,
			fitColumns:true,
			sortName: 'id',
			sortOrder: 'asc',
			idField:'id',
			clickSingleSelect:true,
			columns:[[
				{field:'ck',checkbox:true,width:1},
				{title:'名称',field:'name',width:10},
				{title:'用户名',field:'user',width:10},
				{title:'密码',field:'pass',width:10},
				{title:'Class',field:'clazz',width:30},
				{title:'URL',field:'url',width:40}
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
			<label for="connection.name">名称：</label>
			<input type="text" name="connection.name" id="connection.name" style="float:left;"/>
			<label for="connection.clazz">Class：</label>
			<input type="text" name="connection.clazz" id="connection.clazz" style="float:left;"/>
			<label for="connection.url">URL：</label>
			<input type="text" name="connection.url" id="connection.url" style="float:left;"/>
			<div class="clear"></div>
		</div>
		<div class="datagrid-btn-separator" style="visibility:hidden;"></div>
		<fs:button key="NEWADD" id="addBtn" name="新增" iconCls="icon-add">
			function(){
				win.show('新增','${path}/db/conn!preAdd.qt?random='+getRandomNum()+'&chkAccess='+encodeURIComponent('{#chkAccess}'),table);
				win.reSize(550,450);
			}
		</fs:button>
		<fs:button key="MODIFY" id="modifyBtn" name="修改" iconCls="icon-edit">
			function(){
				var rows = table.datagrid('getSelections');
				if(rows && 1!=rows.length){
					parent.jQuery.messager.alert('错误','对不起！请选择将要修改的一条记录！','error');
					return;
				}
				win.show('修改','${path}/db/conn!preModify.qt?id='+rows[0].id+'&chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum(),table);
				win.reSize(550,450);
			}
		</fs:button>
		<fs:button key="DELETE" id="deleteBtn" name="删除" iconCls="icon-no">
			function(){
				var rows = table.datagrid('getSelections');
				if(rows && 1!=rows.length) parent.jQuery.messager.alert('错误','对不起！请选择将要删除的一条记录！','error');
				if(rows&&0 < rows.length){
					var ids = '',names = '';
					jQuery.each(rows,function(i,el){
						ids+=','+el.id;
						if(i<10){
							names+=',【'+el.name+'】';
						}
						if(i==10){
							names+='……';
						}
					});
					ids = ids.replace(/(^[,]*)|([,]*$)/,'');
					names = names.replace(/(^[,]*)|([,]*$)/,'');
					if(ids == ''){
						
					}else parent.jQuery.messager.confirm('提示','确定删除'+names+'信息吗？',function(b){
						if(b){
							jQuery.ajax({
								async: false,
								type: "GET",
								url: '${path}/db/conn!delete.qt?id='+encodeURIComponent(ids)+'&chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum(),
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
		<div class="datagrid-btn-separator"></div>
		<fs:button key="QUERY" id="queryBtn" name="查询" iconCls="icon-search">
			function(){
				if(!$(this).linkbutton("options").disabled){
					var params = getURLParamsForObj();
					$(this).linkbutton({disabled:true});
					table.datagrid('options').url='${path}/db/conn!list.qt?random='+getRandomNum();
					table.datagrid('options').queryParams=params;
					table.datagrid('reload');
					table.datagrid('clearSelections');
					setTimeout("buttonDisable()",BUTTON_WAIT_TIME);
				}
			}
		</fs:button>
		<div class="clear"></div>
	</div>
	<table id="dataList"></table>
</body>
</html>
