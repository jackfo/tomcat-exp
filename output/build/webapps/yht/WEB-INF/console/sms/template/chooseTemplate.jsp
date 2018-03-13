<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/include/include.jsp"%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" type="text/css" href="${path }/css/buttonPanel.css">
		<title>选择模板</title>
		<script type="text/javascript">
			var table;
			$(document).ready(function(){
				table = $('#dataTable').datagrid({
					url:'${path}/sms/template!choose.qt?type=list&chkAccess='+encodeURIComponent('${param.chkAccess}'),
					width:document.body.clientWidth,
					height:document.body.clientHeight-$('.buttonPanel').height()-9,
					idField:'id',
					nowrap: true,
					pagination:true,
					border:false,
					striped:true,
					fitColumns:true,
					rownumbers:true,
					singleSelect:true,
					columns:[[
						{field:'param',width:20,title:'分类',formatter:function(val,node){return node.paramDroped!=0?val:'<b style="color:red;margin-right:3px;">[系]</b>'+val;}},
						{field:'content',width:80,title:'内容'}
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
					},
					onDblClickRow:fixedChoose
				});
			});
			function query(){
				table.datagrid('options').queryParams = {'txtSearch':$('#txtSearch').val()};
				table.datagrid('reload');
				table.datagrid('clearSelections');
			}
			function fixedChoose(){
				var rows = table.datagrid('getSelections');
				if(rows&&1!=rows.length)parent.jQuery.messager.alert('错误','对不起！请选择一条记录！','error');
				else if('${param.win}'!=''){
					var win = parent.${param.win};
					if(rows[0].paramDroped!='0'){
						if(win&&win.refreshParent){
							win.refreshParent(rows[0]);
						}
					}else{
						parent.jQuery.messager.confirm('提示','您选择的模板是系统替换模板，选择此模板将不会替换模板中的关键字。<br/><center style="margin:10px 0;font-size:14px;font-weight:900;color:red">确定选择该模板麽吗？</center>',function(b){
							if(b){
								if(win&&win.refreshParent){
									win.refreshParent(rows[0]);
								}
							}
						});
					}
				}
			}
		</script>
	</head>
	<body>
		<div class="buttonPanel">
			<a onclick="fixedChoose()" class="easyui-linkbutton" plain="false" iconCls="icon-ok" style="margin-right:10px">确定</a>
			<div class="datagrid-btn-separator"></div>
			<input type="text" id="txtSearch" name="txtSearch" title="请输入要查询的关键字" style="float:left;margin-top:2px;margin-right:10px"/>
			<a href="javascript:query()" class="easyui-linkbutton" plain="false" iconCls="icon-search" style="margin-right:10px">查询</a>
			<div class="clear"></div>
		</div>
		<table id="dataTable"></table>
	</body>
</html>