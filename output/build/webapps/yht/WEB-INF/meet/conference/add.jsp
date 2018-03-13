<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/include/include.jsp"%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>发起会议</title>
		<script type="text/javascript" src="${path }/js/easyui/window.js"></script>
		<style type="text/css">
			*{margin:0px;padding:0px}
			body{padding:10px;background:#fafafa;}
			th{width:80px;height:35px;line-height:35px;text-align:center;font-size:9pt;font-weight:normal;}
			td{height:35px;line-height:35px;font-size:9pt;}
		</style>
		<script type="text/javascript">
			jQuery(document).ready(function(){
			});
			function submitForm(el){
				if($(el).linkbutton('options').disabled) return;
				$('#newForm').form('submit',{
					url:'${path}/meet/conference!newAdd.qt?random='+getRandomNum(),
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
			<table style="width:100%;table-layout:fixed;" border="0" cellpadding="1" cellspacing="0" >
				<tr>
					<th>会议主题:</th>
					<td>
						<input type="text" name="conference.title" class="easyui-validatebox" required="true" maxlength="50" style="width:90%"/>
					</td>
				</tr>
				<tr>
					<th style="height:1%;line-height:26px" valign="middle">接收号码:</th>
					<td>
						<a href="#" class="easyui-linkbutton easyui-validatebox" methodType="chooseUser['${param.chkAccess }','textarea[id=\'conference.destAddrs\']']" iconCls="icon-save" style="margin-left:2px;">&nbsp;选择人员&nbsp;</a>
						<a href="#" class="easyui-linkbutton easyui-validatebox" methodType="chooseAddressBook['${param.chkAccess }','textarea[id=\'conference.destAddrs\']']" iconCls="icon-search" style="margin-left:2px;">&nbsp;选择通讯录&nbsp;</a>
						<a href="#" class="easyui-linkbutton easyui-validatebox" methodType="importPhone['${param.chkAccess }','textarea[id=\'conference.destAddrs\']']" iconCls="icon-save" style="margin-left:2px;">&nbsp;导入号码&nbsp;</a>
						<textarea id="conference.destAddrs" name="conference.destAddrs" rows="5" class="easyui-validatebox" validType="mobile['^[<].+[>]$']" required="true" style="width:90%"></textarea>
					</td>
				</tr>
				<tr>
					<th style="height:1%;line-height:50px" valign="middle">短信内容:</th>
					<td>
						<textarea rows="5" name="content" class="easyui-validatebox" validType="length[0,256]" style="width:90%" required="true" ></textarea>
					</td>
				</tr>
				<tr>
					<th style="height:1%;line-height:26px" valign="top">失效时间:</th>
					<td>
						<input type="text" id="stime" name="stime" style="width:150px;" class="easyui-validatebox" methodType="chooseDate{dateFmt:'yyyy-MM-dd HH:mm'}" required="true" />
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