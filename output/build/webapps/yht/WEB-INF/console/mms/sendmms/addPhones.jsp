<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/include/include.jsp"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
  	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>彩信号码粘贴</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
	<style>
		body{text-align: center;background-color: #ffffff;}
		.desc{width: 90%;height: 25px;line-height: 25px;margin: 0px auto;text-align: left;font-family: 宋体;font-size: 12px;}
		.textarea{width: 90%;border: 1px solid #aaaaaa;overflow: auto;overflow-y: auto;margin: 0px auto;}
		
		.butContent{width: 100%;height: 25px;margin: 2px auto;}
		.button{width: 60px;text-align: center;height: 22px;line-height: 22px;border: 1px solid #aaaaaa;font-family: 宋体;font-size: 12px;cursor: pointer;background-color: #c3fdf8;}
		span{color: blue;font-weight: bold;}
	</style>
	
	<script>
		var reg = /^(13[0-9]|15[0-9]|18[0-9])\d{8}$/;//验证手机号
		$(document).ready(function(){
			
		});
		
		function checkPhones(){
			$('#phones').attr('readonly','readonly');
			$('#ok').attr('disabled','disabled');
		
			var phonesTxt = $('#phones').val();
			var phones = phonesTxt.replace('，',',').replace(/\s+/g,',').split(',');
			$('#phones').val('');
			var phone = "";
			for(var i=0;i<phones.length;i++){
				phone = phones[i];
				if(phone.trim() != "" && reg.test(phone.trim()) && $('#phones').val().indexOf(phone.trim())==-1){
					if($('#phones').val()!='') $('#phones').val($('#phones').val()+',');
					$('#phones').val($('#phones').val()+phone.trim());
				}
			}
			if($('#phones').val()!=''){
				$('#submit').removeAttr('disabled');
				$('#back').removeAttr('disabled');
				$('#total').html('共'+$('#phones').val().split(',').length+'个号码');
			}else{
				alert('去除不规范和重复的号码后，号码为空，确认后重新填写！');
				$('#phones').removeAttr('readonly');
				$('#ok').removeAttr('disabled');
			}
		}
		
		function backInput(){
			$('#phones').removeAttr('readonly');
			$('#ok').removeAttr('disabled');
			$('#submit').attr('disabled','disabled');
			$('#back').attr('disabled','disabled');
		}
		
		function submitForm(){
			parent.win.refreshParent(''+$('#phones').val());
		}
	</script>
  </head>
  
  <body>
  		<form id="phoneForm" action="" method="post">
  			<div class="desc">请将要复制粘贴的号码填入到下面的文本框中！</div>
  			<div class="desc">(<font color="red">注意</font>：1、每行一个号码，或者号码与号码之间以逗号、空格分隔！)</div>
  			<div class="desc">(<font color="red">注意</font>：2、确定后会去除不规范和重复的号码！)<span id="total"></span></div>
  			<textarea id="phones" rows="12" cols="" class="textarea"></textarea>
  			<div class="butContent">
  				<input type="button" id="ok" value="确定" title="确定并验证手机号码" onclick="checkPhones()" class="button"/>
  				<input type="button" id="submit" value="提交" title="提交到彩信页面" onclick="submitForm()" disabled="disabled" class="button" />
  				<input type="button" id="back" value="返回" title="返回输入状态" onclick="backInput()" disabled="disabled" class="button" />
  			</div>
  		</form>
  </body>
</html>
