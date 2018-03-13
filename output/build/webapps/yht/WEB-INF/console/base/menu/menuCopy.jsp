<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/include/include.jsp"%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>菜单复制</title>
		<style type="text/css">
			body{padding:10px;background:#fafafa;overflow:hidden;}
			th{width:80px;height:30px;line-height:30px;font-size:14px;font-weight:normal;border-left: 1px solid #cccccc;border-top: 1px solid #cccccc;}
			td{height:25px;line-height:25px;font-size:12px;border-left: 1px solid #cccccc;border-top: 1px solid #cccccc;}
			.title{width: 100%;text-align: center;height: 45px;line-height: 45px;font-size: 22px;font-family: 黑体;}
			.titleTd{text-align: center;background-color: #eeeeee;}
			.titleInfo{height: 25px;line-height: 25px;padding-left: 30px;font-weight: bold;color: red;}
		</style>
		<script type="text/javascript">
			function submitForm(el){
				$('#newForm').form('submit',{
					url:'${path}/base/menu!menuCopy.qt?random='+getRandomNum(),
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
			
			<div class="title">菜单复制</div>
			<hr/>
			<table style="width:100%;table-layout:fixed;border-bottom: 1px solid #cccccc;border-right: 1px solid #cccccc;" border="0" cellpadding="0" cellspacing="0">
				<thead>
					<tr>
						<th style="width: 10%;text-align: center;font-weight: bold;">栏目</th>
						<th style="width: 30%;text-align: center;font-weight: bold;">源菜单</th>
						<th style="width: 60%;text-align: center;font-weight: bold;">复制菜单</th>
					</tr>
				</thead>
				<tbody>
					<tr>
		    			<td colspan="3" class="titleInfo">1.菜单信息</td>
		    		</tr>
					<tr>
						<td class="titleTd">父&nbsp;&nbsp;菜&nbsp;&nbsp;单</td>
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
						<td>
							<select id="menu.parent.id" name="menu.parent.id" style="width: 70%;">
								<c:forEach var="menu" items="${menuList}" varStatus="s">
									<option value="${menu.id }" <c:if test="${menu.id == item.parent.id}">selected="selected"</c:if>>${menu.menuName }</option>
								</c:forEach>
							</select>
						</td>
					</tr>
					<tr>
						<td class="titleTd">菜单名称</td>
		    			<td>
		    				${item.menuName }
		    			</td>
		    			<td>
							<input type="text" id="menu.menuName" name="menu.menuName" value="${item.menuName }" class="easyui-validatebox" required="true" maxlength="50" style="width:70%;"/>
						</td>
		    		</tr>
		    		<tr>
		    			<td class="titleTd">URL</td>
		    			<td>
		    				${item.menuUrl }
		    			</td>
		    			<td>
		    				<input type="text" id="menu.menuUrl" name="menu.menuUrl" value="${item.menuUrl }" maxlength="200" style="width:70%;"/>
		    			</td>
		    		</tr>
		    		<tr>
		    			<td class="titleTd">优&nbsp;&nbsp;先&nbsp;&nbsp;级</td>
		    			<td>${item.precedence}</td>
		    			<td>
		    				<select id="menu.precedence" name="menu.precedence" style="width:70%;">
			    				<c:forEach var="level" begin="${(item.precedence-5)>0?(item.precedence-5):1}" end="${item.precedence + 5}">
						            <option value="${level }" <c:if test="${item.precedence + 1 eq level }">selected="selected"</c:if>>${level }</option>
					            </c:forEach>
				            </select>
		    			</td>
		    		</tr>
		    		<tr>
		    			<td class="titleTd">状&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;态</td>
		    			<td><c:if test="${item.status eq 1 }">启用</c:if><c:if test="${item.status ne 1 }">停用</c:if></td>
		    			<td>
							<input type="radio" id="menu.status" name="menu.status" value="1" <c:if test="${item.status eq 1 }">checked="checked"</c:if>>
							<label for="menu.status">启用</label>
		    				<input type="radio" id="menu.status" name="menu.status" value="0" <c:if test="${item.status ne 1 }">checked="checked"</c:if>>
		    				<label for="menu.status">停用</label>
		    			</td>
		    		</tr>
		    		<tr>
		    			<td colspan="3" class="titleInfo">2.按钮信息</td>
		    		</tr>
		    		<c:forEach var="but" items="${item.buttons}" varStatus="s">
			    		<tr>
							<c:if test="${s.index==0}"><td class="titleTd" rowspan="${fn:length(item.buttons)}">按钮列表</td></c:if>
			    			<td>
			    				<input type="checkbox" name="menuButton" value="${but.id }" checked="checked"/>${but.buttonName }[<font color="blue">${but.buttonMark }</font>]
			    			</td>
			    			<td>
								<input name="accessRes${but.id }" value="${but.accessRes }" style="width: 80%;" class="easyui-validatebox" validType="length[0,1000]"/>
							</td>
			    		</tr>
		    		</c:forEach>
	    		</tbody>
	    		<tfoot>
		    		<tr>
		    			<td colspan="3" align="center" height="40" valign="bottom">
		    				<a href="#" onclick="submitForm(this)" class="easyui-linkbutton" plain="false" iconCls="icon-save" style="margin-right:10px">保存</a>
		    				<a href="javascript:reset();" class="easyui-linkbutton" plain="false" iconCls="icon-remove">重置</a>
		    			</td>
		    		</tr>
	    		</tfoot>
	    	</table>
	    </form>
	</body>
</html>