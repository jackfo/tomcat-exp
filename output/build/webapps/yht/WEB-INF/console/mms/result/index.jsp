<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/include/include.jsp"%>     
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>已发彩信统计</title>
<script type="text/javascript" src="${path }/js/easyui/window.js"></script>
<link rel="stylesheet" type="text/css" href="${path }/css/buttonPanel.css">
<style>
	*{margin:0px;padding:0px}
	ul{list-style:none;}
	.mytable{padding:5px 5px;}
	input{height:21px;line-height:21px;font-size:9pt;}
	.formField dt,dd{float:left;}
	.buttonPanel .formPanel{margin-left:10px;}
	.buttonPanel .formPanel label{float:left;line-height:28px;width:80px;text-align:right;}
</style>
<script type="text/javascript">
<!--
	var win,table; 
	$(document).ready(function(){
		getColorStyle();
		win = new Jwindow(function(table){table.datagrid('reload');});
		table=$("#dataList").datagrid({
			width:'100%',
			height:document.body.clientHeight-$('.buttonPanel').height()-9,
			nowrap: true,
			fitColumns:true,
			striped: true,
			collapsible:false,
			url:'${path}/mms/mmsResult!list.qt?random='+getRandomNum()+'&chkAccess='+encodeURIComponent('${param.chkAccess }'),
			border:false,
			pagination:true,
			rownumbers:true,
			remoteSort: false,
			sortName: 'id',
			sortOrder: 'asc',
			idField:'id',
			clickSingleSelect:true,
			columns:[[
				{title:'源地址',field:'vasId',width:105},
				{title:'目的地址',field:'sendTo',width:90},
				{title:'彩信主题',field:'subject',width:280},
				{title:'发送时间',field:'sentTime',width:130},
				{title:'彩信类型',field:'reserve2',width:100},
				{title:'发送状态',field:'msg_status',width:80,formatter:function(value,node){return 0==value?'<span style="color:green">失败</span>':(1==value?'成功':'未知')}},
				{title:'接收状态',field:'recv_status',width:80,formatter:function(value,node){return 0==value?'<span style="color:green">失败</span>':(1==value?'成功':'未知')}},
				{title:'接收时间',field:'recv_time',width:130}
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
//-->	
</script>
</head>
<body>
	<div class="buttonPanel">
		<div class="formPanel">
			<label for="result.vasId">源地址：</label>
			<input type="text" name="result.vasId" id="result.vasId" maxlength="21" style="float:left;"/>
			<label for="start">开始时间：</label>
			<span  style="float:left;">
				<input type="text" name="start" id="start" class="easyui-validatebox" methodType="chooseDate{dateFmt:'yyyy-MM-dd HH:mm:ss'}"/>
			</span>
			<label for="end">结束时间：</label>
			<span  style="float:left;">
				<input type="text" name="end" id="end" class="easyui-validatebox" methodType="chooseDate{dateFmt:'yyyy-MM-dd HH:mm:ss'}"/>
			</span>
			<div class="clear"></div>
			<label for="result.sendTo">目的地址：</label>
			<input type="text" name="result.sendTo" id="result.sendTo" style="float:left;" maxlength="15"/>
			<label for="result.reserve2">彩信类型：</label>
			<input type="text" name="result.reserve2" id="result.reserve2" maxlength="21" style="float:left;"/>
			<label for="result.msg_status">发送状态：</label>
			<select name="result.msg_status" id="result.msg_status" style="float:left;">
				<option value="999">--请选择--</option>
				<option value="0">失败</option>
				<option value="1">成功</option>
				<option value="2">未知</option>
			</select>
			<label for="result.recv_status">接收状态：</label>
			<select name="result.recv_status" id="result.recv_status" style="float:left;">
				<option value="999">--请选择--</option>
				<option value="0">失败</option>
				<option value="1">成功</option>
				<option value="2">未知</option>
			</select>
			<div class="clear"></div>
		</div>
		<fs:button key="DOWNLOAD" id="downloadBtn" name="导出彩信" iconCls="icon-search">
			function(){
				function returnValue(a){
					return document.getElementById(a).value;
				}
				var data='result.vasId='+encodeURIComponent(returnValue('result.vasId'))
				+'&result.sendTo='+encodeURIComponent(returnValue('result.sendTo'))
				+'&start='+returnValue('start')
				+'&end='+returnValue('end')
				+'&result.reserve2='+encodeURIComponent(returnValue('result.reserve2'))
				+'&result.msg_status='+returnValue('result.msg_status')
				+'&result.recv_status='+returnValue('result.recv_status');
				$(this).linkbutton({disabled:true});
				location.href='${path}/mms/mmsResult!downloadMms.qt?'+data+'&chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum();
				$(this).linkbutton({disabled:false});
				$('#queryBtn').click();
			}
		</fs:button>
		<fs:button key="DOWNLOADYEAR" id="downloadYearBtn" name="导出已发彩信年度统计" iconCls="icon-search">	
			function(){
				win.show('导出已发彩信年度统计','${path}/mms/mmsResult!preDownloadYear.qt?chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum(),table);
				win.reSize(450,250);
			}
		</fs:button>
		<div class="datagrid-btn-separator"></div>
		<fs:button key="QUERY" id="queryBtn" name="查询" iconCls="icon-search">
			function(){
				if($(this).linkbutton('options').disabled) return;
				var params = getURLParams();
				$(this).linkbutton({disabled:true});
				table.datagrid('options').url='${path}/mms/mmsResult!list.qt?random='+getRandomNum()+'&chkAccess='+encodeURIComponent('{#chkAccess}');
				table.datagrid('options').queryParams=getURLParamsForObj();
				table.datagrid('reload');
				table.datagrid('clearSelections');
				setTimeout("buttonDisable()",BUTTON_WAIT_TIME);
			}
		</fs:button>
		<div class="clear"></div>
	</div>
	<table id="dataList"></table>
</body>
</html>
