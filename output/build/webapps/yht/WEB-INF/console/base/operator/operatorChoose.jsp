<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/include/include.jsp"%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">    
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<script type="text/javascript" src="${path }/js/easyui/window.js"></script>
		<link rel="stylesheet" type="text/css" href="${path }/css/buttonPanel.css">
		<title>用户选择</title>
		<script type="text/javascript">
			var win,table;
			$(document).ready(function(){
				getColorStyle();
				win = new Jwindow(function(table){table.datagrid('reload');});
				table = $('#dataTable').datagrid({
					url:'${path}/mms/mmSend!chooseOperator.qt?random='+getRandomNum()+'&chkAccess='+encodeURIComponent('${param.chkAccess}'),
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
						{field:'userName',width:150,title:'姓名'},
						{field:'mobile',width:150,title:'手机'}
					]],
					onClickRow:function(i,data){
						//alert(data.mobile);
						var flag = false;
						parent.$('select[name=receivePhones] option').each(function(i,obj){
							if($(obj).val()==data.mobile){
								flag = true;
							}
						});
						if(flag == false && data.mobile !=null)
							parent.$('select[name=receivePhones]').append('<option value='+data.mobile+'>'+data.mobile+'</option>');
					},
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
			function searchUserName(){
				var params = getURLParams();
				table.datagrid('options').url='${path}/mms/mmSend!chooseOperator.qt?chkAccess=${param.chkAccess}&random='+getRandomNum()+params;
				table.datagrid('reload');
				table.datagrid('clearSelections');
			}
			function selectAllUserName(){
				table.datagrid('selectAll');
				var rows = table.datagrid('getSelections');
				for(var j=0;j<rows.length;j++){
					var flag = false;
					parent.$('select[name=receivePhones] option').each(function(i,obj){
						if($(obj).val()==rows[j].mobile){
							flag = true;
						}
					});
					if(flag == false && rows[j].mobile !=null){
						parent.$('select[name=receivePhones]').append('<option value='+rows[j].mobile+'>'+rows[j].mobile+'</option>');
				
					}			
				}	
			}
		</script>
	</head>
	<body style="height: 100%;width: 100%;">
		<div class="buttonPanel">
			<div class="formPanel">
				姓名：<input type="text" name="userName" id="userName" value="" size="10"/>
				<a href="javascript:void(0)" onclick="searchUserName()">查询</a>
				<a href="javascript:void(0)" onclick="selectAllUserName()">全选</a>
				<div class="clear"></div>
			</div>
		</div>
		
		<table id="dataTable"></table>
	</body>
</html>