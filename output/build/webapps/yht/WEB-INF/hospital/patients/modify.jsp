<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/include/include.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>修改患者</title>
<style type="text/css">
	body{padding:10px;background:#fafafa;overflow:hidden;}
	th{width:80px;height:30px;line-height:30px;text-align:right;font-size:9pt;font-weight:normal;}
	td{height:30px;line-height:30px;font-size:9pt;}
</style>
	<script type="text/javascript">
		function submitForm(el){			
			$('#newForm').form('submit',{
				url:'${path}/hospital/patients!modify.qt?random='+getRandomNum()+'&chkAccess='+encodeURIComponent('${param.chkAccess}'),
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
	    			<th>患者姓名：</th>
	    			<td>
	    				<input id="patients.name" name="patients.name" value="${item.name}" class="easyui-validatebox" required="true" maxlength="10" style="width:350px;">
	    			</td>
	    		</tr>
	    		<tr>
	    			<th>患者编号：</th>
	    			<td>
	    				<input id="patients.scode" name="patients.scode" value="${item.scode}" class="easyui-validatebox" required="true" maxlength="10" style="width:350px;">
	    			</td>
	    		</tr>
	    		<tr>
	    			<th>患者性别：</th>
	    			<td>
	    				<input type="radio" id="patients.sex.1" name="patients.sex" value="1"<c:if test="${empty item.sex or item.sex eq 1 }"> checked="checked"</c:if> style="cursor:pointer;"/>
						<label for="patients.sex.1" style="cursor:pointer;">男</label>
						
						<input type="radio" id="patients.sex.0" name="patients.sex" value="0"<c:if test="${item.sex eq 0 }"> checked="checked"</c:if> style="cursor:pointer;"/>
						<label for="patients.sex.0" style="cursor:pointer;">女</label>
	    			</td>
	    		</tr>
	    		<tr>
	    			<th>患者年龄：</th>
	    			<td>
	    				<input id="patients.age" name="patients.age" value="${item.age}" validType="number" class="easyui-validatebox" required="true" maxlength="25" style="width:350px;">
	    			</td>
	    		</tr>
	    		<tr>
	    			<th>患者电话：</th>
	    			<td>
	    				<input id="patients.phone" name="patients.phone"  value="${item.phone}" validType="mobile" class="easyui-validatebox" required="true" maxlength="15" style="width:350px;">
	    			</td>
	    		</tr>
	    		<tr>
	    			<th>所属科室：</th>
	    			<td>
	    				<input id="patients.departments" name="patients.departments" value="${item.departments}" class="easyui-validatebox" required="true" maxlength="25" style="width:350px;">
	    			</td>
	    		</tr>
	    		<tr>
	    			<th>患者住址：</th>
	    			<td>
	    				<input id="patients.addr" name="patients.addr" class="easyui-validatebox" value="${item.addr}" required="true" maxlength="60" style="width:350px;">
	    			</td>
	    		</tr>
	    		<tr>
	    			<th>入院时间：</th>
	    			<td>
	    				<input id="patients.enterTime" name="patients.enterTime" value="<fmt:formatDate value="${item.enterTime}" pattern="yyyy-MM-dd" type="date"/>" class="easyui-validatebox" required="true" methodType="chooseDate{dateFmt:'yyyy-MM-dd'}" style="width:350px;">
	    			</td>
	    		</tr>
	    		<tr>
	    			<th>出院时间：</th>
	    			<td>
	    				<input id="patients.exitTime" name="patients.exitTime" value="<fmt:formatDate value="${item.exitTime}" pattern="yyyy-MM-dd" type="date"/>" class="easyui-validatebox"  required="true" methodType="chooseDate{dateFmt:'yyyy-MM-dd'}" style="width:350px;">
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
