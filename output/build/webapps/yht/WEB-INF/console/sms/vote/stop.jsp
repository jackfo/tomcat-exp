<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/include/include.jsp"%><%@
	taglib prefix="ft" uri="http://www.flagsky.com/functions" %>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>停止投票</title>
		<script type="text/javascript" src="${path }/js/easyui/window.js"></script>
		<script type="text/javascript" src="${path }/js/vote/Vote.js"></script>
		<style type="text/css">
			*{margin:0px;padding:0px}
			body{padding:10px;background:#fafafa;}
			th{width:80px;height:35px;line-height:35px;text-align:right;font-size:9pt;font-weight:normal;}
			td{height:35px;line-height:35px;font-size:9pt;}
		</style>
		<script type="text/javascript">
			jQuery(document).ready(function(){
				
			});
			function closeWindow(){
				if(parent&&parent.win) parent.win.refreshParent(1);
			}
			function submitForm(el){
				if($(el).linkbutton('options').disabled) return;
				$('#newForm').form('submit',{
					url:'${path}/sms/vote!stop.qt?random='+getRandomNum(),
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
		</script>
	</head>
	<body>
		<form id="newForm" name="newForm" method="post">
			<input type="hidden" name="chkAccess" value="${param.chkAccess }">
			<input type="hidden" name="vote.id" value="${vote.id }">
			<table style="width:100%;table-layout:fixed;" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<th>标题：</th>
					<td>
						<c:out value="${vote.title }"/>
					</td>
					<td style="width:80px">&nbsp;</td>
				</tr>
				<tr>
					<th style="height:1%;" valign="top">描述：</th>
					<td colspan="2">
						<c:out value="${vote.desc}"/>
					</td>
				</tr>
				<tr>
					<th style="height:1%;" valign="top">接收号码：</th>
					<td colspan="2" style="padding:5px;word-wrap:break-word;word-break:normal;line-height:16px;">
						<c:out value="${ft:cropString(vote.destAddrs,395)}"/>
					</td>
				</tr>
				<tr>
					<th style="height:1%;" valign="top">短信内容：</th>
					<td colspan="2">
						<textarea id="smContent" name="smContent" rows="5" class="easyui-validatebox" validType="length[0,500]" required="true" style="width:100%;padding:3px"><c:out value="${smContent}"/></textarea>
					</td>
				</tr>
				<tr>
					<th>下发短信：</th>
					<td colspan="2" valign="middle">
						<input type="checkbox" id="isSendMsg" name="isSendMsg" value="1" style="margin-right:5px"/><label for="isSendMsg">是</label>
					</td>
				</tr>
				<tr>
					<td colspan="3" align="center" height="40" valign="bottom">
						<a href="#" onclick="submitForm(this);" class="easyui-linkbutton" plain="false" iconCls="icon-save" style="margin-right:10px">确定</a>
	    				<a href="javascript:reset();" class="easyui-linkbutton" plain="false" iconCls="icon-remove" style="margin-right:10px">重置</a>
	    				<a href="javascript:closeWindow();" class="easyui-linkbutton" plain="false" iconCls="icon-remove">关闭</a>
	    			</td>
	    		</tr>
	    	</table>
	    </form>
	</body>
</html>