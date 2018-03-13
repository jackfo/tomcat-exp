<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/include/include.jsp"%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<script type="text/javascript" src="${path }/js/easyui/window.js"></script>
		<link rel="stylesheet" type="text/css" href="${path }/css/buttonPanel.css">
		<title>彩信模板</title>
		<script type="text/javascript">
			var win,table;
			$(document).ready(function(){
				getColorStyle();
				win = new Jwindow(function(table){table.datagrid('reload');});
				table = $('#dataTable').datagrid({
					url:'${path}/mms/template!list.qt?chkAccess='+encodeURIComponent('${param.chkAccess}'),
					width:document.body.clientWidth,
					height:document.body.clientHeight-$('.buttonPanel').height()-9,
					idField:'id',
					pagination:true,
					nowrap: true,
					border:false,
					striped:true,
					fitColumns:true,
					rownumbers:true,
					columns:[[
						{field:'check',width:10,checkbox:'true'},
						{field:'param',width:30,title:'彩信模板分类',formatter:function(val,node){return node.paramDroped==null?'':(node.paramDroped!=1?'<b style="color:red;margin-right:3px;">[系]</b>'+val:val);}},
						{field:'subject',width:80,title:'彩信主题',formatter:function(val,node){return val.replace(/<(.+?)>/gi,"&lt;$1&gt;");}},
						{field:'addAdmin',width:20,title:'添加人'},
						{field:'addTime',width:40,title:'添加时间'}
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
				<label for="templateParamName">分类名称：</label>
				<input type="text" name="template.param.name" id="templateParamName" maxlength="50" style="float:left;"/>
				<label for="subject">彩信主题：</label>
				<input type="text" name="template.subject" id="subject" style="float:left;"/>
				<div class="clear"></div>
			</div>
			<fs:button key="TEMPSUB" id="CHOOSE_BTN" name="提交选择" iconCls="icon-search">
				function choose(){
					var rows = table.datagrid('getSelections');
					if(rows&&1!=rows.length)parent.jQuery.messager.alert('错误','对不起！请选择将要预览的一条记录！','error');
					else{
						parent.win.refreshParent('[{mmId:'+rows[0].id+',subject:"'+rows[0].subject+'",parJson:'+rows[0].content+'}]');
					}
				}
			</fs:button>
			<div class="datagrid-btn-separator"></div>
			<fs:button key="VIEW" id="VIEW_BTN" name="彩信预览" iconCls="icon-search">
				function view(){
					var rows = table.datagrid('getSelections');
					if(rows&&1!=rows.length)parent.jQuery.messager.alert('错误','对不起！请选择将要预览的一条记录！','error');
					else{
						win.show('彩信预览','${path}/mms/template!view.qt?id='+rows[0].id+'&chkAccess='+encodeURIComponent('${fs:chkAccess(param.mid,"VIEW")}')+'&random='+getRandomNum(),table);
						win.reSize(205,350);
					}
				}
			</fs:button>
			<div class="datagrid-btn-separator"></div>
			<fs:button key="TEMPQUERY" id="QUERY_BTN" name="查询" iconCls="icon-search">
				function query(){
					$('#refreshButton').linkbutton('enable');
					table.datagrid('options').url = '${path}/mms/template!list.qt?mark=${param.mark}'+'&chkAccess='+encodeURIComponent('${fs:chkAccess(param.mid,"TEMPQUERY")}')+'&name='+encodeURIComponent($('#txtSearch').val());
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