<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/include/include.jsp"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%
	Map hm = new HashMap();
	hm.put(1, "男");
	hm.put(0, "女");

	Map sm = new HashMap();
	sm.put(1, "正常");
	sm.put(0, "禁用");
	pageContext.setAttribute("hm_sex", hm);
	pageContext.setAttribute("hm_status", sm);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>操作员管理</title>
		<script type="text/javascript" src="${path }/js/easyui/window.js"></script>
		<link rel="stylesheet" type="text/css"
			href="${path }/css/buttonPanel.css">
		<style>
* {
	margin: 0px;
	padding: 0px
}

ul {
	list-style: none;
}

.mytable {
	padding: 5px 5px;
}

input {
	height: 21px;
	line-height: 21px;
	font-size: 9pt;
}

.buttonPanel .formPanel {
	margin-left: 10px;
}

.buttonPanel .formPanel label {
	float: left;
	line-height: 28px;
	width: 80px;
	text-align: right;
}

table{width: 500px;margin: 10px;border-top: 1px solid #cccccc;border-left: 1px solid #cccccc;}
.titletd{text-align: center;width: 100px;background-color: #eeeeee;}
td{height: 25px;line-height: 25px;border-bottom: 1px solid #cccccc;border-right: 1px solid #cccccc;}
</style>
		<script type="text/javascript">
<!--
	var win,table; 
	$(document).ready(function(){
		getColorStyle();
		win = new Jwindow(function(table){});
	});
	
//-->	
</script>
	</head>
	<body>
		<div class="buttonPanel">
			<div class="formPanel">
				<div class="clear"></div>
			</div>
			<div class="datagrid-btn-separator" style="visibility: hidden;"></div>
			<fs:button key="MODIFYOPERATOR" id="modifyoperator" name="修改个人信息"
				iconCls="icon-edit">
			function(){
				win.show('修改个人信息','${path}/base/account!preModifyOperator.qt?chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum(),table);
				win.reSize(450,350);
			}
			</fs:button>
			<fs:button key="MODIFYPWD" id="modifypwd" name="修改密码"
				iconCls="icon-redo">
				function(){
					win.show('修改密码','${path}/base/account!preModifyPass.qt?chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum(),table);
					win.reSize(350,250);
				}
			</fs:button>
			<div class="clear"></div>
		</div>
		<!-- <table id="dataList"></table> -->
		<TABLE cellpadding="0" cellspacing="0" style="width:400px;table-layout: fixed;">
			<tr>
				<td class="titletd">
					&nbsp;&nbsp;编号
				</td>
				<td>
					${item.scode }
				</td>
			</tr>
			<tr>
				<td class="titletd">
					&nbsp;&nbsp;账号
				</td>
				<td>
					${item.account }
				</td>
			</tr>
			<tr>
				<td class="titletd">
					&nbsp;&nbsp;姓名
				</td>
				<td>
					${item.userName }
				</td>
			</tr>
			<tr>
				<td class="titletd">
					&nbsp;&nbsp;性别
				</td>
				<td>
					${hm_sex[item.sex] }
				</td>
			</tr>
			<tr>
				<td class="titletd">
					&nbsp;&nbsp;手机
				</td>
				<td>
					${item.mobile }
				</td>
			</tr>
			<tr>
				<td class="titletd">
					&nbsp;&nbsp;生日
				</td>
				<td>
					<fmt:formatDate value="${item.birthday }" pattern="yyyy-MM-dd"/>&nbsp;
				</td>
			</tr>
			<tr>
				<td class="titletd">
					&nbsp;&nbsp;角色
				</td>
				<td>
					${item.role.roleName }
				</td>
			</tr>
			<tr>
				<td class="titletd">
					&nbsp;&nbsp;状态
				</td>
				<td>
					${hm_status[item.status] }
				</td>
			</tr>
		</TABLE>
	</body>
</html>