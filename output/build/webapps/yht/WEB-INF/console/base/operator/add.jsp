<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/include/include.jsp"%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>新增操作员</title>
	<style type="text/css">
		body{padding:10px;background:#fafafa;overflow:hidden;}
		th{width:80px;height:30px;line-height:30px;text-align:right;font-size:9pt;font-weight:normal;}
		td{height:30px;line-height:30px;font-size:9pt;}
	</style>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			$(document.getElementById('operator.organ.id')).combotree({
				url:"${path}/base/organ!getJson.qt?chkAccess=${param.chkAccess}",
				check:function(node){
					//return node.attributes.isUnit!=1;
					return true;
				}
			});
		});
		function submitForm(el){
			$('#newForm').form('submit',{
				url:'${path}/base/account!newAdd.qt?chkAccess='+encodeURIComponent('${param.chkAccess}')+'&random='+getRandomNum(),
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
						}else parent.jQuery.messager.alert('错误','<br/>保存失败！','error');
					}catch(e){parent.jQuery.messager.alert('错误',e.message+'<br/><br/>保存失败！','error');}
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
			<table style="width:100%;table-layout:fixed;" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<th>账号：</th>
	    			<td>
	    				<input type="text" id="operator.account" name="operator.account" class="easyui-validatebox" required="true" validType="exist['${path }/base/account!accountExist.qt?chkAccess=${param.chkAccess}']" maxlength="30" style="width:200px;"/>
	    			</td>
	    		</tr>
	    		<tr>
	    			<th>密码：</th>
	    			<td>
	    				<input type="password" id="operator.password" name="operator.password" style="width:200px;" class="easyui-validatebox" required="true"/>
	    			</td>
	    		</tr>
	    		<tr>
	    			<th>密码确认：</th>
	    			<td>
	    				<input type="password" id="password2" name="password2" style="width:200px;" class="easyui-validatebox" validType="equalTo['operator.password']" required="true"/>
	    			</td>
	    		</tr>
				<tr>
					<th>编号：</th>
					<td>
						<input type="text" name="operator.scode" id="operator.scode" class="easyui-validatebox"  maxlength="50" style="width:200px;"/>
					</td>
				</tr>
	    		<tr>
	    			<th>姓名：</th>
	    			<td>
	    				<input type="text" id="operator.userName" name="operator.userName" style="width:200px;" maxlength="30" class="easyui-validatebox" required="true"/>
	    			</td>
	    		</tr>
	    		<tr>
	    			<th>性别：</th>
	    			<td>
						<input type="radio" id="operator.sex" name="operator.sex" value="1" checked="checked">
						<label for="status1">男</label>
	    				<input type="radio" id="operator.sex" name="operator.sex" value="0">
	    				<label for="status">女</label>
	    			</td>
	    		</tr>
	    		<tr>
	    			<th>手机：</th>
	    			<td>
	    				<input type="text" id="operator.mobile" name="operator.mobile" style="width:200px;" class="easyui-validatebox" validType="mobile" maxlength="11" required="true"/>
	    			</td>
	    		</tr>
	    		<tr>
	    			<th>生日：</th>
	    			<td>
	    				<input type="text" id="operator.birthday" name="operator.birthday"  style="width:200px;" class="easyui-validatebox" onfocus="WdatePicker()" methodType="chooseDate"/>
	    			</td>
	    		</tr>
	    		<tr>
	    			<th>所属组织：</th>
	    			<td>
	    				<input type="text" id="operator.organ.id" name="operator.organ.id" class="easyui-combotree" required="true" style="width:290px;">
	    			</td>
	    		</tr>
	    		<tr>
	    			<td colspan="2" style="height:1%;line-height:20px;padding-top:5px;">
	    				<ul>
	    					<li>账号只能是字母、数字及下划线</li>
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
