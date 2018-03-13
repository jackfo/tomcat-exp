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
					url:'${path}/meet/conference!list.qt?chkAccess='+encodeURIComponent('${param.chkAccess}'),
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
						{field:'check',width:10,align:'center',checkbox:'true'},
						{field:'title',width:20,align:'center',title:'会议主题'},
						{field:'totalNum',width:20,align:'center',title:'回复人数'},
						{field:'argeeNum',width:20,align:'center',title:'参加人数'},
						{field:'noArgeeNum',width:20,align:'center',title:'不参加人数'},
						{field:'operatorName',width:20,align:'center',title:'发起人'},
						{field:'endTime',width:20,align:'center',title:'结束时间'},
						{field:'status',width:20,align:'center',title:'状态',formatter:function(val,node){
							switch(val){
								case 1:return '<span style="color:green">运行中</span>';break;
								case 2:return '<span style="color:red">已结束</span>';break;
								default: return '';
							}
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
				<label for="title">会议标题：</label>
				<input type="text" name="title" id="title" style="float:left;"/>
				<label for="status">会议状态：</label>
				<select id="status" name="status" style="width: 100px;">
					<option value="9999">请选择</option>
					<option value="1">运行中</option>
					<option value="2">已结束</option>
				</select>
				<div class="clear"></div>
			</div>
			<fs:button key="NEWADD" id="NEWADD_BTN" name="发起会议" iconCls="icon-add">
				function append(){
					win.show('发起会议','${path}/meet/conference!preAdd.qt?chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum(),table);
					win.reSize(530,'80%');
				}
			</fs:button>
			<fs:button key="VIEW" id="VIEW_BTN" name="查看结果" iconCls="icon-search">
				function modify(){
					var rows = table.datagrid('getSelections');
					if(rows&&1!=rows.length) top.jQuery.messager.alert('错误','对不起！请选择将要修改的一条记录！','error');
					else{
						win.show('查看结果','${path}/meet/conference!view.qt?id='+rows[0].id+'&chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum(),table);
						win.reSize(530,'70%');
					}
				}
			</fs:button>
			<fs:button key="DELETE" id="DELETE_BTN" name="删除" iconCls="icon-no">
				function remove(){
					var rows = table.datagrid('getSelections');
					if(rows && 1>rows.length){ parent.jQuery.messager.alert('错误','对不起！请选择将要删除的一条记录！','error');return;}
					if(rows&&0 < rows.length){
						var ids = '',names = '';
						jQuery.each(rows,function(i,el){
							ids+=','+el.id;
							if(i<10){
								names+=',【'+el.title+'】';
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
									url: '${path}/meet/conference!delete.qt?id='+encodeURIComponent(ids)+'&chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum(),
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
					table.datagrid('options').url = '${path}/meet/conference!list.qt?mark=${param.mark}'+'&chkAccess='+encodeURIComponent('{#chkAccess}')+'&name='+encodeURIComponent($('#txtSearch').val());
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