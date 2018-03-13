<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/include/include.jsp"%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<script type="text/javascript" src="${path }/js/easyui/window.js"></script>
		<script type="text/javascript" src="${path }/js/vote/Vote.js"></script>
		<link rel="stylesheet" type="text/css" href="${path }/css/buttonPanel.css">
		<title>短信投票</title>
		<style type="text/css">
			hide{display:none;}
		</style>
		<script type="text/javascript">
			var win,table;
			$(document).ready(function(){
				getColorStyle();
				win = new Jwindow(function(table){table.datagrid('reload');});
				table = $('#dataTable').datagrid({
					url:'${path}/sms/vote!list.qt?chkAccess='+encodeURIComponent('${param.chkAccess}'),
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
						{field:'title',width:80,title:'标题',formatter:function(val,node){
							var l = node.item.length;
							if(0==node.type) val += '(不定项)<br/>';
							else if(1==node.type) val += '(单选)<br/>';
							else val += '('+Vote.chineseNum(node.type)+'选)<br/>';
							for(var i=0;i<l;i++){
								val += '【' + node.item[i].mark+'】('+node.item[i].count+')：'+node.item[i].content+'；';
							}
							return val;
						}},
						{field:'status',width:20,title:'状态',formatter:function(val,node){
							switch(val){
								case 1:return '<span style="color:green">运行中</span>';break;
								case 2:return '<span style="color:red">已结束</span>';break;
								default: return '';
							}
						}},
						{field:'count',width:20,title:'票数'}
					]],
					onSelect:function(index, row){
						if(row.status==1){
							//$('#START_BTN').hide();
							$('#STOP_BTN').show();
						}else{
							//$('#START_BTN').show();
							$('#STOP_BTN').hide();
						}
					},
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
		</script>
	</head>
	<body>
		<div class="buttonPanel">
			<div class="formPanel">
				<label for="vote.title">标题：</label>
				<input type="text" name="vote.title" id="vote.title" style="float:left;"/>
				<div class="clear"></div>
			</div>
			<fs:button key="NEWADD" id="NEWADD_BTN" name="增加" iconCls="icon-add">
				function append(){
					win.show('新增投票','${path}/sms/vote!preAdd.qt?chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum(),table);
					win.reSize(530,'80%');
				}
			</fs:button>
			<fs:button key="MODIFY" id="MODIFY_BTN" name="修改" iconCls="icon-edit">
				function modify(){
					var rows = table.datagrid('getSelections');
					if(rows&&1!=rows.length) top.jQuery.messager.alert('错误','对不起！请选择将要修改的一条记录！','error');
					else if(typeof(rows[0].status)=='undefined'){
						win.show('修改投票','${path}/sms/vote!preModify.qt?id='+rows[0].id+'&chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum(),table);
						win.reSize(530,'80%');
					}else{
						top.jQuery.messager.confirm('提示','该投票已启动或已结束！<br/><br/>修改投票内容可能会影响用户投票！',function(b){
							if(b){
								win.show('修改投票','${path}/sms/vote!preModify.qt?id='+rows[0].id+'&chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum(),table);
								win.reSize(530,'80%');
							}
						});
					}
				}
			</fs:button>
			<fs:button key="START" id="START_BTN" name="启动" iconCls="icon-ok">
				function modify(){
					var rows = table.datagrid('getSelections');
					if(rows&&1!=rows.length) top.jQuery.messager.alert('错误','对不起！请选择将要启动的一条记录！','error');
					else{
						win.show('启动或重发投票','${path}/sms/vote!preStart.qt?id='+rows[0].id+'&chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum(),table);
						win.reSize(530,400);
					}
				}
			</fs:button>
			<fs:button key="STOP" id="STOP_BTN" name="停止" iconCls="icon-remove" classes="easyui-linkbutton hide">
				function modify(){
					var rows = table.datagrid('getSelections');
					if(rows&&1!=rows.length) top.jQuery.messager.alert('错误','对不起！请选择将要停止的一条记录！','error');
					else{
						win.show('停止投票','${path}/sms/vote!preStop.qt?id='+rows[0].id+'&chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum(),table);
						win.reSize(530,400);
					}
				}
			</fs:button>
			<fs:button key="VIEW" id="VIEW_BTN" name="查看结果" iconCls="icon-search">
				function modify(){
					var rows = table.datagrid('getSelections');
					if(rows&&1!=rows.length) top.jQuery.messager.alert('错误','对不起！请选择将要修改的一条记录！','error');
					//else if(typeof(rows[0].status)=='undefined')
					//	top.jQuery.messager.alert('提示','对不起！该投票还没有启动！','info');
					else{
						win.show('查看结果','${path}/sms/vote!view.qt?id='+rows[0].id+'&chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum());
						win.reSize(530,'70%');
					}
				}
			</fs:button>
			<fs:button key="DELETE" id="DELETE_BTN" name="删除" iconCls="icon-no">
				function remove(){
					var rows = table.datagrid('getSelections');
					if(rows && 1!=rows.length) parent.jQuery.messager.alert('错误','对不起！请选择将要删除的一条记录！','error');
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
						top.jQuery.messager.confirm('提示','确定删除'+names+'等记录吗？',function(b){
							if(b){
								jQuery.ajax({
									async: false,
									type: "GET",
									url: '${path}/sms/vote!delete.qt?id='+encodeURIComponent(ids)+'&chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum(),
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
			<fs:button key="QUERY" id="QUERY_BTN" name="查询" iconCls="icon-search">
				function query(){
					$('#refreshButton').linkbutton('enable');
					table.datagrid('options').url = '${path}/sms/vote!list.qt?mark=${param.mark}'+'&chkAccess='+encodeURIComponent('{#chkAccess}')+'&name='+encodeURIComponent($('#txtSearch').val());
					table.datagrid('options').queryParams = getURLParamsForObj();
					table.datagrid('reload');
					table.datagrid('clearSelections');
				}
			</fs:button>
			<div class="clear"></div>
		</div>
		<table id="dataTable"></table>
	</body>
</html>