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
		<title>通讯录选择</title>
		<script type="text/javascript">
			var win,table;
			$(document).ready(function(){
				getColorStyle();
				win = new Jwindow(function(table){table.datagrid('reload');});
				table = $('#dataTable').datagrid({
					url:'${path}/mms/mmSend!chooseAddressBook.qt?random='+getRandomNum()+'&chkAccess='+encodeURIComponent('${param.chkAccess}')+'&conGroup.id='+$('#conGroup_id').val(),
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
						{field:'name',width:150,title:'姓名'},
						{field:'phone',width:150,title:'手机'}
					]],
					onClickRow:function(i,data){
					//alert(data.phone);
						var flag = false;
						parent.$('select[name=receivePhones] option').each(function(i,obj){
							if($(obj).val()==data.phone){
								flag = true;
							}
						});
						if(flag == false && data.phone !=null)
							parent.$('select[name=receivePhones]').append('<option value='+data.phone+'>'+data.phone+'</option>');
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
			
			function searchPersonName(){
				//var params = getURLParams();
				table.datagrid('options').url='${path}/mms/mmSend!chooseAddressBook.qt?chkAccess=${param.chkAccess}&random='+getRandomNum()+'&conGroup.id='+$('#conGroup_id').val();
				table.datagrid('reload');
				table.datagrid('clearSelections');
			}
			
			function selectAllPersonName(){
				table.datagrid('selectAll');
				var rows = table.datagrid('getSelections');
				for(var j=0;j<rows.length;j++){
					var flag = false;
					parent.$('select[name=receivePhones] option').each(function(i,obj){
						if($(obj).val()==rows[j].phone){
							flag = true;
						}
					});
					if(flag == false && rows[j].phone !=null){
						parent.$('select[name=receivePhones]').append('<option value='+rows[j].phone+'>'+rows[j].phone+'</option>');
				
					}			
				}	
			}
		</script>
	</head>
	<body style="height: 100%;width: 100%;">
		<div class="buttonPanel">
			<div class="formPanel">
				通讯录分组：
				<select id="conGroup_id" name="conGroup_id" onchange="searchPersonName()">
					<option value="">==请选择==</option>
					<c:forEach var="list" items="${conGroupList}">
					<option value="${list.id}">${list.name}</option>
					</c:forEach>
				</select>
				<a href="javascript:void(0)" onclick="selectAllPersonName()">全选</a>
				<div class="clear"></div>
			</div>
		</div>
		<table id="dataTable"></table>
	</body>
</html>