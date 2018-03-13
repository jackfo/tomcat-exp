<%@page language="java" pageEncoding="UTF-8"%>
<%@ include file="/include/include.jsp"%>

<html>
<head>
	<title>短信发送</title>
	<script type="text/javascript" src="${path }/js/easyui/window.js"></script>
	<style>
		body{background:#fafafa;overflow:hidden;}
		.FormTable{margin:0px auto;margin-bottom:10px;width:100%;background:#aaa;}
		.FormTable td,.FormTable th{background:#ffffff;}
	</style>
	<script type="text/javascript">
	//	jQuery(document).ready(function(){
	//		$('#phones').val(jQuery.cookie('COOKIE_phones_value'));
	//	});
		function buttonDisable(){
			$("#queryBtn").linkbutton({disabled:true});
		}
		function isSetSendTime(num){
			if(num==0){
				$("#sdtime").css('visibility','hidden');
			}else if(num==1){
				$("#sdtime").css('visibility','');
			}
		}
		function clearPhones(){
			$.cookie('COOKIE_phones_value', null);
			$('#phones').html('');   
		}
		
		function reset(){
			SendForm.reset();
		}
		function submitForm(el){
				$("#mark").val(1);
				el = $('#sendBtn')[0];
				$('#SendForm').form('submit',{
					url:'${path}/sms/publishMsg!send.qt?chkAccess=${param.chkAccess}&random='+getRandomNum(),
					onSubmit:function(){
						//$('#phones').blur();
						var b = $(this).form('validate');
						if(b) $(el).linkbutton({disabled:true});
						return b;
					},
					success:function(data){
						$(el).linkbutton({disabled:false});
						try{
							var obj = eval(data);
							if(obj.b){
								//$('#resultInfo').text(obj.desc);
								//document.forms.replyForm.reset();
								//jQuery.cookie('COOKIE_phones_value','',{path:CONTEXT_PATH,expires:1/24})
								//window.setTimeout("$('#resultInfo').text(' ')",5000);
								//parent.jQuery.messager.alert('提示',obj.desc,'success');
								parent.jQuery.messager.alert('提示',"发送成功",'success');
								parent.win.refreshParent();
							}else parent.jQuery.messager.alert('错误','<br/>保存失败！','error');
						}catch(e){parent.jQuery.messager.alert('错误',e.message+'<br/><br/>保存失败！','error');}
					},
					onLoadError:function(e){
						$(el).linkbutton({disabled:false});
						parent.jQuery.messager.alert('错误',e.message+'<br/><br/>保存失败！','error');
					}
				});
		}	
		
		function updateForm(el){
			$('#SendForm').form('submit',{
					url:'${path}/sms/publishMsg!modify.qt?chkAccess='+encodeURIComponent('${param.chkAccess}')+'&random='+getRandomNum(),
					onSubmit:function(){
						var b = $(this).form('validate');
						if(b) $(el).linkbutton({disabled:true});
						return b;
					},
					success:function(data){
						$(el).linkbutton({disabled:false});
						try{
							var obj = eval(data);
							if(obj.b){
								if(parent&&parent.win) parent.win.refreshParent();
							}else parent.jQuery.messager.alert('错误','<br/>保存失败！','error');
						}catch(e){parent.jQuery.messager.alert('错误',e.message+'<br/><br/>保存失败！','error');}
					},
					onLoadError:function(e){
						$(el).linkbutton({disabled:false});
						parent.jQuery.messager.alert('错误',e.message+'<br/><br/>保存失败！','error');
					}
				});
		}
	</script>
</head>
<body>
<form id="SendForm" name="SendForm" method="post">
	<table class="FormTable" align="center" border="0" cellpadding="1" cellspacing="0">
		<tr>
			<td style="width: 80px;padding: 0px;border-bottom:0px"></td>
			<td style="padding:0px;border-bottom:0px"></td>
			<td style="width: 80px;padding: 0px;border-bottom:0px"></td>
			<td style="padding:0px;border-bottom:0px"></td>
		</tr>
		<tr>
			<td class="titletd" style="text-align:right;">
				所属业务：
			</td>
			<td colspan="3" id='noticeTitle'>
				${param.title}
				<input type="hidden" name="publishMsg.publishType" value="${publishMsg.publishType}"/>
				<input type="hidden" name="publishMsg.publishStatus" value="${publishMsg.publishStatus}"/>
				<input type="hidden" name="id" value="${param.id }"/>
				<input type="hidden" id="mark" name="mark" value=""/>
			</td>
		</tr>
		<tr>
			<td class="titletd" style="text-align:right;">
				发送号码：
			</td>
			<td colspan="3">
				<a href="#" class="easyui-linkbutton easyui-validatebox" methodType="chooseUser['${fs:chkAccess(param.mid,'CHOOSE') }','#phones']" iconCls="icon-save" style="margin-left:20px;">&nbsp;选择人员&nbsp;</a>
				<a href="#" class="easyui-linkbutton easyui-validatebox" methodType="chooseAddressBook['${fs:chkAccess(param.mid,'ADDRESSBOOK') }','#phones']" iconCls="icon-save" style="margin-left:20px;">&nbsp;选择人员通讯录&nbsp;</a>
				<a href="#" class="easyui-linkbutton easyui-validatebox" methodType="pastePhone['${fs:chkAccess(param.mid,'PASTE') }','#phones']" iconCls="icon-save" style="margin-left:20px;">&nbsp;黏贴号码&nbsp;</a>
				<a href="#" class="easyui-linkbutton easyui-validatebox"  iconCls="icon-save" style="margin-left:20px;" onClick="clearPhones()">&nbsp;清空号码&nbsp;</a>
				<textarea id="phones" name="phones" rows="5" class="easyui-validatebox" validType="mobile['^[<].+[>]$']" style="width:100%;" required="true" isnull="true">${publishMsg.publishPhones }</textarea>
			</td>
		</tr>
		
		<tr>
			<td class="titletd" style="text-align:right;">
				发送标题：
			</td>
			<td colspan="3">
				<input type="text" name="publishMsg.publishTitle" value="${publishMsg.publishTitle}" style="width: 100%" class="easyui-validatebox" required="true" isnull="true">
			</td>
		</tr>
		
		<tr>
			<td class="titletd" style="text-align:right;">
				发送内容：
			</td>
			<td colspan="3">
				<a href="#" class="easyui-linkbutton easyui-validatebox" methodType="chooseTemplatePublicMsg['${fs:chkAccess(param.mid,'TEMPLATE') }','#sendContent']" iconCls="icon-save" style="margin-left:20px;">&nbsp;选择模板&nbsp;</a>
				<textarea id="sendContent" name="sendContent" rows="5" class="easyui-validatebox"  style="width:100%;" required="true" isnull="true" validType="filterWord[0,300]">${publishMsg.publishContent }</textarea>
			</td>
		</tr>
		
		<tr>
			<td class="titletd" style="text-align:right;">
				备注描述：
			</td>
			<td colspan="3">
				<textarea id="publishMsg.publishDesc" name="publishMsg.publishDesc" rows="3" style="width:100%;"  validType="filterWord[0,500]">${publishMsg.publishDesc }</textarea>
			</td>
		</tr>
	</table>
	<center style="margin-top: 5px">
		<a href="#" onclick="submitForm(this);" id="sendBtn" class="easyui-linkbutton" plain="false" iconCls="icon-save" style="margin-right:10px">发送</a>
		<a href="#" onclick="updateForm(this);" id="updateBtn" class="easyui-linkbutton" plain="false" iconCls="icon-add" style="margin-right:10px">保存</a>
   		<a href="javascript:reset();" class="easyui-linkbutton" plain="false" iconCls="icon-remove">重置</a>
   	</center>
</form>
</body>
</html>