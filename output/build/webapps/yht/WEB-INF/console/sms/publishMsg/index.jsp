<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/include/include.jsp"%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<script type="text/javascript" src="${path }/js/easyui/window.js"></script>
		<link rel="stylesheet" type="text/css" href="${path }/css/buttonPanel.css">
		<title>${title}</title>
		<script type="text/javascript">
			var win,table;
			$(document).ready(function(){
				getColorStyle();
				win = new Jwindow(function(table){table.datagrid('reload');});
				table = $('#dataTable').datagrid({
					url:'${path}/sms/publishMsg!list.qt?chkAccess='+encodeURIComponent('${param.chkAccess}')+'&publishStatus='+$('#publishStatus').val()+'&publishType=${publishType}',
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
						{field:'publishTitle',width:70,title:'发布标题'},
						{field:'publishTime',width:50,title:'发布时间'},
						{field:'publishDesc',width:100,title:'备注描述'},
						{title:'发送状态',field:'publishStatus',width:100,formatter:function(value,node){return 0==value?'<span style="color:green">未发送</span>':'<span style="color:red">已发送</span>'}}
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
					<label for="start">开始时间：</label>
					<span  style="float:left;">
						<input type="text" name="start" id="start" class="easyui-validatebox" methodType="chooseDate{dateFmt:'yyyy-MM-dd HH:mm:ss'}"/>
					</span>
					<label for="end">结束时间：</label>
					<span  style="float:left;">
						<input type="text" name="end" id="end" class="easyui-validatebox" methodType="chooseDate{dateFmt:'yyyy-MM-dd HH:mm:ss'}"/>
					</span>
					<label for="publishStatus">发送状态：</label>
					<select name="publishStatus" id="publishStatus">
						<option value="1">已发送</option>
						<option value="0">未发送</option>
					</select>
					<div class="clear"></div>
				</div>
				<fs:button key="NEWADD" id="preAdd" name="新增" iconCls="icon-add">	
					function(){
						win.show('新增','${path}/sms/publishMsg!preAdd.qt?chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum()+'&title='+encodeURIComponent('${title}')+'&publishType=${publishType}'+'&mid=${param.mid}',table);
						win.reSize('90%','90%');
					}
				</fs:button>
				<fs:button key="MODIFY" id="modifyButton" name="修改" iconCls="icon-edit">
					function(){
						var rows = table.datagrid('getSelections');
						if(rows && 1!=rows.length){parent.jQuery.messager.alert('错误','对不起！请选择将要修改的一条记录！','error');return;}
						win.show('修改','${path}/sms/publishMsg!preModify.qt?id='+rows[0].id+'&chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum()+'&title='+encodeURIComponent('${title}')+'&mid=${param.mid}',table);
						win.reSize('90%','90%');
					}
			</fs:button>
				<fs:button key="DELETE" id="deleteTrueButton" name="删除" iconCls="icon-remove">
					function(){
						var rows = table.datagrid('getSelections');
						if(rows && 1!=rows.length) parent.jQuery.messager.alert('错误','对不起！请选择将要删除的一条记录！','error');
						else{
							jQuery.messager.confirm('提示','确定删除发表标题: '+rows[0].publishTitle+' 吗？',function(b){
								if(b){
									jQuery.ajax({
										async: false,
										type: "GET",
										url: '${path}/sms/publishMsg!deleteTrue.qt?id='+rows[0].id+'&chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum(),
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
			<fs:button key="SEND" id="sendButton" name="发送" iconCls="icon-save">
					function(){
						var rows = table.datagrid('getSelections');
						if(rows && 1!=rows.length) parent.jQuery.messager.alert('错误','对不起！请选择将要发送的一条记录！','error');
						else{
							jQuery.messager.confirm('提示','确定发送发表标题: '+rows[0].publishTitle+' 吗？',function(b){
								if(b){
									jQuery.ajax({
										async: false,
										type: "GET",
										url: '${path}/sms/publishMsg!sendTo.qt?id='+rows[0].id+'&chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum(),
										success: function(data){
											data = eval(data);
											if(data&&data.b){}else jQuery.messager.alert('错误','发送失败，请刷新页面重试！','error');
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
			<fs:button key="QUERY" id="QUERY_BTN" name="查询" iconCls="icon-search">
				function query(){
					$('#refreshButton').linkbutton('enable');
					table.datagrid('options').url = '${path}/sms/publishMsg!list.qt?mark=${param.mark}'+'&chkAccess='+encodeURIComponent('{#chkAccess}')+'&publishStatus='+$('#publishStatus').val()+'&publishType=${publishType}';
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