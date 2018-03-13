<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/include/include.jsp"%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>新增参数信息</title>
<style type="text/css">
	body{padding:10px;background:#fafafa;overflow:hidden;}
	th{width:80px;height:30px;line-height:30px;text-align:right;font-size:9pt;font-weight:normal;}
	td{height:30px;line-height:30px;font-size:9pt;}
</style>
	<script type="text/javascript">
		function submitForm(el){
			$('#newForm').form('submit',{
				url:'${path}/base/argu!newAdd.qt?chkAccess=${param.chkAccess}&random='+getRandomNum(),
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
		
		function setArguType(){
			if($('#arguType').val()==7){
				$('#arguFormatTr').css('display','block');
				$('#arguFormat').val('yyyy-MM-dd HH:mm:ss');
				$('#arguTimerSpan').css('display','block');
			}else{
				$('#arguFormatTr').css('display','none');
				$('#arguFormat').val('');
				$('#arguTimerSpan').css('display','none');
				$('#arguTimer').attr('checked','');
			}
			checkTimer();
		}
		
		function checkTimer(){
			var obj = $('#arguTimer').attr('checked');
			if(obj){
				$('#TaskJobTr').css('display','block');
				$('#TriggerTr').css('display','block');
			}else{
				$('#TaskJobTr').css('display','none');
				$('#TriggerTr').css('display','none');
				$('#arguTaskJob').val('');
				$('#arguTaskJobTrigger').val('');
			}
		}
	</script>
	</head>
	<body>
		<form id="newForm" name="newForm" method="post">
			<input type="hidden" name="chkAccess" value="${param.chkAccess }">
			<table style="width:100%;table-layout:fixed;" border="0" cellpadding="0" cellspacing="0">
				<tr style="display: none;"><th></th><td style="width: 170px;"></td><td></td></tr>
	    		<tr>
	    			<th>参数名字：</th>
	    			<td colspan="2">
	    				<input name="argument.arguName" id="arguName" class="easyui-validatebox" required="true" style="width:250px;">
	    			</td>
	    		</tr>
				<tr>
					<th>参数标识：</th>
					<td colspan="2">
						<input name="argument.arguMark" id="arguMark" class="easyui-validatebox" required="true" validType="exist['${path }/base/argu!exist.qt?chkAccess=${param.chkAccess}']" style="width:250px"/>
					</td>
				</tr>
				<tr>
					<th>参数类型：</th>
	    			<td colspan="2">
	    				<select name="argument.arguType" id="arguType" onchange="setArguType()" style="width: 250px;">
	    					<option value="0">开关:启用\禁用[Integer]</option>
	    					<option value="1">输入:字符串[String]</option>
	    					<option value="2">输入:文本域[String]</option>
	    					<option value="3">输入:整型[Integer]</option>
	    					<option value="4">输入:长整型[Long]</option>
	    					<option value="5">输入:浮点型[Float]</option>
	    					<option value="6">输入:双精度浮点型[Double]</option>
	    					<option value="7">输入:日期时间[Timestamp]</option>
	    				</select>
	    			</td>
	    		</tr>
				<tr id="arguFormatTr" style="display: none;">
					<th>格式应用：</th>
	    			<td colspan="2">
	    				<input name="argument.arguFormat" id="arguFormat" class="easyui-validatebox" style="width:250px"/>
	    			</td>
	    		</tr>
	    		<!-- 
				<tr>
					<th>参数数值：</th>
	    			<td>
	    				<input name="argument.arguValue" id="arguValue" class="easyui-validatebox" style="width:250px"/>
	    			</td>
	    		</tr>
	    		 -->
				<tr>
					<th>参数状态：</th>
	    			<td>
	    				<input type="radio" name="argument.arguStatus" value="1" checked="checked"/>启用  &nbsp; &nbsp; 
	    				<input type="radio" name="argument.arguStatus" value="0"/>禁用
	    			</td>
	    			<td>
	    				<span id="arguTimerSpan" style="display: none;">
	    					<input type="checkbox" name="argument.arguTimer" id="arguTimer" onclick="checkTimer()" value="1"/>定时配置
	    				</span>
	    			</td>
	    		</tr>
				<tr id="TaskJobTr" style="display: none;">
					<th>TaskJob：</th>
	    			<td colspan="2">
	    				<input name="argument.arguTaskJob" id="arguTaskJob" style="width:250px;">
	    			</td>
	    		</tr>
				<tr id="TriggerTr" style="display: none;">
					<th>Trigger：</th>
	    			<td colspan="2">
	    				<input name="argument.arguTaskJobTrigger" id="arguTaskJobTrigger" style="width:250px;">
	    			</td>
	    		</tr>
				<tr>
					<th>参数描述：</th>
	    			<td style="height: 110px;" colspan="2">
	    				<textarea rows="7" cols="" name="argument.arguDesc" id="arguDesc" style="width: 250px;border: 1px solid #aaaaaa;overflow-y: auto;"></textarea>
	    			</td>
	    		</tr>
	    		<tr>
	    			<td colspan="3" align="center" height="40" valign="bottom">
	    				<a href="#" onclick="submitForm(this);" class="easyui-linkbutton" plain="false" iconCls="icon-save" style="margin-right:10px">保存</a>
	    				<a href="javascript:reset();" class="easyui-linkbutton" plain="false" iconCls="icon-remove">重置</a>
	    			</td>
	    		</tr>
	    	</table>
	    </form>
	</body>
</html>