<%@page language="java" pageEncoding="UTF-8"%>
<%@ include file="/include/include.jsp"%>

<html>
<head>
	<title>短信回复</title>
	<script type="text/javascript" src="${path }/js/easyui/window.js"></script>
	<style>
		*{margin:0px;padding:0px;}
		body{background:#fafafa;overflow: auto;}
		
		.sendBatchTable{width: 100%;margin:auto;margin-top:50px;border-top:1px solid #aaa;border-right:1px solid #aaa;background:#fff;table-layout: fixed;}
		.sendBatchTable td{padding:5px;padding-bottom:3px;height:30px;border-left:1px solid #aaa;border-bottom:1px solid #aaa;}
		.titleTd{width: 120px;background-color: #eeeeee;text-align: center;}
		.time-left{float: left;}
	</style>
	<script type="text/javascript">

		function isSetSendTime(num){
			if(num==0){
				$("#sdtime").css('visibility','hidden');
			}else if(num==1){
				$("#sdtime").css('visibility','');
			}
		}
		$(document).ready(function(){
			
		});
		function reset(){
			replyForm.reset();
		}
		
		function submitForm(el){
				
				el = $('#saveBtn')[0];
				$('#replyForm').form('submit',{
					url:'${path}/sms/received!reply.qt?chkAccess=${param.chkAccess}&random='+getRandomNum(),
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
								parent.jQuery.messager.alert('提示',obj.desc,'success');
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
	</script>
</head>
<body>
<form id="replyForm" name="replyForm" method="post">
	<center><h2 style="margin-top: 15">短&nbsp;信&nbsp;回&nbsp;复</h2></center>
	<table class="sendBatchTable" align="center" cellpadding="0" cellspacing="0" border="0" style="margin-top: 15px">
		<tr>
			<td class="titleTd">接收号码</td>
			<td>
				<input type="text" name="orgAddr" id="orgAddr" value="${param.orgAddr}" readonly="readonly"/>
			</td>
		</tr>
		<tr>
			<td class="titleTd">发送内容</td>
			<td style="height: 150px;">
				<a href="#" class="easyui-linkbutton easyui-validatebox" methodType="chooseTemplateNew['${fs:chkAccess(param.mid,'REPLY') }','#sendContent']" iconCls="icon-save" style="margin-left:20px;">&nbsp;选择模板&nbsp;</a>
				<textarea id="sendContent" name="sendContent" rows="7" class="easyui-validatebox"  style="width:100%;overflow-y: auto;" required="true" isnull="true" validType="filterWord[0,300]"></textarea>
			</td>
		</tr>
		<tr>
			<td class="titleTd">定时发送</td>
			<td>
				<div class="time-left">
					<input type="radio" id="istime_0" name="istime" value="0" checked onclick="isSetSendTime(0)"/>
					<label for="istime_0">否</label>
					<input type="radio" id="istime_1" name="istime" value="1" onclick="isSetSendTime(1)"/>
					<label for="istime_1">是</label>
				</div>	
				<div id="sdtime" style="float:left;visibility:hidden;margin-left: 20px;">
					<input type="text" id="stime" name="stime" style="width:150px;" class="easyui-validatebox" methodType="chooseDate{dateFmt:'yyyy-MM-dd HH:mm'}"/>
				</div>
			</td>
		</tr>
	</table>
	
	<center style="margin-top: 15">
		<a href="#" onclick="submitForm(this);" id="saveBtn" class="easyui-linkbutton" plain="false" iconCls="icon-save" style="margin-right:10px">发送</a>
   		<a href="javascript:reset();" class="easyui-linkbutton" plain="false" iconCls="icon-remove">重置</a>
   	</center>	
</form>
</body>
</html>