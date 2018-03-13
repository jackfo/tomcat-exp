<%@ page language="java" pageEncoding="UTF-8"%>
<%@ taglib uri="/struts-tags" prefix="s"%>
<%@ include file="/include/include.jsp" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
	<head>
		<title>动态登录</title>
		<meta http-equiv="pragma" content="no-cache">
		<meta http-equiv="cache-control" content="no-cache">
		<meta http-equiv="expires" content="0">
		<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
		<meta http-equiv="description" content="This is my page">
		<style type="text/css">
			html{height:100%}
			*{margin:0px;padding:0px;}
			a:link,a:visited,a:active,a:hover{hide-focus:expression(this.hideFocus=true);color:#333333;text-decoration: none;}
			
			body{background:url(${path}/images/reLogin.jpg) no-repeat center;}
			
			#container{position:absolute;top:50%;left:50%;text-align:center;margin-top: -120px;margin-left: -155px;}
			
			#loginForm{margin:0px auto;width:400px;height:200px;}
			#loginForm table{width: 100%;font-size: 14px;}
			#loginForm td{height:35px;color:#333333;vertical-align: middle;font-size: 14px;}
			#loginForm td label{color:#ffffff;}
			#loginForm td input{height:22px;font-size:16px;letter-spacing:1px;border: 1px solid #1096fd;text-align: center;padding-top: 1px;}
			#loginForm .submit{float: left;height:30px;font-size: 14px;line-height:30px;width:88px;overflow:hidden;background:url(${path}/images/login-submit-button.gif) 0px 0px no-repeat;}
			#loginForm .reset{float: right;font-size: 14px;margin-left:0px;height:30px;line-height:30px;width:88px;overflow:hidden;background:url(${path}/images/login-reset-button.gif) 0px 0px no-repeat;}
			
			#copyright{margin-top:75px;text-align:center;color:#fff;line-height:20px;}
			#copyright a{color:#fff;text-decoration:underline;}
			#copyright a:hover{text-decoration:none;}
			a{color:#fff;text-decoration:underline;}
			a:hover{text-decoration:none;color: blue;}
		</style>
		<!--[if IE 6]>
		<script src="${path}/js/DD_belatedPNG.js" mce_src="${path}/js/DD_belatedPNG.js"></script>
		<script type="text/javascript">
			DD_belatedPNG.fix('#comLogo,#comName');/* 将 .png_bg 改成你应用了透明PNG的CSS选择器,例如我例子中的'.trans'*/
		</script>
		<![endif]-->
		<script type="text/javascript">
			jQuery(document).ready(function(){
				$('#login_password').focus();
				setTimeout("displayTry()",10000);
			});
			function formSubmit(){
				var password = $('#login_password');
				if(jQuery.trim(password.val())==''){
					alert('动态验证码不能为空！');
					password.focus();
					return;
				}
				$('#loginForm form').submit();
			}
			function ShowEnterKey(event){
				if(event.keyCode==13)formSubmit();
			}
			
			
			function retry(){
				if(confirm('确定要重发动态密码吗?')){
					$('#retryCode').css('display','none');
					return true;
				}else{
					return false;
				}
			}
			
			function displayTry(){
				$('#retryCode').css('display','block');
			}
		</script>
	</head>
	<body onkeydown="ShowEnterKey(event)">
		<div id="container">
			<div id="loginForm">
			<form name="newForm" action="${path }/base/account!login.qt?logintype=db" method="post" onsubmit="return check()">
				<input type="hidden" name="operator.id" value="${Operator.id }"/>
				<table align="left" style="table-layout: fixed;" border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td width="60">
							账&nbsp;&nbsp;&nbsp;&nbsp;号：
						</td>
						<td style="text-align: center;width: 235px;">	
							${Operator.userName }
						</td>
						<td>&nbsp;</td>
					</tr>
					<tr>
						<td>
							验证码：
						</td>
						<td>
							<input id="login_password" name="operator.twoPass" value="" style="width:230px;" maxlength="6"/>
						</td>
						<td style="padding-top: 12px;"><a id="retryCode" href="<%=request.getContextPath()%>/base/account!retryDCode.qt?id=${Operator.id }" onclick="retry();" style="display: none;">重发动态密码</a>&nbsp;</td>
					</tr>
					<tr>
						<td colspan="3" align="center"><c:if test="${!empty msg}">
							<font color='red' style="font-size:9pt;">信息提示： ${msg }</font></c:if>
						</td>
					</tr>
					<tr>
						<td>&nbsp;</td>
						<td align="center">
							<a href="javascript:formSubmit()" class="submit" onmouseover="this.style.color='white'" onmouseout="this.style.color='black'">登 录</a>
							<a href="javascript:document.forms.newForm.reset()" class="reset">重 置</a>
						</td>
						<td>&nbsp;</td>
					</tr>
				</table>
			</form>
			</div>
			<!-- 
			<div id="copyright">技术支持：武汉商秦软件有限公司  Copyright &copy; 版权所有2010 - 2012</div>
			 -->
		</div>
	</body>
</html>
