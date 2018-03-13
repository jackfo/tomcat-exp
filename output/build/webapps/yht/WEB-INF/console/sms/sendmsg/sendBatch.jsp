<%@page language="java" pageEncoding="UTF-8"%>
<%@ include file="/include/include.jsp"%>

<html>
<head>
	<title>短信发送</title>
	<script type="text/javascript" src="${path }/js/easyui/window.js"></script>
	<style>
		*{margin:0px;padding:0px;}
		body{background:#fafafa;overflow:hidden;}
		
		.sendBatchTable{margin:auto;margin-top:50px;border-top:1px solid #aaa;border-right:1px solid #aaa;background:#fff;width: 600px;table-layout: fixed;}
		.sendBatchTable td{padding:5px;padding-bottom:3px;height:30px;border-left:1px solid #aaa;border-bottom:1px solid #aaa;}
	</style>
	<script type="text/javascript">
		function refresh(obj){
			$('#shadeDiv').css({'display':'none'});
			$('#loadingDiv').css({'display':'none'});
			$('#saveBtn').linkbutton({disabled:false});
			if(obj){
				if(obj.b){
					jQuery.messager.alert('提示','发送成功！<br/><br/>共发送【'+obj.num+'】条信息！','info');
					document.forms.SendForm.reset();
				}else{
					jQuery.messager.alert('错误',obj.message+'<br/><br/>请重新上传！','error');
				}
			}else{
				jQuery.messager.alert('错误','上传错误！<br/><br/>请重新上传！','error');
			}
		}
		function isSetSendTime(num){
			if(num==0){
				$("#sdtime").css('visibility','hidden');
			}else if(num==1){
				$("#sdtime").css('visibility','');
			}
		}
	</script>
</head>
<body>
<iframe id="hiddenIframe" name="hiddenIframe" style="display:none;"></iframe>
<form id="SendForm" name="SendForm" target="hiddenIframe" action="${path}/sms/sendMsg!sendBatch.qt?chkAccess=${fs:chkAccess(param.mid,'SAVE') }" method="post" enctype="multipart/form-data">
	<table class="sendBatchTable" align="center" cellpadding="0" cellspacing="0" border="0">
		<tr>
			<td width="80">所属业务：</td>
			<td>信息群发</td>
		</tr>
		<tr>
			<td>选择文件：</td>
			<td>
				<input type="file" name="upload" style="width: 90%;border: 1px solid #888888;">
			</td>
		</tr>
		<tr>
			<td>定时发送：</td>
			<td>
				<div style="float:left;height:25px;line-height:25px">
					<input type="radio" id="istime_0" name="istime" value="0" checked onclick="isSetSendTime(0)"/>
					<label for="istime_0">否</label>
					<input type="radio" id="istime_1" name="istime" value="1" onclick="isSetSendTime(1)"/>
					<label for="istime_1">是</label>
				</div>
				<div id="sdtime" style="float:left;visibility:hidden;margin-left:20px;">
					<input type="text" id="stime" name="stime" style="width:150px;" class="easyui-validatebox" methodType="chooseDate{dateFmt:'yyyy-MM-dd HH:mm'}"/>
				<div>
			</td>
		</tr>
		<tr>
			<td colspan="2" style="padding-left:30px;height: 100px;">
				<ol>
					<li>文件只能是97-2003版Excel；</li>
					<li>Excel中第一列为手机号码，第二列为短信内容，第三列为定时时间（可选）；</li>
					<li>如果Excel中没有第三列或者第三列为空，则默认为当前时间；</li>
					<li>Excel中第一行为表头行不读取，数据从第二行开始读取；</li>
					<li>如果设置定时发送，则该文件中的所有短信都采用这个时间。<font color="red"><a title="点击下载" href="${path }/uploadTemplate?name=smsSendBatchTemplate.xls" style="font-size: 18px;font-family: 黑体;color: red;text-decoration: underline;">点击下载模板</a></font></li>
				</ol>
			</td>
		</tr>
	</table>
	<center>
		<b id="resultInfo" style="color:red"><c:out value="${successInfo}"/></b><br/>
		<fs:button key="SAVE" id="saveBtn" name="发送" iconCls="icon-search">
			function(){
				var el = $('#saveBtn');
				if(el.linkbutton('options').disabled) return;
				var file = document.forms.SendForm.upload.value;
				if(0>file.indexOf('.')){
					parent.jQuery.messager.alert('错误','对不起！<br/><br/>请选择正确的文件！','error');
				}else if(!/.+(.xls$)/.test(file)){
					parent.jQuery.messager.alert('错误','对不起！<br/><br/>只能上传97-2003版Excel文件！','error');
				}else{
					$('#shadeDiv').css({'display':'','opacity':'0.5','height':document.body.clientHeight+'px'});
					$('#loadingDiv').css({'display':''});
					document.forms.SendForm.submit();
					el.linkbutton({disabled:true});
				}
			}		
		</fs:button>
	</center>
</form>
	<div id="shadeDiv" style="position:absolute;top:0px;left:0px;width:100%;height:100%;background:#777;display:none;"></div>
	<div id="loadingDiv" style="position:absolute;top:50%;left:50%;margin-top:-10px;margin-left:-110px;width:220px;height:19px;background:url(${path }/images/loading.gif) no-repeat;display:none"></div>
</body>
</html>