<%@page language="java" pageEncoding="UTF-8"%>
<%@page import="com.fs.base.param.NumberParam"%>
<%@ include file="/include/include.jsp"%>
<%
	pageContext.setAttribute("superMan",NumberParam.SUPER_MAN);
%>

<html>
<head>
	<title>参数设置</title>
	<script type="text/javascript" src="${path }/js/easyui/window.js"></script>
	<style>
		body{background:#fafafa;}
		.FormTable{margin:0px auto;margin-bottom:20px;width:100%;background:#aaa;}
		.FormTable td,.FormTable th{background:#ffffff;}
		.cue{color: red;font-weight: bold;}
		#noticeTitle{height: 30px;line-height: 30px;}
		#type1{height: 30px;line-height: 30px;}
		#type2{height: 30px;line-height: 30px;}
	</style>
	<script type="text/javascript">
		jQuery(document).ready(function(){
			setDateFmt();
		});
		
		function setDateFmt(){
			var type = $('#type').val();
			if(type==1){
				$('#type1').show();
				$('#type2').hide();
				var dateFmt = $('#dateFmt').val();
				if(dateFmt && dateFmt!=''){
					$('#timeSet').unbind('click').click(function(){
						WdatePicker({
							dateFmt:dateFmt,
							onpicked:function(){$(this).validatebox("validate");},
							oncleared:function(){$(this).validatebox("validate");}
						});
					});
				}
			}else if(type==2){
				$('#type1').hide();
				$('#type2').show();
				var jgFmt = $('input[name=jgFmt]:checked').val();
				if(jgFmt && jgFmt!=''){
					$('#timeSet').unbind('click').click(function(){
						WdatePicker({
							dateFmt: jgFmt,
							onpicked:function(){$(this).validatebox("validate");},
							oncleared:function(){$(this).validatebox("validate");}
						});
					});
				}
			}
		}
		
		function clearPhones(){
			$.cookie('COOKIE_phones_value', null);
			$('#phones').html('');   
		}
	</script>
</head>
<body>
<form id="SendForm" name="SendForm" action="" method="post">
	<table class="FormTable" align="center" border="0" cellpadding="1" cellspacing="0">
		<input type="hidden" name="syncParam.id" id="syncParam.id" value="${itemParam.id }" />
		<input type="hidden" name="timerData.id" value="${itemDate.id }">
		<input type="hidden" name="timerData.type" id="type" value="${itemDate.type }">
		<tr>
			<td style="width: 100px;padding: 0px;border-bottom:0px"></td>
			<td style="padding:0px;border-bottom:0px"></td>
			<td style="width: 80px;padding: 0px;border-bottom:0px"></td>
			<td style="padding:0px;border-bottom:0px"></td>
			<td style="width:110px"></td>
		</tr>
		<tr>
			<td class="titletd" style="text-align:right;">
				所属信息：
			</td>
			<td colspan="3" id='noticeTitle'>
				<c:out value="${itemParam.title }"></c:out>
			</td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td class="titletd" style="text-align:right;">
				设置类型：
			</td>
			<td colspan="3" id='noticeTitle'>
				<font id="cue1" class="cue" style="font-weight: bolder;">定时器</font>
			</td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td class="titletd" style="text-align:right;">
				格式设置：
			</td>
			<td colspan="3" id='type1' style="display: block;">
 				<input id="dateFmt" name="timerData.cronFmt" value="${itemDate.cronFmt }" readonly="readonly" class="easyui-validatebox" required="true" style="width:10%">
			</td>
			<td colspan="3" id='type2' style="display: none;">
   				<input type="radio" name="jgFmt" value="ss" <c:if test="${itemDate.cronFmt eq 'ss'}">checked="checked"</c:if> onclick="setDateFmt()"/>秒
   				<input type="radio" name="jgFmt" value="mm" <c:if test="${itemDate.cronFmt eq 'mm'}">checked="checked"</c:if> onclick="setDateFmt()"/>分
   				<input type="radio" name="jgFmt" value="HH" <c:if test="${itemDate.cronFmt eq 'HH'}">checked="checked"</c:if> onclick="setDateFmt()"/>时
   				<input type="radio" name="jgFmt" value="dd" <c:if test="${itemDate.cronFmt eq 'dd'}">checked="checked"</c:if> onclick="setDateFmt()"/>天
			</td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td class="titletd" style="text-align:right;">
				时间设置：
			</td>
			<td colspan="3" id='noticeTitle'>
				<input id="timeSet" name="timerData.cronTime" value="${itemDate.cronTime }" class="easyui-validatebox" required="true" methodType="chooseDate{dateFmt:'${itemDate.cronFmt }'}" style="width:10%">
			</td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td class="titletd" style="text-align:right;">
				状态设置：
			</td>
			<td colspan="3" id='noticeTitle'>
				<input type="radio" id="status1" name="timerData.status" value="1" <c:if test="${itemDate.status==1}">checked="checked"</c:if>>
				<label for="status1">启用</label>
   				<input type="radio" id="status" name="timerData.status" value="0" <c:if test="${itemDate.status==0}">checked="checked"</c:if>>
   				<label for="status">停用</label>
   			</td>
			<td>&nbsp;</td>
		</tr>
		
		<c:if test="${itemParam.id != 13 }" >
			<tr>
				<td class="titletd" style="text-align:right;">
					设置类型：
				</td>
				<td colspan="3" id='noticeTitle'>
					<font id="cue1" class="cue" style="font-weight: bolder;">短信内容</font>
				</td>
				<td>&nbsp;</td>
			</tr>
			<c:if test="${itemParam.id  != 17 && itemParam.id  != 19 && itemParam.id  != 20 && itemParam.id  != 23 && itemParam.id != 24 }">
				<tr>
					<td class="titletd" style="text-align:right;">
						<c:if test="${itemParam.id != 22 }" >
							周期：
						</c:if>
						<c:if test="${itemParam.id == 22 }" >
							预警金额：
						</c:if>
					</td>
					<td colspan="3" id='noticeTitle'>
						<input id="syncParam.cycle" name="syncParam.cycle" value="${itemParam.cycle }" class="easyui-validatebox" required="true" methodType="number" style="width:10%">
							<c:if test="${itemParam.id != 22 }" >
								天
							</c:if>
							<c:if test="${itemParam.id == 22 }" >
								元
							</c:if>
					</td>
					<td>&nbsp;</td>
				</tr>
			</c:if>
			<c:if test="${itemParam.id == 22 }">
				<tr>
					<td class="titletd" style="text-align:right;">
						提示次数：
					</td>
					<td colspan="3" id='noticeTitle'>
						<input id="num" name="num" value="${itemParam.phone }" class="easyui-validatebox" required="true" methodType="number" style="width:10%">次
					</td>
					<td>&nbsp;</td>
				</tr>
			</c:if>
			<c:if test="${itemParam.id  == 17 }">
				<tr style="height: 90px;">
					<td class="titletd" style="text-align:right;">
						发送号码：
					</td>
					<td colspan="3" id='noticeTitle'>
						<a href="#" class="easyui-linkbutton easyui-validatebox" methodType="chooseUser['${fs:chkAccess(param.mid,'SAVE') }','#phones']" iconCls="icon-search" style="margin-left:20px;">&nbsp;选择人员&nbsp;</a>
						<a href="#" class="easyui-linkbutton easyui-validatebox" methodType="chooseAddressBook['${fs:chkAccess(param.mid,'SAVE') }','#phones']" iconCls="icon-search" style="margin-left:20px;">&nbsp;选择通讯录&nbsp;</a>
						<a href="#" class="easyui-linkbutton easyui-validatebox"  iconCls="icon-remove" style="margin-left:20px;" onClick="clearPhones()">&nbsp;清空号码&nbsp;</a>
						<textarea id="phones" name="syncParam.phone" rows="4" class="easyui-validatebox" validType="mobile['^[<].+[>]$']" style="width:100%;" required="true" isnull="true"><c:out value="${itemParam.phone }"></c:out></textarea>					
					</td>
					<td>&nbsp;</td>
				</tr>
			</c:if>
			<c:if test="${itemParam.id  == 15 || itemParam.id  == 17 || itemParam.id  == 18 || itemParam.id  == 19 || itemParam.id == 20 || itemParam.id == 22 || itemParam.id == 23 || itemParam.id == 24 }">
				<tr>
					<td class="titletd" style="text-align:right;">
						短信内容：
					</td>
					<td colspan="3">
						<textarea id="syncParam.msgContent" name="syncParam.msgContent" rows="4" class="easyui-validatebox" style="width:100%;" required="true" isnull="true" validType="length[0,300]"><c:out value="${itemParam.msgContent }"></c:out></textarea>
					</td>
					<td>&nbsp;</td>
				</tr>
			</c:if>
			
			<c:if test="${itemParam.id  == 16 }">
				<tr>
					<td class="titletd" style="text-align:right;">
						1-28周短信内容：
					</td>
					<td colspan="3">
						<textarea id="syncParam.msgContent" name="syncParam.msgContent" rows="4" class="easyui-validatebox" validType="length[0,100]" style="width:100%;" required="true" isnull="true">${fn:split(itemParam.msgContent, "/*/")[0]}</textarea>
					</td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td class="titletd" style="text-align:right;">
						28-36周短信内容：
					</td>
					<td colspan="3">
						<textarea id="msgCount2" name="msgCount2" rows="4" class="easyui-validatebox" style="width:100%;" validType="length[0,100]" required="true" isnull="true">${fn:split(itemParam.msgContent, "/*/")[1]}</textarea>
					</td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td class="titletd" style="text-align:right;">
						36-出生短信内容：
					</td>
					<td colspan="3">
						<textarea id="msgCount3" name="msgCount3" rows="4" class="easyui-validatebox" style="width:100%;" validType="length[0,100]" required="true" isnull="true">${fn:split(itemParam.msgContent, "/*/")[2]}</textarea>
					</td>
					<td>&nbsp;</td>
				</tr>
			</c:if>
				<c:if test="${itemParam.id  == 15 || itemParam.id  == 16 || itemParam.id == 17 || itemParam.id == 20 || itemParam.id == 22 || itemParam.id == 23||itemParam.id == 24 }">
				<tr>
					<td class="titletd" style="text-align:right;">
						温馨提示：
					</td>
					<td colspan="3" id='noticeTitle' style="height: auto;">
						<c:if test="${itemParam.id  == 15 }">
							1、<font id="cue1" class="cue">FM</font>会自动替换为父母名字；<br/>
							2、<font id="cue1" class="cue">HZ</font>会自动替换为孩子名字；<br/>
							3、如果发送的短信内容不需要含有某项，可将对应标示去掉。
						</c:if>
						<c:if test="${itemParam.id  == 16 }">
							1、<font id="cue1" class="cue">MZ</font>会自动替换为孕妇名字；<br/>
							2、如果发送的短信内容不需要含有某项，可将对应标示去掉。
						</c:if>
						<c:if test="${itemParam.id  == 20 }">
							1、<font id="cue1" class="cue">SJ</font>会自动替换为昨天的日期；<br/>
							2、<font id="cue1" class="cue">XM</font>会自动替换为姓名；<br/>
							3、<font id="cue1" class="cue">FY</font>会自动替换为结账费用；<br/>
							4、<font id="cue1" class="cue">YE</font>会自动替换为余额费用；<br/>
							5、如果发送的短信内容不需要含有某项，可将对应标示去掉。
						</c:if>
						<c:if test="${itemParam.id  == 22 }">
							1、<font id="cue1" class="cue">XM</font>会自动替换为姓名；<br/>
							2、<font id="cue1" class="cue">JE</font>会自动替换为预警值费用；<br/>
							3、如果发送的短信内容不需要含有某项，可将对应标示去掉。
						</c:if>
						<c:if test="${itemParam.id  == 23 }">
							1、<font id="cue1" class="cue">XM</font>会自动替换为姓名；<br/>
							2、<font id="cue1" class="cue">LX</font>会自动替换为报告类型；<br/>
							3、如果发送的短信内容不需要含有某项，可将对应标示去掉。
						</c:if>
						<c:if test="${itemParam.id  == 24 }">
							1、<font id="cue1" class="cue">XM</font>会自动替换为姓名；<br/>
							2、如果发送的短信内容不需要含有某项，可将对应标示去掉。
						</c:if>
					</td>
					<td>&nbsp;</td>
				</tr>	
				</c:if>	
			
			
			<!-- 下面判断是不是超级管理员，如果是这显示同步的sql信息 -->
			<c:if test="${sessionScope.Operator.role.id == superMan }">
				<tr>
					<td class="titletd" style="text-align:right;">
						是否同步：
					</td>
					<td colspan="3" id='noticeTitle'>
						<input type="radio" name="syncParam.syncStatus" id="syncParam.syncStatus" value="0" <c:if test="${itemParam.syncStatus==0}">checked="checked"</c:if>>否
						<input type="radio" name="syncParam.syncStatus" id="syncParam.syncStatus" value="1" <c:if test="${itemParam.syncStatus==1}">checked="checked"</c:if>>是
					</td>
					<td>&nbsp;</td>
				</tr>
				<tr>
				<td class="titletd" style="text-align:right;">
					同步SQL语句：
				</td>
				<td colspan="3">
					<textarea id="syncParam.sqlContent" name="syncParam.sqlContent" rows="5" class="easyui-validatebox" style="width:100%;"><c:out value="${itemParam.sqlContent }"></c:out></textarea>
				</td>
				<td>&nbsp;</td>
			</tr>
			</c:if>		
		</c:if>
	</table>
	<center>
		<b id="resultInfo" style="color:red"><c:out value="${successInfo}"/></b><br/>
		<fs:button key="SAVE" id="saveBtn" name="保存" iconCls="icon-search">
			function(){
				el = $('#saveBtn')[0];
				$('#SendForm').form('submit',{
					url:'${path}/hospital/syncParam!modify.qt?chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum(),
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
								$('#resultInfo').text(obj.desc);
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