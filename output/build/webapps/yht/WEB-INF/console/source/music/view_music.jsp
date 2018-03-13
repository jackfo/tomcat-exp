<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/include/include.jsp"%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>查看彩信音乐素材</title>
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
    			<th style="width:100">自定义音乐名称：</th>
    			<td>
    				${mmMusicBean.musicNewName }
    			</td>
    		</tr>
    		<tr>
    			<th style="width:100">音乐类型：</th>
    			<td>
    				${mmMusicTypeBean.musicTypeName }
    			</td>
    		</tr>
    		<tr>
    			<th style="width:100">原音乐名称：</th>
    			<td>
    				${mmMusicBean.musicByName}
    			</td>
    		</tr>
    		<tr>
    			<th style="width:100">上传时间：</th>
    			<td>
    				${fn:substring(mmMusicBean.upTime, 0, 19)}
    			</td>
    		</tr>
    		<tr>
    			<th style="width:200px;height:150px">音乐预览：</th>
    			<td>
    				<embed type="audio/mpeg" src="${path }/fileDo?filePath=${targetDirectory}" volume="0" autostart="false" loop="-1" style="width:300px;height:45px"/>
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