<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/include/include.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>修改</title>
	<style type="text/css">
		body{padding:10px;background:#fafafa;overflow:hidden;}
		th{width:80px;height:35px;line-height:35px;text-align:right;font-size:9pt;font-weight:normal;}
		td{height:35px;line-height:35px;font-size:9pt;}
	</style>
	<script type="text/javascript">
		function submitForm(el){
			$('#newForm').form('submit',{
				url:'${path}/db/driver!modify.qt?random='+getRandomNum()+'&chkAccess='+encodeURIComponent('${param.chkAccess}'),
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
							if(parent&&parent.win) parent.win.refreshParent();
						}else parent.jQuery.messager.alert('错误','<br/>修改失败！','error');
					}catch(e){parent.jQuery.messager.alert('错误',e.message+'<br/><br/>修改失败！','error');}
				},
				onLoadError:function(e){
					$(el).linkbutton({disabled:false});
					parent.jQuery.messager.alert('错误',e.message+'<br/><br/>修改失败！','error');
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
			<input type="hidden" name="driver.id" value="${item.id }"/>
			<table style="width:100%;table-layout:fixed;" border="0" cellpadding="0" cellspacing="0">
	    		<tr>
					<th>名称：</th>
					<td>
						<input type="text" id="driver.name" name="driver.name" value="${item.name }" class="easyui-validatebox" validType="exist['${path }/db/driver!isExist.qt?chkAccess=${param.chkAccess}','${item.name }','^[.\\-\\w]+$']" required="true" maxlength="50" style="width:70%;"/>
					</td>
				</tr>
				<tr>
					<th>Class：</th>
	    			<td>
	    				<input type="text" id="driver.clazz" name="driver.clazz" value="${item.clazz }" class="easyui-validatebox" required="true" maxlength="200" style="width:70%;"/>
	    			</td>
	    		</tr>
				<tr>
					<th>URL：</th>
	    			<td>
	    				<input type="text" id="driver.url" name="driver.url" value="${item.url }" class="easyui-validatebox" required="true" maxlength="200" style="width:70%;"/>
	    			</td>
	    		</tr>
	    		<tr>
	    			<td colspan="2" style="height:1%;line-height:20px;padding-top:5px;">
	    				<ul>
	    					<li>名称只能是字母、数字、“_”、“-”及“.”且不能与系统中的重复</li>
	    					<li>Class为JDBC驱动的主类</li>
	    					<li>URL为JDBC连接字符串模板，其中可以包含[IP]、[PORT]、[DB]标签</li>
	    				</ul>
	    			</td>
	    		</tr>
	    		<tr>
	    			<td colspan="2" align="center" height="40" valign="bottom">
	    				<a href="#" onclick="submitForm(this);" class="easyui-linkbutton" plain="false" iconCls="icon-save" style="margin-right:10px">保存</a>
	    				<a href="javascript:reset();" class="easyui-linkbutton" plain="false" iconCls="icon-remove">重置</a>
	    			</td>
	    		</tr>
	    	</table>
	    </form>
	</body>
</html>
