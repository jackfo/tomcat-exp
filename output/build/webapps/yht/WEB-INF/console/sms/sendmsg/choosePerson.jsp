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
					url:'${path}/sms/sendMsg!userList.qt?type=list&chkAccess='+encodeURIComponent('${param.chkAccess}'),
					width:document.body.clientWidth,
					height:document.body.clientHeight-$('.buttonPanel').height()-9,
					idField:'id',
					pagination:true,
					border:false,
					striped:true,
					fitColumns:true,
					rownumbers:true,
					clickSingleSelect:true,
					columns:[[
						{field:'ck',checkbox:true,width:100},
						{title:'姓名',field:'userName',width:180},
						{title:'性别',field:'sex',width:180,formatter:function(value,node){return 0==node.id?'':(1==value?'男':'女')}},
						{title:'电话',field:'mobile',width:180},
						{title:'角色名',field:'role',width:180}
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
					//onDblClickRow:fixedChoose
				});
			});
			function query(){
				table.datagrid('options').queryParams = {'txtSearch':$('#txtSearch').val()};
				table.datagrid('reload');
				table.datagrid('clearSelections');
			}
			function fixedChoose(){
				var win = parent.win;
				var rows = table.datagrid('getSelections');
				if(rows&&0==rows.length)parent.jQuery.messager.alert('错误','对不起！请至少选择一条记录！','error');
				else if('${param.win}'!=''){
					var win = parent.${param.win};
					if(win&&win.refreshParent){
						var mobiles='';
						var rowlen=rows.length;
						for(var i=0;i<rowlen;i++){
							if(parent.choosePerson){
								var temp = parent.choosePerson(rows[i]);
								if(temp&&temp!='') mobiles+=','+temp;
							}else if(mobiles.indexOf(rows[i].mobile)==-1)
								mobiles+=','+rows[i].mobile;
						}
						if(mobiles.length>1&&mobiles.indexOf(',')==0){
							mobiles=mobiles.substring(1);
							win.refreshParent(mobiles);
						}
					}
				}
			}
			function fixedChooseAll(){
				var win = parent.win;
				var params = '&txtSearch='+encodeURIComponent($('#txtSearch').val());
				if('${param.win}'!=''){
					var win = parent.${param.win};
					if(win&&win.refreshParent){
						jQuery.ajax({
							async: false,
							type: "GET",
							url: '${path}/sms/sendMsg!userList.qt?type=all&chkAccess='+encodeURIComponent('${param.chkAccess}')+params,
							success: function(mobiles){
								win.refreshParent(mobiles);
							}
						});
					}
				}
			}
		</script>
	</head>
	<body>
		<div class="buttonPanel">
			<a onclick="fixedChoose()" class="easyui-linkbutton" plain="false" iconCls="icon-ok" style="margin-right:10px">提交选择数据</a>
			<a onclick="fixedChooseAll()" class="easyui-linkbutton" plain="false" iconCls="icon-ok" style="margin-right:10px">提交查询数据</a>
			<div class="datagrid-btn-separator"></div>
			<input type="text" id="txtSearch" name="txtSearch" title="请输入要查询的关键字" style="float:left;margin-top:2px;margin-right:10px"/>
			<a href="javascript:query()" class="easyui-linkbutton" plain="false" iconCls="icon-search" style="margin-right:10px">查询</a>
			<div class="clear"></div>
		</div>
		<table id="dataTable"></table>
	</body>
</html>