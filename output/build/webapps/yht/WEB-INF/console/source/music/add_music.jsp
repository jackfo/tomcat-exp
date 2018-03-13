<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/include/include.jsp"%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>新增彩信音乐素材</title>
<style type="text/css">
	body{padding:10px;background:#fafafa;overflow:hidden;}
	th{width:80px;height:30px;line-height:30px;text-align:right;font-size:9pt;font-weight:normal;}
	td{height:30px;line-height:30px;font-size:9pt;}
</style>
	<script type="text/javascript">
		function submitForm(el){
		
		if(""== document.getElementById("mmMusicBean.mmMusicTypeId").value){
			parent.jQuery.messager.alert('错误','请选择音乐类型！','error');
			return;
		}
	
		document.getElementById("mmMusicBean.mmMusicTypeId").select;
		var file = document.forms.newForm.upload.value;
		var fileName = file.substring(file.lastIndexOf("\\")+1,file.length);
		$("input[name=mmMusicBean.musicByName]").val(fileName);
		if(0>file.indexOf('.')){
			parent.jQuery.messager.alert('错误','对不起！<br/><br/>请选择正确的音乐！','error');
			$("#upload").select(); 
			return;
		}else if(!/\.(amr|wma|wav)$/.test(file)) {//判断音乐类型
			parent.jQuery.messager.alert('错误',"音乐格式必须是wma,amr,wav",'error')
		  	$("#upload").select(); 
		  	return;
		 }else{
		 		$('#newForm').form('submit',{
				url:'${path}/source/mmMusicBean!newAdd.qt?chkAccess=${param.chkAccess}&random='+getRandomNum(),
				onSubmit:function(){
					var b = $(this).form('validate');
					if(b) $(el).linkbutton({disabled:true});
					return b;
				},
				success:function(data){
					$(el).linkbutton({disabled:false});
				
						var obj = eval(data);
						if(obj.b){
							if(parent&&parent.win) parent.win.refreshParent();
						}else parent.jQuery.messager.alert('错误','<br/>保存失败！','error');
				
				},
				onLoadError:function(e){
					$(el).linkbutton({disabled:false});
					parent.jQuery.messager.alert('错误',e.message+'<br/><br/>保存失败！','error');
				}
			});
		 }

		
		
		}
		function reset(){
			newForm.reset();
		}
		
		function refresh(obj){
			if(obj){
				if(!obj.b){
					parent.jQuery.messager.alert('错误',obj.message+'<br/><br/>请重新上传！','error');
				}
			}else{
				parent.jQuery.messager.alert('错误','上传错误！<br/><br/>请重新上传！','error');
			}
		}
	</script>
	</head>
	<body>
		<form id="newForm" name="newForm" method="post" enctype="multipart/form-data">
			<input type="hidden" name="chkAccess" value="${param.chkAccess }">
			<input type="hidden" name="mmMusicBean.musicByName" value="">
			<table style="width:100%;table-layout:fixed;" border="0" cellpadding="0" cellspacing="0">
				<tr>
	    			<th style="width:100">自定义音乐名称：</th>
	    			<td>
	    				<input id="mmMusicBean.musicNewName" name="mmMusicBean.musicNewName" class="easyui-validatebox" required="true"  maxlength="15" style="width:200px;"/>
	    			</td>
	    		</tr>
	    		<tr>
	    			<th style="width:100">音乐类型：</th>
	    			<td>
	    				<select id="mmMusicBean.mmMusicTypeId" name="mmMusicBean.mmMusicTypeId">
	    					<option value="">==请选择音乐类型==</option>
							<c:forEach var="mList" items="${mmMusicTypeBeanList}">
	            			<option value="${mList.musicTypeId}">${mList.musicTypeName }</option>
	           				</c:forEach>
	    				</select>
	    			</td>
	    		</tr>
	    		<tr>
	    			<th style="width:100">选择音乐：</th>
	    			<td>
	    				<input type="file" id="upload" name="upload" class="easyui-validatebox" required="true" style="width:265px;"/>
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