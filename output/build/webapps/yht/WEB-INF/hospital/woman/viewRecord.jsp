<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/include/include.jsp"%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>查看孕妇复诊记录</title>
<style type="text/css">
	body{padding:10px;background:#fafafa;overflow:hidden;}
	th{width:80px;height:30px;line-height:30px;text-align:right;font-size:9pt;font-weight:normal;}
	td{height:30px;line-height:30px;font-size:9pt;}
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
			<table style="width:100%;table-layout:fixed;" border="1" cellpadding="0" cellspacing="0">
	    		<tr>
	    			<th>复诊记录：</th>
	    			<td style="width:350px;height: 220px;">
	    				${item.visitRecord}
	    				<c:if test="${item.visitRecord eq null}">暂无复诊记录&nbsp;</c:if>
	    			</td>
	    		</tr>
	    		<tr>
	    			<th>复诊次数：</th>
	    			<td style="width:350px;height: 30px;">
	    				${item.count}<c:if test="${item.count eq null}">0</c:if>
	    			</td>
	    		</tr>
	    		<tr>
	    			<td colspan="2" align="center" height="50" valign="bottom">
	    				<a href="javascript:closeWindow();" class="easyui-linkbutton" plain="false" iconCls="icon-no">关闭</a>
	    			</td>
	    		</tr>
	    	</table>
	    </form>
	</body>
</html>