<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/include/include.jsp"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
  	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>彩信预览</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
	<style>
		.leftMM{width: 100%;height: 100%;;margin:0px;background: url(${path}/images/phonebg.jpg) no-repeat center top;text-align: center;overflow: hidden;}
		.leftMM .leftMM0{width: 120px;height: 90px;margin: 0px auto 0px auto;padding: 0px;}
		.leftMM .leftMM1{width: 120px;height: 80px;margin: 5px auto 7px auto;border: 1px solid #cccccc;}
		.leftMM .leftMM2{width: 120px;height: 65px;margin: 5px auto 7px auto;text-align: left;word-break:break-all;word-wrap: break-word;overflow-y: auto;}
		.leftMM .leftMM3{width: 70%;height: 25px;margin: 20px auto 10px auto;color: #ffffff;}
	</style>
	
	<script>
		var parNum=1;
		var parJson;
		$(document).ready(function(){
			parJson = eval("${parJson}");
			viewMms(0);
		})
		
		//调换当前帧的 图片与文本 的上下关系
		function changeType(type){
			if(type==1){
				if($('div[class=leftMM2]').next($('div')).attr('class')=='leftMM1'){
					$('div[class=leftMM1]').after($('div[class=leftMM2]'));
				}
			}
			if(type==2){
				if($('div[class=leftMM1]').next($('div')).attr('class')=='leftMM2'){
					$('div[class=leftMM2]').after($('div[class=leftMM1]'));
				}
			}
		}
		
		//上一帧
		function prevPar(){
			if(parseInt($('#pageNum').html())>1){
				showPar(parseInt($('#pageNum').html())-2);
			}
		}
		
		//下一帧
		function nextPar(){
			if(parseInt($('#pageNum').html())<parJson.length){
				showPar(parseInt($('#pageNum').html()));
			}
		}
		
		//第一帧
		function firstPar(){
			showPar(0);
		}
		
		//最后一帧
		function lastPar(){
			showPar(parJson.length-1);
		}

		//调整当前显示第n帧（n从0开始，是数组的下标）
		function showPar(n){
			if(n >= 0 && parJson.length > 0 && n < parJson.length){
				var par = parJson[n];
				
				$('input[name=parDur]').val(par.dur);
				changeType(par.region);
				
				$('div[class=leftMM1]:first').empty();
				if(par.picture.path != ''){
					$('div[class=leftMM1]:first').html('<img name="pic" src="'+CONTEXT_PATH+'/fileDo?random='+getRandomNum()+'&filePath='+par.picture.path+'" style="width: 100%;height: 100%;" />');
				}
				
				$('div[class=leftMM2]').html(par.phrase);
				
				$('#pageNum').html(n+1);
				$('#pageTotalNum').html(parseInt(parJson.length));
			}
		}
		
		//彩信预览
		function viewMms(n){
			showPar(n);
			if((n+1)<parJson.length){
				setTimeout('viewMms('+(n+1)+')',(parJson[n].dur) * 1000);
			}else{
				setTimeout('viewMms(0)',(parJson[n].dur) * 1000);				
			}
		}

	</script>
  </head>
  
  <body style="width: 100%;height: 100%;overflow: hidden;">
		<div class="leftMM">
			<div class="leftMM0"></div>
			<div class="leftMM1"></div>
			<div class="leftMM2"></div>
			<div class="leftMM3">
				<img src="${path }/images/mm1.gif" onclick="firstPar()" title="第一帧" style="width: 18px;height: 23px;vertical-align: top;margin: 0px 1px;"/>
				<img src="${path }/images/mm2.gif" onclick="prevPar()" title="上一帧" style="width: 18px;height: 23px;vertical-align: top;margin: 0px 1px;"/>
				<img src="${path }/images/mm3.gif" onclick="nextPar()" title="下一帧" style="width: 18px;height: 23px;vertical-align: top;margin: 0px 1px;"/>
				<img src="${path }/images/mm4.gif" onclick="lastPar()" title="最后帧" style="width: 18px;height: 23px;vertical-align: top;margin: 0px 1px;"/>
				<font id="pageNum" color="#ffffff">1</font>/<font id="pageTotalNum" color="#ffffff">1</font>帧
			</div>
		</div>
  </body>
</html>
