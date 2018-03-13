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
		<title>短语素材</title>
		<script type="text/javascript">
			var win,table;
			$(document).ready(function(){
				getColorStyle();
				win = new Jwindow(function(table){table.datagrid('reload');});
				table = $('#dataTable').datagrid({
					url:'${path}/sms/template!list.qt?droped=1&chkAccess='+encodeURIComponent('${param.chkAccess}'),
					//url:'${path}/sms/template!list.qt?random='+getRandomNum()+'&chkAccess='+encodeURIComponent('${param.chkAccess}'),
					width:document.body.clientWidth,
					height:document.body.clientHeight-$('.buttonPanel').height()-9,
					idField:'id',
					pagination:true,
					nowrap: true,
					border:false,
					striped:true,
					fitColumns:true,
					rownumbers:true,
					columns:[[
						{field:'content',width:150,title:'内容'}
					]],
					onClickRow:function(i,data){
						var pagePar = parent.$('#pageNo').html();
						var mmContent = parent.$('textarea[name=mmWord]:first').html() + data.content;
						
						parent.parJson[pagePar-1].phrase=mmContent;
						parent.$('textarea[name=mmWord]:first').html(mmContent);
						parent.$('div[class=leftMM2]:first').html(mmContent);
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
			
			function search(){
				var params = getURLParams();
				table.datagrid('options').url='${path}/sms/template!list.qt?droped=1&chkAccess='+encodeURIComponent('${param.chkAccess}')+'&random='+getRandomNum()+params;
				table.datagrid('reload');
				table.datagrid('clearSelections');
			}
		</script>
	</head>
	<body>
		<div class="buttonPanel">
			<div class="formPanel">
				<label for="template.param.id">短语类型：</label>
   				<select id="template.param.id" name="template.param.id" onchange="search()">
   					<option value="">--请选择--</option>
					<c:forEach var="mList" items="${mmPhraseTypeBeanList}">
           			<option value="${mList.id}">${mList.name }</option>
          				</c:forEach>
   				</select>
				<div class="clear"></div>
			</div>
		</div>
		<table id="dataTable"></table>
	</body>
</html>