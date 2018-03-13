<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/include/include.jsp"%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<script type="text/javascript" src="${path }/js/easyui/window.js"></script>
		<link rel="stylesheet" type="text/css" href="${path }/css/buttonPanel.css">
		<title>模板分类</title>
		<script type="text/javascript">
			var win,table;
			$(document).ready(function(){
				getColorStyle();
				win = new Jwindow(function(table){table.datagrid('reload');});
				table = $('#dataTable').datagrid({
					url:'${path}/base/param!list.qt?mark=${param.mark}'+'&chkAccess='+encodeURIComponent('${param.chkAccess}'),
					width:document.body.clientWidth,
					height:document.body.clientHeight-$('.buttonPanel').height()-9,
					idField:'id',
					pagination:true,
					nowrap:true,
					border:false,
					striped:true,
					fitColumns:true,
					rownumbers:true,
					clickSingleSelect:true,
					columns:[[
						{field:'check',width:10,checkbox:'true'},
						{field:'parent',width:15,title:'父分类',formatter:function(value,node){return value&&value!=''?value:'无';}},
						{field:'name',width:15,title:'名称'},
						{field:'mark',width:8,title:'标识'},
						{field:'droped',width:10,title:'',formatter:function(value,node){return value&&value==1?'可以删除':'<b style="color:red">不能删除</b>'}},
						{field:'desc',width:50,title:'描述'}
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
				<label for="name">名称：</label>
				<input type="text" name="name" id="name" style="float:left;"/>
				<div class="clear"></div>
			</div>
			<fs:button key="NEWADD" id="NEWADD_BTN" name="增加" iconCls="icon-add">
				function append(){
					var rows = table.datagrid('getSelections');
					var parentId = '0';
					var parentName = '';
					if(rows&&1 < rows.length){
						parent.jQuery.messager.alert('错误','对不起！请选择将要新增的一条记录！','error');
						return;
					}else if(rows&&1 == rows.length){
						parentId=rows[0].id;
						parentName=rows[0].name;
					}
					win.show('新增'+(parentName!=''?('【'+parentName+'】的子'):'')+'分类','${path}/base/param!preAdd.qt?mark=${param.mark}&pid='+parentId+'&pname='+encodeURIComponent(parentName)+'&chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum(),table);
					win.reSize(550,300);
				}
			</fs:button>
			<fs:button key="MODIFY" id="MODIFY_BTN" name="修改" iconCls="icon-edit">
				function modify(){
					var rows = table.datagrid('getSelections');
					if(rows&&1!=rows.length)parent.jQuery.messager.alert('错误','对不起！请选择将要修改的一条记录！','error');
					else if(rows[0].droped==2&&'1'!='${Operator.id }')
						parent.jQuery.messager.alert('提示','对不起！系统分类不允许修改！','info');
					else{
						win.show('修改分类','${path}/base/param!preModify.qt?id='+rows[0].id+'&chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum(),table);
						win.reSize(550,300);
					}
				}
			</fs:button>
			<fs:button key="DELETE" id="DELETE_BTN" name="删除" iconCls="icon-no">
				function remove(){
					var rows = table.datagrid('getSelections');
					if(rows && 1!=rows.length) parent.jQuery.messager.alert('错误','对不起！请选择将要删除的一条记录！','error');
					if(rows&&0 < rows.length){
						var ids = '',names = '';
						jQuery.each(rows,function(i,el){
							if(el.droped == 1){
								ids+=','+el.id;
								if(i<10){
									names+=',【'+el.name+'】';
								}
								if(i==10){
									names+='……';
								}
								
							}
						});
						ids = ids.replace(/(^[,]*)|([,]*$)/,'');
						names = names.replace(/(^[,]*)|([,]*$)/,'');
						if(ids == ''){
							
						}else parent.jQuery.messager.confirm('提示','确定删除'+names+'吗？',function(b){
							if(b){
								jQuery.ajax({
									async: false,
									type: "GET",
									url: '${path}/base/param!delete.qt?id='+encodeURIComponent(ids)+'&mark=${param.mark}&chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum(),
									success: function(data){
										data = eval(data);
										if(data&&data.b){
										jQuery.messager.alert('提示',data.desc,'error');
										}else jQuery.messager.alert('错误','删除失败，请刷新页面重试！','error');
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
					table.datagrid('options').url = '${path}/base/param!list.qt?mark=${param.mark}'+'&chkAccess='+encodeURIComponent('{#chkAccess}')+'&name='+encodeURIComponent($('#name').val());
					table.datagrid('reload');
					table.datagrid('clearSelections');
				}
			</fs:button>
			<div class="clear"></div>
		</div>
		<table id="dataTable"></table>
	</body>
</html>