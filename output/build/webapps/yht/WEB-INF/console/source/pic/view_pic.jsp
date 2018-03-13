<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/include/include.jsp"%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>查看彩信图片素材</title>
<style type="text/css">
	body{padding:10px;background:#fafafa;overflow:hidden;}
	th{width:80px;height:30px;line-height:30px;text-align:right;font-size:9pt;font-weight:normal;}
	td{height:30px;line-height:30px;font-size:9pt;}
</style>
	<script type="text/javascript">
		$(document).ready(function(){
			document.body.style.overflow = 'scroll';//页面显示滚动条;
		});
	</script>
	</head>
	<body>
		<table style="width:100%;table-layout:fixed;" border="1" cellpadding="0" cellspacing="0">
			<tr>
    			<th style="width:100">自定义图片名称：</th>
    			<td>
    				${mmPicBean.picNewName }
    			</td>
    		</tr>
    		<tr>
    			<th style="width:100">图片类型：</th>
    			<td>
    				${mmPicTypeBean.picTypeName }
    			</td>
    		</tr>
    		<tr>
    			<th style="width:100">原图片名称：</th>
    			<td>
    				${mmPicBean.picByName}
    			</td>
    		</tr>
    		<tr>
    			<th style="width:100">上传时间：</th>
    			<td>
    				${fn:substring(mmPicBean.upTime, 0, 19)}
    			</td>
    		</tr>
    		<tr>
    			<th style="width:200px;height:150px">图片预览：</th>
    			<td>
    				<img src="${path }/fileDo?filePath=${targetDirectory}" style="width:200px;height:150px"/>
    			</td>
    		</tr>
    		<tr>
    			<td colspan="2" align="center" height="40" valign="bottom">
    				<a href="#" onclick="javascript:parent.win.refreshParent()" class="easyui-linkbutton" plain="false" iconCls="icon-remove" style="margin-right:10px">关闭</a>
    			</td>
    		</tr>
    	</table>
	</body>
</html>