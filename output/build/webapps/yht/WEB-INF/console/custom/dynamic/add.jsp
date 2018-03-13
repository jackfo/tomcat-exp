<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/include/include.jsp"%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>新增</title>
	<style type="text/css">
		body{padding:10px;background:#fafafa;overflow:hidden;}
		th{width:100px;height:35px;line-height:35px;text-align:right;font-size:9pt;font-weight:normal;}
		td{height:35px;line-height:35px;font-size:9pt;}
	</style>
	<script type="text/javascript">
		function submitForm(el){
			$('#newForm').form('submit',{
				url:'${path}/custom/dynamic!newAdd.qt?chkAccess=${param.chkAccess}&random='+getRandomNum(),
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
			<input type="hidden" name="dt.entityName" value="${form.name }"/>
			<table style="width:100%;table-layout:fixed;" border="0" cellpadding="0" cellspacing="0">
				<c:catch><c:if test="${not empty form}"><c:forEach var="item" items="${form.attrs}"><tr>
					<th>
						<input type="hidden" name="dt.attrKeys" value="${item.name }"/>
						<input type="hidden" name="dt.attrClazz" value="${item.clazz }"/>
						<label for="dt.attrValues.${item.name }"><c:out value="${item.label}"/>：</label>
					</th>
					<td>
						<input type="text" id="dt.attrValues.${item.name }" name="dt.attrValues" maxlength="${item.length }" style="width:150px" class="easyui-validatebox"<c:if test="${item.clazz eq 'java.sql.Timestamp' }">
							 methodType="chooseDate{dateFmt:'yyyy-MM-dd HH:mm:ss'}"<c:if test="${fn:toLowerCase(item.nomal) eq 'now' }"> value="<%=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()) %>"</c:if></c:if><c:if test="${item.clazz eq 'java.sql.Date' }">
							 methodType="chooseDate"<c:if test="${fn:toLowerCase(item.nomal) eq 'now' }"> value="<%=new SimpleDateFormat("yyyy-MM-dd").format(new Date()) %>"</c:if></c:if><c:if test="${item.clazz eq 'java.sql.Time' }">
							 methodType="chooseDate{dateFmt:'HH:mm:ss'}"<c:if test="${fn:toLowerCase(item.nomal) eq 'now' }"> value="<%=new SimpleDateFormat("HH:mm:ss").format(new Date()) %>"</c:if></c:if><c:if test="${item.clazz eq 'java.lang.Long' or item.clazz eq 'java.lang.Integer' }">
							 validType="decimals['只能输入整数！','^[\\-]?[\\d]+$']" value="${item.nomal }"</c:if><c:if test="${item.clazz eq 'java.lang.Float' or item.clazz eq 'java.lang.Double' }">
							 validType="decimals['只能输入小数','^[\\d]+(\\.[\\d]+)?$']" value="${item.nomal }"</c:if><c:if test="${item.clazz eq 'java.lang.String' }">
							 value="${item.nomal }"</c:if><c:if test="${item.required eq 1 }">
							 required="true"</c:if><c:if test="${item.unique eq 1 }">
							 validType="exist['${path }/custom/dynamic!isExist.qt?entityName=${form.name }&key=${item.name }&clazz=${item.clazz }&chkAccess=${param.chkAccess}']"</c:if><c:if test="${item.mobile eq 1 }">
							 validType="mobile"</c:if>/>
					</td>
				</tr></c:forEach></c:if></c:catch>
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