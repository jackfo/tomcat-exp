<%@ page language="java" pageEncoding="UTF-8"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ include file="/include/include.jsp"%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>增加分类</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">    
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="">
		<style type="text/css">
			body{padding:10px;background:#fafafa;overflow:hidden;}
			th{width:80px;height:35px;line-height:35px;text-align:right;font-size:9pt;font-weight:normal;}
			td{height:35px;line-height:35px;font-size:9pt;}
		</style>
		<script type="text/javascript">
			function submitForm(el){
				$('#newForm').form('submit',{
					url:'${path}/sms/chart!total.qt?random='+getRandomNum(),
					onSubmit:function(){
						var b = $(this).form('validate');
						if(b) $(el).linkbutton({disabled:true});
						return b;
					},
					success:function(data){
						$(el).linkbutton({disabled:false});
						try{
							var obj = eval(data);
							if(obj.b){
								parent.jQuery.messager.alert('提示','提交成功！<br/><br/>请稍后刷新查看汇总结果！','info');
								if(parent&&parent.win) parent.win.refreshParent();
							}else parent.jQuery.messager.alert('错误','<br/>提交失败！','error');
						}catch(e){parent.jQuery.messager.alert('错误',e.message+'<br/><br/>提交失败！','error');}
					},
					onLoadError:function(e){
						$(el).linkbutton({disabled:false});
						parent.jQuery.messager.alert('错误',e.message+'<br/><br/>提交失败！','error');
					}
				});
			}
			function reset(){
				newForm.reset();
			}
		</script>
	</head>
	<body>
		<form id="newForm" name="newForm" method="post">
			<input type="hidden" name="chkAccess" value="${param.chkAccess }">
			<input type="hidden" name="type" value="save"/>
			<table style="width:100%;table-layout:fixed;" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<th>汇总月份：</th>
	    			<td>
	    				<input type="text" name="yearMonth" class="easyui-validatebox" value="<%=new SimpleDateFormat("yyyy-MM").format(new Date()) %>" methodType="chooseDate{dateFmt:'yyyy-MM'}" onFocus="WdatePicker({dateFmt:'yyyy-MM',readOnly:true})" required="true"/>
	    			</td>
	    		</tr>
	    		<tr>
	    			<td colspan="2" align="center" height="40" valign="bottom">
	    				<a href="#" onclick="submitForm(this);" class="easyui-linkbutton" plain="false" iconCls="icon-save" style="margin-right:10px">确定</a>
	    				<a href="javascript:reset();" class="easyui-linkbutton" plain="false" iconCls="icon-remove">重置</a>
	    			</td>
	    		</tr>
	    	</table>
	    </form>
	</body>
</html>