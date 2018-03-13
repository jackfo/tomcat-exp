<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/include/include.jsp"%>     
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>已发短信统计</title>
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
		$("#smReserve2").combobox({   
		    data: eval('${taskNames}'),   
		    valueField:'value',   
		    textField:'value'
		});  
		table=$("#dataList").datagrid({
			width:'100%',
			height:document.body.clientHeight-$('.buttonPanel').height()-9,
			nowrap: true,
			fitColumns:true,
			striped: true,
			collapsible:false,
			url:'${path}/sms/result!list.qt?random='+getRandomNum()+'&chkAccess='+encodeURIComponent('${param.chkAccess }'),
			border:false,
			pagination:true,
			rownumbers:true,
			remoteSort: false,
			sortName: 'id',
			sortOrder: 'asc',
			idField:'id',
			clickSingleSelect:true,
			columns:[[
				{title:'源地址',field:'orgAddr',width:150},
				{title:'目的地址',field:'destAddr',width:90},
				{title:'短信内容',field:'smContent',width:280,formatter:function(val,node){return val.replace(/<(.+?)>/gi,"&lt;$1&gt;");}},
				{title:'发送时间',field:'sendTime',width:130},
				{title:'短信类型',field:'taskName',width:100},
				{title:'发送状态',field:'msgSatus',width:60,formatter:function(value,node){return 0==value?'<span style="color:green">成功</span>':(1==value?'失败':'未知')}},
				{title:'接收状态',field:'recvStatus',width:60,formatter:function(value,node){return 0==value?'<span style="color:green">成功</span>':(1==value?'失败':'未知')}},
				{title:'接收时间',field:'recvTime',width:130}
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
	function buttonDisable_down(){
		$("#downloadBtn").linkbutton({disabled:false});
	}
	function buttonDisable_downYear(){
		$("#downloadYearBtn").linkbutton({disabled:false});
	}
//-->	
</script>
</head>
<body>
	<div class="buttonPanel">
		<div class="formPanel">
			<label for="result.smOrgAddr">源地址：</label>
			<input type="text" name="result.smOrgAddr" id="smOrgAddr" maxlength="21" style="float:left;"/>
			<label for="start">开始时间：</label>
			<span  style="float:left;">
				<input type="text" name="start" id="start" class="easyui-validatebox" methodType="chooseDate{dateFmt:'yyyy-MM-dd HH:mm:ss'}"/>
			</span>
			<label for="end">结束时间：</label>
			<span  style="float:left;">
				<input type="text" name="end" id="end" class="easyui-validatebox" methodType="chooseDate{dateFmt:'yyyy-MM-dd HH:mm:ss'}"/>
			</span>
			<div class="clear"></div>
			<label for="result.smDestAddrs">目的地址：</label>
			<input type="text" name="result.smDestAddrs" id="smDestAddrs" style="float:left;" maxlength="15"/>
			<label for="result.smReserve2">短信类型：</label>
			<div style="float:left;width: 120px;">
				<input id="smReserve2" name="result.smReserve2" value="===请选择===" panelHeight="auto"/>
			</div>
			<label for="result.smMsgStatus">发送状态：</label>
			<select name="result.smMsgStatus" id="smMsgStatus" style="float:left;">
				<option value="999">--请选择--</option>
				<option value="0">成功</option>
				<option value="1">失败</option>
				<option value="2">未知</option>
			</select>
			<label for="result.smRecvStatus">接收状态：</label>
			<select name="result.smRecvStatus" id="smRecvStatus" style="float:left;">
				<option value="999">--请选择--</option>
				<option value="0">成功</option>
				<option value="1">失败</option>
				<option value="2">未知</option>
			</select>
			<div class="clear"></div>
		</div>
		<fs:button key="DOWNLOAD" id="downloadBtn" name="导出查询短信" iconCls="icon-print">
			function(){
				var data='result.smOrgAddr='+encodeURIComponent($('#smOrgAddr').val())
				+'&result.smDestAddrs='+encodeURIComponent($('#smDestAddrs').val())
				+'&start='+$('#start').val()
				+'&end='+$('#end').val()
				+'&result.smReserve2='+encodeURIComponent($('#smReserve2').combobox('getValue'))
				+'&result.smMsgStatus='+$('#smMsgStatus').val()
				+'&result.smRecvStatus='+$('#smRecvStatus').val();
				
				$(this).linkbutton({disabled:true});
				location.href='${path}/sms/result!downloadSms.qt?'+data+'&chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum();
				$(this).linkbutton({disabled:false});
				$('#queryBtn').click();
			}
		</fs:button>
		<fs:button key="DOWNLOADYEAR" id="downloadYearBtn" name="导出年度统计" iconCls="icon-print">	
			function(){
				win.show('导出年度统计','${path}/sms/result!preDownloadYear.qt?chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum(),table);
				win.reSize(600,400);
			}
		</fs:button>
		<div class="datagrid-btn-separator"></div>
		<fs:button key="QUERY" id="queryBtn" name="查询" iconCls="icon-search">
			function(){
				if($(this).linkbutton('options').disabled) return;
				$(this).linkbutton({disabled:true});
				table.datagrid('options').url='${path}/sms/result!list.qt?random='+getRandomNum()+'&chkAccess='+encodeURIComponent('{#chkAccess}');
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
