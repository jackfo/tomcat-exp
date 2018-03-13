<%@ page language="java" pageEncoding="UTF-8"%>
<%@page import="com.fs.util.param.StringParam"%>
<%@ include file="/include/include.jsp"%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<script type="text/javascript" src="${path }/js/easyui/window.js"></script>
		<link rel="stylesheet" type="text/css" href="${path }/css/buttonPanel.css">
		<title>系统主页面</title>
		<script type="text/javascript">
			var win,subWin,table;
			$(document).ready(function(){
				getColorStyle();
				win = new Jwindow(function(node){
					if(node){
						var parent, method = 'reload';
						parent = table.treegrid('getParent',node.id);
						if('delete' == node.method && null!=parent){
							parent = table.treegrid('getParent',parent.id);
						}
						if(null == parent) window.location.reload();
						else table.treegrid(method, parent.id);
					}else window.location.reload();
				});
				subWin = new Jwindow(function(table){table.datagrid('reload');});
				table = $('#menuTable');
				table.treegrid({
					width: document.body.clientWidth,
					height: document.body.clientHeight-$('.buttonPanel').height()-9,
					nowrap: true,
					rownumbers: true,
					animate: false,
					collapsible: false,
					striped:true,
					border:false,
					fitColumns:true,
					clickSingleSelect:true,
					url:'${path}/base/organ!list.qt?chkAccess='+encodeURIComponent('${param.chkAccess}'),
					idField:'id',
					treeField:'name',
					columns:[[
						{field:'name',title:'名称',width:45,formatter:function(value){return '<span style="color:red">'+value+'</span>';}},
						{field:'unit',title:'所属单位',width:15,formatter:function(value,node){
								if(0==node.id)return '';
								if(value&&value.name) return value.name;
								else return '';
							}
						},
						{field:'isUnit',title:'类别',width:10,formatter:function(value,node){return 0==node.id?'':(1==value?'单位':'部门')}},
						{field:'orgnNo',title:'编号',width:10},
						{field:'level',title:'优先级',align:'center',width:10},
						{field:'sortNo',title:'层级',align:'center',width:10}
					]]
				});
			});
		</script>
	</head>
	<body>
		<div class="buttonPanel">
			<fs:button key="NEWADD" id="NEWADD_BTN" name="增加子项目" iconCls="icon-add">
				function append(){
					var node = table.treegrid('getSelected');
					if(!node){jQuery.messager.alert('错误','对不起！请选择一项！','error');return;}
					win.show('增加子项目——'+node.name,'${path}/base/organ!preAdd.qt?id='+node.id+'&no='+node.orgnNo+'&sortNo='+node.sortNo+'&chkAccess='+encodeURIComponent('{#chkAccess}')+'&name='+encodeURIComponent(node.name)+'&isUnit='+node.isUnit,{id:node.id,method:'new'});
					win.reSize(460,290);
				}
			</fs:button>
			<fs:button key="MODIFY" id="MODIFY_BTN" name="修改项目" iconCls="icon-edit">
				function modify(){
					var node = table.treegrid('getSelected');
					if(!node){jQuery.messager.alert('错误','对不起！请选择一项！','error');return;}
					if(0 == node.id) jQuery.messager.alert('错误','对不起！根目录不允许修改！','error');
					else{
						win.show('修改项目——'+node.name,'${path}/base/organ!preModify.qt?id='+node.id+'&no='+node.parentNo+'&chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum(),{id:node.id,method:'modify'});
						win.reSize(460,320);
					}
				}
			</fs:button>
			<fs:button key="DELETE" id="DELETE_BTN" name="删除项目" iconCls="icon-no">
				function remove(){
					var node = table.treegrid('getSelected');
					if(!node){jQuery.messager.alert('错误','对不起！请选择一项！','error');return;}
					if(0 == node.id || 0000 == node.parentNo)jQuery.messager.alert('错误','对不起！根目录不允许删除！','error');
					else jQuery.messager.confirm('提示','确定删除【'+node.name+'】项目及其子项目？',function(b){
						if(b)jQuery.ajax({
									async: false,
									type: "GET",
									url: '${path}/base/organ!delete.qt?type=0&id='+node.id+'&chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum(),
									success: function(data){
										var obj=eval(data);
										if(obj.b){
											parent.jQuery.messager.alert('提示',obj.desc,'error');
										}else{
											jQuery.ajax({
												async: false,
												type: "GET",
												url: '${path}/base/organ!delete.qt?type=1&id='+node.id+'&chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum(),
												success: function(data){
													win.refreshParent({id:node.id,method:'delete'});
												}
											});
										}
										
									}
								});
					});
				}
			</fs:button>
			<div class="datagrid-btn-separator" style="visibility:hidden;"></div>
			<div class="clear"></div>
		</div>
		<table id="menuTable"></table>
	</body>
</html>