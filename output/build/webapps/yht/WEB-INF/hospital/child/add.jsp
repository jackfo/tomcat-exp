<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/include/include.jsp"%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>新增儿童</title>
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
				url:'${path}/hospital/child!newAdd.qt?chkAccess=${param.chkAccess}&random='+getRandomNum(),
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
	    			<th>儿童姓名：</th>
	    			<td>
	    				<input id="child.name" name="child.name" class="easyui-validatebox" required="true" maxlength="10" style="width:350px;">
	    			</td>
	    		</tr>
	    		<tr>
	    			<th>儿童年龄：</th>
	    			<td>
	    				<input id="child.age" name="child.age" validType="number" class="easyui-validatebox" required="true" maxlength="25" style="width:350px;">
	    			</td>
	    		</tr>
	    		<tr>
	    			<th>家长姓名：</th>
	    			<td>
	    				<input id="child.parentName" name="child.parentName" class="easyui-validatebox" required="true" maxlength="10" style="width:350px;">
	    			</td>
	    		</tr>
	    		<tr>
	    			<th>免疫类型：</th>
	    			<td>
	    				<select id="vaccineTypeId" name="child.vaccineTypeId" class="easyui-combotree" required="true"  url="${path}/hospital/vaccine!getAllTypes.qt?chkAccess=${param.chkAccess}" style="width:350px;">
						</select>
	    			</td>
	    		</tr>
	    		<tr>
	    			<th>联系电话：</th>
	    			<td>
	    				<input id="child.phone" name="child.phone" validType="mobile" class="easyui-validatebox" required="true" maxlength="15" style="width:350px;">
	    			</td>
	    		</tr>
	    		<tr>
	    			<th>儿童住址：</th>
	    			<td>
	    				<input id="child.addr" name="child.addr" class="easyui-validatebox" required="true" maxlength="60" style="width:350px;">
	    			</td>
	    		</tr>
	    		<tr>
	    			<th>出生日期：</th>
	    			<td>
	    				<input id="child.birthday" name="child.birthday" class="easyui-validatebox" required="true" methodType="chooseDate{dateFmt:'yyyy-MM-dd'}" style="width:350px;">
	    			</td>
	    		</tr>
	    		<tr>
	    			<th>开始接种日期：</th>
	    			<td>
	    				<input id="child.startTime" name="child.startTime" class="easyui-validatebox" required="true" methodType="chooseDate{dateFmt:'yyyy-MM-dd'}" style="width:350px;">
	    			</td>
	    		</tr>
	    		<tr>
	    			<th>短信提醒：</th>
	    			<td>
	    				<input type="radio" id="child.isMessage.1" name="child.isMessage" checked="checked" value="1" style="cursor:pointer;"/>
						<label for="child.isMessage.1" style="cursor:pointer;">是</label>
						
						<input type="radio" id="child.isMessage.0" name="child.isMessage" value="0" style="cursor:pointer;"/>
						<label for="child.isMessage.0" style="cursor:pointer;">否</label>
	    			</td>
	    		</tr>
	    		<tr>
	    			<th>备注：</th>
	    			<td style="height: 100px;width: 100%;">
						<textarea id="child.messageDesc" rows="5" name="child.messageDesc" style="cursor:pointer;width:350px;"></textarea>
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