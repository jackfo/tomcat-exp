<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/include/include.jsp"%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>修改菜单</title>
		<link rel="stylesheet" type="text/css" href="${path}/css/easyUImain.css">
		<style type="text/css">
			body{padding:10px;background:#fafafa;overflow:hidden;}
			th{width:80px;height:35px;line-height:35px;text-align:right;font-size:9pt;font-weight:normal;}
			td{height:35px;line-height:35px;font-size:9pt;}
		</style>
		<script type="text/javascript">
			function submitForm(el){
				$('#newForm').form('submit',{
					url:'${path}/base/menu!modify.qt?random='+getRandomNum(),
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
			<input type="hidden" name="menu.id" value="${item.id }"/>
			<table style="width:100%;table-layout:fixed;" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<th>父菜单：</th>
					<td>
						<c:catch>
							<c:if test="${item.parent.id gt 0}">
								<c:out value="${item.parent.menuName}"/>
							</c:if>
							<c:if test="${item.parent.id eq 0}">
								/
							</c:if>
						</c:catch>
					</td>
				</tr>
				<tr>
					<th>菜单名称：</th>
	    			<td>
	    				<input type="text" id="menu.menuName" name="menu.menuName" value="${item.menuName }" class="easyui-validatebox" required="true" maxlength="50" style="width:200px"/>
	    			</td>
	    		</tr>
	    		<tr>
	    			<th>URL：</th>
	    			<td>
	    				<input type="text" id="menu.menuUrl" name="menu.menuUrl" value="${item.menuUrl }" maxlength="200" style="width:200px"/>
	    			</td>
	    		</tr>
	    		<tr>
	    			<th>优先级：</th>
	    			<td>
	    				<select id="menu.precedence" name="menu.precedence" style="width:200px"><c:forEach var="level" begin="${(item.precedence-5)>0?(item.precedence-5):1}" end="${item.precedence + 5}">
				            <option value="${level }" <c:if test="${item.precedence eq level }">selected="selected"</c:if>>${level }</option></c:forEach>
			            </select>
	    			</td>
	    		</tr>
	    		<tr>
	    			<th>菜单图标：</th>
	    			<td>
	    				<input type="text" id="menu.menuIcon" name="menu.menuIcon" value="${item.menuIcon }" class="easyui-validatebox" methodType="chooseIcon" showText="${item.menuIcon }" readonly="readonly" style="width:150px"/>
	    			</td>
	    		</tr>
	    		<tr>
	    			<th>状态：</th>
	    			<td>
						<input type="radio" id="menu.status1" name="menu.status" value="1" <c:if test="${item.status eq 1 }">checked="checked"</c:if>>
						<label for="menu.status1">启用</label>
	    				<input type="radio" id="menu.status" name="menu.status" value="0" <c:if test="${item.status ne 1 }">checked="checked"</c:if>>
	    				<label for="menu.status">停用</label>
	    			</td>
	    		</tr>
	    		<tr>
	    			<td colspan="2" align="center" height="40" valign="bottom">
	    				<a href="#" onclick="submitForm(this)" class="easyui-linkbutton" plain="false" iconCls="icon-save" style="margin-right:10px">保存</a>
	    				<a href="javascript:reset();" class="easyui-linkbutton" plain="false" iconCls="icon-remove">重置</a>
	    			</td>
	    		</tr>
	    	</table>
	    </form>
	</body>
</html>