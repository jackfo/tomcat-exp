<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/include/include.jsp"%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>修改定时器</title>
<style type="text/css">
	body{padding:10px;background:#fafafa;overflow:hidden;}
	th{width:80px;height:30px;line-height:30px;text-align:right;font-size:9pt;font-weight:normal;}
	td{height:30px;line-height:30px;font-size:9pt;}
</style>
	<script type="text/javascript">
		$(document).ready(function(){
			setDateFmt();
		});
		function submitForm(el){
			$('#newForm').form('submit',{
				url:'${path}/base/timer!modify.qt?chkAccess=${param.chkAccess}&random='+getRandomNum(),
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
		function reset(){
			newForm.reset();
		}
		
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
	</script>
	</head>
	<body>
		<form id="newForm" name="newForm" method="post">
			<input type="hidden" name="chkAccess" value="${param.chkAccess }">
			<input type="hidden" name="timerData.id" value="${item.id }">
			<table style="width:100%;table-layout:fixed;" border="0" cellpadding="0" cellspacing="0">
	    		<tr>
	    			<th>定时器名称：</th>
	    			<td>
	    				<input id="timerData.name" name="timerData.name" value="${item.name }" class="easyui-validatebox" required="true" style="width:70%;">
	    			</td>
	    		</tr>
				<tr>
					<th>定时器类型：</th>
					<td><select id="type" name="timerData.type" onchange="setDateFmt()" style="width:70%;"><option value="1" <c:if test="${item.type==1}">selected="selected"</c:if>>定点执行</option><option value="2" <c:if test="${item.type==2}">selected="selected"</c:if>>定时轮询</option></select></td>
				</tr>
				<tr>
	    			<th>格式类型：</th>
	    			<td>
	    				<div id="type1" style="display: block;">
	    					<input id="dateFmt" name="timerData.cronFmt" value="${item.cronFmt }" onchange="setDateFmt()" class="easyui-validatebox" required="true" style="width:70%">
	    				</div>
	    				<div id="type2" style="display: none;">
		    				<input type="radio" name="jgFmt" value="ss" <c:if test="${item.cronFmt eq 'ss'}">checked="checked"</c:if> onclick="setDateFmt()"/>秒
		    				<input type="radio" name="jgFmt" value="mm" <c:if test="${item.cronFmt eq 'mm'}">checked="checked"</c:if> onclick="setDateFmt()"/>分
		    				<input type="radio" name="jgFmt" value="HH" <c:if test="${item.cronFmt eq 'HH'}">checked="checked"</c:if> onclick="setDateFmt()"/>时
		    				<input type="radio" name="jgFmt" value="dd" <c:if test="${item.cronFmt eq 'dd'}">checked="checked"</c:if> onclick="setDateFmt()"/>天
	    				</div>
	    			</td>
	    		</tr>
				<tr>
	    			<th>时间设置：</th>
	    			<td>
	    				<input id="timeSet" name="timerData.cronTime" value="${item.cronTime }" class="easyui-validatebox" required="true" methodType="chooseDate{dateFmt:'${item.cronFmt }'}" style="width:70%">
	    			</td>
	    		</tr>
	    		<tr>
	    			<th>定时器任务：</th>
	    			<td>
	    				<input id="timerData.service" name="timerData.service" value="${item.service }" style="width:70%">
	    			</td>
	    		</tr>
	    		<tr>
	    			<th>状态：</th>
	    			<td>
						<input type="radio" id="status1" name="timerData.status" value="1" <c:if test="${item.status==1}">checked="checked"</c:if>>
						<label for="status1">启用</label>
	    				<input type="radio" id="status" name="timerData.status" value="0" <c:if test="${item.status==0}">checked="checked"</c:if>>
	    				<label for="status">停用</label>
	    			</td>
	    		</tr>
				<tr>
					<th>定时器描述：</th>
	    			<td style="height: 100px;">
	    				<textarea name="timerData.describe" rows="6" cols="" style="width:70%;">${item.describe }</textarea>
	    			</td>
	    		</tr>
	    		<tr>
	    			<td colspan="2" align="center" height="40" valign="bottom">
	    				<a href="#" onclick="submitForm(this);" class="easyui-linkbutton" plain="false" iconCls="icon-save" style="margin-right:10px">保存</a>
	    				<a href="javascript:reset();" class="easyui-linkbutton" plain="false" iconCls="icon-remove">重置</a>
	    			</td>
	    		</tr>
	    	</table>
	    </form>
	</body>
</html>