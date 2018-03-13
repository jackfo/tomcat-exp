<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/include/include.jsp"%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>修改自定义内容</title>
<style type="text/css">
	body{padding:10px;background:#fafafa;overflow:hidden;}
	th{width:80px;height:30px;line-height:30px;text-align:right;font-size:9pt;font-weight:normal;}
	td{height:30px;line-height:30px;font-size:9pt;}
</style>
	<script type="text/javascript">
				function submitForm(el){			
			$('#newForm').form('submit',{
				url:'${path}/hospital/receivedDefinition!modify.qt?random='+getRandomNum()+'&chkAccess='+encodeURIComponent('${param.chkAccess}'),
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
			<input type="hidden" name="id" id="id" value="${item.id }"/>
			<table style="width:100%;table-layout:fixed;" border="0" cellpadding="0" cellspacing="0">
	    		<tr>
	    			<th>接收代码：</th>
	    			<td>
	    				<input id="receivedDefinition.receivedMsg" name="receivedDefinition.receivedMsg" value="${item.receivedMsg }" class="easyui-validatebox" validType="exist['${path}/hospital/receivedDefinition!exist.qt?chkAccess=${param.chkAccess}','${item.receivedMsg}']" required="true" maxlength="25" style="width:350px;">
	    			</td>
	    		</tr>
	    		<tr>
	    			<th>回复内容：</th>
	    			<td style="height: 1%;">
	    				<textarea id="receivedDefinition.autoSend" name="receivedDefinition.autoSend" required="true"  cols="" rows="5" class="easyui-validatebox" maxlength="128" style="width:350px;" ><c:out value="${item.autoSend}"></c:out></textarea>
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