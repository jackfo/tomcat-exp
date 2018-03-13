<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/include/include.jsp"%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>新增孕妇</title>
<style type="text/css">
	body{padding:10px;background:#fafafa;overflow:hidden;}
	th{width:80px;height:30px;line-height:30px;text-align:right;font-size:9pt;font-weight:normal;}
	td{height:30px;line-height:30px;font-size:9pt;}
</style>
	<script type="text/javascript">
		function submitForm(el){
			$('#newForm').form('submit',{
				url:'${path}/hospital/woman!newAdd.qt?chkAccess=${param.chkAccess}&random='+getRandomNum(),
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
	    			<th>姓名：</th>
	    			<td>
	    				<input id="woman.name" name="woman.name" class="easyui-validatebox" required="true" maxlength="10" style="width:350px;">
	    			</td>
	    		</tr>
	    		<tr>
	    			<th>年龄：</th>
	    			<td>
	    				<input id="woman.age" name="woman.age" validType="number" class="easyui-validatebox" required="true" maxlength="2" style="width:350px;">
	    			</td>
	    		</tr>
	    		<tr>
	    			<th>第一次检查时间：</th>
	    			<td>
	    				<input id="woman.firstInspectionTime" name="woman.firstInspectionTime" class="easyui-validatebox" required="true" methodType="chooseDate{dateFmt:'yyyy-MM-dd'}" style="width:350px;">
	    			</td>
	    		</tr>
	    		<tr>
	    			<th>预产期：</th>
	    			<td>
	    				<input id="woman.ExpectedDate" name="woman.ExpectedDate" class="easyui-validatebox" required="true" methodType="chooseDate{dateFmt:'yyyy-MM-dd'}" style="width:350px;">
	    			</td>
	    		</tr>
	    		<tr>
	    			<th>末次月经：</th>
	    			<td>
	    				<input id="woman.lastMenstrual" name="woman.lastMenstrual" class="easyui-validatebox" required="true" methodType="chooseDate{dateFmt:'yyyy-MM-dd'}" style="width:350px;">
	    			</td>
	    		</tr>
	    		<tr>
	    			<th>联系电话：</th>
	    			<td>
	    				<input id="woman.phone" name="woman.phone" validType="mobile" class="easyui-validatebox" required="true" maxlength="15" style="width:350px;">
	    			</td>
	    		</tr>
	    		<tr>
	    			<th>住址：</th>
	    			<td>
	    				<input id="woman.addr" name="woman.addr" class="easyui-validatebox" required="true" maxlength="50" style="width:350px;">
	    			</td>
	    		</tr>
	    		<tr>
	    			<th>教育程度：</th>
	    			<td>
	    				<input id="woman.education" name="woman.education" class="easyui-validatebox" required="true" maxlength="15" style="width:350px;">
	    			</td>
	    		</tr>
	    		<!-- 
	    		<tr>
	    			<th>复诊记录：</th>
	    			<td>
	    				<input id="woman.visitRecord" name="woman.visitRecord" class="easyui-validatebox" required="true" maxlength="15" style="width:350px;">
	    			</td>
	    		</tr>
	    		<tr>
	    			<th>复诊次第：</th>
	    			<td>
	    				<input id="woman.count" name="woman.count" value="1" class="easyui-validatebox" validType="number" required="true" maxlength="2" style="width:350px;">
	    			</td>
	    		</tr>
	    		 -->
	    		<tr>
	    			<th>孕妇类型：</th>
	    			<td>
	    				<input type="radio" id="woman.womenType.1" name="woman.womenType" checked="checked" value="1" style="cursor:pointer;"/>
						<label for="woman.womenType.1" style="cursor:pointer;">产妇</label>
						
						<input type="radio" id="woman.womenType.0" name="woman.womenType" value="0" style="cursor:pointer;"/>
						<label for="woman.womenType.0" style="cursor:pointer;">孕妇</label>
	    			</td>
	    		</tr>
	    		<tr>
	    			<th>备注：</th>
	    			<td style="height: 1%;">
						<textarea id="woman.messageDesc" rows="4" name="woman.messageDesc" class="easyui-validatebox" validType="filterWord[0,150]"  style="width:350px;"></textarea>
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