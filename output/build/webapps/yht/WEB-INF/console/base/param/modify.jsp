<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/include/include.jsp"%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>修改分类</title>
		<style type="text/css">
			body{padding:10px;background:#fafafa;overflow:hidden;}
			th{width:80px;height:35px;line-height:35px;text-align:right;font-size:9pt;font-weight:normal;}
			td{height:35px;line-height:35px;font-size:9pt;}
			.disabled{width:133px;background:#EBEBE4;border:1px solid #7F9DB9;}
		</style>
		<script type="text/javascript">
			function submitForm(el){
				$('#newForm').form('submit',{
					url:'${path}/base/param!modify.qt?random='+getRandomNum(),
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
							}else parent.jQuery.messager.alert('错误',obj.desc+'<br/><br/>保存失败！','error');
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
			<input type="hidden" name="fparam.id" value="${item.id }"/>
			<input type="hidden" name="fparam.droped" value="${item.droped }"/>
			<table style="width:100%;table-layout:fixed;" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<th>父分类：</th>
					<td><c:catch><c:out value="${item.parent.name}"/></c:catch></td>
				</tr>
				<tr>
					<th>分类名称：</th>
	    			<td>
	    				<input type="text" id="fparam.name" name="fparam.name" value="${item.name }" class="easyui-validatebox<c:if test="${item.droped eq 2 }"> disabled</c:if>"<c:if test="${item.droped eq 2 }"> readonly="readonly"</c:if> required="true" maxlength="32" style="width:70%;"/>
	    			</td>
	    		</tr>
	    		<tr>
	    			<th style="height:100px;" valign="top">分类描述：</th>
	    			<td>
	    				<textarea id="fparam.desc" name="fparam.desc" rows="6" style="width:70%;" class="easyui-validatebox<c:if test="${(item.droped eq 2 or item.droped eq 3 ) and Operator.id ne 1 }"> disabled</c:if>"<c:if test="${(item.droped eq 2 or item.droped eq 3 ) and Operator.id ne 1 }"> readonly="readonly"</c:if> validType="length[0,1000]"><c:out value="${item.desc}"/></textarea>
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