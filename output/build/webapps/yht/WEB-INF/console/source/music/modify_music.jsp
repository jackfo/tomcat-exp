<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/include/include.jsp"%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>修改彩信音乐素材</title>
<style type="text/css">
	body{padding:10px;background:#fafafa;overflow:hidden;}
	th{width:80px;height:30px;line-height:30px;text-align:right;font-size:9pt;font-weight:normal;}
	td{height:30px;line-height:30px;font-size:9pt;}
</style>
	<script type="text/javascript">
		$(document).ready(function(){
			document.body.style.overflow = 'scroll';//页面显示滚动条;
		});
		function submitForm(el){
	 		$('#newForm').form('submit',{
			url:'${path}/source/mmMusicBean!modify.qt?chkAccess=${param.chkAccess}&random='+getRandomNum(),
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
		<form id="newForm" name="newForm" method="post" enctype="multipart/form-data">
			<input type="hidden" name="chkAccess" value="${param.chkAccess }">
			<input type="hidden" name="mmMusicBean.id" value="${mmMusicBean.id}">
			<table style="width:100%;table-layout:fixed;" border="0" cellpadding="0" cellspacing="0">
				<tr>
	    			<th style="width:100">自定义音乐名称：</th>
	    			<td>
	    				<input id="mmMusicBean.musicNewName" name="mmMusicBean.musicNewName" value="${mmMusicBean.musicNewName }" class="easyui-validatebox" required="true"  maxlength="15" style="width:200px;"/>
	    			</td>
	    		</tr>
	    		<tr>
	    			<th style="width:100">音乐类型：</th>
	    			<td>
	    				<select id="mmMusicBean.mmMusicTypeId" name="mmMusicBean.mmMusicTypeId">
	    					<c:forEach var="mList" items="${mmMusicTypeBeanList}">
	    					<c:choose>
	    						<c:when test="${mList.musicTypeId==mmMusicBean.mmMusicTypeId}">
	    							<option value="${mList.musicTypeId}" selected="selected">${mList.musicTypeName }</option>
	    						</c:when>
	    						<c:otherwise>
	    							<option value="${mList.musicTypeId}">${mList.musicTypeName }</option>
	    						</c:otherwise>
	    					</c:choose>
	           				</c:forEach>
	    				</select>
	    			</td>
	    		</tr>
	    		<tr>
	    			<th style="width:100">原音乐名称：</th>
	    			<td>
	    				${mmMusicBean.musicByName}
	    			</td>
	    		</tr>
	    		<tr>
	    			<th style="width:200px;height:150px">音乐预览：</th>
	    			<td>
	    				<embed type="audio/mpeg" src="${path }/fileDo?filePath=${targetDirectory}" volume="0" autostart="false" loop="-1" style="width:300px;height:45px"/>
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