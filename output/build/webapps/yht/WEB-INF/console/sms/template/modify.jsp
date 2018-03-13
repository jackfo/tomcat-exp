<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/include/include.jsp"%><%@
	taglib prefix="ft" uri="http://www.flagsky.com/functions" %>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>修改模板</title>
		<style type="text/css">
			body{padding:10px;background:#fafafa;overflow:hidden;}
			th{width:80px;height:35px;line-height:35px;text-align:right;font-size:9pt;font-weight:normal;}
			td{height:35px;line-height:35px;font-size:9pt;}
		</style>
		<script type="text/javascript">
			jQuery(document).ready(function(){
				var type = document.getElementById('template.param.id');
				if(type) $(type).change(typeChange).change();
			});
			function typeChange(){
				var obj = $(this);
				var content = $('#keyContent');
				if(0<content.find('.keyButtonPanel_'+obj.val()).length){
					content.find('.keyButtonPanel').hide();
					content.find('.keyButtonPanel_'+obj.val()).show();
					return;
				}
				var desc = obj.children('option:selected').attr('desc');
				if(typeof(desc)!='string'||desc=='')return;
				jQuery.getJSON('${path}/sms/template!getKeyForObject.qt?random='+getRandomNum(),{chkAccess:'${param.chkAccess }','desc':desc},function(str){
					if(str.b){
						content.find('.keyButtonPanel').hide();
						var panel = jQuery('<div class="keyButtonPanel keyButtonPanel_'+obj.val()+'" style="float:right;width:200px;height:145px;height:140px\\9;overflow-y:auto;"></div>').appendTo(content);
						jQuery.each(str.desc,function(i,item){
							if(typeof(item.split)=='undefined')jQuery('<a href="javascript:insert(\''+item.key+'\')" style="'+(i%2==0?'float:left;':'float:right;')+'margin:3px 3px 1px 5px;padding:3px;white-space:nowrap;text-align:center;border:2px ridge #999;background:#f5f5f5"'+(typeof(item.title)!='undefined'?'title="'+item.title+'"':'')+'>'+item.name+'</a>').appendTo(panel);
							if(i%2!=0) jQuery('<div style="clear:both;"></div>').appendTo(panel);
						});
					}
				});
			}
			function insert(myValue) {
				var myField = document.getElementById('template.content');
				insertAtCursor(myField,myValue);
				myField.focus();
			}
			function submitForm(el){
				if($(el).linkbutton('options').disabled) return;
				$('#newForm').form('submit',{
					url:'${path}/sms/template!modify.qt?random='+getRandomNum(),
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
			<input type="hidden" name="template.id" value="${item.id }"/>
			<input type="hidden" name="template.mark" value="${item.mark }">
			<input type="hidden" name="template.droped" value="${item.droped }">
			<table style="width:100%;table-layout:fixed;" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<th>分类：</th>
					<td>
						<select id="template.param.id" name="template.param.id" style="width:150px"<c:catch><c:if test="${item.param.droped ne 1 }"> disabled="disabled"</c:if></c:catch>><c:forEach var="p" items="${params}">
							<option value="${p.id}"<c:if test="${p.droped ne 1 }"> desc="${ft:replaceAll(p.desc,'[\\n\\r]','') }"</c:if><c:if test="${item.param.id eq p.id }"> selected="selected"</c:if>><c:out value="${p.name}"/></option></c:forEach>
						</select>
					</td>
	    		</tr>
	    		<tr>
	    			<th style="height:1%;" valign="top">模板内容：</th>
	    			<td id="keyContent" style="line-height:150%;">
	    				<textarea id="template.content" name="template.content" rows="9" style="float:left;width:280px" class="easyui-validatebox" validType="filterWord[0,300]" required="true"><c:out value="${item.content}"/></textarea>
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