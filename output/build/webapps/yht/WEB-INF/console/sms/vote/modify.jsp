<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/include/include.jsp"%><%@
	taglib prefix="ft" uri="http://www.flagsky.com/functions" %>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>修改投票</title>
		<script type="text/javascript" src="${path }/js/easyui/window.js"></script>
		<script type="text/javascript" src="${path }/js/vote/Vote.js"></script>
		<style type="text/css">
			*{margin:0px;padding:0px}
			body{padding:10px;background:#fafafa;}
			th{width:80px;height:35px;line-height:35px;text-align:right;font-size:9pt;font-weight:normal;}
			td{height:35px;line-height:35px;font-size:9pt;}
		</style>
		<script type="text/javascript">
			var vote;
			jQuery(document).ready(function(){
				vote = new Vote(document.getElementById('itemContent'),{
					mark:'itemMark',
					name:'itemContent',
					type:'vote.type',
					typeDefault:'${vote.type}',
					length:200
				});<c:catch><c:forEach var="item" items="${vote.item}" varStatus="s">
				vote.add({mark:'${item.mark}',name:'${item.content}'<c:if test="${s.index le 1}">,del:false</c:if>});</c:forEach></c:catch>
			});
			function submitForm(el){
				if($(el).linkbutton('options').disabled) return;
				$('#newForm').form('submit',{
					url:'${path}/sms/vote!modify.qt?random='+getRandomNum(),
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
				vote.removeAll();
				<c:catch><c:forEach var="item" items="${vote.item}" varStatus="s">
				vote.add({mark:'${item.mark}',name:'${item.content}'<c:if test="${s.index le 1}">,del:false</c:if>});</c:forEach></c:catch>
			}
		</script>
	</head>
	<body>
		<form id="newForm" name="newForm" method="post">
			<input type="hidden" name="chkAccess" value="${param.chkAccess }">
			<input type="hidden" name="vote.id" value="${vote.id }">
			<input type="hidden" name="vote.mark" value="${vote.mark }">
			<table style="width:100%;table-layout:fixed;" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<th>标题：</th>
					<td>
						<input type="text" name="vote.title" value="${vote.title }" class="easyui-validatebox" required="true" maxlength="64" style="width:100%"/>
					</td>
				</tr>
				<tr>
					<th style="height:1%;line-height:26px" valign="top">描述：</th>
					<td>
						<textarea rows="2" name="vote.desc" class="easyui-validatebox" validType="length[0,256]" style="width:100%"><c:out value="${vote.desc}"/></textarea>
					</td>
				</tr>
				<tr>
					<th style="height:1%;line-height:26px" valign="top">接收号码：</th>
					<td>
						<a href="#" class="easyui-linkbutton easyui-validatebox" methodType="chooseUser['${param.chkAccess }','textarea[id=\'vote.destAddrs\']']" iconCls="icon-save" style="margin-left:2px;">&nbsp;选择人员&nbsp;</a>
						<a href="#" class="easyui-linkbutton easyui-validatebox" methodType="chooseAddressBook['${param.chkAccess }','textarea[id=\'vote.destAddrs\']']" iconCls="icon-search" style="margin-left:2px;">&nbsp;选择通讯录&nbsp;</a>
						<a href="#" class="easyui-linkbutton easyui-validatebox" methodType="importPhone['${param.chkAccess }','textarea[id=\'vote.destAddrs\']']" iconCls="icon-save" style="margin-left:2px;">&nbsp;导入号码&nbsp;</a>
						<textarea id="vote.destAddrs" name="vote.destAddrs" rows="5" class="easyui-validatebox" validType="mobile['^[<].+[>]$']" required="true" style="width:100%"><c:out value="${vote.destAddrs}"/></textarea>
					</td>
				</tr>
				<tr>
					<th>参与次数：</th>
					<td>
						<input type="text" name="vote.number" value="${vote.number }" class="easyui-validatebox" validType="number" required="true" maxlength="64" style="width:100%"/>
					</td>
				</tr>
	    		<tr>
	    			<th style="height:1%;line-height:26px;line-height:33px\9;" valign="top">选项：</th>
	    			<td id="itemContent" valign="top"></td>
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