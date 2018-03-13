<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/include/include.jsp"%>     
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>数据库数据操作</title>
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
		win = new Jwindow(function(table){$('#dataViewList').datagrid('reload');});
		
		//设置按钮禁用时间
		BUTTON_WAIT_TIME = 5000;
		
		$('#pp').portal({
			border:false,
			fit:true
		});
		
		$('#columnDiv').panel({
			height: document.body.clientHeight - $('div[region=north]').height() - 80,
			onBeforeExpand:function(){$('#dataDiv').panel('collapse');}
		});
		$('#dataDiv').panel({
			height: document.body.clientHeight - $('div[region=north]').height() - 80,
			onBeforeExpand:function(){$('#columnDiv').panel('collapse');}
		});
		
		accordion=$("#accordion").accordion({
			onSelect:function(title){
				var panel = $("#accordion").accordion('getSelected');
				var dbid = $(panel).children('table').attr('dbid');
				setDataList(dbid,title);
				$('#currentDBLab').html('当前库：'+title);
			}
		});
		viewTableFields();
	//	viewTableDatas();
	});
	
	/**刷新数据库的表列表信息*/
	function　setDataList(obj,db){
		var table = "#dataList"+obj;
		$(table).datagrid({
			width: $('div[region=west]').width()-25,
			height:document.body.clientHeight - 129 - ${fn:length(dbList)} * 26 - 25,
			nowrap: true,
			fitColumns:true,
			striped: true,
			collapsible:false,
			url:'${path}/db/dataOpt!list.qt?id='+obj+'&random='+getRandomNum(),
			border:false,
			rownumbers:true,
			pagination:true,
			remoteSort: false,
			clickSingleSelect:true,
			sortName: 'name',
			sortOrder: 'asc',
			idField:'name',
			columns:[[
				{title:'数据表名',field:'name',width:150},
				{title:'中文别名',field:'label',width:100,hidden:true}
			]],
			onDblClickRow:function(rowIndex,rowData){
				$('#currentTableLab').html('当前表：'+rowData.name);
				$('#currentDB').val(obj);
				$('#currentDB').attr('txt',db);
				$('#currentTable').val(rowData.name);
				$("#columnList").datagrid('options').url='${path}/db/dataOpt!fieldList.qt?id='+obj+'&tableName='+rowData.name+'&random='+getRandomNum()+'&chkAccess='+encodeURIComponent('${fs:chkAccess(param.mid,"FIELD_LIST")}');
				$("#columnList").datagrid('reload');
				$("#columnList").datagrid('clearSelections');
				$('#columnDiv').panel('expand');
				$('#dataDiv').panel('collapse');
			}
		});
	}
	
	/**刷新数据表的字段集信息*/
	function viewTableFields(dbid,tableName){
		if(dbid && dbid != ''){}else{dbid='';}
		if(tableName && tableName != ''){}else{tableName='';}
		$("#columnList").datagrid({
			width: $('div[region=center]').width() - $('div[region=west]').width() - 25,
			height: document.body.clientHeight - $('div[region=north]').height() - 130,
			nowrap: true,
			fitColumns: true,
			striped: true,
			collapsible:false,
			url:'${path}/db/dataOpt!fieldList.qt?id='+dbid+'&tableName='+tableName+'&random='+getRandomNum()+'&chkAccess='+encodeURIComponent('${fs:chkAccess(param.mid,"FIELD_LIST")}'),
			border:false,
			rownumbers:true,
			pagination:true,
			remoteSort: false,
			clickSingleSelect:true,
			sortName: 'fieldName',
			sortOrder: 'asc',
			idField:'fieldName',
			columns:[[
				{title:'字段名称',field:'fieldName',width:150},
				{title:'中文别名',field:'label',width:150},
				{title:'数据类型',field:'fieldType',width:150},
				{title:'数据长度',field:'fieldLength',width:60},
				{title:'必填',field:'required',width:60,formatter:function(value,node){return 0==node.id?'':(1==value?'<font color=red>否</font>':'<font color=green>是</font>')}}
			]],
			onHeaderContextMenu: function(e, field){
				e.preventDefault();
				if (!$('#tmenu').length){
					createColumnMenu($("#columnList"));
				}
				$('#tmenu').menu('show', {
					left:e.pageX,
					top:e.pageY
				});
			}
		});
	}
	
	/**刷新数据表的数据集信息*/
	function viewTableDatas(columns){
	//	alert(columns);
		$('#columnDiv').panel('collapse');
		$('#dataDiv').panel('expand');
		$("#dataViewList").datagrid({
			width: $('#columnDiv').width(),
			height: $('#columnDiv').height(),
			nowrap: true,
			fitColumns: true,
			striped: true,
			collapsible:false,
			url:'${path}/db/dataOpt!dynDataList.qt?dbid='+$('#currentDB').val()+'&tableName='+$('#currentTable').val()+'&random='+getRandomNum()+'&chkAccess='+encodeURIComponent('${fs:chkAccess(param.mid,"DATA_LIST")}'),
			border:false,
			rownumbers:true,
			pagination:true,
			remoteSort: false,
			clickSingleSelect:true,
			columns:[eval(columns)],
			onHeaderContextMenu: function(e, field){
				e.preventDefault();
				if (!$('#tmenu').length){
					createColumnMenu($("#dataViewList"));
				}
				$('#tmenu').menu('show', {
					left:e.pageX,
					top:e.pageY
				});
			}
		});
	}
	
	//查询数据库的数据表
	function searchTable(dbid){
        var searchCnd = $('#ipt'+dbid).val();
        $("#dataList"+dbid).datagrid('options').url='${path}/db/dataOpt!list.qt?id='+dbid+'&searchCnd='+searchCnd+'&random='+getRandomNum();
		$("#dataList"+dbid).datagrid('reload');
		$("#dataList"+dbid).datagrid('clearSelections');
    }  
    
    //表数据显示
    function dataView(){
    	var tableName = $('#currentTable').val();
    	if(tableName && tableName != ''){
	    	$("#queryDataBtn").linkbutton({disabled:true});
			jQuery.ajax({
				async: false,
				type: "GET",
				url: '${path}/db/dataOpt!dataList.qt?dbid='+$('#currentDB').val()+'&tableName='+$('#currentTable').val()+'&random='+getRandomNum()+'&chkAccess='+encodeURIComponent('${fs:chkAccess(param.mid,"DATA_LIST")}'),
				success: function(data){
					if(data&&data!=''){
						viewTableDatas(data);
					}
				}
			});
			setTimeout("$('#queryDataBtn').linkbutton({disabled:false})",BUTTON_WAIT_TIME);
		}else{
    		jQuery.messager.alert('提示','请选择需要操作的数据库表？','warning');	
    	}
    }
    
    //数据批量删除
    function deleteData(){
    	var tableName = $('#currentTable').val();
    	if(tableName && tableName != ''){
	    	$("#deleteBtn").linkbutton({disabled:true});
	    	jQuery.messager.confirm('提示','确定要对'+$('#currentDB').attr('txt')+'数据库的'+tableName+'进行数据批量操作吗？',function(b){
				if(b){
					win.show('数据批量删除','${path}/db/dataOpt!preDelete.qt?dbid='+$('#currentDB').val()+'&tableName='+$('#currentTable').val()+'&chkAccess='+encodeURIComponent('${fs:chkAccess(param.mid,"DELETE")}')+'&random='+getRandomNum(),table);
					win.reSize('80%','80%');
				}
			});	
	    	setTimeout("$('#deleteBtn').linkbutton({disabled:false})",BUTTON_WAIT_TIME);
    	}else{
    		jQuery.messager.alert('提示','请选择需要操作的数据库表？','warning');	
    	}
    }
//-->	
</script>
</head>
<body class="easyui-layout">
	<!-- 头部 -->
	<div region="north" title="" split="false" style="height:98px;overflow: hidden;">
		<div id="info">
			<span class="linkTitle"></span> 
			当前位置 >> 数据批处理
		</div>
		<div id="titleDesc">
			<div class="title">数据批处理</div>
			<div class="desc"><如果您不是系统管理员，请慎重使用！></div>
		</div>
		<div id="optButton">
			<a href="#" id="saveBtn" onclick="" class="easyui-linkbutton" plain="false" iconCls="icon-save" style="margin-top:5px;margin-right:5px;float: right;">库表备份</a>
			<a href="#" id="sqlBtn" onclick="" class="easyui-linkbutton" plain="false" iconCls="icon-search" style="margin-top:5px;margin-right:5px;float: right;">SQL直通车</a>
			<a href="#" id="outputBtn" onclick="" class="easyui-linkbutton" plain="false" iconCls="icon-print" style="margin-top:5px;margin-right:5px;float: right;">结构导出</a>
			<a href="#" id="deleteBtn" onclick="deleteData()" class="easyui-linkbutton" plain="false" iconCls="icon-no" style="margin-top:5px;margin-right:5px;float: right;">批量删除</a>
			<a href="#" id="modifyBtn" onclick="" class="easyui-linkbutton" plain="false" iconCls="icon-edit" style="margin-top:5px;margin-right:5px;float: right;">批量修改</a>
			<a href="#" id="exportBtn" onclick="" class="easyui-linkbutton" plain="false" iconCls="icon-redo" style="margin-top:5px;margin-right:5px;float: right;">批量导出</a>
			<a href="#" id="importBtn" onclick="" class="easyui-linkbutton" plain="false" iconCls="icon-add" style="margin-top:5px;margin-right:5px;float: right;">批量导入</a>
		</div>
	</div>

	<div region="west" split="fasle" title="<b>连接面板</b>【数据库/数据表】" style="width:280px;padding:1px;overflow:hidden;">
		<div id="accordion" class="easyui-accordion" fit="true" border="false">
			<c:forEach var="db" items="${dbList }" varStatus="s">
				<div title="${db.name }" id="div${db.id }" selected="false" icon="dbIcon" style="padding: 0px;">
					<div>
						<input id="ipt${db.id }" name="ipt${db.id }" value="" style="float: left;width: 230px;border: 1px solid #99BBE8;margin-top: 2px;"/>
						<div onclick="searchTable(${db.id })" title="快速搜索表" class="fl dbcs">
							<img src="${path }/images/search.png" style="width: 16px;height: 16px;vertical-align: middle;margin-top: 2px;"/>
						</div>
					</div>
					<table id="dataList${db.id }" dbid="${db.id }"></table>
				</div>
			</c:forEach>
		</div>
	</div>
	
	<div region="center" title="" style="overflow:hidden;">
		<div id="pp" style="position:relative">
			<div style="width: 100%;">
				<div id="columnDiv" class="easyui-panel" title="字段集列表" iconCls="icon-search" style="width: 100%;overflow: hidden;" collapsible="true" minimizable="fasle" maximizable="false" closable="false">
					<div style="width: 100%;height: 25px;margin: 0px;padding: 0px;overflow: hidden;">
						<label id="currentDBLab" title="当前数据库" class="fl ipt"></label>
						<label id="currentTableLab" title="当前数据表" class="fl ipt"></label>
						<input type="hidden" id="currentDB" name="currentDB" value="" txt=""/>
						<input type="hidden" id="currentTable" name="currentTable" value=""/>
						<a href="#" id="queryDataBtn" onclick="dataView()" class="easyui-linkbutton" plain="false" iconCls="icon-search" style="margin-top:0px;margin-right:5px;float: right;">数据列表</a>
						<!-- 
						<div title="快速搜索表" class="dbcs">
							<img src="${path }/images/search.png" style="width: 16px;height: 16px;vertical-align: middle;margin-top: 2px;"/>
						</div>
						<input id="" name="" value="" style="float: right;width: 200px;border: 1px solid #99BBE8;margin-top: 2px;"/>
						 -->
					</div>
					<table id="columnList"></table>
				</div>
				<div id="dataDiv" class="easyui-panel" title="数据集列表" iconCls="icon-search" style="width: 100%;" collapsed="true" collapsible="true" minimizable="fasle" maximizable="false" closable="false">
					<table id="dataViewList"></table>
				</div>
			</div>
		</div>
	</div>
			
</body>
</html>