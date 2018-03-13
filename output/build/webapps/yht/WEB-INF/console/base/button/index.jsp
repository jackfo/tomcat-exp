<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/include/include.jsp"%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" type="text/css" href="${path }/css/buttonPanel.css">
		<title>修改菜单</title>
		<style type="text/css">
			body{background:#fafafa;}
		</style>
		<script type="text/javascript">
			var win,table;
			$(document).ready(function(){
				getColorStyle();
				win = parent.subWin;
				table = $('#dataTable').datagrid({
					url:'${path}/base/menu!btnList.qt?id=${param.id}'+'&chkAccess='+encodeURIComponent('${param.chkAccess}'),
					width:document.body.clientWidth,
					height:document.body.clientHeight-$('.buttonPanel').height()-9,
					idField:'id',
					fitColumns:true,
					pagination:true,
					nowrap:true,
					border:false,
					striped:true,
					fitColumns:true,
					clickSingleSelect:true,
					columns:[[
						{field:'check',width:10,checkbox:'true'},
						{field:'id',width:80,title:'ID'},
						{field:'name',width:100,title:'名称'},
						{field:'mark',width:100,title:'标识'},
						{field:'accessRes',width:200,title:'可访问资源'}
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
			<fs:button key="BTNNEWADD" id="BTNNEWADD_BTN" name="增加" iconCls="icon-add">
				function append(){
					win.show('新增按钮','${path}/base/menu!btnPreAdd.qt?id=${param.id}'+'&chkAccess='+encodeURIComponent('{#chkAccess}')+'&name='+encodeURIComponent('${param.name}')+'&random='+getRandomNum(),table);
					win.reSize(460,280);
				}
			</fs:button>
			<fs:button key="BTNMODIFY" id="BTNMODIFY_BTN" name="修改" iconCls="icon-edit">
				function modify(){
					var rows = table.datagrid('getSelections');
					if(rows&&1!=rows.length)parent.jQuery.messager.alert('错误','对不起！请选择将要修改的一条记录！','error');
					else{
						win.show('修改按钮','${path}/base/menu!btnPreModify.qt?id='+rows[0].id+'&chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum(),table);
						win.reSize(460,280);
					}
				}
			</fs:button>
			<fs:button key="BTNDELETE" id="BTNDELETE_BTN" name="删除" iconCls="icon-no">
				function remove(){
					var rows = table.datagrid('getSelections');
					if(rows && 1!=rows.length) parent.jQuery.messager.alert('错误','对不起！请选择将要删除的一条记录！','error');
					if(rows&&0 < rows.length){
						var ids = '',names = '';
						jQuery.each(rows,function(i,el){
							ids+=','+el.id;
							names+=',【'+el.name+'】';
						});
						ids = ids.replace(/(^[,]*)|([,]*$)/,'');
						names = names.replace(/(^[,]*)|([,]*$)/,'');
						parent.jQuery.messager.confirm('提示','确定删除'+names+'等按钮吗？',function(b){
							if(b){
								jQuery.ajax({
									async: false,
									type: "GET",
									url: '${path}/base/menu!btnDelete.qt?id='+encodeURIComponent(ids)+'&chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum(),
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
			<label style="float:left;margin-right:10px;line-height:28px" for="txtSearch">名称：</label>
			<input type="text" id="txtSearch" title="请输入按钮名称" style="float:left;margin-top:2px;margin-right:10px"/>
			<fs:button key="BTNQUERY" id="BTNQUERY_BTN" name="查询" iconCls="icon-search">
				function query(){
					$('#refreshButton').linkbutton('enable');
					table.datagrid('options').url = '${path}/base/menu!btnList.qt?id=${param.id}'+'&chkAccess='+encodeURIComponent('{#chkAccess}')+'&name='+encodeURIComponent($('#txtSearch').val());
					table.datagrid('reload');
					table.datagrid('clearSelections');
				}
			</fs:button>
			<div class="clear"></div>
		</div>
		<table id="dataTable"></table>
	</body>
</html>