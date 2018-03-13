<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/include/include.jsp"%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<script type="text/javascript" src="${path }/js/easyui/window.js"></script>
		<script type="text/javascript" src="${path }/js/vote/Vote.js"></script>
		<link rel="stylesheet" type="text/css" href="${path }/css/buttonPanel.css">
		<title>院后随访</title>
		<style type="text/css">
			hide{display:none;}
		</style>
		<script type="text/javascript">
			var win,table;
			$(document).ready(function(){
				getColorStyle();
				win = new Jwindow(function(table){table.datagrid('reload');});
				table = $('#dataTable').datagrid({
					url:'${path}/port/follow!list.qt?chkAccess='+encodeURIComponent('${param.chkAccess}'),
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
						{field:'check',width:10,align:'center',checkbox:'true'},
						{field:'name',width:20,align:'center',title:'姓名'},
						{field:'sex',width:20,align:'center',title:'性别'},
						{field:'homeTel',width:20,align:'center',title:'手机号'},
						{field:'disDate',width:20,align:'center',title:'出院时间'}
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
				<label for="name">姓名：</label>
				<input type="text" name="name" id="name" style="float:left;"/>
				<label for="sex">性别：</label>
				<select id="sex" name="sex" style="width: 100px;float: left;">
					<option value="9999">请选择</option>
					<option value="1">男</option>
					<option value="2">女</option>
				</select>
				<label for="start">出院时间：</label>
				<input type="text" name="outStart" id="outStart" style="float: left;" class="easyui-validatebox" methodType="chooseDate{dateFmt:'yyyy-MM-dd '}"/>
				<span style="float: left;">~</span>
				<input type="text" name="outEnd" id="outEnd" style="float: left;" class="easyui-validatebox" methodType="chooseDate{dateFmt:'yyyy-MM-dd '}"/>
				<div class="clear"></div>
			</div>
			<div class="datagrid-btn-separator"></div>
			<fs:button key="QUERY" id="QUERY_BTN" name="查询" iconCls="icon-search">
				function query(){
					$('#refreshButton').linkbutton('enable');
					table.datagrid('options').url = '${path}/port/follow!list.qt?chkAccess='+encodeURIComponent('{#chkAccess}');
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