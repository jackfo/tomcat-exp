<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/include/include.jsp"%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>新增</title>
	<style type="text/css">
		body{padding:10px;background:#fafafa;overflow:hidden;}
		th{width:100px;height:35px;line-height:35px;text-align:right;font-size:9pt;font-weight:normal;}
		td{height:35px;line-height:35px;font-size:9pt;}
	</style>
	<script type="text/javascript">
		var exceTest = false;
		function submitForm(el){
			$('#newForm').form('submit',{
				url:'${path}/db/conn!newAdd.qt?chkAccess=${param.chkAccess}&random='+getRandomNum(),
				onSubmit:function(){
					if(!exceTest){
						parent.jQuery.messager.alert('提示','请先测试连接，单击Test按钮！','info');
						return false;
					}
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
		function testConn(){
			var driver = $('#diver').val();
			var ip = $('#ip').val();
			var port = $('#port').val();
			var db = $('#db').val();
			var user = jQuery.trim(document.getElementById('connection.user').value);
			var pass = jQuery.trim(document.getElementById('connection.pass').value);
			
			var str = eval(driver);
			var clazz = '', url = '', did='0';
			if(str&&str.length>2){
				did = str[0];
				clazz = jQuery.trim(str[1]);
				url = jQuery.trim(str[2].replace('[IP]',ip).replace('[PORT]',port).replace('[DB]',db));
			}
			var param = 'clazz='+encodeURIComponent(clazz)+'&';
			param += 'url='+encodeURIComponent(url)+'&';
			param += 'user='+encodeURIComponent(user)+'&';
			param += 'pass='+encodeURIComponent(pass)+'&';
			
			jQuery.ajax({
				async: true,
				type: "GET",
				url: '${path}/db/conn!test.qt?chkAccess=${param.chkAccess}&random='+getRandomNum(),
				data: param,
				success: function(data){
					exceTest = true;
					try{
						var obj=eval(data);
						if(obj.b){
							document.getElementById('connection.clazz').value=clazz;
							document.getElementById('connection.url').value=url;
							document.getElementById('connection.driver.id').value=did;
							parent.jQuery.messager.alert('提示','连接成功！','info');
						}else parent.jQuery.messager.alert('错误',obj.desc,'error');
					}catch(e){}
				}
			});
		}
	</script>
	</head>
	<body>
		<form id="newForm" name="newForm" method="post">
			<input type="hidden" name="chkAccess" value="${param.chkAccess }">
			<input type="hidden" id="connection.clazz" name="connection.clazz">
			<input type="hidden" id="connection.url" name="connection.url">
			<input type="hidden" id="connection.driver.id" name="connection.driver.id" value="0">
			<table style="width:100%;table-layout:fixed;" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<th>名称：</th>
					<td>
						<input type="text" id="connection.name" name="connection.name" class="easyui-validatebox" validType="exist['${path }/db/conn!isExist.qt?chkAccess=${param.chkAccess}','','^[.\\-\\w\\u4E00-\\u9FA5]+$']" required="true" maxlength="50" style="width:70%;"/>
					</td>
				</tr>
				<tr>
					<th>数据库驱动：</th>
	    			<td>
						<select id="diver" style="width:70%;"><c:forEach var="driver" items="${drivers }">
							<option value="['${driver.id }','${driver.clazz }','${driver.url }']">${driver.name }</option></c:forEach>
						</select>
	    			</td>
	    		</tr>
	    		<tr>
	    			<th>服务器地址[IP]：</th>
	    			<td>
	    				<input type="text" id="ip" style="width:70%;"/>
	    			</td>
	    		</tr>
	    		<tr>
	    			<th>端口[PORT]：</th>
	    			<td>
	    				<input type="text" id="port" style="width:70%;"/>
	    			</td>
	    		</tr>
	    		<tr>
	    			<th>数据库名[DB]：</th>
	    			<td>
	    				<input type="text" id="db" style="width:70%;"/>
	    			</td>
	    		</tr>
	    		<tr>
					<th>用户名：</th>
	    			<td>
	    				<input type="text" id="connection.user" name="connection.user" class="easyui-validatebox" maxlength="100" style="width:70%;"/>
	    			</td>
	    		</tr>
	    		<tr>
					<th>密码：</th>
	    			<td>
	    				<input type="text" id="connection.pass" name="connection.pass" class="easyui-validatebox" maxlength="100" style="width:70%;"/>
	    			</td>
	    		</tr>
	    		<tr>
	    			<td colspan="2" style="height:1%;line-height:20px;padding-top:5px;">
	    				<ul>
	    					<li>名称只能是中文、字母、数字、“_”、“-”及“.”且不能与系统中的重复</li>
	    					<li>用户名及密码为登录数据库的用户名及密码</li>
	    					<li style="color:red">请保存前先进行测试是否连接成功，请单击Test按钮</li>
	    				</ul>
	    			</td>
	    		</tr>
	    		<tr>
	    			<td colspan="2" align="center" height="40" valign="bottom">
	    				<a href="#" onclick="testConn()" class="easyui-linkbutton" plain="false" iconCls="icon-reload" style="margin-right:10px">Test</a>
	    				<a href="#" onclick="submitForm(this);" class="easyui-linkbutton" plain="false" iconCls="icon-save" style="margin-right:10px">保存</a>
	    				<a href="javascript:reset();" class="easyui-linkbutton" plain="false" iconCls="icon-remove">重置</a>
	    			</td>
	    		</tr>
	    	</table>
	    </form>
	</body>
</html>