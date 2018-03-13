<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/include/include.jsp"%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<script type="text/javascript" src="${path }/js/easyui/window.js"></script>
		<script type="text/javascript" src="${path }/js/bgshade/jQuery_plug_bgshade.js"></script>
		<link rel="stylesheet" type="text/css" href="${path }/css/icon.css">
		<link rel="stylesheet" type="text/css" href="${path }/css/buttonPanel.css">
		<title>系统主页面</title>
		<style type="text/css">
			.menu{background-position-x:4px}
			.subMenuItem{width:150px;}
			.menu-text{left:32px}
			.menu-icon{margin-left:2px;width:20px;height:16px;}
			.menu-icon{background-image:url(${path}/images/tabicons.gif);}
			.tree-icon{background-image:url(${path}/images/tabicons.gif);}
			.icon_root{background-position:20px 20px;}
			.disabled{color:#d5d5d5;}
		</style>
		<script type="text/javascript">
			var win,subWin,table,menuBar;
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
				menuBar = $('#menuBar').menu({
					onMouseOver:function(el){
						var id = el.attr('id').replace(/\D/ig,'');
						if($(el[0].submenu).is(':empty')){
							table.treegrid('reload', id);
							$('.menu-rightarrow', el).addClass('subMenuLoading');
						}
					},
					onBeforeShow:function(){
						var type = menuBar.data('currentClickType');
						$('.disabled').removeClass('disabled').show();
						var obj = table.treegrid('getSelected');
						if(obj.id==0) $('.menu-item').addClass('disabled');
						else if(type=='move'){
							var parent = table.treegrid('getParent', obj.id);
							if(parent==null){
								$('#menu_item_0,#menu_item_'+obj.id).addClass('disabled').hide();
							}else{
								$('#menu_item_'+obj.id).addClass('disabled').hide();
								$('#menu_item_'+parent.id).addClass('disabled')
							}
						}else if(type=='copy'){
							$('#menu_item_'+obj.id).addClass('disabled').hide();
						}
					},
					onClick:function(item){
						if($(item.target).is('.disabled')) return false;
						var fromId = table.treegrid('getSelected').id;
						var toId = $(item.target).attr('id').replace(/\D/ig,'');
						var type = menuBar.data('currentClickType');
						var desc = '移动';
						var key = encodeURIComponent('${fs:chkAccess(param.mid,"MOVE_TO")}');
						if(type=='copy'){
							key = encodeURIComponent('${fs:chkAccess(param.mid,"COPY_TO")}');
							desc = '复制';
						}
						
						$.messager.confirm('提示','是否将【'+table.treegrid('getSelected').name+'】'+desc+'到【'+item.text+'】？',function(b){
							if(b){
								$(document.body).bgshade("菜单"+desc+"中...");
								var url = "${path }/base/menu!moveOrCopy.qt";
								var data = "type="+type+"&fromId="+fromId+"&toId="+toId+'&chkAccess='+key;
								jQuery.ajax({
									async:false,
									type:'POST',
									url:url,
									data:data,
									dataType:"json",
									error:function(){
										jQuery.messager.alert('错误',desc+'失败！','error');
										$(document.body).bgshade(false);
									},
									success:function(obj){
										if(obj.b){
											jQuery.messager.alert('提示',desc+'成功！','info');
											window.location.reload();
										}else{
											jQuery.messager.alert('错误',desc+'失败！<br/><br/>原因是：'+obj.desc,'error');
										}
										$(document.body).bgshade(false);
									}
								});
							}
						});
					}
				});
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
					url:'${path}/base/menu!list.qt?chkAccess='+encodeURIComponent('${param.chkAccess}'),
					idField:'id',
					treeField:'name',
					columns:[[
						{field:'name',title:'菜单名称',width:120,formatter:function(value){return '<span style="color:red">'+value+'</span>';}},
						{field:'buttons',title:'按钮',width:120,formatter:function(value){
							if(value){
								var items = eval(value);
								var length = items.length;
								value = '';
								for(var i=0;i<length;i++){
									value += '，'+items[i].name;
								}
								return value.replace(/(^[,，]*)|([,，]*$)/,'');
							}else return '';
						}},
						{field:'url',title:'URL',width:120},
						{field:'level',title:'优先级',align:'center',width:80},
						{field:'isRoot',title:'是否是根',align:'center',width:80,formatter:function(value,node){return 0==node.id?'':(1==value?'是':'否')}},
						{field:'status',title:'状态',align:'center',width:80,formatter:function(value,node){return 0==node.id?'':(1==value?'启用':'停用')}}
					]],
					onLoadSuccess:function(row, data){
						var parentObj = null;
						if(null!=row){
							parentObj = menuBar.menu('getItem',$('#menu_item_'+row.id)[0]);
							if(parentObj!=null) parentObj = parentObj.target;
						}
						for(var i=0,len=data.length;i<len;i++){
							var obj = data[i];
							var submenu = null;
							if(obj.id!=0&&obj.isRoot==1) submenu = $('<div id="submenu_'+obj.id+'" class="subMenuItem"></div>').appendTo('#menuBar').menu({}); 
							menuBar.menu('appendItem', {'parent':parentObj, 'id':'menu_item_'+obj.id, 'text':obj.name, 'iconCls':obj.iconCls, 'submenu':submenu});
						}
					}
				});
			});
			function moveOrCopyMenu(e,type){
				var menuBar = $('#menuBar');
				var linka = $('#MOVE_TO_BTN');
				if(type=='copy') linka = $('#COPY_TO_BTN');
				menuBar.data('currentClickType',type);
				menuBar.menu('show', {
					left: linka.offset().left,
					top: linka.offset().top + linka.outerHeight()
				});
			}
		</script>
	</head>
	<body>
		<div class="buttonPanel">
			<fs:button key="NEWADD" id="NEWADD_BTN" name="增加子菜单" iconCls="icon-add">
				function(){
					var node = table.treegrid('getSelected');
					if(!node){jQuery.messager.alert('错误','对不起！请选择一项！','error');return;}
					win.show('增加子菜单——'+node.name,'${path}/base/menu!preAdd.qt?id='+node.id+'&chkAccess='+encodeURIComponent('{#chkAccess}')+'&name='+encodeURIComponent(node.name),{id:node.id,method:'new'});
					win.reSize(500,350);
				}
			</fs:button>
			<fs:button key="MODIFY" id="MODIFY_BTN" name="修改菜单" iconCls="icon-edit">
				function(){
					var node = table.treegrid('getSelected');
					if(!node){jQuery.messager.alert('错误','对不起！请选择一项！','error');return;}
					if(0 == node.id) jQuery.messager.alert('错误','对不起！根目录不允许修改！','error');
					else{
						win.show('修改菜单——'+node.name,'${path}/base/menu!preModify.qt?id='+node.id+'&chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum(),{id:node.id,method:'modify'});
						win.reSize(500,350);
					}
				}
			</fs:button>
			<fs:button key="DELETE" id="DELETE_BTN" name="删除菜单" iconCls="icon-no">
				function(){
					var node = table.treegrid('getSelected');
					if(!node){jQuery.messager.alert('错误','对不起！请选择一项！','error');return;}
					if(0 == node.id)jQuery.messager.alert('错误','对不起！根目录不允许删除！','error');
					else jQuery.messager.confirm('提示','确定删除【'+node.name+'】菜单及其子菜单？',function(b){
						if(b)jQuery.get('${path}/base/menu!delete.qt?id='+node.id+'&chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum(),function(){
							win.refreshParent({id:node.id,method:'delete'});
						});
					});
				}
			</fs:button>
			<div class="datagrid-btn-separator"></div>
			<fs:button key="MOVE_TO" id="MOVE_TO_BTN" name="菜单移动到" iconCls="icon-edit">
				function(e){
					var node = table.treegrid('getSelected');
					if(!node){jQuery.messager.alert('错误','对不起！请选择一项！','error');return;}
					if(0 == node.id) jQuery.messager.alert('错误','对不起！根目录不允许执行改操作！','error');
					else moveOrCopyMenu(e,'move');
				}
			</fs:button>
			<fs:button key="COPY_TO" id="COPY_TO_BTN" name="菜单复制到" iconCls="icon-edit">
				function(e){
					var node = table.treegrid('getSelected');
					if(!node){jQuery.messager.alert('错误','对不起！请选择一项！','error');return;}
					if(0 == node.id) jQuery.messager.alert('错误','对不起！根目录不允许执行改操作！','error');
					else moveOrCopyMenu(e,'copy');
				}
			</fs:button>
			<div class="datagrid-btn-separator"></div>
			<fs:button key="EDITBUTTONS" id="EDITBUTTONS_BTN" name="编辑按钮" iconCls="icon-remove">
				function(){
					var node = table.treegrid('getSelected');
					if(!node){jQuery.messager.alert('错误','对不起！请选择一项！','error');return;}
					if(0 == node.id) jQuery.messager.alert('错误','对不起！对不起！根目录不允许编辑按钮！','error');
					else if(1 == node.isRoot) jQuery.messager.alert('错误','对不起！根目录不允许编辑按钮！','error');
					else{
						win.show('编辑按钮——'+node.name,'${path}/base/menu!btnIndex.qt?id='+node.id+'&mid=${param.mid }'+'&chkAccess='+encodeURIComponent('${fs:chkAccess(param.mid, "EDITBUTTONS") }')+'&name='+encodeURIComponent(node.name)+'&random='+getRandomNum(),{id:node.id,method:'modify'});
						win.reSize('60%','60%');
					}
				}
			</fs:button>
			<!-- 
			<div class="datagrid-btn-separator"></div>
			<fs:button key="COPYMENU" id="COPYMENU_BTN" name="菜单复制" iconCls="icon-add">
				function(){
					var node = table.treegrid('getSelected');
					if(!node){jQuery.messager.alert('错误','对不起！请选择需要复制一项！','error');return;}
					if(0 == node.id || node.isRoot) jQuery.messager.alert('错误','对不起！根目录不允许复制！','error');
					else{
						win.show('复制菜单——'+node.name,'${path}/base/menu!preCopy.qt?id='+node.id+'&chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum(),{id:node.id,method:'modify'});
						win.reSize('80%','80%');
					}
				}
			</fs:button>
			 -->
			<div class="clear"></div>
		</div>
		<table id="menuTable"></table>
		<div id="menuBar" class="easyui-menu" style="width:150px"></div>
	</body>
</html>
