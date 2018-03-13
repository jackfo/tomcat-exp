<%@ page language="java" pageEncoding="UTF-8"%>
<%@page import="com.fs.util.param.StringParam"%>
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
					url:'${path}/base/organ!modify.qt?random='+getRandomNum(),
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
			<input type="hidden" name="organ.id" value="${item.id }"/>
			<table style="width:100%;table-layout:fixed;" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<th>父项目：</th>
					<td><c:catch>
						<c:if test="${item.parent.id eq 0}">
							/ <%=StringParam.PROJECT_NAME %>
						</c:if>
						<c:out value="${item.parent.orgnName}"/>
						</c:catch>
					</td>
				</tr>
	    		<tr>
	    			<th>所属单位：</th>
	    			<td>
	    				<c:catch>
	    					<c:if test="${item.unit.id eq 0}">
								<%=StringParam.PROJECT_NAME %>
							</c:if>
		    				<c:out value="${item.unit.orgnName}"/>
	    				</c:catch>
	    			</td>
	    		</tr>
				<tr>
					<th>名称：</th>
	    			<td>
	    				<input type="text" id="organ.orgnName" name="organ.orgnName" value="${item.orgnName }" class="easyui-validatebox" required="true" maxlength="50" style="width:150px"/>
	    			</td>
	    		</tr>
	    		<tr>
					<th>编号：</th>
	    			<td>
	    				<c:if test="${item.isRoot eq 0}">
		    				<input type="text" id="organ.orgnNo" name="organ.orgnNo" value="${ fn:contains(item.orgnNo,item.parentNo) ? fn:substringAfter(item.orgnNo,item.parentNo) : item.orgnNo }" class="easyui-validatebox" validType="exist['${path }/base/organ!noExist.qt?pNo=${item.parentNo }&type=${fn:contains(item.orgnNo,item.parentNo) }&chkAccess=${param.chkAccess }','${ fn:contains(item.orgnNo,item.parentNo) ? fn:substringAfter(item.orgnNo,item.parentNo) : item.orgnNo }']" required="true" maxlength="${ fn:contains(item.orgnNo,item.parentNo) ? 2 : fn:length(item.orgnNo) }" style="width:150px"/>
	    				</c:if>
	    				<c:if test="${item.isRoot eq 1}">
	    					<input type="hidden" name="organ.orgnNo" value="${ fn:contains(item.orgnNo,item.parentNo) ? fn:substringAfter(item.orgnNo,item.parentNo) : item.orgnNo }" />
	    					<c:out value="${item.orgnNo}"/>
	    				</c:if>
	    			</td>
	    		</tr>
	    		<tr>
					<th>层级：</th>
	    			<td>
	    				<input type="text" id="organ.sortNo" name="organ.sortNo" value="${item.sortNo }" class="easyui-numberbox" precision="0" required="true" style="width:150px"/>
	    			</td>
	    		</tr>
	    		<tr style="display:none;">
	    			<th>优先级：</th>
	    			<td>
	    				<select id="organ.precedence" name="organ.precedence" style="width:150px"><c:forEach var="level" begin="1" end="10">
				            <option value="${level }" <c:if test="${item.precedence eq level }">selected="selected"</c:if>>${level }</option></c:forEach>
			            </select>
	    			</td>
	    		</tr>
	    		<tr style="display:none;">
	    			<th>类别：</th>
	    			<td>
						<input type="radio" id="organ.isUnit1" name="organ.isUnit" value="1" disabled="disabled" <c:if test="${item.isUnit eq 1 }">checked="checked"</c:if>>
						<label for="organ.isUnit1">单位</label>
	    				<input type="radio" id="organ.isUnit" name="organ.isUnit" value="0" disabled="disabled" <c:if test="${item.isUnit eq 0 }">checked="checked"</c:if>>
	    				<label for="organ.isUnit">部门</label>
	    			</td>
	    		</tr>
	    		<tr style="display:none;">
	    			<th>查看级别：</th>
	    			<td><c:set var="levelMap" value="只能查看自己"/>
	    				<select id="organ.seeLevel" name="organ.seeLevel" style="width:150px;<c:if test="${item.isUnit ne 1 }">display:none</c:if>" defaultValue="${item.seeLevel }" class="easyui-validatebox" required="true"><c:forEach var="level" begin="0" end="10">
				            <option value="${level }" <c:if test="${item.seeLevel eq level }">selected="selected"</c:if>><c:out value="${level eq 0 ? levelMap : level}"/></option></c:forEach>
			            </select><c:if test="${item.isUnit ne 1 }">
			            <div id="organ.seeLevel.info" style="color:red">部门不需要设置查看级别！</div></c:if>
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