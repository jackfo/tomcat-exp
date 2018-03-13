<%@ page language="java" pageEncoding="UTF-8"%>
<%@page import="com.fs.base.pojo.Contacts"%>
<%@ include file="/include/include.jsp"%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>上传号码</title>
		<script type="text/javascript" src="${path }/js/bgshade/jQuery_plug_bgshade.js"></script>
		<script type="text/javascript">
			function refresh(obj){
				if(obj){
					if(obj.b){
						window.location.href="${path }/base/contacts!importContact.qt?b=preview&file="+encodeURIComponent(obj.path)+"&chkAccess="+encodeURIComponent("${param.chkAccess }");
					}else{
						parent.jQuery.messager.alert('错误',obj.message+'<br/><br/><center>请重新上传！</center>','error');
						$('#submitBtn').linkbutton({disabled:false});
						shadeDivHandle();
					}
				}else{
					parent.jQuery.messager.alert('错误','上传错误！<br/><br/><center>请重新上传！</center>','error');
					$('#submitBtn').linkbutton({disabled:false});
					shadeDivHandle();
				}
			}
			function fixedUpdate(el){
				if($(el).linkbutton('options').disabled) return;
				var file = document.forms.updateForm.upload.value;
				if(0>file.indexOf('.')){
					parent.jQuery.messager.alert('错误','对不起！<br/><br/>请选择正确的文件！','error');
				}else if(!/.+(.xls$)/.test(file)){
					parent.jQuery.messager.alert('错误','对不起！<br/><br/>只能上传97-2003版Excel文件！','error');
				}else{
					shadeDivHandle(true);
					document.forms.updateForm.submit();
					$(el).linkbutton({disabled:true});
				}
			}
			function shadeDivHandle(b){
				if(b){
					$(document.body).bgshade("上传中...");
				}else{
					$(document.body).bgshade(false);
				}
			}
		</script>
	</head>
	<body style="overflow:hidden;">
		<div id="shadeDiv" style="position:absolute;top:0px;left:0px;width:100%;height:100%;background:#777;display:none;"></div>
		<div id="loadingDiv" style="position:absolute;top:50%;left:50%;margin-top:-10px;margin-left:-110px;width:220px;height:19px;background:url(${path }/images/loading.gif) no-repeat;display:none"></div>
		<iframe id="hiddenIframe" name="hiddenIframe" style="display:none;"></iframe>
		<form id="updateForm" target="hiddenIframe" action="${path }/base/contacts!importContact.qt" method="POST" enctype="multipart/form-data">
			<input type="hidden" name="chkAccess" value="${param.chkAccess }"/>
			<table width="100%">
				<tr>
					<td align="center" height="50">
						<input type="file" name="upload" style="width: 90%;border: 1px solid #aaaaaa;">
					</td>
				</tr>
				<tr>
					<td>
						<ol>
							<li>上传请先用下载的模板来填写数据</li>
							<li>上传的文件不能为空，最大10M</li>
							<li>上传的文件只能是97-2003版Excel</li>
						</ol>
							<p style="margin:0px;padding:0px;margin-bottom:10px;text-align:center;">
								<a href="${path }/base/contacts!importContact.qt?b=false&filename=%E4%B8%8B%E8%BD%BD%E5%AF%BC%E5%85%A5%E6%A8%A1%E6%9D%BF.xls&chkAccess=${param.chkAccess }" style="text-decoration:underline;font-size: 18px;font-family: 黑体;color: red;">点击下载模板</a>
							</p>
							<p style="margin:0px;padding:0px;margin-bottom:10px;text-align:center;line-height:20px;">
								最近上传文件，单击预览再次导入：<br/>
								<script type="text/javascript">
									var file = jQuery.cookie("<%=Contacts.SESSION_IMPORT_CONTACTS_KEY%>");
									if(typeof(file)!='undefined'&&file!=''&&file!=null)
										document.write('<a href="${path }/base/contacts!importContact.qt?b=preview&file='+encodeURIComponent(file)+'&chkAccess='+encodeURIComponent("${param.chkAccess }")+'">'+file+'</a>');
								</script>
							</p>
					</td>
				</tr>
				<tr>
					<td align="center">
						<a href="#" id="submitBtn" onclick="fixedUpdate(this)" class="easyui-linkbutton" plain="false" iconCls="icon-ok">上传</a>
					</td>
				</tr>
			</table>
		</form>
		<form id="importForm" name="importForm" action="${path }/base/contacts!importContact.qt" method="post" style="display:none;">
			<input type="hidden" name="chkAccess" value="${param.chkAccess }"/>
			<input type="hidden" id="fileName" name="fileName"/>
		</form>
	</body>
</html>