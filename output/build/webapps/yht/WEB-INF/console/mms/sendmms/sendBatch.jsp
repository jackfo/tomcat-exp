<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/include/include.jsp"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
  	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title></title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
	<style>
		*{margin:0px;padding:0px;}
		body{text-align: center;background: #ffffff;}
		.mmTable{width: 600px;border-left: 1px solid #aaaaaa;border-top: 1px solid #aaaaaa;table-layout: fixed;margin: 60px auto 0px auto;overflow: hidden;}
		.td1{width: 100px;text-align: center;}
		.mmTable td{border-bottom: 1px solid #aaaaaa;border-right: 1px solid #aaaaaa;height: 30px;line-height: 30px;}
		.desc{margin-left: 40px;height: 22px;line-height: 20px;}
	</style>
		
	<script>
		var parJson;
		var win;
		var mmId; 
		$(document).ready(function(){
			getColorStyle();
			win = new Jwindow();
		});
	
		function checkSet(){
			if($('input[name=timeSet][checked=true]').val()==1){
				$('input[name=sendTime]').val('');
				$('input[name=sendTime]').attr('disabled','disabled');				
			}else{
				$('input[name=sendTime]').removeAttr('disabled');							
			}
		}
		
		//从彩信模板中选择已有的彩信
		function chooseMmTemplate(){
			win.show('彩信模板选择','${path}/mms/mmSend!chooseMmTemplate.qt?random='+getRandomNum()+'&mid=${param.mid}&chkAccess=${fs:chkAccess(param.mid,"CHOTEMP")}',function(data){
				var mmData = eval(data);
				parJson = mmData[0].parJson;
				$('input[name=subject]').val(mmData[0].subject);
				mmId = mmData[0].mmId;
				$('#parJson').val(obj2Str(parJson));
			});
			win.reSize('80%','80%');
		}
		
		//彩信预览
		function mmView(){
			if(mmId != null && mmId != ''){
				win.show('彩信预览','${path}/mms/template!view.qt?id='+mmId+'&chkAccess='+encodeURIComponent('${fs:chkAccess(param.mid,"VIEW")}')+'&random='+getRandomNum());
				win.reSize(205,350);
			}else{
				alert('请先选择彩信模板！');
			}
		}
		
		function refresh(obj){
			$('#shadeDiv').css({'display':'none'});
			$('#loadingDiv').css({'display':'none'});
			$('#saveBtn').linkbutton({disabled:false});
			if(obj){
				if(obj.b){
					if(obj.needAudit==2){
						jQuery.messager.alert('提示','彩信发送成功！<br/><br/>共发送【'+obj.num+'】条信息！','info');
					}else{
						jQuery.messager.alert('提示','彩信成功保存至发送任务中!<br/><br/>共【'+obj.num+'】条手机发送对象！','info');
					}
					document.forms.SendForm.reset();
				}else{
					jQuery.messager.alert('错误',obj.message+'<br/><br/>请重新上传！','error');
				}
			}else{
				jQuery.messager.alert('错误','上传错误！<br/><br/>请重新上传！','error');
			}
		}
		
		function submitForm(el){
			var el = $('#saveBtn');
			if(el.linkbutton('options').disabled) return;
			var file = document.forms.SendForm.upload.value;
			if(0 > file.indexOf('.')){
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
		
		function reset(){
			SendForm.reset();
		}
	</script>
  </head>
  
  <body>
  			<iframe id="hiddenIframe" name="hiddenIframe" style="display:none;"></iframe>
			<form id="SendForm" name="SendForm" target="hiddenIframe" action="${path }/mms/mmSend!sendBatch.qt?chkAccess=${fs:chkAccess(param.mid,'SEND')}" method="post" enctype="multipart/form-data">
				<input type="hidden" id="parJson" name="parJson" value=""/>
				<table border="0" cellpadding="0" cellspacing="0" class="mmTable">
					<tr style="display: none;"><td class="td1"></td><td></td><td class="td1"></td><td></td></tr>
					<tr>
						<td class="td1">彩信主题</td>
						<td colspan="3"><input type="text" name="subject" value="" class="easyui-validatebox" required="true" style="width: 200px;"/></td>
					</tr>
					<tr>
						<td class="td1">彩信模板</td>
						<td colspan="3">
							<a href="#" onclick="chooseMmTemplate();" class="easyui-linkbutton" plain="false" iconCls="icon-search" style="margin-right:10px">模板选择</a>
							<a href="#" onclick="mmView()" class="easyui-linkbutton" plain="false" iconCls="icon-search">彩信预览</a>
						</td>
					</tr>
					<tr>
						<td class="td1">号码文件</td>
						<td colspan="3"><input type="file" name="upload" value="" style="width: 100%;border: 1px solid #aaaaaa;"/></td>
					</tr>
					<tr>
						<td class="td1">接收报告</td>
						<td>
							<input type="checkbox" name="needReport"  value="1" /> 
						</td>
						<td class="td1">是否审核</td>
						<td>
							<input type="radio" name="needAudit"  value="1" checked="checked"/>是 
							<input type="radio" name="needAudit"  value="2" />否 
						</td>
					</tr>
					<tr>
						<td class="td1">定时发送</td>
						<td colspan="3">
							<input type="radio" name="timeSet" value="1" checked="checked" onclick="checkSet()"/>否
							<input type="radio" name="timeSet" value="2" style="margin-left: 20px;" onclick="checkSet()"/>是
							<input type="text" name="sendTime" value="" style="width: 200px;margin: 0px;" disabled="disabled" class="easyui-validatebox" methodType="chooseDate{dateFmt:'yyyy-MM-dd HH:mm:ss'}"/>
						</td>
					</tr>
					<tr>
						<td colspan="4" style="height: 125px;vertical-align: top;">
							<font color="red" style="margin-left: 10px;"><b>注 意</b></font></br>
							<div class="desc">1、文件只能是97-2003版Excel；</div>
							<div class="desc">2、Excel中第一列为手机号码，只有一列；</div>
							<div class="desc">3、Excel中第一行为表头行不读取，数据从第二行开始读取；</div>
							<div class="desc">4、上传过程中，系统会去除重复与不规范的手机号。<font color="red"><b><a title="点击下载" href="${path }/uploadTemplate?name=mmsSendBatchTemplate.xls">上传模板下载</a></b></font></div>
						</td>
					</tr>
				</table>
				<div style="clear: both;"></div>
				<div style="width: 100%;text-align: center;margin-top: 10px;">
					<a href="#" id="saveBtn" onclick="submitForm(this);" class="easyui-linkbutton" plain="false" iconCls="icon-save" style="margin-right:10px">保存</a>
    				<a href="javascript:reset();" class="easyui-linkbutton" plain="false" iconCls="icon-remove">重置</a>
				</div>
			</form>
			<div id="shadeDiv" style="position:absolute;top:0px;left:0px;width:100%;height:100%;background:#777;display:none;"></div>
			<div id="loadingDiv" style="position:absolute;top:50%;left:50%;margin-top:-10px;margin-left:-110px;width:220px;height:19px;background:url(${path }/images/loading.gif) no-repeat;display:none"></div>
  </body>
</html>
