<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/include/include.jsp"%><%@
	taglib prefix="ft" uri="http://www.flagsky.com/functions" %>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>查看结果</title>
		<script type="text/javascript" src="${path }/js/easyui/window.js"></script>
		<script type="text/javascript" src="${path }/js/vote/Vote.js"></script>
		<style type="text/css">
			*{margin:0px;padding:0px}
			body{padding:10px;background:#fafafa;}
			th{width:80px;height:35px;line-height:35px;text-align:right;font-size:9pt;font-weight:normal;}
			td{height:35px;line-height:35px;font-size:9pt;}
		</style>
		<script type="text/javascript">
			jQuery(document).ready(function(){
				
			});
			function closeWindow(){
				if(parent&&parent.win) parent.win.refreshParent();
			}
		</script>
	</head>
	<body>
		<form id="newForm" name="newForm" method="post">
			<input type="hidden" name="chkAccess" value="${param.chkAccess }">
			<input type="hidden" name="vote.id" value="${vote.id }">
			<input type="hidden" name="vote.mark" value="${vote.mark }">
			<table style="width:100%;table-layout:fixed;" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<th>标题：</th>
					<td>
						<c:out value="${vote.title }"/>
					</td>
					<td style="width:80px">&nbsp;</td>
				</tr>
				<tr>
					<th style="height:1%;" valign="top">描述：</th>
					<td colspan="2">
						<c:out value="${vote.desc}"/>
					</td>
				</tr>
				<tr>
					<th style="height:1%;" valign="top">接收号码：</th>
					<td colspan="2" style="padding:5px;word-wrap:break-word;word-break:normal;line-height:16px;">
						<c:out value="${ft:cropString(vote.destAddrs,335)}"/>
					</td>
				</tr><c:forEach var="voteItem" items="${vote.item}">
				<tr>
					<th><c:out value="${voteItem.content }"/>：</th>
					<td style="padding:3px;" valign="middle">
						<div style="position:relative;width:100%;height:22px;background-color:#ddd;overflow:hidden;border:2px ridge #ccc;border:0px\9;"><c:if test="${voteItem.count>0}">
				   			<div style="width:<fmt:formatNumber value="${voteItem.count/vote.count*100 }" pattern="0.0"/>%;height:22px;background:red;filter:Alpha(Opacity=${voteItem.count/vote.count*50+30 })\9;opacity:${voteItem.count/vote.count+0.2 };"></div>
				   			<div style="position:absolute;white-space:nowrap;top:0px;left:10px;margin-left:5px;height:22px;line-height:22px;font-weight:900;"><fmt:formatNumber value="${voteItem.count/vote.count*100 }" pattern="0.0"/>%</div></c:if>
				   		</div>
					</td>
					<td style="padding-left:5px"><c:out value="${voteItem.count}"></c:out> 票</td>
				</tr></c:forEach>
				<tr>
					<td colspan="3" align="center" height="40" valign="bottom">
	    				<a href="javascript:closeWindow();" class="easyui-linkbutton" plain="false" iconCls="icon-remove">关闭</a>
	    			</td>
	    		</tr>
	    	</table>
	    </form>
	</body>
</html>