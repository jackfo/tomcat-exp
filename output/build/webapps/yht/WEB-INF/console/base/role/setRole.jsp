<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/include/include.jsp"%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>新增角色</title>
	<link rel="stylesheet" type="text/css" href="${path }/css/buttonPanel.css">
	<script type="text/javascript">
		var roleTree;
		jQuery(document).ready(function(){
			$('#roleTreeDIV').height(document.body.clientHeight-$('.buttonPanel').height()-8);
			roleTree = $('#roleTree').tree({
				checkbox: true,
				url: '${path}/base/menu!roleList.qt?rid=${param.roleId}&chkAccess='+encodeURIComponent('${param.chkAccess}')+'&random='+getRandomNum(),
				onClick:function(node){
					$(this).tree('toggle', node.target);
				},
				onBeforeExpand:function(node){
					if(node.attributes.isRoot=='1'){
						roleTree.tree('options').url = '${path}/base/menu!roleList.qt?rid=${param.roleId}&chkAccess='+encodeURIComponent('${param.chkAccess}')+'&random='+getRandomNum();
					}else{
						roleTree.tree('options').url = '${path}/base/menu!btnRoleList.qt?rid=${param.roleId}&chkAccess='+encodeURIComponent('${param.chkAccess}')+'&random='+getRandomNum();
					}
				},
				onExpand:function(node){
					if(node&&node.checked){
						var nodes = $(this).tree('getChildren',node.target);
						jQuery.each(nodes,function(i,el){
							if(el.attributes.mark=='QUERY'){
								$('#roleTree').tree('check',el.target);
								return false;
							}
						});
					}
				}
			});
		});
		function submitForm(el){
			var array = roleTree.tree('getAllNode');
			var length = array.length;
			var str = "";
			for(var i=0; i < length; i++){
				var node = array[i];
				str += ","+node.id+"-"+(node.attributes.isMenu?1:0)+"-"+(node.checked?1:0);
			}
			str = str.replace(/(^[,]*)|([,]*$)/ig,"");
			$(el).linkbutton({disabled:true})
			jQuery.ajax({
				async: false,
				type: "POST",
				url: '${path}/base/role!authorize.qt?roleId=${param.roleId}',
				data: 'role='+str+'&chkAccess='+encodeURIComponent('${param.chkAccess}'),
				success: function(data){
					try{
						var obj = eval(data);
						if(obj.b){
							if(parent&&parent.win) parent.win.hide();
						}else{
							parent.jQuery.messager.alert('错误','<br/>保存失败！','error');
							$(el).linkbutton({disabled:false});
						}
					}catch(e){
						$(el).linkbutton({disabled:false});
						parent.jQuery.messager.alert('错误',e.message+'<br/><br/>保存失败！','error');
					}
				}
			});
		}
	</script>
</head>
<body>
	<div id="roleTreeDIV" style="height:200px;overflow-y:auto;">
		<ul id="roleTree" style="margin:5px"></ul>
	</div>
	<div class="buttonPanel" style="border:0px;border-top:1px solid #CCCCCC;">
		<div class="datagrid-btn-separator" style="visibility:hidden;"></div>
		<a href="#" onclick="submitForm(this)" class="easyui-linkbutton" plain="false" iconCls="icon-save" style="margin-right:10px">保存</a>
		<div class="clear"></div>
	</div>
</body>
</html>