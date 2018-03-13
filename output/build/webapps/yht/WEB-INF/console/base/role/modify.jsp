<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/include/include.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>修改角色</title>
<style type="text/css">
	body{padding:10px;background:#fafafa;overflow:hidden;}
	th{width:80px;height:35px;line-height:35px;text-align:right;font-size:9pt;font-weight:normal;}
	td{height:35px;line-height:35px;font-size:9pt;}
</style>
	<script type="text/javascript">
		$(document).ready(function(){
			$("#status"+${item.status}).attr("checked","true");
		});
		function submitForm(el){			
			$('#newForm').form('submit',{
				url:'${path}/base/role!modify.qt?random='+getRandomNum()+'&chkAccess='+encodeURIComponent('${param.chkAccess}'),
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
			$("#status"+${item.status}).attr("checked","true");
		}
	</script>
	</head>
	<body>
		<form id="newForm" name="newForm" method="post">
			<input type="hidden" name="chkAccess" value="${param.chkAccess }">
			<input type="hidden" name="roleId" id="roleId" value="${item.id }"/>
			<table style="width:100%;table-layout:fixed;" border="0" cellpadding="0" cellspacing="0"><c:if test="${1 eq item.id}">
				<tr>
					<th>所属组织：</th>
	    			<td>
	    				<input value="${item.organ.orgnName}" readonly="readonly" style="width:250px;">
	    			</td>
				</tr></c:if><c:if test="${1 ne item.id}">
	    		<tr>
	    			<th>所属组织：</th>
	    			<td><c:catch>
	    				<input id="orgId" name="orgId" class="easyui-combotree" value="${item.organ.id }" showText="${item.organ.orgnName}" url="${path}/base/organ!getJson.qt?chkAccess=${param.chkAccess}" required="true" style="width:250px;">
	    				</c:catch>
	    			</td>
	    		</tr></c:if>
				<tr>
					<th>角色名称：</th>
					<td><input type="text" name="roleName" id="roleName" class="easyui-validatebox" required="true" maxlength="50" style="width:250px" value="${item.roleName }"/></td>
				</tr>
				<tr>
					<th>角色描述：</th>
	    			<td>
	    				<input type="text" id="roleDesc" name="roleDesc" class="easyui-validatebox" maxlength="50" style="width:250px" value="${item.roleDesc }"/>
	    			</td>
	    		</tr>
	    		<tr>
	    			<th>状态：</th>
	    			<td>
						<input type="radio" id="status1" name="status" value="1"<c:if test="${1 eq item.status}"> checked="checked"</c:if>>
						<label for="status1">启用</label>
	    				<input type="radio" id="status0" name="status" value="0"<c:if test="${0 eq item.status}"> checked="checked"</c:if>>
	    				<label for="status0">禁用</label>
	    			</td>
	    		</tr>
				<tr>
					<th style="color: red;">注意</th>
	    			<td style="color: red;">
	    				* 不能修改所属组织
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
