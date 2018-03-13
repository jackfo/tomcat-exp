<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/include/include.jsp"%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>参数信息设置</title>
<style type="text/css">
	*{margin: 0px;padding: 0px;overflow: hidden;}
	body{padding:10px;background:#fafafa;overflow-y:auto;}
	.setTable{table-layout: fixed;width: 90%;border-left: 1px solid #aaaaaa;border-top: 1px solid #aaaaaa;text-align: left;}
	.setTable tr td{border-right: 1px solid #aaaaaa;border-bottom: 1px solid #aaaaaa;height: 27px;line-height: 27px;}
	.setTable tr .titleTd{width: 120px;text-align: center;background-color: #dddddd;}
	.setTable tr .optTd{width: 120px;text-align: center;}
	.titleTr{text-align: center;font-weight: bold;background-color: #dddddd;height: 30px;line-height: 30px;}
</style>
	<script type="text/javascript">
		var win;
		$(document).ready(function(){
			getColorStyle();
			win = new Jwindow();
		});
		function editArgu(id){
			win.show('编辑参数','${path}/base/argu!preModifyVal.qt?id='+id+'&chkAccess='+encodeURIComponent('${fs:chkAccess(param.mid,"EDIT")}')+'&random='+getRandomNum(),function(){
				window.location.reload();
			});
			win.reSize(500,300);
		}
	</script>
</head>
<body>
	<table class="setTable" cellpadding="0" cellspacing="0">
		<tr>
			<td class="titleTd titleTr">参数名称</td>
			<td class="valueTd titleTr">参数数值</td>
			<td class="descTd titleTr">参数描述</td>
			<td class="optTd titleTr">操作</td>
		</tr>
		<c:forEach var="argu" items="${arguList}" varStatus="s">
			<tr>
				<td class="titleTd">${argu.arguName }&nbsp;</td>
				<td class="valueTd" title="${argu.arguValue }">
					<c:choose>
						<c:when test="${argu.arguType==0 }">
							<c:if test="${argu.arguValue eq '1' }"><font color="green">启用</font></c:if>
							<c:if test="${argu.arguValue eq '0' }"><font color="red">禁用</font></c:if>
						</c:when>
						<c:otherwise>${argu.arguValue }</c:otherwise>
					</c:choose>&nbsp;
				</td>
				<td class="descTd" title="${argu.arguDesc }">${argu.arguDesc }&nbsp;</td>
				<td class="optTd"><a href="#" onclick="editArgu(${argu.id });" class="easyui-linkbutton" plain="false" iconCls="icon-edit" >编辑参数</a></td>
			</tr>
		</c:forEach>
	</table>
</body>
</html>