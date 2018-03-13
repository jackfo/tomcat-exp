<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/include/include.jsp"%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
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
					clickSingleSelect:true,
					columns:[[
						{field:'ck',checkbox:true,width:100},
						{field:'musicByName',width:200,title:'原音乐名称'},
						{field:'musicNewName',width:200,title:'自定义音乐名称'},
						{field:'musicName',width:200,title:'音乐加工(上传于缓存)后的名称'},
						{field:'upTime',width:200,title:'上传时间'}
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
			
			function buttonDisable(){
				$("#queryBtn").linkbutton({disabled:false});
			}
		</script>
	</head>
	<body>
		<div class="buttonPanel">
			<div class="formPanel">
				<label for="mmMusicBean.musicNewName" style="width: 100">自定义音乐名称：</label>
				<input type="text" name="mmMusicBean.musicNewName" id="mmMusicBean.musicNewName" style="float:left;"/>
				<label for="mmMusicBean.mmMusicTypeId">音乐类型：</label>
   				<select id="mmMusicBean.mmMusicTypeId" name="mmMusicBean.mmMusicTypeId">
   					<option value="">==请选择音乐类型==</option>
					<c:forEach var="mList" items="${mmMusicTypeBeanList}">
           			<option value="${mList.musicTypeId}">${mList.musicTypeName }</option>
          				</c:forEach>
   				</select>
				<div class="clear"></div>
			</div>
			<fs:button key="NEWADD" id="addButton" name="新增" iconCls="icon-add">
				function(){
					win.show('新增彩信音乐素材','${path}/source/mmMusicBean!preAdd.qt?chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum(),table);
					win.reSize(500,200);
				}
			</fs:button>
			<fs:button key="MODIFY" id="modifyButton" name="修改" iconCls="icon-edit">
				function(){
					var rows = table.datagrid('getSelections');
					if(rows && 1!=rows.length){parent.jQuery.messager.alert('错误','对不起！请选择将要修改的一条记录！','error');return;}
					win.show('修改彩信音乐素材','${path}/source/mmMusicBean!preModify.qt?mmMusicBean.id='+rows[0].id+'&chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum(),table);
					win.reSize(500,350);
				}
			</fs:button>
			<fs:button key="DELETE" id="deleteButton" name="删除" iconCls="icon-remove">
				function(){
					var rows = table.datagrid('getSelections');
					if(rows && 1!=rows.length) parent.jQuery.messager.alert('错误','对不起！请选择将要删除的一条记录！','error');
					else{
						jQuery.messager.confirm('提示','确定删除彩信音乐素材: \"'+rows[0].musicNewName+'\" 吗？',function(b){
							if(b){
								jQuery.ajax({
									async: false,
									type: "GET",
									url: '${path}/source/mmMusicBean!delete.qt?mmMusicBean.id='+rows[0].id+'&chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum(),
									success: function(data){
										data = eval(data);
										if(data&&data.b){}else jQuery.messager.alert('错误','删除失败，请刷新页面重试！','error');
										table.datagrid('reload');
										table.datagrid('clearSelections');
									}
								});
							}
						});
					}
				}
			</fs:button>
			<fs:button key="VIEW" id="viewButton" name="查看" iconCls="icon-search">
				function(){
					var rows = table.datagrid('getSelections');
					if(rows && 1!=rows.length){parent.jQuery.messager.alert('错误','对不起！请选择将要查看的一条记录！','error');return;}
					win.show('查看彩信音乐素材','${path}/source/mmMusicBean!view.qt?mmMusicBean.id='+rows[0].id+'&chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum(),table);
					win.reSize(500,380);
				}
			</fs:button>
			<div class="datagrid-btn-separator"></div>
			<fs:button key="QUERY" id="queryBtn" name="查询" iconCls="icon-search">
				function(){
					var params = getURLParams();
					$(this).linkbutton({disabled:true});
					table.datagrid('options').url='${path}/source/mmMusicBean!list.qt?chkAccess='+encodeURIComponent('{#chkAccess}')+'random='+getRandomNum()+params;
					table.datagrid('reload');
					table.datagrid('clearSelections');
					setTimeout("buttonDisable()",BUTTON_WAIT_TIME);
				}
			</fs:button>
			<div class="datagrid-btn-separator" style="visibility:hidden;"></div>
			<div class="clear"></div>
		</div>
		<table id="dataTable"></table>
	</body>
</html>