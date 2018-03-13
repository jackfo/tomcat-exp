<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/include/include.jsp"%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<script type="text/javascript" src="${path }/js/easyui/window.js"></script>
		<link rel="stylesheet" type="text/css" href="${path }/css/buttonPanel.css">
		<title>待发短信</title>
		<script type="text/javascript">
			var win,table;
			$(document).ready(function(){
				getColorStyle();
				win = new Jwindow(function(table){table.datagrid('reload');});
				$("#taskNameView").combobox({   
				    data: eval('${taskNames}'),   
				    valueField:'value',   
				    textField:'value',
				    onSelect:function(record){
				    	$('#taskName').val($(record).val());
				    },
				    onChange:function(record){
				    	$('#taskName').val(record);
				    }
				});
				table = $('#dataTable').datagrid({
					url:'${path}/sms/sending!list.qt?chkAccess='+encodeURIComponent('${param.chkAccess}'),
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
						{field:'destAddrs',width:15,title:'手机号码'},
						{field:'sendTime',width:15,title:'发送时间'},
						{field:'content',width:60,title:'短信内容',formatter:function(val,node){return val.replace(/<(.+?)>/gi,"&lt;$1&gt;");}},
						{field:'taskName',width:25,title:'短信类型'}
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
		</script>
	</head>
	<body>
		<div class="buttonPanel">
			<div class="formPanel">
				<label for="destAddr">手机号码：</label>
				<input type="text" name="destAddr" id="destAddr" style="float:left;"/>
				<label for="start">开始时间：</label>
				<span  style="float:left;">
					<input type="text" name="start" id="start" style="" class="easyui-validatebox" methodType="chooseDate{dateFmt:'yyyy-MM-dd HH:mm:ss'}"/>
				</span>
				<label for="end">结束时间：</label>
				<span  style="float:left;">
					<input type="text" name="end" id="end" style="" class="easyui-validatebox" methodType="chooseDate{dateFmt:'yyyy-MM-dd HH:mm:ss'}"/>
				</span>
				<div class="clear"></div>
				<label for="taskName">短信类型：</label>
				<div style="float:left;width: 131px;">
					<input id="taskNameView" name="taskNameView" value="===请选择===" style="float:left;width: 131px;" panelHeight="auto"/>
					<input type="hidden" id="taskName" name="taskName" value=""/>
				</div>
				<div class="clear"></div>
			</div>
			<fs:button key="VIEW" id="VIEW_BTN" name="查阅" iconCls="icon-search">
				function(){
					var rows = table.datagrid('getSelections');
					if(rows&&1!=rows.length)parent.jQuery.messager.alert('错误','对不起！请选择需要查看的一条记录！','error');
					else{
						var index = table.datagrid('getRowIndex',rows[0]);
						win.show('查阅短信','${path}/sms/sending!view.qt?id='+rows[0].id+'&chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum());
						win.reSize(600,280);
					}
				}
			</fs:button>
			<fs:button key="DELETE" id="DELETE_BTN" name="删除" iconCls="icon-no">
				function remove(){
					var rows = table.datagrid('getSelections');
					if(rows && 1>rows.length){ parent.jQuery.messager.alert('错误','对不起！请选择将要删除的一条记录！','error');return;};
					if(rows&&0 < rows.length){
						var ids = '',names = '';
						jQuery.each(rows,function(i,el){
							ids+=','+el.id;
							if(i<10){
								names+=',【'+el.destAddrs+'】';
							}
							if(i==10){
								names+='……';
							}
						});
						ids = ids.replace(/(^[,]*)|([,]*$)/,'');
						names = names.replace(/(^[,]*)|([,]*$)/,'');
						parent.jQuery.messager.confirm('提示','确定删除以下待发号码吗？<br/>'+names,function(b){
							if(b){
								jQuery.ajax({
									async: false,
									type: "GET",
									url: '${path}/sms/sending!delete.qt?id='+encodeURIComponent(ids)+'&chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum(),
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
			<fs:button key="CLEAR" id="CLEAR_BTN" name="数据清空" iconCls="icon-no">
				function clear(){
					var params='&destAddr='+$('#destAddr').val()+'&start='+$('#start').val()+'&end='+$('#end').val()+'&taskName='+encodeURIComponent($('#taskName').val());
					parent.jQuery.messager.confirm('提示','确定要清空当前查询条件下的所有数据吗？',function(b){
						if(b){
							jQuery.ajax({
								async: false,
								type: "GET",
								url: '${path}/sms/sending!clear.qt?chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum()+params,
								success: function(data){
									data = eval(data);
									if(data&&data.b){}else jQuery.messager.alert('错误','清空失败，请刷新页面重试！','error');
									table.datagrid('reload');
									table.datagrid('clearSelections');
								}
							});
						}
					});
				}
			</fs:button>
			<fs:button key="QUERY" id="QUERY_BTN" name="查询" iconCls="icon-search">
				function query(){
					$('#refreshButton').linkbutton('enable');
					table.datagrid('options').url = '${path}/sms/sending!list.qt?mark=${param.mark}'+'&chkAccess='+encodeURIComponent('{#chkAccess}')+'&name='+encodeURIComponent($('#txtSearch').val());
					table.datagrid('options').queryParams = getURLParamsForObj();
					table.datagrid('reload');
					table.datagrid('clearSelections');
				}
			</fs:button>
			<div class="datagrid-btn-separator" style="visibility:hidden;"></div>
			<div class="clear"></div>
		</div>
		<table id="dataTable"></table>
	</body>
</html>