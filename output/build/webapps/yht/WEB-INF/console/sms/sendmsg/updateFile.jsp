<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/include/include.jsp"%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>上传号码</title>
		<script type="text/javascript">
			function refresh(obj){
				if(obj){
					if(obj.b){
						var win = parent.${param.win};
						parent.jQuery.messager.alert('提示','上传成功！<br/><br/>文件中共包含【'+obj.num+'】个有效号码！','info');
						win.refreshParent(obj);
					}else{
						parent.jQuery.messager.alert('错误',obj.message+'<br/><br/>请重新上传！','error');
						$('#submitBtn').linkbutton({disabled:false});
					}
				}else{
					parent.jQuery.messager.alert('错误','上传错误！<br/><br/>请重新上传！','error');
					$('#submitBtn').linkbutton({disabled:false});
				}
				$('#shadeDiv').css({'display':'none'});
				$('#loadingDiv').css({'display':'none'});
			}
			function fixedUpdate(el){
				var win = parent.win;
				if($(el).linkbutton('options').disabled) return;
				var file = document.forms.updateForm.upload.value;
				if(win==''){
					parent.jQuery.messager.alert('错误','对不起！<br/><br/>请重新打开本页！','error');
				}else if(0>file.indexOf('.')){
					parent.jQuery.messager.alert('错误','对不起！<br/><br/>请选择正确的文件！','error');
				}else if(!/.+(.txt$)/.test(file)){
					parent.jQuery.messager.alert('错误','对不起！<br/><br/>只能上传TXT文本！','error');
				}else{
					$('#shadeDiv').css({'display':'','opacity':'0.5','height':document.body.clientHeight+'px'});
					$('#loadingDiv').css({'display':''});
					document.forms.updateForm.submit();
					$(el).linkbutton({disabled:true});
				}
			}
		</script>
	</head>
	<body>
		<div id="shadeDiv" style="position:absolute;top:0px;left:0px;width:100%;height:100%;background:#777;display:none;"></div>
		<div id="loadingDiv" style="position:absolute;top:50%;left:50%;margin-top:-10px;margin-left:-110px;width:220px;height:19px;background:url(${path }/images/loading.gif) no-repeat;display:none"></div>
		<iframe id="hiddenIframe" name="hiddenIframe" style="display:none;"></iframe>
		<form id="updateForm" target="hiddenIframe" action="${path }/sms/sendMsg!updateFile.qt" method="POST" enctype="multipart/form-data">
			<input type="hidden" name="chkAccess" value="${param.chkAccess }"/>
			<table width="100%">
				<tr>
					<td align="center" height="50">
						<input type="file" name="upload" style="width: 90%;border: 1px solid #888888;">
					</td>
				</tr>
				<tr>
					<td>
						<ol>
							<li>上传文件不能为空</li>
							<li>上传的号码文件只能是TXT文本，一行一个手机号码</li>
							<li>请不要上传0字节的文件</li>
							<li>多个文件中的重复号码请上传前手动去重</li>
						</ol>
					</td>
				</tr>
				<tr>
					<td align="center">
						<a href="#" id="submitBtn" onclick="fixedUpdate(this)" class="easyui-linkbutton" plain="false" iconCls="icon-ok">上传</a>
					</td>
				</tr>
			</table>
		</form>
	</body>
</html>