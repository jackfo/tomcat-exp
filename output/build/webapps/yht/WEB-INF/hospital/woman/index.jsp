<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/include/include.jsp"%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<script type="text/javascript" src="${path }/js/easyui/window.js"></script>
		<link rel="stylesheet" type="text/css" href="${path }/css/buttonPanel.css">
		<title>孕妇模块</title>
		<script type="text/javascript">
			var win,table;
			$(document).ready(function(){
				getColorStyle();
				win = new Jwindow(function(table){table.datagrid('reload');});
				table = $('#dataTable').datagrid({
					url:'${path}/hospital/woman!list.qt?random='+getRandomNum(),
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
						{field:'name',width:50,title:'姓名'},
						{field:'age',width:50,title:'年龄'},
						{field:'firstInspectionTime',width:100,title:'第一次检查时间'},
						{field:'ExpectedDate',width:80,title:'预产期'},
						{field:'lastMenstrual',width:80,title:'末次月经'},
						{field:'phone',width:100,title:'电话'},
						{field:'education',width:60,title:'学历'},
						{field:'womenType',width:70,align:'center',title:'孕妇类型',formatter:function(value,node){return typeof(value)=='undefined'||value==1?'产妇':'孕妇'}},
						{field:'count',width:60,title:'复诊次数'},
						{field:'addr',width:150,title:'住址'},
						{field:'messageDesc',width:100,title:'备注'},
						{field:'visitRecord',width:250,title:'复诊记录'}
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
		</script>
	</head>
	<body>
		<div class="buttonPanel">
			<div class="formPanel">
				<label for="woman.name">孕妇姓名：</label>
				<input type="text" name="woman.name"  style="float:left;"/>
				<label for="woman.phone">责任人电话：</label>
				<input type="text" name="woman.phone"  />
				<div class="clear"></div>
			</div>
			<fs:button key="NEWADD" id="addButton" name="新增" iconCls="icon-add">
				function(){
					win.show('新增孕妇','${path}/hospital/woman!preAdd.qt?chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum(),table);
					win.reSize(500,450);
				}
			</fs:button>
			<fs:button key="MODIFY" id="modifyButton" name="修改" iconCls="icon-edit">
				function(){
					var rows = table.datagrid('getSelections');
					if(rows && 1!=rows.length){parent.jQuery.messager.alert('错误','对不起！请选择将要修改的一条记录！','error');return;}
					win.show('修改孕妇','${path}/hospital/woman!preModify.qt?id='+rows[0].id+'&chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum(),table);
					win.reSize(500,450);
				}
			</fs:button>
			<fs:button key="MODIFYRECORD" id="modifyRecordButton" name="更新复诊记录" iconCls="icon-edit">
				function(){
					var rows = table.datagrid('getSelections');
					if(rows && 1!=rows.length){parent.jQuery.messager.alert('错误','对不起！请选择将要修改复诊的一条记录！','error');return;}
					win.show('修改孕妇复诊记录','${path}/hospital/woman!preModifyRecord.qt?id='+rows[0].id+'&chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum(),table);
					win.reSize(500,350);
				}
			</fs:button>
			<fs:button key="VIEWRECORD" id="viewRecordButton" name="查看复诊记录" iconCls="icon-search">
				function(){
					var rows = table.datagrid('getSelections');
					if(rows && 1!=rows.length){parent.jQuery.messager.alert('错误','对不起！请选择将要查看的一条复诊记录！','error');return;}
					win.show('查看孕妇复诊记录','${path}/hospital/woman!preModifyRecord.qt?id='+rows[0].id+'&view=view&chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum(),table);
					win.reSize(500,350);
				}
			</fs:button>
			<fs:button key="IMPORT" id="IMPORT_BTN" name="导入" iconCls="icon-redo">
				function(){
					win.show('导入孕妇','${path}/hospital/woman!preImport.qt?mid=${param.mid }&chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum(),table);
					win.reSize(550,520);
				}
			</fs:button>
			<fs:button key="EXPORT" id="EXPORT_BTN" name="导出" iconCls="icon-print">
				function(){
					var param = '';
					$('.formPanel :input').each(function(i,el){
						param+='&'+$(el).attr('name')+'='+encodeURIComponent($(el).val());
					});
					var url = '${path}/hospital/woman!export.qt?b=true'+param+'&chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum();
					window.location.href=url;
				}
			</fs:button>
			<fs:button key="DELETE" id="deleteButton" name="删除" iconCls="icon-remove">
				function remove(){
					var rows = table.datagrid('getSelections');
					if(rows&&0 < rows.length){
						var ids = '',names = '';
						jQuery.each(rows,function(i,el){
							ids+=','+el.id;
							names+=',【'+el.name+'】';
						});
						ids = ids.replace(/(^[,]*)|([,]*$)/,'');
						names = names.replace(/(^[,]*)|([,]*$)/,'');
						parent.jQuery.messager.confirm('提示','确定删除'+names+'等记录吗？',function(b){
							if(b){
								jQuery.ajax({
									async: false,
									type: "GET",
									url: '${path}/hospital/woman!delete.qt?id='+encodeURIComponent(ids)+'&chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum(),
									success: function(data){
										data = eval(data);
										if(data&&data.b){}else jQuery.messager.alert('错误','删除失败，请刷新页面重试！','error');
										table.datagrid('reload');
										table.datagrid('clearSelections');
									}
								});
							}
						});
					}else{
						parent.jQuery.messager.alert('温馨提示','对不起！请至少选择一条将要删除的记录！','error');
					}
				}
			</fs:button>
			<fs:button key="QUERY" id="queryBtn" name="查询" iconCls="icon-search">
				function(){
					var params = getURLParams();
					$(this).linkbutton({disabled:true});
					table.datagrid('options').url='${path}/hospital/woman!list.qt?chkAccess='+encodeURIComponent('{#chkAccess}')+'random='+getRandomNum()+params;
					table.datagrid('reload');
					table.datagrid('clearSelections');
					setTimeout("buttonDisable()",BUTTON_WAIT_TIME);
				}
			</fs:button>
			<div class="datagrid-btn-separator" style="visibility:hidden;"></div>
			<div class="clear"></div>
		</div>
		<table id="dataTable"></table>
	</body>
</html>