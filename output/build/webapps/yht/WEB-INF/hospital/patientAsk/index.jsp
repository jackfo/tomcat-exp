<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/include/include.jsp"%>     
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>患者咨询服务</title>
<script type="text/javascript" src="${path }/js/easyui/window.js"></script>
<script type="text/javascript" src="${path }/js/easyui/plugins/jquery.portal.js"></script>
<link rel="stylesheet" type="text/css" href="${path }/css/buttonPanel.css" />
<link rel="stylesheet" type="text/css" href="${path }/js/easyui/themes/gray/portal.css" />
<style>
	*{margin:0px;padding:0px}
	.linkTitle{width: 20px;height: 20px;background: url(${path}/images/tabicons.gif) no-repeat -20px -140px;vertical-align: middle;}
	.dbIcon{width: 20px;height: 20px;background: url(${path}/images/tabicons.gif) no-repeat 0px -140px;vertical-align: middle;}
	#titleDesc{width: 100%;height: 40px;overflow: hidden;}
	#titleDesc .title{height: 40px;line-height: 40px;font-family: 黑体;font-size: 25px;color: black;font-weight: bold;padding-left: 50px;float: left;}
	#titleDesc .desc{height: 40px;line-height: 40px;font-family: 宋体;font-size: 12px;color: red;padding-left: 10px;float: left;}
	#optButton{width: 100%;height: 35px;overflow: hidden;}
	.buttonPanel .formPanel{margin-left:10px;}
	.buttonPanel .formPanel label{float:left;line-height:28px;width:80px;text-align:right;}
	.fl{float: left;}
	.fr{float: right;}
	.lab{height: 25px;line-height: 25px;}
	.ipt{width: 190px;height: 25px;line-height: 25px;border: 0px solid #E5EEFF;background-color: #E5EEFF;overflow: hidden;}
	.dbcs{width: 20px;width: 21px\9;height: 19px;height: 21px\9;vertical-align: middle;border: 1px solid #99BBE8;margin: 2px 5px 0px 0px;border-left: 0px;text-align: center;overflow: hidden;cursor: pointer;}
</style>
<script type="text/javascript">
<!--
	var win,table,accordion; 
	$(document).ready(function(){
		getColorStyle();
		
		viewTableFields();
		setDataList();
	});
	
	/**已发短信*/
	function　setDataList(){
		table=$("#dataList").datagrid({
			width:document.body.clientWidth/2-100,
			height:document.body.clientHeight-$('.buttonPanel').height()-19,
			nowrap: true,
			fitColumns:true,
			striped: true,
			collapsible:false,
			url:'${path}/sms/result!list2.qt?random='+getRandomNum()+'&chkAccess='+encodeURIComponent('${fs:chkAccess(param.mid,"QUERY")}'),
			border:false,
			pagination:true,
			rownumbers:true,
			remoteSort: false,
			sortName: 'id',
			sortOrder: 'asc',
			idField:'id',
			clickSingleSelect:true,
			columns:[[
				{title:'手机号码',field:'destAddr',width:30},
				{title:'发送时间',field:'sendTime',width:30},
				{title:'短信内容',field:'smContent',width:100,formatter:function(val,node){return val.replace(/<(.+?)>/gi,"&lt;$1&gt;");}}
			]]
		});
	}
	
	/**已收短信*/
	function viewTableFields(){
				win = new Jwindow(function(table){table.datagrid('reload');});
				table = $('#dataTable').datagrid({
					url:'${path}/sms/received!list2.qt?chkAccess='+encodeURIComponent('${fs:chkAccess(param.mid,"QUERY")}'),
					width:document.body.clientWidth/2+90,
					height:document.body.clientHeight-$('.buttonPanel').height()-19,
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
						{field:'orgAddr',width:20,title:'手机号码'},
						{field:'recvTime',width:20,title:'接收时间',formatter:function(value,row){return value.length<11?value:value.substring(0,10)}},
						{field:'content',width:40,title:'短信内容',formatter:function(val,node){return val.replace(/<(.+?)>/gi,"&lt;$1&gt;");}},
						{field:'reverted',width:10,title:'状态',formatter:function(val,node){
							if(node.readed&&node.readed=='1'){}
							var str = '';
							if(node&&node.readed&&node.readed=='1'){
								str='已读';
							}
							if(val&&val=='back'){
								str='已回复';
							}
							return '<b style="color:red">'+str+'</b>';
						}},
						{field:'orgAddr1',width:35,title:'描述',formatter:function(val,row){return information(row.orgAddr);}}
					]],
					onHeaderContextMenu: function(e, field){
						e.preventDefault();
						if (!$('#tmenu').length){
							createColumnMenu( $('#dataTable'));
						}
						$('#tmenu').menu('show', {
							left:e.pageX,
							top:e.pageY
						});
					}
				});
	}
	
	
    function querySend(){
    		var table = $("#dataList");
			table.datagrid('options').url='${path}/sms/result!list2.qt?chkAccess='+encodeURIComponent('${fs:chkAccess(param.mid,"QUERY")}')+'&random='+getRandomNum();
			table.datagrid('options').queryParams = {'smOrgAddr':$('#smOrgAddr').val(),'start':$('#start').val(),'end':$('#end').val()};
			table.datagrid('reload');
			table.datagrid('clearSelections');
		}
   function  queryReceive(){
   			var table = $("#dataTable");
			table.datagrid('options').url='${path}/sms/received!list2.qt?chkAccess='+encodeURIComponent('${fs:chkAccess(param.mid,"QUERY")}')+'&random='+getRandomNum();
			table.datagrid('options').queryParams = {'smOrgAddr':$('#smOrgAddr').val(),'start':$('#start').val(),'end':$('#end').val()};
			table.datagrid('reload');
			table.datagrid('clearSelections');
   }
   /**调用两个方法查询发送接收信息*/
   function query(){
	   	querySend();
	   	queryReceive();
   }
   /**查询患者信息*/
   function information(el){
	   var phone = el;
	   var value='';
	   var obj;
	   jQuery.ajax({
			async: false,
			type: "GET",
			url: '${path}/sms/received!findInformation.qt?chkAccess='+encodeURIComponent('${fs:chkAccess(param.mid,"QUERY")}')+'&orgAddr='+phone+'&random='+getRandomNum(),
			success: function(data){
					obj = eval("("+data+")");
					value = obj.patientDesc;
				}
			});
			return value;
   }
//-->	
</script>
</head>
<body class="easyui-layout">
	<!-- 头部 -->
	<div region="north"  class="buttonPanel" title=""  style="height:60px;overflow: hidden;">
		<label for="received.smOrgAddr">手机号码：</label>
			<input type="text" name="smOrgAddr" id="smOrgAddr" />
		<label for="start">开始时间：</label>
			<input type="text" name="start" id="start" class="easyui-validatebox" methodType="chooseDate{dateFmt:'yyyy-MM-dd HH:mm:ss'}"/>
		<label for="end">结束时间：</label>
			<input type="text" name="end" id="end" class="easyui-validatebox" methodType="chooseDate{dateFmt:'yyyy-MM-dd HH:mm:ss'}"/>
		<div class="clear"></div>
		<div class="datagrid-btn-separator"></div>
		<fs:button key="QUERY" id="queryBtn" name="查询" iconCls="icon-search">
			function(){
				if($(this).linkbutton('options').disabled) return;
				query();
			}
		</fs:button>
		<fs:button key="REPLY" id="replyButton" name="短信回复" iconCls="icon-add">
				function(){
					var rows = $('#dataTable').datagrid('getSelections');
					if(rows && 1!=rows.length){parent.jQuery.messager.alert('错误','对不起！请选择将要回复的一条记录！','error');return;}
					win.show('短信回复','${path}/sms/received!preReply2.qt?orgAddr='+rows[0].orgAddr+'&sid='+rows[0].id+'&chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum()+'&mid=${param.mid}',table);
					win.reSize(600,400);
				}
		</fs:button>
		<div class="clear"></div>
	</div>
	<div region="west" split="fasle"  style="width:700px;overflow: hidden;">
		<table id="dataTable"></table>
	</div>
	<div region="center" title="" >
		<table id="dataList"></table>
	</div>
</body>
</html>