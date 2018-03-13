<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/include/include.jsp"%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<script type="text/javascript" src="${path }/js/easyui/window.js"></script>
		<link rel="stylesheet" type="text/css" href="${path }/css/buttonPanel.css">
		<title>已收短信统计</title>
		<script type="text/javascript">
			var win,table;
			$(document).ready(function(){
				getColorStyle();
				win = new Jwindow(function(table){table.datagrid('reload');});
				table = $('#dataTable').datagrid({
					url:'${path}/sms/received!list.qt?chkAccess='+encodeURIComponent('${param.chkAccess}')+'&sort='+${sort },
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
						{field:'orgAddr',width:15,title:'手机号码'},
						{field:'recvTime',width:15,title:'接收时间'},
						{field:'content',width:60,title:'短信内容',formatter:function(val,node){return val.replace(/<(.+?)>/gi,"&lt;$1&gt;");}},
						{field:'reverted',width:10,title:'状态',formatter:function(val,node){
							if(node.readed&&node.readed=='1'){}
							var str = '';
							if(node&&node.readed&&node.readed=='1')str='已读';
							if(val&&val=='1')str='已回复';
							return '<b style="color:red">'+str+'</b>';
						}}
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
				<label for="received.smOrgAddr">手机号码：</label>
				<input type="text" name="received.smOrgAddr" id="received.smOrgAddr" style="float:left;"/>
				<label for="start">开始时间：</label>
				<span  style="float:left;">
					<input type="text" name="start" id="start" class="easyui-validatebox" methodType="chooseDate{dateFmt:'yyyy-MM-dd HH:mm:ss'}"/>
				</span>
				<label for="end">结束时间：</label>
				<span  style="float:left;">
					<input type="text" name="end" id="end" class="easyui-validatebox" methodType="chooseDate{dateFmt:'yyyy-MM-dd HH:mm:ss'}"/>
				</span>
				<input type="hidden" name="sort" id="sort" value="${sort }" />
				<div class="clear"></div>
			</div>
			<fs:button key="DOWNLOAD" id="downloadBtn" name="导出短信" iconCls="icon-print">
				function(){
					function returnValue(a){
						return document.getElementById(a).value;
					}
					var data='received.smOrgAddr='+encodeURIComponent(returnValue('received.smOrgAddr'))
					+'&start='+returnValue('start')
					+'&end='+returnValue('end')
					+'&sort='+$('#sort').val();
					$(this).linkbutton({disabled:true});
					location.href='${path}/sms/received!downloadSms.qt?'+data+'&chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum();
					$(this).linkbutton({disabled:false});
					$('#QUERY_BTN').click();
				}
			</fs:button>
			<fs:button key="DOWNLOADYEAR" id="downloadYearBtn" name="导出年度统计" iconCls="icon-print">	
				function(){
					win.show('导出年度统计','${path}/sms/received!preDownloadYear.qt?chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum(),table);
					win.reSize(450,250);
				}
			</fs:button>
			<fs:button key="VIEW" id="VIEW_BTN" name="查看已收短信" iconCls="icon-ok">
				function(){
					var rows = table.datagrid('getSelections');
					if(rows&&1!=rows.length)parent.jQuery.messager.alert('错误','对不起！请选择需要查看的一条记录！','error');
					else{
						var index = table.datagrid('getRowIndex',rows[0]);
						win.show('查看已收短信','${path}/sms/received!view.qt?id='+rows[0].id+'&chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum(),table);
						win.reSize(600,280);
					}
				}
			</fs:button>
			<fs:button key="REPLY" id="replyButton" name="短信回复" iconCls="icon-add">
				function(){
					var rows = table.datagrid('getSelections');
					if(rows && 1!=rows.length){parent.jQuery.messager.alert('错误','对不起！请选择将要回复的一条记录！','error');return;}
					win.show('短信回复','${path}/sms/received!preReply.qt?orgAddr='+rows[0].orgAddr+'&chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum()+'&mid=${param.mid}',table);
					win.reSize(600,400);
				}
			</fs:button>
			<div class="datagrid-btn-separator"></div>
			<fs:button key="QUERY" id="QUERY_BTN" name="查询" iconCls="icon-search">
				function query(){
					$('#refreshButton').linkbutton('enable');
					table.datagrid('options').url = '${path}/sms/received!list.qt?mark=${param.mark}'+'&chkAccess='+encodeURIComponent('{#chkAccess}')+'&name='+encodeURIComponent($('#txtSearch').val());
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