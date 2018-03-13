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
					url:'${path}/hospital/child!childrenList.qt?type=list&chkAccess='+encodeURIComponent('${param.chkAccess}'),
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
						{field:'ck',checkbox:true,width:100},
						{field:'name',width:80,title:'儿童姓名'},
						{field:'parentName',width:80,title:'家长'},
						{field:'phone',width:100,title:'家长电话'},
						{field:'age',width:50,title:'年龄'},
						{field:'startTime',width:150,title:'开始接种时间'},
						{field:'birthday',width:150,title:'出生日期'},
						{field:'isMessage',width:80,align:'center',title:'短信提醒',formatter:function(value,node){return typeof(value)=='undefined'||value==1?'是':'否'}},
						{field:'vaccineType',width:200,title:'疫苗类型'},
						{field:'addr',width:200,title:'住址'},
						{field:'messageDesc',width:200,title:'描述'}
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
			function query(){
					table.datagrid('options').queryParams = {'txtSearch':$('#txtSearch').val(),'inStart':$('#inStart').val(),'inEnd':$('#inEnd').val(),'outStart':$('#outStart').val(),'outEnd':$('#outEnd').val()};
				table.datagrid('reload');
				table.datagrid('clearSelections');
			}
			function fixedChoose(){
				var win = parent.win;
				var rows = table.datagrid('getSelections');
				if(rows&&0==rows.length)parent.jQuery.messager.alert('错误','对不起！请至少选择一条记录！','error');
				else if(win!=''){
					if(win&&win.refreshParent){
						var mobiles='';
						var rowlen=rows.length;
						for(var i=0;i<rowlen;i++){
							if(parent.choosePerson){
								var temp = parent.choosePerson(rows[i]);
								if(temp&&temp!='') mobiles+=','+temp;
							}else if(mobiles.indexOf(rows[i].phone)==-1)
								mobiles+=','+rows[i].phone;
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
				if(win!=''){
					if(win&&win.refreshParent){
						jQuery.ajax({
							async: false,
							type: "GET",
							url: '${path}/hospital/child!childrenList.qt?type=all&chkAccess='+encodeURIComponent('${param.chkAccess}')+params,
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
			<a href="javascript:query()" class="easyui-linkbutton" plain="false" iconCls="icon-search" style="margin-right:10px">查询</a>
			<input type="text" id="txtSearch" name="txtSearch" title="请输入要查询的关键字" style="float:left;margin-top:2px;margin-right:10px"/>
			<label for="start">开始接种时间：</label>
			<input type="text" name="inStart" id="inStart" class="easyui-validatebox" methodType="chooseDate{dateFmt:'yyyy-MM-dd '}"/>
				<input type="text" name="inEnd" id="inEnd" class="easyui-validatebox" methodType="chooseDate{dateFmt:'yyyy-MM-dd '}"/>
			</br>
			<label for="start" style="text-align: right;width: 227px;">出&nbsp;&nbsp;&nbsp;生&nbsp;&nbsp;&nbsp;日&nbsp;&nbsp;期：</label>
				<input type="text" name="outStart" id="outStart" style="" class="easyui-validatebox" methodType="chooseDate{dateFmt:'yyyy-MM-dd '}"/>
				<input type="text" name="outEnd" id="outEnd" style="" class="easyui-validatebox" methodType="chooseDate{dateFmt:'yyyy-MM-dd '}"/>
			<div class="clear"></div>
		</div>
		<table id="dataTable"></table>
	</body>
</html>