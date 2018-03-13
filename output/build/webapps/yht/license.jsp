<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@page import="com.fs.license.pojo.License"%>
<%@page import="com.fs.license.tools.LicenseManager"%>
<%
String _licenseDir = ((HttpServletRequest)request).getSession().getServletContext().getRealPath("/")+"WEB-INF/lib/";
License _license = LicenseManager.getInstance().decode(_licenseDir+"license.lic");
request.setAttribute("_license",_license);
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
	<%@ include file="/include/include.jsp" %>
    <title></title>
	<style type="text/css">
		body{background: url(${path }/images/license.jpg) no-repeat;position: relative;}
		.title{font-size: 30px;position: absolute;top: 310px;left: 280px;font-weight: bold;}
		.lt{width: 550px;position: absolute;top: 350px;left: 240px;}
		.lt .td1{text-align: right;width: 120px;line-height: 20px; height: 20px;}
		.lt .td2{text-align: left;line-height: 20px; height: 20px;}
	</style>
  </head>
  
  <body>
		<div class="title">MAS服务器硬件信息</div>
		<table border="0" class="lt" style="table-layout: fixed;">
			<tr><td class="td1">产品名称：</td><td class="td2">${_license.productName }</td></tr>			
			<tr><td class="td1">版本号：</td><td class="td2">${_license.version }</td></tr>			
			<tr><td class="td1">有效期至：</td><td class="td2">${_license.expiry }</td></tr>	
			<!-- 
			<tr><td class="td1">MAS地址：</td><td class="td2">${_license.mac }</td></tr>			
			<tr><td class="td1">机器码：</td><td class="td2">${_license.machineCode }</td></tr>			
			 -->		
			<tr><td class="td1">服务启动时间：</td><td class="td2">${Application_Start_Time}</td></tr>			
			<tr><td class="td1">系统登录时间：</td><td class="td2">${login_time }</td></tr>			
			<tr><td class="td2" colspan="2">&nbsp;</td></tr>			
			<tr><td colspan="2" style="text-align: center;">Copyright© 2007-2012 <a href="http://www.flagsky.com" target="_blank">www.flagsky.com</a> All Rights Reserved 版权所有：武汉商秦软件有限公司</td></tr>			
		</table>
  </body>
</html>
