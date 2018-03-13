<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/include/include.jsp"%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<script type="text/javascript" src="${path }/js/easyui/window.js"></script>
		<link rel="stylesheet" type="text/css" href="${path }/css/buttonPanel.css">
		<title>短信模板</title>
		<script type="text/javascript">
			var win,table;
			$(document).ready(function(){
				getColorStyle();
				win = new Jwindow(function(table){table.datagrid('reload');});
				table = $('#dataTable').datagrid({
					url:'${path}/sms/template!list.qt?chkAccess='+encodeURIComponent('${param.chkAccess}'),
					width:document.body.clientWidth,
					height:document.body.clientHeight-$('.buttonPanel').height()-9,
					idField:'id',
					pagination:true,
					nowrap: true,
					border:false,
					striped:true,
					fitColumns:true,
					rownumbers:true,
					clickSingleSelect:true,
					columns:[[
						{field:'check',width:10,checkbox:'true'},
						{field:'param',width:20,title:'分类',formatter:function(val,node){return node.paramDroped!=1?'<b style="color:red;margin-right:3px;">[系]</b>'+val:val;}},
						{field:'content',width:80,title:'内容',formatter:function(val,node){return val.replace(/<(.+?)>/gi,"&lt;$1&gt;");}}
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
			/**
			 * 重置高宽
			 */
			function resizeDataGrid(el){
				el.datagrid('resize', {
					width: function(){return document.body.clientWidth;},
					height: function(){return document.body.clientHeight;}
				});
			}
		</script>
	</head>
	<body>
		<div class="buttonPanel">
			<div class="formPanel">
				<label for="roleName">分类名称：</label>
				<input type="text" name="template.param.name" id="roleName" maxlength="50" style="float:left;"/>
				<label for="status">内容：</label>
				<input type="text" name="template.content" id="roleDesc" style="float:left;"/>
				<div class="clear"></div>
			</div>
			<fs:button key="NEWADD" id="NEWADD_BTN" name="增加" iconCls="icon-add">
				function append(){
					win.show('新增模板','${path}/sms/template!preAdd.qt?chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum(),table);
					win.reSize(600,280);
				}
			</fs:button>
			<fs:button key="MODIFY" id="MODIFY_BTN" name="修改" iconCls="icon-edit">
				function modify(){
					var rows = table.datagrid('getSelections');
					if(rows&&1!=rows.length)parent.jQuery.messager.alert('错误','对不起！请选择将要修改的一条记录！','error');
					else{
						win.show('修改模板','${path}/sms/template!preModify.qt?id='+rows[0].id+'&chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum(),table);
						win.reSize(600,280);
					}
				}
			</fs:button>
			<fs:button key="DELETE" id="DELETE_BTN" name="删除" iconCls="icon-no">
				function remove(){
					var rows = table.datagrid('getSelections');
					if(rows && 1>rows.length) {parent.jQuery.messager.alert('错误','对不起！请选择将要删除的一条记录！','error');return;}
					if(rows&&0 < rows.length){
						var ids = '',names = '';
						jQuery.each(rows,function(i,el){
							ids+=','+el.id;
							if(i<10){
								names+=',【第'+(table.datagrid('getRowIndex',el)+1)+'行】';
							}
							if(i==10){
								names+='……';
							}
						});
						ids = ids.replace(/(^[,]*)|([,]*$)/,'');
						names = names.replace(/(^[,]*)|([,]*$)/,'');
						parent.jQuery.messager.confirm('提示','确定删除'+names+'模板吗？',function(b){
							if(b){
								jQuery.ajax({
									async: false,
									type: "GET",
									url: '${path}/sms/template!delete.qt?id='+encodeURIComponent(ids)+'&chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum(),
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
			<fs:button key="QUERY" id="QUERY_BTN" name="查询" iconCls="icon-search">
				function query(){
					$('#refreshButton').linkbutton('enable');
					table.datagrid('options').url = '${path}/sms/template!list.qt?mark=${param.mark}'+'&chkAccess='+encodeURIComponent('{#chkAccess}')+'&name='+encodeURIComponent($('#txtSearch').val());
					table.datagrid('options').queryParams = getURLParamsForObj();
					table.datagrid('reload');
					table.datagrid('clearSelections');
				}
			</fs:button>
			<div class="clear"></div>
		</div>
		<table id="dataTable"></table>
	</body>
</html>