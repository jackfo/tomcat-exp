<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/include/include.jsp"%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<script type="text/javascript" src="${path }/js/easyui/window.js"></script>
		<link rel="stylesheet" type="text/css" href="${path }/css/buttonPanel.css">
		<title>我的彩信</title>
		<script type="text/javascript">
			var win,table;
			$(document).ready(function(){
				getColorStyle();
				win = new Jwindow(function(table){table.datagrid('reload');});
				table = $('#dataTable').datagrid({
					url:'${path}/mms/mmSendTask!myList.qt?chkAccess='+encodeURIComponent('${fs:chkAccess(param.mid,"QUERY")}'),
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
						{field:'check',width:10,checkbox:'true'},
						{field:'subject',width:50,title:'彩信主题'},
						{field:'addTime',width:25,title:'任务提交时间'},
						{field:'sendTime',width:25,title:'定时发送时间'},
						{field:'sendMark',width:15,title:'彩信标示'},
						{field:'status',width:15,title:'审核状态',formatter:function(value,node){return 0==node.status?'未审核':(1==value?'<span style="color:green">审核通过</span>':'<span style="color:red">审核未通过</span>')}}
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
				checkStatus();
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
			
			function checkStatus(){
				if($('#status').val()==1){
					$('#SEND_BTN').css({display:'block'});
				}else{
					$('#SEND_BTN').css({display:'none'});
				}
			}
			
		</script>
	</head>
	<body>
		<div class="buttonPanel">
			<div class="formPanel">
				<label for="templateParamName">彩信主题：</label>
				<input type="text" name="mmSendTask.subject" id="templateSubject" maxlength="50" style="float:left;"/>
				<label for="status">审核状态：</label>
				<select name="mmSendTask.status" id="status" style="float:left;width: 100px;">
					<option value="999">--请选择--</option>
					<option value="0" selected="selected">未审核</option>
					<option value="1">审核通过</option>
					<option value="2">审核未通过</option>
				</select>
				<label for="addTime">提交时间：</label>
				<input type="text" name="addTime1" id="addTime1" class="easyui-validatebox" methodType="chooseDate{dateFmt:'yyyy-MM-dd HH:mm:ss'}" style="float:left;width: 120px;"/>
				<span style="float: left;width: 20px;text-align: center;">~</span>
				<input type="text" name="addTime2" id="addTime2" class="easyui-validatebox" methodType="chooseDate{dateFmt:'yyyy-MM-dd HH:mm:ss'}" style="float:left;width: 120px;"/>
				<div class="clear"></div>
			</div>
			<fs:button key="DELETE" id="DELETE_BTN" name="删除" iconCls="icon-no">
				function remove(){
					var rows = table.datagrid('getSelections');
					if(rows&&0 < rows.length){
						var ids = '',names = '';
						jQuery.each(rows,function(i,el){
							ids+=','+el.id;
							if(i<10){
								names+=',【'+el.id+'】';
							}
							if(i==10){
								names+='……';
							}
						});
						ids = ids.replace(/(^[,]*)|([,]*$)/,'');
						names = names.replace(/(^[,]*)|([,]*$)/,'');
						parent.jQuery.messager.confirm('提示','确定删除'+names+'等模板吗？',function(b){
							if(b){
								jQuery.ajax({
									async: false,
									type: "GET",
									url: '${path}/mms/mmSendTask!delete.qt?id='+encodeURIComponent(ids)+'&chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum(),
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
			<div class="datagrid-btn-separator"></div>
			<fs:button key="VIEW" id="VIEW_BTN" name="彩信预览" iconCls="icon-search">
				function view(){
					var rows = table.datagrid('getSelections');
					if(rows&&1!=rows.length)parent.jQuery.messager.alert('错误','对不起！请选择将要预览的一条记录！','error');
					else{
						win.show('彩信预览','${path}/mms/mmSendTask!view.qt?id='+rows[0].id+'&chkAccess='+encodeURIComponent('${fs:chkAccess(param.mid,"VIEW")}')+'&random='+getRandomNum());
						win.reSize(205,350);
					}
				}
			</fs:button>
			<fs:button key="DESC" id="DESC_BTN" name="查看" iconCls="icon-search">
				function view(){
					var rows = table.datagrid('getSelections');
					if(rows&&1!=rows.length)parent.jQuery.messager.alert('错误','对不起！请选择将要预览的一条记录！','error');
					else{
						win.show('查看结果','${path}/mms/mmSendTask!viewDesc.qt?id='+rows[0].id+'&chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum(),table);
						win.reSize(600,280);
					}
				}
			</fs:button>
			<div class="datagrid-btn-separator"></div>
			<fs:button key="QUERY" id="QUERY_BTN" name="查询" iconCls="icon-search">
				function query(){
					$('#refreshButton').linkbutton('enable');
					table.datagrid('options').url = '${path}/mms/mmSendTask!myList.qt?chkAccess='+encodeURIComponent('{#chkAccess}');
					table.datagrid('options').queryParams = getURLParamsForObj();
					table.datagrid('reload');
					table.datagrid('clearSelections');
					checkStatus();
				}
			</fs:button>
			<div class="clear"></div>
		</div>
		<table id="dataTable"></table>
	</body>
</html>