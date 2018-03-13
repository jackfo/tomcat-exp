<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@page import="com.fs.util.param.StringParam"%><%@
	taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%><%@
	taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%><%@
	taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %><%@
	taglib prefix="x" uri="http://java.sun.com/jsp/jstl/xml" %><%@
	taglib prefix="fs" uri="http://www.flagsky.com/buttons" %><%
	/**-====================================================================
	*                               基本常量的设定
	*=====================================================================**/
	//设定context path
	String path = request.getContextPath();
	if("/".equals(path.trim())) path = "";
	pageContext.setAttribute("path",path);
%>
<script type="text/javascript">
<!--
	var CONTEXT_PATH="<c:out value="${path}" />";
	var PHONE_REGEX="<%=StringParam.PHONE_REGEX.replaceAll("[\\\\]","\\\\\\\\")%>";
	var YD_PHONE_REGEX="<%=StringParam.YD_PHONE_REGEX.replaceAll("[\\\\]","\\\\\\\\")%>";
	var BUTTON_WAIT_TIME=2000;
	var ROOT_WINDOW="ROOT_WINDOW";	//用于判断是否是最根的window
	
	function getRandomNum(){
		return Math.floor(Math.random()*10000+1);
	}

//-->
</script>
<link rel="stylesheet" type="text/css" href="${path }/css/newstyle.css">
<script type="text/javascript" src="${path }/js/jquery.js"></script>
<script type="text/javascript" src="${path }/js/commons.js"></script>
<script type="text/javascript" src="${path }/js/reset.js"></script>

<script type="text/javascript" src="${path}/js/easyui/jquery-1.4.4.min.js"></script>
<script type="text/javascript" src="${path}/js/easyui/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${path}/js/easyui/easyloader.js"></script>
<script type="text/javascript" src="${path}/js/easyui/validatebox.js"></script>
<script type="text/javascript" src="${path}/js/easyui/locale/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" src="${path}/js/jquery.cookie.js"></script>

<!-- easyUI  -->
<link rel="stylesheet" type="text/css" href="${path}/js/easyui/themes/icon.css">
<link rel="stylesheet" type="text/css" href="${path}/js/easyui/themes/default/easyui.css" rel="stylesheet" title="blue">
<link rel="stylesheet" type="text/css" href="${path}/js/easyui/themes/gray/easyui.css" rel="stylesheet" title="gray">
<link rel="stylesheet" type="text/css" href="${path}/js/easyui/themes/green/easyui.css" rel="stylesheet" title="green">
<link rel="stylesheet" type="text/css" href="${path}/js/easyui/themes/orange/easyui.css" rel="stylesheet" title="orange">
<link rel="stylesheet" type="text/css" href="${path}/js/easyui/themes/pink/easyui.css" rel="stylesheet" title="pink">
<link rel="stylesheet" type="text/css" href="${path}/js/easyui/themes/default/easyui.css" rel="stylesheet" title="blue">

