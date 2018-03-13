<%@page language="java" pageEncoding="UTF-8"%>
<%@ include file="/include/include.jsp"%>

<html>
<head>
	<title>分组群发</title>
	<script type="text/javascript" src="${path }/js/easyui/window.js"></script>
	<script type="text/javascript" src="${path }/js/bgshade/jQuery_plug_bgshade.js"></script>
	<style>
		body{background:#fafafa;overflow-y: auto;}
		.FormTable{margin:0px auto;margin-bottom:20px;width:100%;background:#aaa;}
		.FormTable td,.FormTable th{background:#ffffff;}
		.cue{color: red;font-weight: bold;}
		.gItem{float: left;width: 200px;height: 25px;line-height: 25px;overflow: hidden;}
		.gItem span{color: red;}
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
		
		function checkWord(){
			var cue1 = $('#sendContent').val().trim().length;
			var cue3 = $('#cue3').text();
			var cue2 = cue3 - cue1;
			$('#cue1').text(cue1);
			$('#cue2').text(cue2);
		}
		function checkAll(obj){
			if($(obj).attr('checked')){
				$('input[name=group]').attr('checked',true);
			}else{
				$('input[name=group]').attr('checked',false);				
			}
		}	
	</script>
</head>
<body>
<form id="SendForm" name="SendForm" action="${path}/sms/sendMsg!sendGroup.qt?chkAccess=${fs:chkAccess(param.mid,'SEND') }" method="post">
	<table class="FormTable" align="center" border="0" cellpadding="1" cellspacing="0">
		<tr>
			<td style="width: 80px;padding: 0px;border-bottom:0px"></td>
			<td style="padding:0px;border-bottom:0px"></td>
			<td style="width: 80px;padding: 0px;border-bottom:0px"></td>
			<td style="padding:0px;border-bottom:0px"></td>
			<td style="width:130px"></td>
		</tr>
		<tr>
			<td class="titletd" style="text-align:right;height: 25px;">
				所属业务：
			</td>
			<td colspan="3" id='noticeTitle'>
				通讯录分组群发
			</td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td class="titletd" style="text-align:right;" rowspan="3">
				分组信息：
			</td>
			<td colspan="3">
				<input type="checkbox" name="groupAll" value="all" onclick="checkAll(this)"/>所有分组(${allgroup})
			</td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td colspan="3">
				<c:forEach var="item" items="${groups}">
					<div class="gItem">
						<input type="checkbox" name="group" value="${item.id }" />
						<c:if test="${item.type eq 1}"><span>[共]</span></c:if><c:out value="${item.name}"/><c:catch>(<c:out value="${fn:length(item.contacts)}"/>)</c:catch>
					</div>
				</c:forEach>
			</td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td colspan="3">
				<input type="checkbox" name="group" value="0" />未分组(<c:out value="${ungroup}"/>)
			</td>
			<td>&nbsp;</td>
		</tr>
		<tr>
			<td class="titletd" style="text-align:right;">
				发送内容：
			</td>
			<td colspan="3">
				<div style="width: 100%;overflow: hidden;">
					<a href="#" class="easyui-linkbutton easyui-validatebox" methodType="chooseTemplate['${fs:chkAccess(param.mid,'TEMPLATE') }','#sendContent']" iconCls="icon-search" style="margin-left:20px;float: left;">&nbsp;选择模板&nbsp;</a>
					<label style="float: right;margin-right: 20px;height: 25px;line-height: 25px;">已输入 <font id="cue1" class="cue">0</font> 字，还可输入 <font id="cue2" class="cue">300</font> 字，总共可输入 <font id="cue3" class="cue">300</font> 字！</label>	
				</div>
				<textarea id="sendContent" name="sendContent" rows="5" class="easyui-validatebox"  style="width:100%;" required="true" isnull="true" onchange="checkWord()" onfocus="checkWord()" onblur="checkWord()" onKeyDown="checkWord()" onKeyUp="checkWord()" onkeypress="checkWord()" ></textarea>
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
					<input type="text" id="stime" name="stime" style="width:150px;" class="easyui-validatebox" methodType="chooseDate{dateFmt:'yyyy-MM-dd HH:mm:ss'}"/>
				<div>
			</td>
			<td>&nbsp;</td>
		</tr>
	</table>
	<center>
		<b id="resultInfo" style="color:red"><c:out value="${successInfo}"/></b><br/>
		<fs:button key="SEND" id="saveBtn" name="发送" iconCls="icon-search">
			function(){
				el = $('#saveBtn')[0];
				$('#SendForm').form('submit',{
					url:'${path}/sms/sendMsg!sendGroup.qt?chkAccess='+encodeURIComponent('${fs:chkAccess(param.mid,'SEND') }')+'&random='+getRandomNum(),
					onSubmit:function(){
						$('#phones').blur();
						var b = $(this).form('validate');
						if(b){
						 	$(el).linkbutton({disabled:true});
							$(document.body).bgshade("分组数据处理中，请耐心等待......");
						}
						return b;
					},
					success:function(data){
						$(el).linkbutton({disabled:false});
						try{
							var obj = eval(data);
							if(obj.b){
								$(document.body).bgshade(false);
								$('#resultInfo').text(obj.desc);
								document.forms.SendForm.reset();
								checkWord();
								jQuery.cookie('COOKIE_phones_value','',{path:CONTEXT_PATH,expires:1/24})
								window.setTimeout("$('#resultInfo').text(' ')",5000);
							}else parent.jQuery.messager.alert('错误','<br/>保存失败！','error');
						}catch(e){$(document.body).bgshade(false);parent.jQuery.messager.alert('错误',e.message+'<br/><br/>保存失败！','error');}
					},
					onLoadError:function(e){
						$(document.body).bgshade(false);
						parent.jQuery.messager.alert('错误',e.message+'<br/><br/>保存失败！','error');
						$(el).linkbutton({disabled:false});
					}
				});
			} 
		</fs:button>
	</center>
</form>
</body>
</html>