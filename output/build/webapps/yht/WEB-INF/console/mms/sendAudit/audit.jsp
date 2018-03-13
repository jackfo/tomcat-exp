<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/include/include.jsp"%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>彩信审核</title>
	<style type="text/css">
		body{padding:10px;background:#fafafa;overflow:hidden;}
		th{width:120px;height:30px;line-height:30px;text-align:right;font-size:9pt;font-weight:normal;}
		td{height:30px;line-height:30px;font-size:9pt;}
	</style>
	<script type="text/javascript">
		var win;
		jQuery(document).ready(function(){
			getColorStyle();
			win = new Jwindow();
		});
		function submitForm(el){
			var sta = $('input[name=mmSendTask.status][checked]').val();
			var val = $('#audirtDesc').val();
			if(sta==2&&""==val){
				parent.jQuery.messager.alert('错误','请输入不通过的原因!','error');
				return;
			}
			$('#newForm').form('submit',{
				url:'${path}/mms/mmSendTask!modify.qt?random='+getRandomNum(),
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
							if(''!=jQuery.trim(obj.desc)){
								parent.jQuery.messager.alert('提示','审核成功!<br/><br/><span color="green">'+obj.desc+'</span>','info');
							}
							if(parent&&parent.win) parent.win.refreshParent();
						}else parent.jQuery.messager.alert('错误','<br/>审核失败！','error');
					}catch(e){parent.jQuery.messager.alert('错误',e.message+'<br/><br/>审核失败！','error');}
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
		function view(){
			win.show('彩信预览','${path}/mms/mmSendTask!view.qt?id='+$('input[name=id]').val()+'&chkAccess='+encodeURIComponent('${fs:chkAccess(param.mid,"VIEW")}')+'&random='+getRandomNum());
			win.reSize(205,350);
		}
	</script>
	</head>
	<body>
		<form id="newForm" name="newForm" method="post">
			<input type="hidden" name="chkAccess" value="${param.chkAccess }">
			<input type="hidden" name="id" value="${item.id }"/>
			<table style="width:100%;table-layout:fixed;" border="0" cellpadding="0" cellspacing="0">
				<tr style="display: none;"><th></th><td></td><th></th><td></td></tr>
				<tr>
					<th>任务提交人：</th>
	    			<td colspan="3">
	    				<input type="text" id="addAdmin" name="addAdmin" value="${item.addAdmin.userName}" readonly="readonly" style="width: 100%;"/>
	    			</td>
	    		</tr>
				<tr>
					<th>任务提交时间：</th>
	    			<td colspan="3">
	    				<input type="text" id="mmSendTask.addTime" name="mmSendTask.addTime" value="${item.addTime}" readonly="readonly" style="width: 100%;"/>
	    			</td>
	    		</tr>
				<tr>
					<th>彩信主题：</th>
	    			<td colspan="3">
	    				<input type="text" id="mmSendTask.subject" name="mmSendTask.subject" value="${item.subject}" readonly="readonly" style="width: 100%;"/>
	    			</td>
	    		</tr>
				<tr>
					<th>发送标示：</th>
	    			<td colspan="3">
	    				<input type="text" id="mmSendTask.sendMark" name="mmSendTask.sendMark" value="${item.sendMark}" readonly="readonly" style="width: 100%;"/>
	    			</td>
	    		</tr>
	    		<tr>
					<th>彩信发送号码：</th>
	    			<td  colspan="3" style="height: 160px;">
	    				<textarea rows="10" id="mmSendTask.phones" name="mmSendTask.phones" cols="" style="width: 100%;overflow-y: auto;" readonly="readonly">${item.phones }</textarea>
	    			</td>
	    		</tr>
	    		<tr>
					<th>定时发送时间：</th>
	    			<td colspan="3">
	    				<input type="text" id="mmSendTask.sendTime" name="mmSendTask.sendTime" value="${item.sendTime}" class="easyui-validatebox" methodType="chooseDate{dateFmt:'yyyy-MM-dd HH:mm:ss'}" style="width: 100%;"/>
	    			</td>
	    		</tr>
	    		<tr>
					<th>是否通过：</th>
	    			<td>
	    				<input type="radio" name="mmSendTask.status" id="status" value="1" checked="checked"/>是 
	    				<input type="radio" name="mmSendTask.status" id="status" value="2"/>否 
	    			</td>
					<th>短信提醒：</th>
	    			<td>
	    				<input type="radio" name="remind" value="1" checked="checked"/>是
	    				<input type="radio" name="remind" value="2"/>否
	    			</td>
	    		</tr>
	    		<tr>
					<th>处理意见：</th>
	    			<td colspan="3">
	    				<input type="text" id="audirtDesc" name="mmSendTask.audirtDesc" style="width: 100%;"/>
	    			</td>
	    		</tr>	    		
	    		<tr>
	    			<td colspan="4" style="height: 60px;text-align: left;">
	    				<div style="width: 99%;border: 1px solid red;padding: 3px;padding-left: 30px;">
		    				1、审核中除了能修改定时发送的时间外，其他彩信信息不能修改；</br>
		    				2、审核通过即会保存数据库并按照预定情况发送彩信；</br>
		    				3、彩信的定时发送时间，不填或者在当前时间之前都表示立即发送！
	    				</div>
	    			</td>
	    		</tr>
	    		<tr>
	    			<td colspan="2" align="center" height="40" valign="bottom">
	    				<a href="#" onclick="view();" class="easyui-linkbutton" plain="false" iconCls="icon-search" style="margin-right:10px">彩信预览</a>
	    				<a href="#" onclick="submitForm(this);" class="easyui-linkbutton" plain="false" iconCls="icon-save" style="margin-right:10px">提交</a>
	    				<a href="javascript:reset();" class="easyui-linkbutton" plain="false" iconCls="icon-remove">重置</a>
	    			</td>
	    		</tr>
	    	</table>
	    </form>
	</body>
</html>