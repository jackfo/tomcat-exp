<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/include/include.jsp"%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>增加菜单</title>
		<style type="text/css">
			body{padding:10px;background:#fafafa;overflow:hidden;}
			th{width:80px;height:35px;line-height:35px;text-align:right;font-size:9pt;font-weight:normal;}
			td{height:35px;line-height:35px;font-size:9pt;}
		</style>
		<script type="text/javascript">
			function submitForm(el){
				$('#newForm').form('submit',{
					url:'${path}/base/menu!btnNewAdd.qt?random='+getRandomNum(),
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
								if(parent&&parent.subWin) parent.subWin.refreshParent();
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
			<input type="hidden" name="button.menu.id" value="${param.id }"/>
			<table style="width:100%;table-layout:fixed;" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<th>所属菜单：</th>
					<td><c:out value="${param.name}"/></td>
				</tr>
				<tr>
					<th>按钮名称：</th>
	    			<td>
	    				<input type="text" id="button.buttonName" name="button.buttonName" class="easyui-validatebox" required="true" maxlength="50" style="width:200px"/>
	    			</td>
	    		</tr>
	    		<tr>
	    			<th>按钮标识：</th>
	    			<td>
	    				<input type="text" id="button.buttonMark" name="button.buttonMark" class="easyui-validatebox" required="true" validType="exist['${path }/base/menu!btnExist.qt?id=${param.id }&chkAccess=${param.chkAccess }']" maxlength="15" style="width:200px"/>
	    			</td>
	    		</tr>
	    		<tr>
	    			<th style="height:70px;" valign="top">访问资源：</th>
	    			<td>
	    				<textarea id="button.accessRes" name="button.accessRes" rows="4" style="width:200px" class="easyui-validatebox" validType="length[0,1000]"></textarea>
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