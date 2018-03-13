<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<%@ include file="/include/include.jsp" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>登录</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<style type="text/css">
			html{height:100%}
			*{margin:0px;padding:0px;}
			a:link,a:visited,a:active,a:hover{hide-focus:expression(this.hideFocus=true);color:#333333;text-decoration: none;}
			
			body{background:url(${path}/images/login_bj.jpg) no-repeat center;}
			
			#container{position:absolute;top:54%;left:50%;text-align:center;margin-top: -80px;margin-left: 30px;}
			
			#loginForm{margin:0px auto;width:360px;height:240px;}
			#loginForm table{}
			#loginForm td{height:34px;color:#333333}
			#loginForm td label{color:#034494;}
			#loginForm td input{height:22px;font-size:16px;letter-spacing:1px;}
			#loginForm .submit{display:inline-block;height:56px;margin-left: 28;-margin-left: 0;margin-top: 30%;line-height:56px;width:59px;overflow:hidden;background:url(${path}/images/login-button.gif) 0px 0px no-repeat;}
			#loginForm .reset{display:inline-block;margin-left:40px;height:24px;line-height:26px;width:70px;overflow:hidden;background:url(${path}/images/login-reset-button.jpg) 0px 0px no-repeat;}
			
			#copyright{position: absolute;left: 51%;top: 50%;margin-top: 200px;text-align:center;line-height:20px;color: #FFFFFF;width: 500px;margin-left: -250px;}
			#copyright a{text-decoration:underline;color: #FFFFFF;}
			#copyright a:hover{text-decoration:none;}
		</style>
		<!--[if IE 6]>
		<script src="${path}/js/DD_belatedPNG.js" mce_src="${path}/js/DD_belatedPNG.js"></script>
		<script type="text/javascript">
			DD_belatedPNG.fix('#comLogo,#comName');/* 将 .png_bg 改成你应用了透明PNG的CSS选择器,例如我例子中的'.trans'*/
		</script>
		<![endif]-->
		<script type="text/javascript">
			jQuery(document).ready(function(){
				$('#login_form_account').focus();
			});
			function formSubmit(){
				var account = $('#login_form_account');
				if(jQuery.trim(account.val())==''){
					alert('账号不能为空！');
					account.focus();
					return;
				}
				var password = $('#login_form_password');
				if(jQuery.trim(password.val())==''){
					alert('密码不能为空！');
					password.focus();
					return;
				}
				var code = $('#dyImg');
				if(jQuery.trim(code.val())==''){
					alert('验证码不能为空！');
					code.focus();
					return;
				}
				$('#loginForm form').submit();
			}
			function ShowEnterKey(event){
				if(event.keyCode==13)formSubmit();
			}
		</script>
	</head>
	<body onkeydown="ShowEnterKey(event)">
		<div id="container">
			<div id="loginForm">
				<form name="newForm" action="${path }/base/account!login.qt" method="post">
					<table align="right" style="float: left;" border="0" cellpadding="0" cellspacing="0">
						<tr>
							<td width="60">
								<label for="login_form_account">账&nbsp;&nbsp;&nbsp;&nbsp;号：</label>
							</td>
							<td>	
								<input type="text" id="login_form_account" name="operator.account" value="${operator.account }" style="width:180px;"/>
							</td>
						</tr>
						<tr>
							<td>
								<label for="login_form_password">密&nbsp;&nbsp;&nbsp;&nbsp;码：</label>
							</td>
							<td>
								<input type="password" id="login_form_password" name="operator.password" value="${operator.password }" style="width:180px;"/>
							</td>
						</tr>
						<tr>
							<td>
								<label>验证码：</label>
							</td>
							<td valign="middle">
								<input type="text" id="dyImg" name="checkCode" style="width:100px;" maxlength="4"/>
								<img src="${path }/dyCodeImg.qt" onclick="this.src='${path }/dyCodeImg.qt?date='+new Date()" alt="如看不清楚,请点击此图。" style="vertical-align:bottom;width: 75px"/>
							</td>
						</tr>
						<tr>
							<td colspan="2" align="center"><c:if test="${!empty msg}">
								<font color='red' style="font-size:9pt;">信息提示： ${msg }</font></c:if>
							</td>
						</tr>
					</table>
					<table>
						<tr>
							<td colspan="2" align="center">
								<a href="javascript:formSubmit()" class="submit"></a>
								<!-- <a href="javascript:document.forms.newForm.reset()" class="reset"></a> -->
							</td>
						</tr>
					</table>
				</form>
			</div>
		</div>
		<div id="copyright">技术支持：武汉商秦软件有限公司  Copyright &copy; 版权所有2010 - 2012</div>
	</body>
</html>