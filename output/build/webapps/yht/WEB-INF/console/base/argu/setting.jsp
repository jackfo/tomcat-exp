<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/include/include.jsp"%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>修改参数数值</title>
<style type="text/css">
	body{padding:10px;background:#fafafa;overflow:hidden;}
	table{border-left: 1px solid #bbbbbb;border-top: 1px solid #bbbbbb;}
	th{width:80px;height:30px;line-height:30px;text-align:right;font-size:9pt;font-weight:normal;border-bottom: 1px solid #bbbbbb;border-right: 1px solid #bbbbbb;}
	td{height:30px;line-height:30px;font-size:9pt;border-bottom: 1px solid #bbbbbb;border-right: 1px solid #bbbbbb;}
</style>
	<script type="text/javascript">
		function submitForm(el){
			$('#newForm').form('submit',{
				url:'${path}/base/argu!modifyVal.qt?chkAccess=${param.chkAccess}&random='+getRandomNum(),
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
			<input type="hidden" name="argument.id" value="${item.id }">
			<table style="width:100%;table-layout:fixed;" border="0" cellpadding="0" cellspacing="0">
	    		<tr>
	    			<th>参数名称：</th>
	    			<td>
	    				${item.arguName }
	    			</td>
	    		</tr>
				<tr>
					<th>参数数值：</th>
					<c:if test="${item.arguType != 2}">
		    			<td>
		    				<c:if test="${item.arguType == 0 }">
		    					<input type="radio" name="argument.arguValue" value="1" <c:if test="${item.arguValue==1 }">checked="checked"</c:if>/>启用 &nbsp; &nbsp;
		    					<input type="radio" name="argument.arguValue" value="0" <c:if test="${item.arguValue==0 }">checked="checked"</c:if>/>禁用
		    				</c:if>
		    				<c:if test="${item.arguType == 1 }">
		    					<input name="argument.arguValue" id="arguValue" value="${item.arguValue }" class="easyui-validatebox" required="true" style="width:95%"/>
		    				</c:if>
		    				<c:if test="${item.arguType == 3 || item.arguType == 4}">
		    					<input name="argument.arguValue" id="arguValue" value="${item.arguValue }" class="easyui-validatebox" validType="number" style="width:95%"/>
		    				</c:if>
		    				<c:if test="${item.arguType == 5 || item.arguType == 6}">
		    					<input name="argument.arguValue" id="arguValue" value="${item.arguValue }" class="easyui-validatebox" validType="number" style="width:95%"/>
		    				</c:if>
		    				<c:if test="${item.arguType == 7 }">
		    					<input name="argument.arguValue" id="arguValue" value="${item.arguValue }" class="easyui-validatebox" required="true" methodType="chooseDate{dateFmt:'${item.arguFormat }'}" style="width:95%"/>
		    				</c:if>
		    			</td>
					</c:if>
					<c:if test="${item.arguType == 2}">
						<td style="height: 85px;">
							<textarea rows="5" cols="" name="argument.arguValue" id="arguValue" class="easyui-validatebox" required="true" style="width: 100%;border: 1px solid #aaaaaa;overflow-y: auto;">${item.arguValue }</textarea>
						</td>
					</c:if>
	    		</tr>
				<tr>
					<th>参数描述：</th>
	    			<td style="height: 85px;">
	    				${item.arguDesc }&nbsp;
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