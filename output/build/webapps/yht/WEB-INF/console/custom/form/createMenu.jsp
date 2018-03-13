<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/include/include.jsp"%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>生成菜单</title>
	<style type="text/css">
		body{padding:10px;background:#fafafa;}
		th{width:100px;height:35px;line-height:35px;text-align:right;font-size:9pt;font-weight:normal;}
		td{height:35px;line-height:35px;font-size:9pt;}
		ol{list-style:none;margin:0px;padding:0px;}
		ol li{margin:0px;padding:0px;height:25px;line-height:25px;}
		ol li label{cursor:pointer;}
	</style>
	<script type="text/javascript">
		function submitForm(el){
			$('#newForm').form('submit',{
				url:'${path}/custom/form!saveMenu.qt?chkAccess=${param.chkAccess}&random='+getRandomNum(),
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
			<input type="hidden" name="chkAccess" value="${param.chkAccess }"/>
			<input type="hidden" name="ids" value="${param.id }"/>
			<table style="width:100%;table-layout:fixed;" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td>
						请选择创建菜单至：
					</td>
					<td width="100"></td>
				</tr>
				<tr>
					<td style="height:1%">
						<ol><c:forEach var="item" items="${menus}" varStatus="s">
							<li>
								<input type="radio" id="menuId.${item.id }" name="menuId" value="${item.id }"/>
								<label for="menuId.${item.id }">${item.menuName }</label>
							</li></c:forEach>
						</ol>
					</td>
					<td>
						<a href="#" onclick="submitForm(this);" class="easyui-linkbutton" plain="false" iconCls="icon-save" style="margin-right:10px">保存</a>
					</td>
				</tr>
	    	</table>
	    </form>
	</body>
</html>