<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="com.fs.util.param.StringParam"%><%@
	taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%><%@
	taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%><%@
	taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %><%@
	taglib prefix="x" uri="http://java.sun.com/jsp/jstl/xml" %><%@
	taglib prefix="fs" uri="http://www.flagsky.com/buttons" %><%@
	taglib prefix="s" uri="/struts-tags" %><%
String path = request.getContextPath();
if("/".equals(path)) path = "";
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>My JSP 'success.jsp' starting page</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
	<script type="text/javascript" src="<%=path %>/js/easyui/jquery-1.4.4.min.js"></script>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			var error = "";
			<s:if test="hasFieldErrors()"><s:iterator value="fieldErrors"><s:iterator value="value">
			error += '<s:property escape="false"/>'</s:iterator></s:iterator></s:if>
			if(error!=''&&parent&&parent.refresh){
				parent.refresh({b:false, message:error});
			}
		});
	</script>
  </head>
  
  <body>
  	<center><s:if test="hasActionErrors()"><s:iterator value="actionErrors">
  		<s:property escape="false"/><br/></s:iterator></s:if><s:if test="hasActionMessages()"><s:iterator value="actionMessages">
  		<s:property escape="false"/><br/></s:iterator></s:if><c:if test="${not empty errorInfo }"><c:out value="${errorInfo }"/></c:if></center>
    <p align="center"><font color="red" size="5">出错了！</font></p>
    <p align="center"><a href="<%=path %>/">重新登陆</a></p>
  </body>
</html>