<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/include/include.jsp"%>     
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>动态表单</title>
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
			url:'${path}/custom/form!list.qt?random='+getRandomNum()+'&chkAccess='+encodeURIComponent('${param.chkAccess }'),
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
				{title:'别名',field:'label',width:120},
				{title:'名称',field:'name',width:120},
				{title:'表名',field:'alias',width:120},
				{title:'类型',field:'type',width:110,formatter:function(value,node){return 0==node.id?'':(1==value?'主动同步定时发送':'上行查询发送')}}
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
			<label for="form.label">别名：</label>
			<input type="text" name="form.label" id="form.label" maxlength="50" style="float:left;"/>
			<label for="form.name">名称：</label>
			<input type="text" name="form.name" id="form.name" style="float:left;"/>
			<label for="form.type">类型：</label>
			<select name="form.type" id="form.type" style="float:left;">
				<option value="999">--请选择--</option>
				<option value="1">主动同步定时发送</option>
				<option value="2">上行查询发送</option>
			</select>
			<div class="clear"></div>
		</div>
		<div class="datagrid-btn-separator" style="visibility:hidden;"></div>
		<fs:button key="NEWADD" id="addBtn" name="新增" iconCls="icon-add">
			function(){
				win.show('新增','${path}/custom/form!preAdd.qt?random='+getRandomNum()+'&chkAccess='+encodeURIComponent('{#chkAccess}'),table);
				win.reSize('80%','80%');
			}
		</fs:button>
		<fs:button key="MODIFY" id="modifyBtn" name="修改" iconCls="icon-edit">
			function(){
				var rows = table.datagrid('getSelections');
				if(rows && 1!=rows.length){
					parent.jQuery.messager.alert('错误','对不起！请选择将要修改的一条记录！','error');
					return;
				}
				win.show('修改','${path}/custom/form!preModify.qt?id='+rows[0].id+'&chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum(),table);
				win.reSize('80%','80%');
			}
		</fs:button>
		<fs:button key="MENU" id="menuBtn" name="生成菜单" iconCls="icon-reload">
			function(){
				var rows = table.datagrid('getSelections');
				if(rows&&0 < rows.length){
					var ids = '',names = '';
					jQuery.each(rows,function(i,el){
						ids+=','+el.id;
						names+=',【'+el.label+'】';
					});
					ids = ids.replace(/(^[,]*)|([,]*$)/,'');
					names = names.replace(/(^[,]*)|([,]*$)/,'');
					if(ids == '') return;
					win.show('生成菜单','${path}/custom/form!preMenu.qt?id='+encodeURIComponent(ids)+'&chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum(),table);
					win.reSize(400,300);
				}else{
					parent.jQuery.messager.alert('错误','对不起！请至少选择一条记录！','error');
				}
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
						names+=',【'+el.label+'】';
					});
					ids = ids.replace(/(^[,]*)|([,]*$)/,'');
					names = names.replace(/(^[,]*)|([,]*$)/,'');
					if(ids == ''){
						
					}else parent.jQuery.messager.confirm('提示','确定删除'+names+'等信息吗？',function(b){
						if(b){
							jQuery.ajax({
								async: false,
								type: "GET",
								url: '${path}/custom/form!delete.qt?id='+encodeURIComponent(ids)+'&chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum(),
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
		<fs:button key="REPAIR" id="repairBtn" name="一键修复" iconCls="icon-ok">
			function(){
				parent.jQuery.messager.confirm('提示','确定一键修复动态表配置文件吗？',function(b){
					if(b){
						jQuery.ajax({
							async: false,
							type: "GET",
							url: '${path}/custom/form!repairAll.qt?chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum(),
							success: function(data){
								data = eval(data);
								if(data&&data.b){}else jQuery.messager.alert('错误','修复失败，请刷新页面重试！','error');
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
				if(!$(this).linkbutton("options").disabled){
					var params = getURLParamsForObj();
					$(this).linkbutton({disabled:true});
					table.datagrid('options').url='${path}/custom/form!list.qt?random='+getRandomNum();
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
