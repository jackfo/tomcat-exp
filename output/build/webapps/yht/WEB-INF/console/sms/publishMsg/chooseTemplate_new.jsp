<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/include/include.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>短信选择</title>
<link rel="stylesheet" type="text/css" href="${path }/css/buttonPanel.css">
	<script>
		var table;
		var smTypeTable;
		$(function(){
			getColorStyle();
			table = $('#dataTable').datagrid({
					url:'${path}/sms/template!choose.qt?type=list&chkAccess='+encodeURIComponent('${param.chkAccess}'),
					idField:'id',
					width:720,
					height:320,
					nowrap: true,
					pagination:true,
					border:false,
					striped:true,
					fitColumns:true,
					rownumbers:true,
					singleSelect:true,
					columns:[[
						{field:'param',width:15,title:'分类',formatter:function(val,node){return node.paramDroped!=0?val:'<b style="color:red;margin-right:3px;">[系]</b>'+val;}},
						{field:'content',width:80,title:'内容'}
					]],
					onHeaderContextMenu: function(e, field){
						e.preventDefault();
					},
					onDblClickRow:fixedChoose,
					onClickRow:function(row1,rowData1){
						$('#center').panel('setTitle','<b style="color:red;margin-right:3px;">'+rowData1.content+'</b>');
					}
				});
				
				smTypeTable = $('#smTypeDataTable').datagrid({
					url:'${path}/base/param!findAllSmTypes.qt?chkAccess='+encodeURIComponent('${param.chkAccess}'),
					width:180,
					height:280,
					idField:'id',
					pagination:false,
					nowrap:true,
					border:false,
					striped:true,
					fitColumns:true,
					rownumbers:true,
					clickSingleSelect:true,
					columns:[[
						{field:'name',width:50,title:'短信分类名称'}
					]],
					onHeaderContextMenu: function(e, field){
					},
					onClickRow:function(row,rowData){
						var smTypeId = rowData.id;
						$("#smTypeId").val(smTypeId);
						/**修改panel的title属性**/
						$('#west').panel('setTitle','<b style="color:red;margin-right:3px;">【'+rowData.name+'】</b>');
						query(smTypeId);
					}
				});
		});
		
		function query(smTypeId){
				$('#center').panel('setTitle','短信模板');
				var txtSearch = $('#txtSearch').val();
				var hiddenSmTypeId = $("#smTypeId").val();
				table.datagrid('options').queryParams = {'txtSearch':txtSearch,'smTypeId':hiddenSmTypeId};	
				table.datagrid('reload');
				table.datagrid('clearSelections');
			}
			function fixedChoose(){
				var win = parent.win;
				var rows = table.datagrid('getSelections');
				if(rows&&1!=rows.length)parent.jQuery.messager.alert('错误','对不起！请选择一条短信模板记录！','error');
				else if('${param.win}'!=''){
					var win = parent.${param.win};
					if(rows[0].paramDroped!='0'){
						if(win&&win.refreshParent){
							win.refreshParent(rows[0]);
						}
					}else{
						parent.jQuery.messager.confirm('提示','您选择的模板是系统替换模板，选择此模板将不会替换模板中的关键字。<br/><center style="margin:10px 0;font-size:14px;font-weight:900;color:red">确定选择该模板麽吗？</center>',function(b){
							if(b){
								if(win&&win.refreshParent){
									win.refreshParent(rows[0]);
								}
							}
						});
					}
				}
			}
			/***刷新短信分类列表**/
			function reloadSmType(){
				$('#west').panel('setTitle','短信分类');
				$('#smTypeId').val(0);
				smTypeTable.datagrid('reload');
				smTypeTable.datagrid('clearSelections');
			}
	</script>
</head>
<body id="myBody" class="easyui-layout" >
		<!-- 条件栏 -->
	<div region="north" border="ture" style="height:50px;" class="buttonPanel">
		<input id="smTypeId" name="smTypeId" value="0" type="hidden" /><!-- 短信分类隐藏域 -->
		<a onclick="fixedChoose()" class="easyui-linkbutton" plain="false" iconCls="icon-ok" style="margin-right:10px">确定</a>
			<div class="datagrid-btn-separator"></div>
			<a href="javascript:query()" class="easyui-linkbutton" plain="false" iconCls="icon-search" style="margin-right:10px">搜索</a>
			<input type="text" id="txtSearch" name="txtSearch" title="请输入要查询的关键字" style="float:left;margin-top:2px;margin-right:10px"/>
			<div class="clear"></div>
	</div>
		<!-- 短信分类栏 -->
	<div region="west" id="west" split="true" title="短信分类" style="width:210px;padding:10px;">
		<div id="footpage"  style="height:35px;text-align: center;">
			<a onclick="javascript:reloadSmType();" class="easyui-linkbutton" plain="false" iconCls="icon-reload" style="margin-right:5px;margin-top: 5px;margin-left: 15px;">刷新短信分类</a>
		</div>
		<table id="smTypeDataTable"></table>
	</div>
		<!-- 短信内容展示栏 -->
	<div region="center" id="center" title="短信模板" fit="true" style="padding:10px;">
		<table id="dataTable"></table>
	</div>
</body>
</html>