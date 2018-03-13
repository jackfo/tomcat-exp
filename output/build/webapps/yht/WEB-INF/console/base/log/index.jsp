<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/include/include.jsp"%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<script type="text/javascript" src="${path }/js/easyui/window.js"></script>
		<link rel="stylesheet" type="text/css" href="${path }/css/buttonPanel.css">
		<title>日志管理</title>
		<style type="text/css">
			*{margin:0px;padding:0px}
			ul{list-style:none;}
			.mytable{padding:5px 5px;}
			input{height:21px;line-height:21px;font-size:9pt;}
			.formField dt,dd{float:left;}
			.buttonPanel .formPanel{margin-left:10px;}
			.buttonPanel .formPanel label{float:left;line-height:28px;width:80px;text-align:right;}
		</style>
		<script type="text/javascript">
			var win,table;
			$(document).ready(function(){
				getColorStyle();
				win = new Jwindow(function(table){});
				table = $('#dataTable').datagrid({
					url:'${path}/base/log!list.qt?chkAccess='+encodeURIComponent('${param.chkAccess}'),
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
						{field:'check',width:10,checkbox:'true'},
						{field:'userName',width:10,title:'操作员'},
						{field:'type',width:10,title:'操作类型'},
						{field:'business',width:10,title:'业务'},
						{field:'date',width:20,title:'时间'},
						{field:'desc',width:50,title:'详情'}
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
			function buttonDisable(){
				$("#queryBtn").linkbutton({disabled:false});
			}
		</script>
	</head>
	<body>
		<div class="buttonPanel">
			<div class="formPanel">
				<label for="logger.operatorName">操作员：</label>
				<input type="text" name="logger.operatorName" id="logger.operatorName" maxlength="50" style="float:left;"/>
				<label for="logger.operateType">操作类型：</label>
				<input type="text" name="logger.operateType" id="logger.operateType" style="float:left;"/>
				<label for="logger.operateBusiness">业务：</label>
				<input type="text" name="logger.operateBusiness" id="logger.operateBusiness" style="float:left;"/>
				<div class="clear"></div>
			</div>
			<div class="datagrid-btn-separator" style="visibility:hidden;"></div>
			<fs:button key="DELETE" id="deleteBtn" name="删除" iconCls="icon-no">
				function remove(){
					var rows = table.datagrid('getSelections');
					if(rows && 1>rows.length) {parent.jQuery.messager.alert('错误','对不起！请选择将要删除的一条记录！','error');return;}
					if(rows&&0 < rows.length){
						var ids = '',names = '',_ids = '';
						jQuery.each(rows,function(i,el){
							ids+=','+el.id;
							if(i<10){
								_ids+=el.id+',';
							}
							if(i==10){
								_ids+='……';
							}
						});
						ids = ids.replace(/(^[,]*)|([,]*$)/,'');
						parent.jQuery.messager.confirm('提示','确定删除日志吗？',function(b){
							if(b){
								jQuery.ajax({
									async: false,
									type: "GET",
									url: '${path}/base/log!delete.qt?id='+encodeURIComponent(ids)+'&chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum(),
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
			<fs:button key="QUERY" id="queryBtn" name="查询" iconCls="icon-search">
				function(){
					var params = getURLParams();
					$(this).linkbutton({disabled:true});
					table.datagrid('options').url='${path}/base/log!list.qt?random='+getRandomNum()+params;
					table.datagrid('reload');
					table.datagrid('clearSelections');
					setTimeout("buttonDisable()",BUTTON_WAIT_TIME);
				}
			</fs:button>
			<fs:button key="SYSLOG" id="SYSLOG_btn" name="后台日志文件下载" iconCls="icon-print">
				function(){
					win.show('系统日志下载','${path}/base/log!preDownSysLog.qt?chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum(),table);
					win.reSize(500,270);
				}
			</fs:button>
			<div class="clear"></div>
		</div>
		<table id="dataTable"></table>
	</body>
</html>