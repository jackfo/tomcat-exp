<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/include/include.jsp"%>
<%@	taglib prefix="ft" uri="http://www.flagsky.com/functions" %>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>查看结果</title>
		<style type="text/css">
			*{margin:0px;padding:0px}
			body{padding:10px;background:#fafafa;}
			th{width:80px;height:35px;line-height:35px;text-align:right;font-size:9pt;font-weight:normal;}
			td{height:35px;line-height:35px;font-size:9pt;}
		</style>
		<script type="text/javascript" src="${path }/js/easyui/window.js"></script>
		<script type="text/javascript">
			function closeWindow(){
				if(parent&&parent.win) parent.win.refreshParent();
			}
		</script>
	</head>
	<body>
		<form id="newForm" name="newForm" method="post">
			<input type="hidden" name="chkAccess" value="${param.chkAccess }">
			<table style="width:100%;table-layout:fixed;" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<th>标题：</th>
					<td>
						<c:out value="${conference.title }"/>
					</td>
					<td style="width:80px">&nbsp;</td>
				</tr>
				<tr>
					<th style="height:1%;" valign="top">接收号码：</th>
					<td colspan="2" style="padding:5px;word-wrap:break-word;word-break:normal;line-height:16px;">
						<c:out value="${ft:cropString(conference.destAddrs,335)}"/>
					</td>
				</tr>
				<tr>
					<th style="height:1%;" valign="top">参加人员：</th>
					<td colspan="2" style="padding:5px;word-wrap:break-word;word-break:normal;line-height:16px;">
						<textarea rows="5" cols="5" style="width: 90%;"><c:out value="${conference.haveArgeeNames }"></c:out></textarea>
					</td>
				</tr>
				<tr>
					<th style="height:1%;" valign="top">不参加人员：</th>
					<td colspan="2" style="padding:5px;word-wrap:break-word;word-break:normal;line-height:16px;">
						<textarea rows="5" cols="5" style="width: 90%;"><c:out value="${conference.haveNoArgeeNames }"></c:out></textarea>
					</td>
				</tr>
				
				<tr>
					<th>参加：</th>
					<td style="padding:3px;" valign="middle">
						<div style="position:relative;width:100%;height:22px;background-color:#ddd;overflow:hidden;border:2px ridge #ccc;border:0px\9;">
							<c:if test="${conference.argeeNum>0}">
					   			<div style="width:<fmt:formatNumber value="${conference.argeeNum/conference.totalNum*100 }" pattern="0.0"/>%;height:22px;background:red;filter:Alpha(Opacity=${conference.argeeNum/conference.totalNum*50+30 })\9;opacity:${conference.argeeNum/conference.totalNum+0.2 };"></div>
					   			<div style="position:absolute;white-space:nowrap;top:0px;left:10px;margin-left:5px;height:22px;line-height:22px;font-weight:900;"><fmt:formatNumber value="${conference.argeeNum/conference.totalNum*100 }" pattern="0.0"/>%</div>
					   		</c:if>
				   		</div>
					</td>
					<td style="padding-left:5px"><c:out value="${conference.argeeNum}"></c:out> 票</td>
				</tr>
				<tr>
					<th>不参加：</th>
					<td style="padding:3px;" valign="middle">
						<div style="position:relative;width:100%;height:22px;background-color:#ddd;overflow:hidden;border:2px ridge #ccc;border:0px\9;"><c:if test="${conference.noArgeeNum>0}">
				   			<div style="width:<fmt:formatNumber value="${conference.noArgeeNum/conference.totalNum*100 }" pattern="0.0"/>%;height:22px;background:red;filter:Alpha(Opacity=${conference.noArgeeNum/conference.totalNum*50+30 })\9;opacity:${conference.noArgeeNum/conference.totalNum+0.2 };"></div>
				   			<div style="position:absolute;white-space:nowrap;top:0px;left:10px;margin-left:5px;height:22px;line-height:22px;font-weight:900;"><fmt:formatNumber value="${conference.noArgeeNum/conference.totalNum*100 }" pattern="0.0"/>%</div></c:if>
				   		</div>
					</td>
					<td style="padding-left:5px"><c:out value="${conference.noArgeeNum}"></c:out> 票</td>
				</tr>
				<tr>
					<td colspan="3" align="center" height="40" valign="bottom">
	    				<a href="javascript:closeWindow();" class="easyui-linkbutton" plain="false" iconCls="icon-remove">关闭</a>
	    			</td>
	    		</tr>
	    	</table>
	    </form>
	</body>
</html>