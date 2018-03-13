<%@page language="java" pageEncoding="UTF-8"%>
<%@ include file="/include/include.jsp"%>

<html>
<head>
	<title>导出已发彩信年度统计</title>
	<script type="text/javascript" src="${path }/js/easyui/window.js"></script>
	<style>
		*{margin:0px;padding:0px;}
		body{background:#fafafa;overflow:hidden;}
		
		.sendBatchTable{width: 350px;margin:auto;margin-top:50px;border-top:1px solid #aaa;border-right:1px solid #aaa;background:#fff;table-layout: fixed;}
		.sendBatchTable td{padding:5px;padding-bottom:3px;height:30px;border-left:1px solid #aaa;border-bottom:1px solid #aaa;}
	</style>
	<script type="text/javascript">

		$(document).ready(function(){
			document.body.style.overflow = 'scroll';//页面显示滚动条;
		});
		function reset(){
			downloadYearForm.reset();
		}
		
		function submitForm(el){
			if(null==$("#year").val() || ""==$("#year").val()){
				alert("\"年 份\"不能为空！");
			}else{
				$('#downloadYearForm').form('submit',{
					url:'${path}/mms/mmsResult!downloadYearMms.qt?chkAccess=${param.chkAccess}',
					onSubmit:function(){
						var b = $(this).form('validate');
						if(b) $(el).linkbutton({disabled:true});
						return b;
					},
					success:function(data){},
					onLoadError:function(e){
						$(el).linkbutton({disabled:false});
						parent.jQuery.messager.alert('错误',e.message+'<br/><br/>保存失败！','error');
					}
				});
				parent.win.refreshParent();
			}
		}	
	</script>
</head>
<body>
<form id="downloadYearForm" name="downloadYearForm" method="post">
	<center><h2 style="margin-top: 15">导&nbsp;出&nbsp;已&nbsp;发&nbsp;彩&nbsp;信&nbsp;年&nbsp;度&nbsp;统&nbsp;计</h2></center>
	<table class="sendBatchTable" align="center" cellpadding="0" cellspacing="0" border="0" style="margin-top: 15px">
		<tr>
			<td width="150">选择导出已发彩信年份：</td>
			<td>
				<input type="text" name="year" id="year" value="${year}" class="easyui-validatebox" methodType="chooseDate{dateFmt:'yyyy'}" readonly="readonly"/>
			</td>
		</tr>
	</table>
	<center style="margin-top: 15">
		<a href="#" onclick="submitForm(this);" id="saveBtn" class="easyui-linkbutton" plain="false" iconCls="icon-save" style="margin-right:10px">下载</a>
   		<a href="javascript:reset();" class="easyui-linkbutton" plain="false" iconCls="icon-remove">重置</a>
   	</center>	
</form>
</body>
</html>