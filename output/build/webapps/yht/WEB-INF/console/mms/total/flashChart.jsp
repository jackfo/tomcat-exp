<%@ page language="java" pageEncoding="UTF-8"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@ include file="/include/include.jsp"%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>报表</title>
		<script type="text/javascript" src="${path }/js/swfobject.js"></script>
		<script type="text/javascript">
			var width=780,height=440,win;
			jQuery(document).ready(function(){
				getColorStyle();
				win = new Jwindow();
				query();
			});
			function query(){
				$('#my_chart').parent().append('<div id="my_chart"></div>').end().remove();
				var url = '';<c:if test="${param.type eq 'received'}">
				url = "${path}/mms/chart!chartForReceived.qt?chkAccess="+encodeURIComponent('${fs:chkAccess(param.mid,'CHART')}')+getURLParams();</c:if><c:if test="${param.type eq 'sent'}">
				url = "${path}/mms/chart!chartForSent.qt?chkAccess="+encodeURIComponent('${fs:chkAccess(param.mid,'CHART')}')+getURLParams();</c:if>
				url = encodeURIComponent(url);
				swfobject.embedSWF("${path}/js/total/open-flash-chart.swf", "my_chart", width, height, "9.0.0", 
					"expressInstall.swf",
					{"data-file":url},
					{wmode:"transparent",allowScriptAccess:"sameDomain",menu:'false'});
			}
		</script>
	</head>
	<body style="padding-top:5px;background:#f8f8d8">
		<div class="buttonPanel" style="">
			<div class="formPanel">
				<table>
					<tr>
						<td width="80" align="right">
							选择年份：
						</td>
						<td>
							<input type="text" name="year" class="easyui-validatebox" value="<%=new SimpleDateFormat("yyyy").format(new Date()) %>" methodType="chooseDate{dateFmt:'yyyy',readOnly:true}"/>
						</td>
						<td>
							<input type="radio" name="graphType" id="graphType_1" value="1" checked="checked"/>
							<label for="graphType_1">柱状图</label>
							<input type="radio" name="graphType" id="graphType_2" value="2"/>
							<label for="graphType_2">饼状图</label>
						</td>
						<td width="100" align="right">
							<fs:button key="CHART" id="CHART_BTN" name="查看" iconCls="icon-search">
								function(){
									query();
								}
							</fs:button>
						</td><c:if test="${param.type eq 'sent'}">
						<td>
							<fs:button key="RETOTAL" id="RETOTAL_BTN" name="重新汇总" iconCls="icon-search">
								function(){
									win.show('重新汇总','${path}/mms/chart!total.qt?chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum());
									win.reSize(300,150);
								}
							</fs:button>
						</td></c:if>
					</tr>
				</table>
				<div class="clear"></div>
			</div>
			<div class="datagrid-btn-separator" style="visibility:hidden;"></div>
			<div class="clear"></div>
		</div>
		<div id="my_chart"></div>
	</body>
</html>