<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/include/include.jsp"%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>修改个人信息</title>
	<style type="text/css">
		body{padding:10px;background:#fafafa;overflow:hidden;}
		th{width:80px;height:35px;line-height:35px;text-align:right;font-size:9pt;font-weight:normal;}
		td{height:35px;line-height:35px;font-size:9pt;}
	</style>
	<script type="text/javascript">
		function submitForm(el){
			$('#newForm').form('submit',{
				url:'${path}/base/account!modifyPass.qt?chkAccess='+encodeURIComponent('${param.chkAccess}')+'&random='+getRandomNum(),
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
							if(''!=jQuery.trim(obj.desc)){
								parent.jQuery.messager.alert('提示','修改成功!<br/><br/><span color="green">'+obj.desc+'</span>','info');
							}
							if(parent&&parent.win) parent.win.refreshParent();
						}else parent.jQuery.messager.alert('错误',obj.desc+'<br/>修改失败！','error');
					}catch(e){parent.jQuery.messager.alert('错误',e.message+'<br/><br/>修改失败！','error');}
				},
				onLoadError:function(e){
					$(el).linkbutton({disabled:false});
					parent.jQuery.messager.alert('错误',e.message+'<br/><br/>保存失败！','error');
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
			<input type="hidden" name="operator.id" value="${item.id }"/>
			<table style="width:100%;table-layout:fixed;" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<th>原密码：</th>
	    			<td>
						<input type="password" id="oldpassword" name="oldpassword" class="easyui-validatebox" required="true" maxlength="20" style="width:150px;" validType="exist['${path }/base/account!passExist.qt?chkAccess=${param.chkAccess}']"/>
	    			</td>
	    		</tr>
				<tr>
					<th>新密码：</th>
					<td>
						<input type="password" id="password" name="password" class="easyui-validatebox"  maxlength="20" style="width:150px;" required="true"/>
					</td>
				</tr>
	    		<tr>
	    			<th>确认密码：</th>
	    			<td>
	    				<input type="password" id="password2" name="password2" style="width:150px;" class="easyui-validatebox" validType="equalTo['password']" maxlength="20" required="true"/>
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