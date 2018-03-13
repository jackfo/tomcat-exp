<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="/include/include.jsp"%>     
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>系统日志下载</title>
	<style>
		body{background:#fafafa;overflow:hidden;padding:5px;}
		ol{margin:0 20px 0 40px\9;}
		ol,li{line-height:20px;margin:5px;}
	</style>
	<script type="text/javascript">
	<!--
		function submitForm(el){
			if($(el).linkbutton('options').disabled) return;
			if(0>=$('input[name="filename"]:checked').length) return;
			$('#newForm').submit();
			$(el).linkbutton({disabled:true});
			setTimeout("$('#submitBtn').linkbutton({disabled:false});", 3000);
			//if(parent&&parent.win)parent.win.hide();//如果设置destroy为true，则隐藏并销毁JWindow对象
		}
		function reset(){
			newForm.reset();
		}
	//-->
	</script>
</head>
<body>
	<form id="newForm" name="newForm" method="post" action="${path }/base/log!downSysLog.qt">
		<input type="hidden" name="chkAccess" value="${param.chkAccess }"/>
		<table width="100%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td>
					<div style="width:100%;height:180px;overflow:hidden;overflow-y:auto;">
						<ol><c:forEach var="item" items="${map }" varStatus="s"><c:if test="${not fn:endsWith(item.key,'.zip')}">
							<li>
								<input type="checkbox" id="checkbox_${s.index }" name="filename" value="${item.value }"<c:if test="${fn:endsWith(item.key,'.log')}"> checked="checked"</c:if>/>
								<label for="checkbox_${s.index }" style="cursor:pointer;"><c:out value="${item.key }"/></label>
							</li></c:if></c:forEach>
						</ol>
					</div>
				</td>
			</tr>
			<tr>
	   			<td align="center" height="35" valign="bottom">
	   				<a href="#" id="submitBtn" onclick="submitForm(this);" class="easyui-linkbutton" plain="false" iconCls="icon-save" style="margin-right:10px">批量下载</a>
	   				<a href="javascript:reset();" class="easyui-linkbutton" plain="false" iconCls="icon-remove">重置</a>
	   			</td>
	   		</tr>
		</table>
	</form>
</body>
</html>
