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
					url:'${path}/base/organ!newAdd.qt?random='+getRandomNum(),
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
			function organType(){
				var v = $('#newForm input[name="organ.isUnit"]:checked').val();
				var el = $(document.getElementById('organ.seeLevel'));
				var info = $(document.getElementById('organ.seeLevel.info'));
				if(v == '0'){
					el.hide();
					info.show();
					el.attr('defaultValue',el.val());
					el.val('0');
				}else {
					el.val(el.attr('defaultValue'));
					el.show();
					info.hide();
				}
			}
		</script>
	</head>
	<body>
		<form id="newForm" name="newForm" method="post">
			<input type="hidden" name="chkAccess" value="${param.chkAccess }">
			<input type="hidden" name="organ.parent.id" value="${param.id }"/>
			<table style="width:100%;table-layout:fixed;" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<th>父项目：</th>
					<td><c:out value="${param.name}"/></td>
				</tr>
				<tr>
					<th>名称：</th>
	    			<td>
	    				<input type="text" id="organ.orgnName" name="organ.orgnName" class="easyui-validatebox" required="true" maxlength="50" style="width:150px"/>
	    			</td>
	    		</tr>
	    		<tr>
					<th>编号：</th>
	    			<td>
	    				<input type="text" id="organ.orgnNo" name="organ.orgnNo" class="easyui-validatebox" validType="exist['${path }/base/organ!noExist.qt?pNo=${param.no }&chkAccess=${param.chkAccess }']" required="true" maxlength="2" style="width:150px"/>
	    			</td>
	    		</tr>
	    		<tr>
					<th>层级：</th>
	    			<td>
	    				<input type="text" id="organ.sortNo" name="organ.sortNo" value="${param.sortNo }" class="easyui-numberbox" precision="0" required="true" style="width:150px"/>
	    			</td>
	    		</tr>
	    		<tr style="display:none;">
	    			<th>优先级：</th>
	    			<td>
	    				<select id="organ.precedence" name="organ.precedence" style="width:150px"><c:forEach var="level" begin="1" end="10">
				            <option value="${level }">${level }</option></c:forEach>
			            </select>
	    			</td>
	    		</tr>
	    		<tr style="display:none;">
	    			<th>类别：</th>
	    			<td>
						<input type="radio" id="organ.isUnit1" name="organ.isUnit" value="1" onclick="organType(this)" <c:if test="${param.isUnit eq 1 }">checked="checked"</c:if> <c:if test="${param.isUnit ne 1 }">disabled="disabled"</c:if>>
						<label for="organ.isUnit1">单位</label>
	    				<input type="radio" id="organ.isUnit" name="organ.isUnit" value="0" onclick="organType(this)" <c:if test="${param.isUnit ne 1 }">checked="checked" readonly="readonly"</c:if>>
	    				<label for="organ.isUnit">部门</label>
	    			</td>
	    		</tr>
	    		<tr style="display:none;">
	    			<th>查看级别：</th>
	    			<td><c:set var="levelMap" value="只能查看自己"/>
	    				<select id="organ.seeLevel" name="organ.seeLevel" style="width:150px;<c:if test="${param.isUnit ne 1 }">display:none;</c:if>" class="easyui-validatebox" required="true"><c:forEach var="level" begin="0" end="10">
				            <option value="${level }"><c:out value="${level eq 0 ? levelMap : level}"/></option></c:forEach>
			            </select>
			            <div id="organ.seeLevel.info" style="<c:if test="${param.isUnit eq 1 }">display:none;</c:if>color:red">部门下只能创建部门且部门不需要设置查看级别！</div>
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