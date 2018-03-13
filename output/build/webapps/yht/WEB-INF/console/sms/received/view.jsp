<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/include/include.jsp"%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>查看信息</title>
		<style type="text/css">
			body{padding:10px;background:#fafafa;}
			th{width:80px;height:30px;line-height:30px;text-align:right;font-size:9pt;font-weight:normal;background:#fff;}
			td{padding:0px 5px;height:30px;line-height:30px;font-size:9pt;background:#fff;}
		</style>
		<script type="text/javascript">
			function closeWindow(){
				if(parent&&parent.win) parent.win.refreshParent();
			}
		</script>
	</head>
	<body>
		<table style="width:100%;margin-bottom:20px;table-layout:fixed;background:#aaa" border="0" cellpadding="0" cellspacing="1">
			<tr>
				<th>发送号码：</th>
				<td>
					<c:out value="${item.smOrgAddr}"/>
				</td>
				<th>接收号码：</th>
				<td>
					<c:out value="${item.smDestAddr}"/>
				</td>
    		</tr>
    		<tr>
    			<th>发送时间：</th>
    			<td colspan="3">
    				<fmt:formatDate value="${item.smRecvTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
    			</td>
    		</tr>
    		<tr>
    			<th style="" valign="top">短信内容：</th>
    			<td id="keyContent" style="line-height: 30px;height: 100px;vertical-align: top;" colspan="3">
    				<c:out value="${item.smMsgContent}"/>
    			</td>
    		</tr>
    	</table>
    	<center>
    		<a href="javascript:closeWindow();" class="easyui-linkbutton" plain="false" iconCls="icon-remove">关闭</a>
    	</center>
	</body>
</html>