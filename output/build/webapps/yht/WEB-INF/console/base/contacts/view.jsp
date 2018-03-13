<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/include/include.jsp"%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>修改联系人</title>
		<script type="text/javascript" src="${path }/js/sms/validatebox.js"></script>
		<style type="text/css">
			body{padding:10px;background:#fafafa;}
			th{padding:3px;width:80px;text-align:right;font-size:9pt;font-weight:normal;}
			td{padding:3px;word-break:break-all;font-size:9pt;border-bottom:1px dotted #ccc;}
		</style>
		<script type="text/javascript">
			function closeWindow(){
				if(parent&&parent.win) parent.win.refreshParent();
			}
		</script>
	</head>
	<body>
		<form id="newForm" name="newForm" method="post">
			<input type="hidden" name="chkAccess" value="${param.chkAccess }">
			<input type="hidden" name="contacts.id" value="${item.id }">
			<table style="width:100%;table-layout:fixed;" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<th>姓名：</th>
					<td>
						<c:out value="${item.name }"/>&nbsp;
					</td>
					<th>编号：</th>
					<td>
						<c:out value="${item.code }"/>&nbsp;
					</td>
					<td style="width:10px;border:0px;">&nbsp;</td>
				</tr>
				<tr>
					<th>性别：</th>
					<td><c:if test="${empty item.sex or item.sex eq 1 }">男</c:if>
						<c:if test="${item.sex eq 0 }">女</c:if>&nbsp;
					</td>
					<th>生日：</th>
					<td><c:if test="${dateType eq 1 }">
						公历 </c:if><c:if test="${dateType eq 0 }">
						农历 </c:if><c:out value="${item.birthday }"/>&nbsp;
					</td>
					<td style="border:0px;">&nbsp;</td>
	    		</tr>
	    		<tr>
					<th>手机(主)：</th>
					<td>
						<c:out value="${item.phone }"/>&nbsp;
					</td>
					<th>号码(备1)：</th>
					<td>
						<c:out value="${item.phoneBK1 }"/>&nbsp;
					</td>
					<td style="border:0px;">&nbsp;</td>
				</tr>
				<tr>
					<th>E-mail：</th>
					<td>
						<c:out value="${item.email }"/>&nbsp;
					</td>
					<th>号码(备2)：</th>
					<td>
						<c:out value="${item.phoneBK2 }"/>&nbsp;
					</td>
					<td style="border:0px;">&nbsp;</td>
				</tr>
				<tr>
					<th>地址：</th>
					<td colspan="3">
						<c:out value="${item.address }"/>&nbsp;
					</td>
					<td style="border:0px;">&nbsp;</td>
				</tr>
				<tr>
					<th>QQ：</th>
					<td>
						<c:out value="${item.qq }"/>&nbsp;
					</td>
					<th>飞信：</th>
					<td>
						<c:out value="${item.fetion }"/>&nbsp;
					</td>
					<td style="border:0px;">&nbsp;</td>
				</tr>
				<tr>
					<th>状态：</th>
					<td><c:if test="${item.status eq 1 }">
						不发短信</c:if>&nbsp;
					</td>
					<th>分组：</th>
					<td style="line-height:100%"><c:forEach var="group" items="${item.groups}" varStatus="s">
						<c:if test="${group.type eq 1}"><span style="color:red">[共]</span></c:if><c:out value="${group.name}"/><c:if test="${not s.last}">，</c:if></c:forEach>&nbsp;
					</td>
					<td style="border:0px;">&nbsp;</td>
				</tr>
	    		<tr>
	    			<td colspan="5" align="center" height="40" valign="bottom" style="border:0px;">
	    				<a href="javascript:closeWindow();" class="easyui-linkbutton" plain="false" iconCls="icon-remove">关闭</a>
	    			</td>
	    		</tr>
	    	</table>
	    </form>
	</body>
</html>