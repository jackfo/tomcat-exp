<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/include/include.jsp"%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<script type="text/javascript" src="${path }/js/easyui/window.js"></script>
		<link rel="stylesheet" type="text/css" href="${path }/css/buttonPanel.css">
		<title>待发彩信</title>
		<script type="text/javascript">
			var win,table;
			$(document).ready(function(){
				getColorStyle();
				win = new Jwindow(function(table){table.datagrid('reload');});
				table = $('#dataTable').datagrid({
					url:'${path}/mms/mmsWaite!list.qt?random='+getRandomNum(),
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
						{field:'sendTo',width:200,title:'接收号码'},
						{field:'subject',width:200,title:'彩信标题'},
						{field:'sendTime',width:200,title:'发送日期'}
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
				<label for="mmSendBean.sendTo">接收号码：</label>
				<input type="text" name="mmSendBean.sendTo" id="mmSendBean.sendTo" style="float:left;"/>
				<label for="sendTimeStart">发送日期起：</label>
				<input type="text" name="sendTimeStart" id="sendTimeStart" class="easyui-validatebox" methodType="chooseDate{dateFmt:'yyyy-MM-dd HH:mm:ss'}" style="float:left;" readonly="readonly"/>
				<label for="sendTimeEnd">发送日期止：</label>
				<input type="text" name="sendTimeEnd" id="sendTimeEnd" class="easyui-validatebox" methodType="chooseDate{dateFmt:'yyyy-MM-dd HH:mm:ss'}" style="float:left;" readonly="readonly"/>
				<div class="clear"></div>
			</div>
			<!-- 
			<fs:button key="VIEW" id="viewButton" name="查看" iconCls="icon-search">
				function(){
					var rows = table.datagrid('getSelections');
					if(rows && 1!=rows.length){parent.jQuery.messager.alert('错误','对不起！请选择将要查看的一条记录！','error');return;}
					win.show('查看待发彩信','${path}/mms/mmsWaite!view.qt?mmSendBean.id='+rows[0].id+'&chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum(),table);
					win.reSize(500,200);
				}
			</fs:button>
			<div class="datagrid-btn-separator"></div>
			 -->
			<fs:button key="DELETE" id="deleteButton" name="删除" iconCls="icon-remove">
				function(){
					var rows = table.datagrid('getSelections');
					if(rows && 1!=rows.length) parent.jQuery.messager.alert('错误','对不起！请选择将要删除的一条记录！','error');
					else{
						jQuery.messager.confirm('提示','确定删除彩信--<br/>\"接收号码\"：'+rows[0].sendTo+',<br/>\"标题\"：'+rows[0].subject+' 吗？',function(b){
							if(b){
								jQuery.ajax({
									async: false,
									type: "GET",
									url: '${path}/mms/mmsWaite!delete.qt?mmSendBean.id='+rows[0].id+'&chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum(),
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
			<fs:button key="EMPTY" id="emptyButton" name="清空待发彩信" iconCls="icon-remove">
				function(){
					jQuery.messager.confirm('提示','确定要清空待发彩信吗？',function(b){
						if(b){
							jQuery.ajax({
								async: false,
								type: "GET",
								url: '${path}/mms/mmsWaite!empty.qt?chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum(),
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
			</fs:button>
			<div class="datagrid-btn-separator"></div>
			<fs:button key="QUERY" id="queryBtn" name="查询" iconCls="icon-search">
				function(){
					var params = getURLParams();
					$(this).linkbutton({disabled:true});
					table.datagrid('options').url='${path}/mms/mmsWaite!list.qt?chkAccess='+encodeURIComponent('{#chkAccess}')+'random='+getRandomNum()+params;
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