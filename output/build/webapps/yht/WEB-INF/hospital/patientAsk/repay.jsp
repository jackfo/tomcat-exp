<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/include/include.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>患者咨询回复服务</title>
<script type="text/javascript" src="${path }/js/easyui/window.js"></script>
<script type="text/javascript" src="${path }/js/easyui/plugins/jquery.portal.js"></script>
<link rel="stylesheet" type="text/css" href="${path }/js/easyui/themes/gray/portal.css" />
<style>
	input{
		margin-top: 5px;
		vertical-align: middle;
	}
	label{
		margin-left: 25px;
		height: 35px;
		line-height: 35px;
		padding-bottom: 5px;
	}
	/**覆盖easyui.css中原有的样式*/
	.pagination-info{
		float:none;
		padding-top:8px;
		padding-right:0px;
		font-size:12px;
	}	
	html,body{ height:100%; margin:0 auto;}
</style>
<script type="text/javascript">
<!--
	var win,table,accordion; 
	$(document).ready(function(){
		getColorStyle();
		viewTableFields();
		setDataList();
		setTimeout(collapseEast,0);
	});
	
	function collapseEast(){
		$("#myPanel").layout('collapse','east');
		
	}
	/**专家回复*/
	function　setDataList(){
		win = new Jwindow(function(table){table.datagrid('reload');});
		table=$("#dataList").datagrid({
			width:document.body.clientWidth-200,
			height:document.body.clientHeight-120,
			nowrap: true,
			fitColumns:true,
			striped: true,
			collapsible:false,
			url:'${path}/sms/result!list2.qt?random='+getRandomNum()+'&chkAccess='+encodeURIComponent('${fs:chkAccess(param.mid,"QUERY")}'),
			border:false,
			pagination:true,
			rownumbers:true,
			remoteSort: false,
			sortName: 'sendTime',
			sortOrder: 'desc',
			idField:'id',
			clickSingleSelect:true,
			columns:[[
				{title:'手机号码',field:'destAddr',width:90,formatter:
					function(val,row){
						return val+'  '+information(row.destAddr,'sysUser');
					}},
				{title:'发送时间',field:'sendTime',width:50},
				{title:'短信内容',field:'smContent',width:250,formatter:function(val,node){return val.replace(/<(.+?)>/gi,"&lt;$1&gt;");}}
				]],
				onClickRow:function(row,rowData){
					/**修改panel的title属性**/
					$('#centents').panel('setTitle','专家回复 <b style="color:red;margin-right:3px;">'+rowData.destAddr+'说：'+rowData.smContent+'</b>');
				},
				/**双击事件**/
				onDblClickRow:function(row,rowData){
						var phone_zx = rowData.destAddr;
						if(phone_zx){
							var table_zx = $("#dataTable");
							table_zx.datagrid('options').url='${path}/sms/received!list2.qt?chkAccess='+encodeURIComponent('${fs:chkAccess(param.mid,"QUERY")}')+'&random='+getRandomNum();
							table_zx.datagrid('options').queryParams = {'smOrgAddr':''+phone_zx,'start':$('#start').val(),'end':$('#end').val()};
							table_zx.datagrid('reload');
							table_zx.datagrid('clearSelections');
						}
					}
		});
	}
	
	/**患者咨询*/
	function viewTableFields(){
				win = new Jwindow(function(table){table.datagrid('reload');});
				table = $('#dataTable').datagrid({
					url:'${path}/sms/received!list2.qt?chkAccess='+encodeURIComponent('${fs:chkAccess(param.mid,"QUERY")}'),
					width:document.body.clientWidth-40,
					height:document.body.clientHeight-120,
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
						{field:'orgAddr',width:80,title:'手机号码',formatter:
							function(val,row){
								return val+'  '+information(row.orgAddr,'');
							}},
						{field:'reverted',width:25,title:'状态',formatter:function(val,node){
							if(node.readed&&node.readed=='1'){}
							var str = '';
							if(node&&node.readed&&node.readed=='1'){
								str='已读';
							}
							if(val&&val=='back'){
								str='已回复';
								return '<b style="color:red">'+str+'</b>';
							}
							return str;
						}},
						{field:'content',width:200,title:'短信内容',formatter:function(val,node){
								return val.replace(/<(.+?)>/gi,"&lt;$1&gt;");
							}
						},
						{field:'recvTime',width:40,title:'接收时间',formatter:function(value,row){return value.length<11?value:value.substring(0,10)}}
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
					},
					onClickRow:function(row,rowData){
						/**修改panel的title属性**/
						$('#center').panel('setTitle','患者咨询  <b style="color:red;margin-right:3px;">'+rowData.orgAddr+'说：'+rowData.content+'</b>');
					},
					/**双击事件**/
					onDblClickRow:function(row,rowData){
						var phone = rowData.orgAddr;
						if(phone){
							var table_zj = $("#dataList");
							table_zj.datagrid('options').url='${path}/sms/result!list2.qt?chkAccess='+encodeURIComponent('${fs:chkAccess(param.mid,"QUERY")}')+'&random='+getRandomNum();
							table_zj.datagrid('options').queryParams = {'smOrgAddr':phone,'start':$('#start').val(),'end':$('#end').val()};
							table_zj.datagrid('reload');
							table_zj.datagrid('clearSelections');
						}
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
   /**查询患者信息  sysUser-代表系统用户*/
   function information(el,orgAddrType){
	   var phone = el;
	   var value='';
	   var obj;
	   jQuery.ajax({
			async: false,
			type: "GET",
			url: '${path}/sms/received!findInformation.qt?chkAccess='+encodeURIComponent('${fs:chkAccess(param.mid,"QUERY")}')+'&orgAddr='+phone+'&orgAddrType='+orgAddrType+'&random='+getRandomNum(),
			success: function(data){
					obj = eval("("+data+")");
					value = obj.patientDesc;
				}
			});
			return value;
   }
   function frushViewTableFields(){
		$('#dataTable').datagrid('reload');
		$('#dataTable').datagrid('clearSelections');
	}
//-->	
</script>
</head>
<body>
	<div id="myPanel" class="easyui-layout" style="width:100%;height:98%;">
		<div region="north" border="false" style="overflow:hidden;height:68px;background:#EFEFEF;">
			<label for="received.smOrgAddr">手机号码：</label>
			<input type="text" name="smOrgAddr" id="smOrgAddr" />
			<label for="start">开始时间：</label>
				<input type="text" name="start" id="start" class="easyui-validatebox" methodType="chooseDate{dateFmt:'yyyy-MM-dd HH:mm:ss'}"/>
			<label for="end">结束时间：</label>
			<input type="text" name="end" id="end" class="easyui-validatebox" methodType="chooseDate{dateFmt:'yyyy-MM-dd HH:mm:ss'}"/>
		<div class="clear"></div>
		<div style="margin-left: 20px;">
			<fs:button key="REPLY" id="replyButton" name="专家回复" iconCls="icon-add">
				function(){
					var rows = $('#dataTable').datagrid('getSelections');
					if(rows && 1!=rows.length){parent.jQuery.messager.alert('错误','对不起！请选择将要回复的一条记录！','error');return;}
					win.show('短信回复','${path}/sms/received!preReply2.qt?orgAddr='+rows[0].orgAddr+'&sid='+rows[0].id+'&chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum()+'&mid=${param.mid}',frushViewTableFields);
					win.reSize(670,470);
				}
			</fs:button>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
			<fs:button key="QUERY" id="queryBtn" name="查&nbsp;&nbsp;询" iconCls="icon-search">
				function(){
					if($(this).linkbutton('options').disabled) return;
					query();
				}
			</fs:button>
		</div>
		<div class="clear"></div>
	</div>
		<!-- 患者咨询 -->
		<div id="centents" region="east" icon="" title="专家回复" split="true" style="width:720px;overflow: hidden;">
			<table id="dataList"></table>
		</div>
		
		<!--专家回复 -->
		<div region="center" id="center" title="患者咨询" style="overflow: hidden;">
			<table id="dataTable"></table>
		</div>
	</div>
</body>
</html>