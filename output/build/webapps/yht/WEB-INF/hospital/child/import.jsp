<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/include/include.jsp"%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>导入儿童</title>
<style type="text/css">
	body{padding:10px;background:#fafafa;overflow:hidden;}
	th{width:80px;height:30px;line-height:30px;text-align:right;font-size:9pt;font-weight:normal;}
	td{height:30px;line-height:30px;font-size:9pt;}
</style>
<script type="text/javascript" src="${path }/js/bgshade/jQuery_plug_bgshade.js"></script>
	<script type="text/javascript">
		jQuery(document).ready(function(){
				if('${importResult}'){ 		//后台返回json结果 {b:true,num:count} {b:false,message:msg}
					var str = '${importResult}';
					var obj = eval('(' + str + ')');   
					if(obj.b){
						shadeDivHandle(true,'共成功导入【'+obj.num+'】条记录！');
						window.setTimeout(function(){ parent.win.refreshParent();},1000);
					}else{
						shadeDivHandle(true,obj.message+'请重新上传！');
					}
				}
		});
		/**
		表单提交
		**/
		function submitForm(el){
			if($(el).linkbutton('options').disabled) return;
				var file = document.forms.newForm.upload.value;
				if(0>file.indexOf('.')){
					parent.jQuery.messager.alert('错误','对不起！<br/><br/>请选择正确的文件！','error');
				}else if(!/.+(.xls$)/.test(file)){
					parent.jQuery.messager.alert('错误','对不起！<br/><br/>只能上传97-2003版Excel文件！','error');
				}else{
					shadeDivHandle(true,"正在导入中...");
					document.forms.newForm.submit();
					$(el).linkbutton({disabled:true});
				}
		}
		/**
		重置
		**/
		function reset(){
			newForm.reset();
		}
		
		/**
		信息提示块
		**/
		function shadeDivHandle(b,msg){
			if(b){
				$(document.body).bgshade(msg);
			}else{
				$(document.body).bgshade(false);
			}
		}
	</script>
	</head>
	<body>
		<form id="newForm" name="newForm" action="${path }/hospital/child!childImport.qt?chkAccess=${param.chkAccess}" method="POST" enctype="multipart/form-data">
			<input type="hidden" name="chkAccess" value="${param.chkAccess }">
			<table style="width:100%;table-layout:fixed;" border="0" cellpadding="0" cellspacing="0">
	    		<tr>
	    			<th>选择文件：</th>
	    			<td>
	    				<input type="file" name="upload" class="easyui-validatebox" required="true" style="width: 90%;border: 1px solid #aaaaaa;">
	    			</td>
	    		</tr>
	    		<tr>
	    			<th>模板下载：</th>
	    			<td height="50px;">
						<p style="margin:0px;padding:0px;margin-bottom:10px;text-align:center;">
							<a title="点击下载" href="${path }/uploadTemplate?name=ChildImport.xls" style="text-decoration:underline;font-size: 18px;color: red;">点击下载儿童导入模板</a>
						</p>
					</td>
	    		</tr>
	    		<tr>
	    			<th>导入提示：</th>
	    			<td height="50px;">
						<p>
						上传文件不能为空，最大10M<br/>
						上传的文件只能是97-2003版Excel
						</p><br/><br/>
					</td>
	    		</tr>
	    		<tr>
	    			<td colspan="2" align="center" height="40" valign="bottom">
	    				<a href="#" onclick="submitForm(this);" class="easyui-linkbutton" plain="false" iconCls="icon-save" style="margin-right:10px">上传</a>
	    				<a href="javascript:reset();" class="easyui-linkbutton" plain="false" iconCls="icon-remove">取消</a>
	    			</td>
	    		</tr>
	    	</table>
	    </form>
	</body>
</html>