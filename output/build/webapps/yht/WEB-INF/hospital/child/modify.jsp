<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/include/include.jsp"%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>修改儿童</title>
<style type="text/css">
	body{padding:10px;background:#fafafa;overflow:hidden;}
	th{width:95px;height:30px;line-height:30px;text-align:right;font-size:9pt;font-weight:normal;}
	td{height:30px;line-height:30px;font-size:9pt;}
</style>
	<script type="text/javascript">
		function submitForm(el){
			var treeVal =  $('#vaccineTypeId').combotree('getValue');
			if(treeVal==''){
				parent.jQuery.messager.alert('错误','<br/>请选择免疫类型后在提交保存！','error');
				return;
			}
			$('#newForm').form('submit',{
				url:'${path}/hospital/child!modify.qt?chkAccess=${param.chkAccess}&random='+getRandomNum(),
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
			<input type="hidden" name="id" id="id" value="${item.id }"/>
			<table style="width:100%;table-layout:fixed;" border="0" cellpadding="0" cellspacing="0">
	    		<tr>
	    			<th>儿童姓名：</th>
	    			<td>
	    				<input id="child.name" name="child.name" value="${item.name}" class="easyui-validatebox" required="true" maxlength="10" style="width:350px;">
	    			</td>
	    		</tr>
	    		<tr>
	    			<th>儿童年龄：</th>
	    			<td>
	    				<input id="child.age" name="child.age" value="${item.age}" validType="number" class="easyui-validatebox" required="true" maxlength="25" style="width:350px;">
	    			</td>
	    		</tr>
	    		<tr>
	    			<th>家长姓名：</th>
	    			<td>
	    				<input id="child.parentName" value="${item.parentName}" name="child.parentName" class="easyui-validatebox" required="true" maxlength="10" style="width:350px;">
	    			</td>
	    		</tr>
	    		<tr>
	    			<th>免疫类型：</th>
	    			<td>
	    				<select id="vaccineTypeId" name="child.vaccineTypeId" class="easyui-combotree" required="true"  url="${path}/hospital/vaccine!getAllTypes.qt?chkAccess=${param.chkAccess}" style="width:350px;">
							<option selected="selected" value="${item.vaccineTypeId}">${item.vaccineType.name}</option>
						</select>
	    			</td>
	    		</tr>
	    		<tr>
	    			<th>联系电话：</th>
	    			<td>
	    				<input id="child.phone" name="child.phone" value="${item.phone}" validType="mobile" class="easyui-validatebox" required="true" maxlength="15" style="width:350px;">
	    			</td>
	    		</tr>
	    		<tr>
	    			<th>儿童住址：</th>
	    			<td>
	    				<input id="child.addr" name="child.addr" value="${item.addr}" class="easyui-validatebox" required="true" maxlength="60" style="width:350px;">
	    			</td>
	    		</tr>
	    		<tr>
	    			<th>出生日期：</th>
	    			<td>
	    				<input id="child.birthday" name="child.birthday" value="<fmt:formatDate value="${item.birthday}" pattern="yyyy-MM-dd" type="date"/>" class="easyui-validatebox" required="true" methodType="chooseDate{dateFmt:'yyyy-MM-dd'}" style="width:350px;">
	    			</td>
	    		</tr>
	    		<tr>
	    			<th>开始接种日期：</th>
	    			<td>
	    				<input id="child.startTime" name="child.startTime" value="<fmt:formatDate value="${item.startTime}" pattern="yyyy-MM-dd" type="date"/>" class="easyui-validatebox" required="true" methodType="chooseDate{dateFmt:'yyyy-MM-dd'}" style="width:350px;">
	    			</td>
	    		</tr>
	    		<tr>
	    			<th>短信提醒：</th>
	    			<td>
	    				<input type="radio" id="child.isMessage.1" name="child.isMessage" value="1" <c:if test="${empty item.isMessage or item.isMessage eq 1 }"> checked="checked"</c:if> style="cursor:pointer;"/>
						<label for="child.isMessage.1" style="cursor:pointer;">是</label>
						
						<input type="radio" id="child.isMessage.0" name="child.isMessage" value="0" <c:if test="${item.isMessage eq 0 }"> checked="checked"</c:if> style="cursor:pointer;"/>
						<label for="child.isMessage.0" style="cursor:pointer;">否</label>
	    			</td>
	    		</tr>
	    		<tr>
	    			<th>备注：</th>
	    			<td style="height: 100px;width: 100%;">
						<textarea id="child.messageDesc" rows="5" name="child.messageDesc" style="cursor:pointer;width:350px;">${item.messageDesc}</textarea>
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