<%@page language="java" pageEncoding="UTF-8"%>
<%@ include file="/include/include.jsp"%>

<html>
<head>
	<title>短信发送</title>
	<script type="text/javascript" src="${path }/js/easyui/window.js"></script>
	<style>
		body{background:#fafafa;overflow:hidden;}
		.FormTable{margin:0px auto;margin-bottom:20px;width:100%;background:#aaa;}
		.FormTable td,.FormTable th{background:#ffffff;}
		.cue{color: red;font-weight: bold;}
	</style>
	<script type="text/javascript">
		var win;
		jQuery(document).ready(function(){
			$('#phones').val(jQuery.cookie('COOKIE_phones_value'));
			getColorStyle();
			win = new Jwindow(function(s){
			});
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
		
		function checkWord(){
			var cue1 = $('#sendContent').val().trim().length;
			var cue3 = $('#cue3').text();
			var cue2 = cue3 - cue1;
			$('#cue1').text(cue1);
			$('#cue2').text(cue2);
		}	
	</script>
</head>
<body>
<form id="SendForm" name="SendForm" action="${path}/sms/sendMsg!send.qt?chkAccess=${fs:chkAccess(param.mid,'SAVE') }" method="post">
	<table class="FormTable" align="center" border="0" cellpadding="1" cellspacing="0">
		<tr>
			<td style="width: 80px;padding: 0px;border-bottom:0px"></td>
			<td style="padding:0px;border-bottom:0px"></td>
			<td style="width: 80px;padding: 0px;border-bottom:0px"></td>
			<td style="padding:0px;border-bottom:0px"></td>
			<td style="width:130px"></td>
		</tr>
		<tr>
			<td class="titletd" style="text-align:right;">
				所属业务：
			</td>
			<td colspan="3" id='noticeTitle'>
				短信发送
			</td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td class="titletd" style="text-align:right;">
				发送号码：
			</td>
			<td colspan="3">
				<a href="#" class="easyui-linkbutton easyui-validatebox" methodType="chooseUser['${fs:chkAccess(param.mid,'CHOOSE') }','#phones']" iconCls="icon-search" style="margin-left:20px;">&nbsp;选择人员&nbsp;</a>
				<a href="#" class="easyui-linkbutton easyui-validatebox" methodType="chooseAddressBook['${fs:chkAccess(param.mid,'ADDRESSBOOK') }','#phones']" iconCls="icon-search" style="margin-left:20px;">&nbsp;选择通讯录&nbsp;</a>
				<fs:button key="PATIENT" id="choosePatient" name="选择患者" iconCls="icon-search">
					function(){
						win.show('选择患者','${path}/hospital/patients!patientList.qt?mid=${param.mid}&chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum(),function(childval){
							if($("#phones").val()!='')
								$("#phones").val($("#phones").val()+','+childval);
							else
								$("#phones").val(childval);
							$("#phones").focus();
						});
						win.reSize(900,500);
					}
				</fs:button>&nbsp;
				<fs:button key="PORT" id="choosePort" name="选择患者" iconCls="icon-search">
					function(){
						win.show('选择患者','${path}/port/follow!portList.qt?mid=${param.mid}&chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum(),function(childval){
							if($("#phones").val()!='')
								$("#phones").val($("#phones").val()+','+childval);
							else
								$("#phones").val(childval);
							$("#phones").focus();
						});
						win.reSize(900,500);
					}
				</fs:button>&nbsp;
				<fs:button key="WOMEN" id="women" name="选择孕妇" iconCls="icon-search">
					function(){
						win.show('选择孕妇','${path}/hospital/woman!womenList.qt?mid=${param.mid}&chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum(),function(childval){
							if($("#phones").val()!='')
								$("#phones").val($("#phones").val()+','+childval);
							else
								$("#phones").val(childval);
							$("#phones").focus();
						});
						win.reSize(1000,500);
					}
				</fs:button>&nbsp;
				<fs:button key="CHILDREN" id="child" name="选择儿童" iconCls="icon-search">
					function(){
						win.show('选择儿童','${path}/hospital/child!childrenList.qt?mid=${param.mid}&chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum(),function(childval){
							if($("#phones").val()!='')
								$("#phones").val($("#phones").val()+','+childval);
							else
								$("#phones").val(childval);
							$("#phones").focus();
						});
						win.reSize(1000,500);
					}
				</fs:button>&nbsp;
				<a href="#" class="easyui-linkbutton easyui-validatebox" methodType="importPhone['${fs:chkAccess(param.mid,'IMPORT') }','#phones']" iconCls="icon-print" style="margin-left:20px;">&nbsp;导入号码&nbsp;</a>
				<a href="#" class="easyui-linkbutton easyui-validatebox"  iconCls="icon-remove" style="margin-left:20px;" onClick="clearPhones()">&nbsp;清空号码&nbsp;</a>
				<textarea id="phones" name="phones" rows="5" class="easyui-validatebox" validType="mobile['^[<].+[>]$']" style="width:100%;" required="true" isnull="true"></textarea>
			</td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td class="titletd" style="text-align:right;">
				发送内容：
			</td>
			<td colspan="3">
				<div style="width: 100%;overflow: hidden;">
					<fs:button key="TEMPLATE" id="chooseTemplate" name="选择模板" iconCls="icon-print">
						function(){
							win.show('选择模板','${path}/sms/template!choose.qt?mid=${param.mid}&version=new&chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum(),function(childval){
								$("#sendContent").val(childval);
								$("#sendContent").focus();
							});
							win.reSize(962,504);
						}
					</fs:button>
					<!-- 
					<a href="#" class="easyui-linkbutton easyui-validatebox" methodType="chooseTemplate['${fs:chkAccess(param.mid,'TEMPLATE') }','#sendContent']" iconCls="icon-search" style="margin-left:20px;float: left;">&nbsp;选择模板【旧版】&nbsp;</a>
					<a href="#" class="easyui-linkbutton easyui-validatebox" methodType="chooseTemplateNew['${fs:chkAccess(param.mid,'TEMPLATE') }','#sendContent']" iconCls="icon-search" style="margin-left:20px;float: left;">&nbsp;选择模板【新版】&nbsp;</a>
					-->
					<label style="float: right;margin-right: 20px;height: 25px;line-height: 25px;">已输入 <font id="cue1" class="cue">0</font> 字，还可输入 <font id="cue2" class="cue">300</font> 字，总共可输入 <font id="cue3" class="cue">300</font> 字！</label>	
				</div>
				<textarea id="sendContent" name="sendContent" rows="5" class="easyui-validatebox"  style="width:100%;" required="true" isnull="true" onchange="checkWord()" onfocus="checkWord()" onblur="checkWord()" onKeyDown="checkWord()" onKeyUp="checkWord()" onkeypress="checkWord()" validType="filterWord[0,300]"></textarea>
			</td>
			<td>&nbsp;</td>
		</tr>
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
		</tr>
	</table>
	<center>
		<b id="resultInfo" style="color:red"><c:out value="${successInfo}"/></b><br/>
		<fs:button key="SAVE" id="saveBtn" name="发送" iconCls="icon-search">
			function(){
				el = $('#saveBtn')[0];
				$('#SendForm').form('submit',{
					url:'${path}/sms/sendMsg!send.qt?chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum(),
					onSubmit:function(){
						$('#phones').blur();
						var b = $(this).form('validate');
						if(b) $(el).linkbutton({disabled:true});
						return b;
					},
					success:function(data){
						$(el).linkbutton({disabled:false});
						try{
							var obj = eval(data);
							if(obj.b){
								$('#resultInfo').text(obj.desc);
								document.forms.SendForm.reset();
								jQuery.cookie('COOKIE_phones_value','',{path:CONTEXT_PATH,expires:1/24})
								window.setTimeout("$('#resultInfo').text(' ')",5000);
							}else parent.jQuery.messager.alert('错误','<br/>保存失败！','error');
						}catch(e){parent.jQuery.messager.alert('错误',e.message+'<br/><br/>保存失败！','error');}
					},
					onLoadError:function(e){
						$(el).linkbutton({disabled:false});
						parent.jQuery.messager.alert('错误',e.message+'<br/><br/>保存失败！','error');
					}
				});
			} 
		</fs:button>
	</center>
</form>
</body>
</html>