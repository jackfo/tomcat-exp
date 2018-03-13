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
		<title>彩信音乐素材</title>
		<script type="text/javascript">
			var win,table;
			$(document).ready(function(){
				getColorStyle();
				win = new Jwindow(function(table){table.datagrid('reload');});
				table = $('#dataTable').datagrid({
					url:'${path}/source/mmMusicBean!list.qt?random='+getRandomNum(),
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
						{field:'musicNewName',width:200,title:'音乐名称'}
					]],
					onClickRow:function(i,data){
						var pagePar = parent.$('#pageNo').html();
						var filePath = '${targetDirectory}' + '/' + data.musicName;
						parent.parJson[pagePar-1].music.id=data.id;
						parent.parJson[pagePar-1].music.name=data.musicNewName;
						parent.parJson[pagePar-1].music.path=filePath;
					
						parent.$('div[name=mmMusic]:first').empty();
						parent.$('div[name=mmMusic]:first').html(''+data.musicNewName);
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
				table.datagrid('options').url='${path}/source/mmMusicBean!list.qt?chkAccess='+encodeURIComponent('${param.chkAccess}')+'random='+getRandomNum()+params;
				table.datagrid('reload');
				table.datagrid('clearSelections');
			}
		</script>
	</head>
	<body>
		<div class="buttonPanel">
			<div class="formPanel">
				<label for="mmMusicBean.mmMusicTypeId">音乐类型：</label>
   				<select id="mmMusicBean.mmMusicTypeId" name="mmMusicBean.mmMusicTypeId" onchange="search()">
   					<option value="">--请选择--</option>
					<c:forEach var="mList" items="${mmMusicTypeBeanList}">
           			<option value="${mList.musicTypeId}">${mList.musicTypeName }</option>
          				</c:forEach>
   				</select>
				<div class="clear"></div>
			</div>
		</div>
		<table id="dataTable"></table>
	</body>
</html>