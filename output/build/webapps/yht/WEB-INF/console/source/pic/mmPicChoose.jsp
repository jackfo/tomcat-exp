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
		<title>彩信图片素材</title>
		<script type="text/javascript">
			var win,table;
			$(document).ready(function(){
				getColorStyle();
				win = new Jwindow(function(table){table.datagrid('reload');});
				table = $('#dataTable').datagrid({
					url:'${path}/source/mmPicBean!list.qt?random='+getRandomNum()+'&chkAccess='+encodeURIComponent('${param.chkAccess}'),
					width:document.body.clientWidth,
					height:document.body.clientHeight-$('.buttonPanel').height()-9,
					idField:'id',
					pagination:true,
					nowrap:true,
					border:false,
					striped:true,
					fitColumns:true,
					rownumbers:true,
					singleSelect:true,
					columns:[[
						{field:'picNewName',width:150,title:'图片名称'}
					]],
					onClickRow:function(i,data){
						var pagePar = parent.$('#pageNo').html();
						var filePath = '${targetDirectory}' + '/' + data.picName;
						parent.parJson[pagePar-1].picture.id=data.id;
						parent.parJson[pagePar-1].picture.name=data.picName;
						parent.parJson[pagePar-1].picture.path=filePath;
						
						parent.$('div[name=picture]:first').empty();
						parent.$('div[name=picture]:first').html('<img name="pic" src="'+CONTEXT_PATH+'/fileDo?random='+getRandomNum()+'&filePath='+filePath+'" style="width: 100%;height: 100%;" />');
						parent.$('div[class=leftMM1]:first').empty();
						parent.$('div[class=leftMM1]:first').html('<img name="pic" src="'+CONTEXT_PATH+'/fileDo?random='+getRandomNum()+'&filePath='+filePath+'" style="width: 100%;height: 100%;" />');
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
				table.datagrid('options').url='${path}/source/mmPicBean!list.qt?chkAccess='+encodeURIComponent('${param.chkAccess}')+'random='+getRandomNum()+params;
				table.datagrid('reload');
				table.datagrid('clearSelections');
			}
		</script>
	</head>
	<body style="height: 100%;width: 100%;">
		<div class="buttonPanel">
			<div class="formPanel">
				<label for="mmPicBean.picTypeId">图片类型：</label>
   				<select id="mmPicBean.picTypeId" name="mmPicBean.picTypeId" onchange="search()">
   					<option value="">--请选择--</option>
					<c:forEach var="mList" items="${mmPicTypeBeanList}">
           			<option value="${mList.picTypeId}">${mList.picTypeName }</option>
          				</c:forEach>
   				</select>
				<div class="clear"></div>
			</div>
		</div>
		<table id="dataTable"></table>
	</body>
</html>