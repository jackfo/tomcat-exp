<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/include/include.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>新增人员信息</title>
	<script type="text/javascript" src="${path }/js/sms/validatebox.js"></script>
	<style type="text/css">
		*{margin:0px;padding:0px;font-size:9pt;}
		body{padding:10px;background:#fafafa;}
		.clearFloat{clear:both;}
		
		#formDiv{float:left;margin:5px 10px 0px 0px;height:24px;line-height:24px}
	</style>
	<script type="text/javascript">
		var table,data=parent.${param.jsname}.data;
		jQuery(document).ready(function(){
			var height = $('#formDiv').empty().append(data.setting.queryHtml).height();
			parent.${param.jsname}.reSize(data.setting.winWidth, data.setting.winHeight+height-15);
			table=$("#dataList").datagrid(jQuery.extend(true, {}, data.setting.table, {
				width: '100%',
				height: document.body.clientHeight-54-height
			}));
		});
		function debug(obj){
			var str = "";
			for(var v in obj)
				str += ","+v;
			return str;
		}
		function queryForm(el){
			if(!$(el).linkbutton("options").disabled){
				$(el).linkbutton({disabled:true});
				
				table.datagrid('options').queryParams = jQuery.extend(table.datagrid('options').queryParams,{
					query:obj2Str($('#formDiv').getObjInForm())
				});
				if(1 < table.datagrid('getPager').pagination("options").pageNumber)
					table.datagrid('getPager').find("a[icon=pagination-first]").click();
				else table.datagrid('reload');
				//table.datagrid('clearSelections');
				window.setTimeout(function(){$(el).linkbutton({disabled:false});},2000);
			}
		}
		function clearForm(el){
			table.datagrid('clearSelections');
			$('#formDiv')[0].reset();
		}
		function submitForm(el){
			if(data.setting.allowSelectAll&&!data.setting.table.singleSelect)
				parent.${param.jsname}.refreshParent({type:'hand',data:table.datagrid('getSelections')});
			else parent.${param.jsname}.refreshParent(table.datagrid('getSelections'));
		}
		function submitAllForm(el){
			//queryForm(document.getElementById('queryBtn'));
			var obj = eval('('+table.datagrid('options').queryParams.query+')');
			obj[data.setting.selectDataTotalKey]=table.datagrid('getPager').pagination('options').total;
			parent.${param.jsname}.refreshParent({type:'all',data:obj});
		}
		(function($){
			$.fn.getObjInForm = function(){
				var obj = {};
				this.find(':text,:password,textarea,select,input[type="hidden"]').each(function(){
					if(typeof($(this).attr('name'))=='string'&&$(this).attr('name')!='')
						obj[$(this).attr('name')] = $(this).val();
				});
				return obj;
			}
		})(jQuery);
	</script>
	</head>
	<body>
		<table id="dataList"></table>
		<div style="clear:both;text-align:center;">
			<form id="formDiv"></form>
			<div style="clear:both;">
				<a href="#" id="queryBtn" onclick="queryForm(this);" class="easyui-linkbutton" plain="false" iconCls="icon-search" style="margin-top:5px;margin-right:5px">查询</a>
				<a href="#" onclick="clearForm(this);" class="easyui-linkbutton" plain="false" iconCls="icon-remove" style="margin-top:5px;margin-right:5px">重置</a>
				<script type="text/javascript">
					if(data.setting.allowSelectAll&&!data.setting.table.singleSelect)
						document.write('<a href="#" onclick="submitAllForm(this);" class="easyui-linkbutton" plain="false" iconCls="icon-save" style="margin-top:5px;margin-right:5px">选择所有</a>');
				</script>
				<a href="#" onclick="submitForm(this);" class="easyui-linkbutton" plain="false" iconCls="icon-save" style="margin-top:5px;margin-right:5px">确定</a>
			</div>
		</div>
	</body>
</html>
