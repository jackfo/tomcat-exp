<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="x" uri="http://java.sun.com/jsp/jstl/xml" %>
<%@ taglib prefix="fs" uri="http://www.flagsky.com/buttons" %>
<%
	String path = request.getContextPath();
	if("/".equals(path.trim())) path = "";
	pageContext.setAttribute("path",path);
%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>图标选择</title>
		<script type="text/javascript" src="${path }/js/jquery.js"></script>
		<link rel="stylesheet" type="text/css" href="${path}/css/easyUImain.css">
		<style type="text/css">
			*{margin: 0px;padding: 0px;overflow: hidden;font-size: 12px;background-color: white;}
			body{overflow-y: auto;background-color: #FFFFFF;text-align: center;}
			.iconContent{padding: 0px;margin: 0px auto;width: 600px;}
			.iconContent .iconItem{float: left;margin: 0px;padding: 0px;overflow:hidden;cursor:pointer;}
		</style>
		<script type="text/javascript">
			function submitForm(obj){
				parent.${param.jsname}.refreshParent({'iconVal':$(obj).attr('value')});
			}
		</script>
	</head>
	<body>
		<div class="iconContent"><c:forEach begin="1" end="520" step="1" varStatus="s">
			<div onclick="submitForm(this)" title="点击选择并返回" value="icon-${s.index }" class="iconItem iconMain icon-${s.index }"></div><c:if test="${s.index % 30 == 0}">
			<div style="clear: both;"></div></c:if></c:forEach>	
		</div>
	</body>
</html>