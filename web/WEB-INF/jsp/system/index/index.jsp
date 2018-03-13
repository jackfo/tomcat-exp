<%@page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}"></c:set>

<%
    String path = request.getContextPath();
    String basePath = request.getScheme() + "://"
            + request.getServerName() + ":" + request.getServerPort()
            + path + "/";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <base href="<%=basePath%>">

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="renderer" content="webkit">
    <title>人力资源管理系统</title>
    <link rel="shortcut icon" href="${contextPath}/hfr/img/favicon.ico">
    <link href="${contextPath}/hfr/css/bootstrap.min.css?v=3.3.6" rel="stylesheet">
    <link href="${contextPath}/hfr/css/font-awesome.min.css?v=4.4.0" rel="stylesheet">
    <link href="${contextPath}/hfr/css/animate.css" rel="stylesheet">
    <link href="${contextPath}/hfr/css/style.css?v=4.1.0" rel="stylesheet">
</head>

<body class="fixed-sidebar full-height-layout gray-bg" style="overflow:hidden">


<div id="wrapper">
    <!--左侧导航开始-->
    <%@ include file="index_left.jsp"%>

    <!--左侧导航结束-->
    <!--右侧部分开始-->
    <div id="page-wrapper" class="gray-bg dashbard-1">
        <%@ include file="index_right.jsp"%>
        <%--<div class="footer">--%>
            <%--<div class="pull-right">&copy; 2017-2018 郑小康--%>
            <%--</div>--%>
        <%--</div>--%>
    </div>
    <!--右侧部分结束-->
  
</div>

<!-- 全局js -->
<script src="${contextPath}/hfr/js/jquery.min.js?v=2.1.4"></script>
<script src="${contextPath}/hfr/js/bootstrap.min.js?v=3.3.6"></script>
<script src="${contextPath}/hfr/js/plugins/metisMenu/jquery.metisMenu.js"></script>
<script src="${contextPath}/hfr/js/plugins/slimscroll/jquery.slimscroll.min.js"></script>
<script src="${contextPath}/hfr/js/plugins/layer/layer.min.js"></script>

<!-- 自定义js -->
<script src="${contextPath}/hfr/js/hplus.js?v=4.1.0"></script>
<script type="text/javascript" src="${contextPath}/hfr/js/contabs.js"></script>

<!-- 第三方插件 -->
<script src="${contextPath}/hfr/js/plugins/pace/pace.min.js"></script>

</body>

</html>
