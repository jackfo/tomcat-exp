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
		jQuery(document).ready(function(){
			$('#phones').val(jQuery.cookie('COOKIE_phones_value'));
		});
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
				$("input[name=publishMsg.publishStatus]").val(1);
				el = $('#sendBtn')[0];
				$('#SendForm').form('submit',{
					url:'${path}/sms/publishMsg!send.qt?chkAccess=${param.chkAccess}&random='+getRandomNum()+'&mark=0',
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
		
		function saveForm(el){
			$("input[name=publishMsg.publishStatus]").val(0);
			$('#SendForm').form('submit',{
				url:'${path}/sms/publishMsg!newAdd.qt?chkAccess='+encodeURIComponent('${param.chkAccess}')+'&random='+getRandomNum(),
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
						}else parent.jQuery.messager.alert('错误',e.message+'<br/><br/>保存失败！','error');
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
<body style="overflow-y: auto;">
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
				<input type="hidden" name="publishMsg.publishType" value="${param.publishType}"/>
				<input type="hidden" name="publishMsg.publishStatus" value="${publishMsg.publishStatus}"/>
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
				<textarea id="phones" name="phones" rows="5" class="easyui-validatebox" validType="mobile['^[<].+[>]$']" style="width:100%;" required="true" isnull="true"></textarea>
			</td>
		</tr>
		
		<tr>
			<td class="titletd" style="text-align:right;">
				发送标题：
			</td>
			<td colspan="3">
				<input type="text" name="publishMsg.publishTitle" value="" style="width: 100%" class="easyui-validatebox" required="true" isnull="true">
			</td>
		</tr>
		
		<tr>
			<td class="titletd" style="text-align:right;">
				发送内容：
			</td>
			<td colspan="3">
				<a href="#" class="easyui-linkbutton easyui-validatebox" methodType="chooseTemplatePublicMsg['${fs:chkAccess(param.mid,'TEMPLATE') }','#sendContent']" iconCls="icon-save" style="margin-left:20px;">&nbsp;选择模板&nbsp;</a>
				<textarea id="sendContent" name="sendContent" rows="5" class="easyui-validatebox"  style="width:100%;" required="true" isnull="true" validType="filterWord[0,300]"></textarea>
			</td>
		</tr>
		
		<tr>
			<td class="titletd" style="text-align:right;">
				备注描述：
			</td>
			<td colspan="3">
				<textarea id="publishMsg.publishDesc" name="publishMsg.publishDesc" rows="3"  style="width:100%;"  validType="filterWord[0,500]"></textarea>
			</td>
		</tr>
		<!--
		<tr>
			<td class="titletd" style="text-align:right;">
				定时发送：
			</td>
			<td colspan="3">
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
			<td>&nbsp;</td>
		</tr>  -->
	</table>
	<center style="margin-top: 5px">
		<a href="#" onclick="submitForm(this);" id="sendBtn" class="easyui-linkbutton" plain="false" iconCls="icon-save" style="margin-right:10px">发送</a>
		<a href="#" onclick="saveForm(this);" id="saveBtn" class="easyui-linkbutton" plain="false" iconCls="icon-add" style="margin-right:10px">保存</a>
   		<a href="javascript:reset();" class="easyui-linkbutton" plain="false" iconCls="icon-remove">重置</a>
   	</center>
</form>
</body>
</html>