<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/include/include.jsp"%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>新增</title>
	<style type="text/css">
		*{margin:0px;padding:0px}
		body{height:100%;}
		
	</style>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			$('#tt').tabs({
				fit:true,
				border:false,
				onSelect:function(title){
			        if(title=='passive') {
			        	//<iframe src="${path }/custom/form!preAdd.qt?type=passive&chkAccess=${param.chkAccess}" frameborder="0" width="100%" height="100%" scrolling="auto"></iframe>
			        	var tab = $(this).tabs('getTab','passive');
			        	if(tab.panel("options").content==''){
			        		var options = {
			        			content:'<iframe src="${path }/custom/form!preAdd.qt?type=passive&chkAccess=${param.chkAccess}" frameborder="0" width="100%" height="100%" scrolling="auto"></iframe>'
			        		};
			        		$(this).tabs('update',{'tab':tab,'options':options});
			        	}
			        }
			    }
			}).tabs('add',{
				title:'automate',
				content:'<iframe src="${path }/custom/form!preAdd.qt?type=automate&chkAccess=${param.chkAccess}" frameborder="0" width="100%" height="100%" scrolling="auto"></iframe>',
				closable:false,
				showText:'主动短信发送'
			}).tabs('add',{
				title:'passive',
				content:'',
				closable:false,
				showText:'被动查询发送',
				selected:false
			});
		});
	</script>
	</head>
	<body>
		<div id="tt"></div>
	</body>
</html>