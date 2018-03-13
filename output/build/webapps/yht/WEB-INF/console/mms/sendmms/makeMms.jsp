<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/include/include.jsp"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
  	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>制作彩信</title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
	<style>
		.leftMM{float: left;width: 220px;margin: 10px 0px 0px 0px;background: url(${path}/images/phonebg.jpg) no-repeat center top;text-align: center;overflow: hidden;}
		.rightInfo{float: left;height: 360px;width: 250px;margin: 5px 0px;overflow: hidden;}
		
		.leftMM .leftMM0{width: 120px;height: 90px;margin: 0px auto 0px auto;padding: 0px;}
		.leftMM .leftMM1{width: 120px;height: 80px;margin: 5px auto 7px auto;border: 1px solid #cccccc;}
		.leftMM .leftMM2{width: 120px;height: 65px;margin: 5px auto 7px auto;text-align: left;word-break:break-all;word-wrap: break-word;overflow-y: auto;}
		.leftMM .leftMM3{width: 70%;height: 25px;margin: 20px auto 10px auto;color: #ffffff;}
		.leftMM .leftMM4{width: 90%;height: 25px;margin: 30px auto 10px auto;}
		.leftMM .leftMM5{width: 90%;height: 20px;margin: 5px auto 10px auto;line-height: 20px;}
		.td1{width: 70px;text-align: center;}
		
		.mmContent{width: 248px;width: 100%\9;height: 302px;background-color: #ECF2F9;border: 1px solid #cccccc;margin-top: 10px;overflow: hidden;}
		.mmContent .mmContent-title{width: 100%;height: 23px;height: 25px\9;background-color: #EDF4FE;border-bottom: 1px solid #cccccc;margin: 0px;overflow: hidden;}
		.mmContent .mmContent-title .title-left{height: 23px;height: 25px\9;line-height: 25px;float: left;margin-left: 5px;}
		.mmContent .mmContent-title .title-right{height: 23px;height: 25px\9;line-height: 25px;float: right;margin-right: 5px;cursor: pointer;}
		.button{}
	</style>
	
	<script>
		var parNum=1;
		var tId=0;
		var parJson = [];
		for(var i=0;i< parent.parentJson.length;i++){
			parJson.push(parent.parentJson[i]);
		}
		$(document).ready(function(){
			$('#mmPicFrame').height(document.body.clientHeight-55);
			$('#mmMusicFrame').height(document.body.clientHeight-55);
			$('#mmPhraseFrame').height(document.body.clientHeight-55);
			$('#mmPicFrame').attr('src','${path}/source/mmPicBean!chooseMmPic.qt?random='+getRandomNum()+'&chkAccess='+encodeURIComponent('${param.chkAccess}'));
			if(parJson.length>1){
				for(var i=2;i<=parJson.length;i++){
					$('select[name=parSel]').append('<option value="'+i+'">第 '+i+' 帧</option>');
				}
			}
			showPar(0);
		})
		
		//添加一个空帧,并显示当前的空帧，最多9帧
		function addPar(){
			checkPars();
			if(parJson.length<9){
				if($('div[name=mmMusic]').html()!='' || $('div[name=picture]').html()!='' || $('textarea[name=mmWord]').text()!=''){
					parNum = parJson.length + 1;
					var newPar = {'sort':parNum,'dur':2,'region':1,'picture':{'id':'','name':'','path':''},'music':{'id':'','name':'','path':''},'phrase':''};
					parJson.push(newPar);
					$('select[name=parSel]').append('<option selected="selected" value="'+parNum+'">第 '+parNum+' 帧</option>');
					showPar(parNum - 1);
				}else{
					jQuery.messager.alert('错误','<br/>图片、文字内容、背景音乐必须有一个不为空！','error');
				}
			}else{
				jQuery.messager.alert('错误','<br/>彩信最多可编辑9帧，不能再添加帧了！','error');
			}
		}
		
		//调换当前帧的 图片与文本 的上下关系
		function changeType(type){
			if(type==1){
				if($('div[class=leftMM2]').next($('div')).attr('class')=='leftMM1'){
					$('div[class=leftMM1]').after($('div[class=leftMM2]'));
				}
				if($('#tr3').next('tr').attr('id')=='tr2'){
					$('#tr2').after($('#tr3'));
				}
			}
			if(type==2){
				if($('div[class=leftMM1]').next($('div')).attr('class')=='leftMM2'){
					$('div[class=leftMM2]').after($('div[class=leftMM1]'));
				}
				if($('#tr2').next('tr').attr('id')=='tr3'){
					$('#tr3').after($('#tr2'));
				}
			}
		}
				
		//用下拉框来切换帧
		function changePar(obj){
			showPar($(obj).val()-1);
		}
		
		//上一帧
		function prevPar(){
			if(parseInt($('#pageNo').html())>1){
				showPar(parseInt($('#pageNo').html())-2);
			}
		}
		
		//下一帧
		function nextPar(){
			if(parseInt($('#pageNo').html())<parJson.length){
				showPar(parseInt($('#pageNo').html()));
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
				
				$('div[name=picture]:first').empty();
				$('div[class=leftMM1]:first').empty();
				if(par.picture.path != ''){
					$('div[name=picture]:first').html('<img name="pic" src="'+CONTEXT_PATH+'/fileDo?random='+getRandomNum()+'&filePath='+par.picture.path+'" style="width: 100%;height: 100%;" />');
					$('div[class=leftMM1]:first').html('<img name="pic" src="'+CONTEXT_PATH+'/fileDo?random='+getRandomNum()+'&filePath='+par.picture.path+'" style="width: 100%;height: 100%;" />');
				}
				
				$('textarea[name=mmWord]').val(par.phrase);
				$('div[class=leftMM2]').html(par.phrase);
				
				$('div[name=mmMusic]:first').html(''+par.music.name);
				
				$('#pageNo').html(n+1);
				$('#pageTotal').html(parseInt(parJson.length));
				$('#pageNum').html(n+1);
				$('#pageTotalNum').html(parseInt(parJson.length));
				
				$('select[name=parSel] option').each(function(i,obj){
					if($(obj).attr('value')==(n+1)){
						$(obj).attr('selected','selected');	
					}else{
						$(obj).removeAttr('selected');
					}
				});
			}
		}
				
		//删除当前帧
		function deletePar(){
			var n = parseInt($('#pageNo').html())-1;
			var temp = parJson;
			if(n >= 0 && parJson.length > 1){
				parJson = temp.slice(0,n).concat(temp.slice(n+1,temp.length));
				$('select[name=parSel] option:last').remove();
				if(n < parJson.length){
					showPar(n);
				}else{
					showPar(parJson.length - 1);
				}
			}else{
				jQuery.messager.alert('错误','<br/>不能进行删除了，至少要保留一帧！','error');
			}
		}
		
		//删除指定帧
		function delPar(n){
			var temp = parJson;
			if(n >= 0 && parJson.length > 1){
				parJson = temp.slice(0,n).concat(temp.slice(n+1,temp.length));
				$('select[name=parSel] option:last').remove();
				if(n < parJson.length){
					showPar(n);
				}else{
					showPar(parJson.length - 1);
				}
			}
		}
		
		//删除当前帧的图片
		function deletePic(obj){
			$(obj).prev('div').empty();
			$('div[class=leftMM1]').empty();
			parJson[parseInt($('#pageNo').html())-1].picture.id='';
			parJson[parseInt($('#pageNo').html())-1].picture.name='';
			parJson[parseInt($('#pageNo').html())-1].picture.path='';
		}
		
		//删除当前帧的音乐
		function deleteMusic(obj){
			$(obj).prev('div').empty();
			parJson[parseInt($('#pageNo').html())-1].picture.id='';
			parJson[parseInt($('#pageNo').html())-1].picture.name='';
			parJson[parseInt($('#pageNo').html())-1].picture.path='';
		}
		
		//调换当前帧的 图片与 文本的上下位置
		function changeModel(obj){
			parJson[$('#pageNo').html()-1].region=$(obj).val();
			changeType($(obj).val());
		}
		
		//修改当前帧的间隔时间
		function setParDur(obj){
			parJson[$('#pageNo').html()-1].dur=$(obj).val();
		}
		
		//查询音乐素材 与 短语模板素材
		function search(obj){
			var p = $('#tabs').tabs("getSelected");
			if($(p).children('iframe').attr('name')=='mmPicFrame'){
				if($('#mmPicFrame').attr('src')==null || $('#mmPicFrame').attr('src')==''){
					$('#mmPicFrame').attr('src','${path}/source/mmPicBean!chooseMmPic.qt?random='+getRandomNum()+'&chkAccess='+encodeURIComponent('${param.chkAccess}'));
				}
			}
			if($(p).children('iframe').attr('name')=='mmMusicFrame'){
				if($('#mmMusicFrame').attr('src')==null || $('#mmMusicFrame').attr('src')==''){
					$('#mmMusicFrame').attr('src','${path}/source/mmMusicBean!chooseMmMusic.qt?random='+getRandomNum()+'&chkAccess='+encodeURIComponent('${param.chkAccess}'));
				}
			}
			if($(p).children('iframe').attr('name')=='mmPhraseFrame'){
				if($('#mmPhraseFrame').attr('src')==null || $('#mmPhraseFrame').attr('src')==''){
					$('#mmPhraseFrame').attr('src','${path}/base/param!choosemmPhrase.qt?mark=SMS_T&random='+getRandomNum()+'&chkAccess='+encodeURIComponent('${param.chkAccess}'));
				}
			}
		}
		
		//彩信预览
		function viewMms(n){
			checkPars();
			showPar(n);
			if((n+1)<parJson.length){
				setTimeout('viewMms('+(n+1)+')',(parJson[n].dur) * 1000);
			}
		}
		
		//提交彩信编辑内容
		function submitForm(){
			checkPars();
			if(parJson.length > 1){
				parent.win.refreshParent(parJson);
			}else if(parJson.length <= 1){
				var par = parJson[0];
				if(par.picture.path=='' && par.music.path=='' && par.phrase==''){
					jQuery.messager.alert('错误','<br/>请制作完彩信再提交！','error');
				}else{
					parent.win.refreshParent(parJson);
				}
			}
		}
		
		//保存至彩信模板
		function saveTemplate(){
			checkPars();
			if(parJson.length > 1){
				save(tId);
			}else if(parJson.length <= 1){
				var par = parJson[0];
				if(par.picture.path=='' && par.music.path=='' && par.phrase==''){
					jQuery.messager.alert('错误','<br/>请制作完彩信再保存至模板！','error');
				}else{
					save(tId);
				}
			}
		}
		
		//保存至彩信模板
		function save(tId){
			var json = obj2Str(parJson);
			jQuery.messager.confirm('提示','确定要保存至模板吗？',function(b){
				if(b){
					$.ajax({
						type: "POST",
						url: "${path}/mms/template!saveToTemplate.qt?chkAccess=${fs:chkAccess(param.mid,'TEMPSUB')}&random="+getRandomNum(),
					  	data: "tId="+tId+"&parJson="+json,
					  	success: function(data){
					  		var obj = eval(data);
							if(obj.b){
					    		jQuery.messager.alert('提示','<br/>彩信模板保存成功！','info');
					    	}
					  	}
					}); 
				}
			});
		}
		
		//重置彩信内容
		function resetForm(){
			parJson = [];
			for(var i=0;i< parent.parentJson.length;i++){
				parJson.push(parent.parentJson[i]);
			}
			showPar(0);
		}
		
		//验证每一帧是否有空帧
		function checkPars(){
			var temp;
			for(var i=0;i<parJson.length;i++){
				if(parJson[i].picture.path=='' && parJson[i].music.path=='' && parJson[i].phrase==''){
					delPar(i);
				}
			}
		}
		
		//检验当前文本框中文本的字数，并填写当前帧的文本内容
		function LimitTextArea(field){ 
	    	maxlimit=500;
	    	if (field.value.length > maxlimit){
	    		field.value = field.value.substring(0, maxlimit);
	        }
    		$('div[class=leftMM2]:first').html(field.value);
    		parJson[parseInt($('#pageNo').html())-1].phrase=field.value;
	    }

	</script>
  </head>
  
  <body>
	<div class="easyui-layout" style="width:100%;height:100%;">
		<div region="center" title="彩信编辑区" style="background:#ffffff;">
			<form name="mmForm" action="">
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
					<div class="leftMM4">
						<input type="button" name="" value="预览" onclick="viewMms(0)" style="width: 60px;margin-right: 20px;border: 1px solid #8A93BE;text-align: center;background-color: #E7EEFE;cursor: pointer;" onmouseover="$(this).css('color','red')" onmouseout="$(this).css('color','black')"/>
					</div>
				</div>
				<div class="rightInfo">
					<div>
						<img src="${path }/images/leftPage.gif" title="上一帧" onclick="prevPar()" style="width: 16px;height: 19px;vertical-align: middle;cursor: pointer;"/>
						<select name="parSel" onchange="changePar(this)" style="width: 80px;height: 19px;vertical-align: middle;">
							<option value="1">第 1 帧</option>
						</select>
						<img src="${path }/images/rightPage.gif" title="下一帧" onclick="nextPar()" style="width: 15px;height: 19px;vertical-align: middle;cursor: pointer;"/>
						<input type="button" name="" onclick="addPar()" value="增加一帧" style="width: 80px;margin-right: 20px;border: 1px solid #8A93BE;text-align: center;background-color: #E7EEFE;cursor: pointer;vertical-align: middle;" onmouseover="$(this).css('color','red')" onmouseout="$(this).css('color','black')"/>
					</div>
					<div class="mmContent">
						<div class="mmContent-title">
							<div class="title-left">第<font id="pageNo" color="red">1</font>帧，共<font id="pageTotal" color="red">1</font> 帧</div> 
							<div class="title-right" onclick="deletePar()" onmouseover="$(this).css('color','red')" onmouseout="$(this).css('color','black')">删除该帧</div> 
						</div>
						<table name="mmTable" style="width: 100%;table-layout: fixed;">
							<tr id="tr1">
								<td class="td1">播放时间：</td>
								<td>
									<input name="parDur" value="2" onchange="setParDur(this)" style="width: 60px;margin-right: 15px;text-align: center;" class="easyui-validatebox" required="true" validType="number" maxlength="3" />
									<select name="" style="width: 80px;" onchange="changeModel(this)">
										<option value="1" >图上文下</option>
										<option value="2" >图下文上</option>
									</select>
								</td>
							</tr>
							<tr id="tr2">
								<td class="td1">图片信息：</td>
								<td>
									<div style="width: 95%;height: 118px;height: 120px\9;border: 1px solid #cccccc;background-color: #FFFFFF;">
										<div name="picture" style="float: left;width: 116px;width: 125px\9;height: 103px;height: 110px\9;border: 1px solid #eeeeee;margin: 5px 2px 0px 5px;-margin-left: 2px;-margin-right: 1px;"></div>
										<div name="" onclick="deletePic(this)" style="float: right;height: 25px;line-height: 25px;margin: 95px 2px 0px 0px;-margin-right: 1px;cursor: pointer;" onmouseover="$(this).css('color','red')" onmouseout="$(this).css('color','black')">删除</div>
									</div>
								</td>
							</tr>
							<tr id="tr3">
								<td class="td1">文字内容：</td>
								<td>
									<textarea name="mmWord" rows="5" cols="" maxlength="5" style="width: 95%;background-color: #FFFFFF;overflow-y: auto;border: 1px solid #cccccc;" onchange="LimitTextArea(this)" onKeyDown="LimitTextArea(this)" onKeyUp="LimitTextArea(this)" onkeypress="LimitTextArea(this)" onblur="LimitTextArea(this)" onfocus="LimitTextArea(this)"></textarea>
								</td>
							</tr>
							<tr id="tr4">
								<td class="td1">背景音乐：</td>
								<td>
									<div style="width: 95%;height: 23px;height: 25px\9;border: 1px solid #cccccc;background-color: #FFFFFF;overflow: hidden;">
										<div name="mmMusic" style="float: left;width: 126px;height: 17px;height: 19px\9;border: 1px solid #eeeeee;margin: 2px;-margin: 1px;overflow: hidden;"></div>
										<div name="" onclick="deleteMusic(this)" style="float: right;height: 21px;height: 25px\9;line-height: 25px;margin: 0px 2px 0px 0px;-margin-right: 1px;cursor: pointer;" onmouseover="$(this).css('color','red')" onmouseout="$(this).css('color','black')">删除</div>
									</div>
								</td>
							</tr>
						</table>
					</div>
					<div><font color="red"><b>注意</b></font>：每帧文字内容最多500字，上限9帧！</div>
				</div>
				<div style="clear: both;"></div>
				<div style="width: 100%;text-align: center;border-top: 1px dotted #aaaaaa;">
					<input type="button" name="" value="提交" onclick="submitForm()" style="width: 80px;border: 1px solid #8A93BE;text-align: center;background-color: #E7EEFE;cursor: pointer;margin-top: 6px;" onmouseover="$(this).css('color','red')" onmouseout="$(this).css('color','black')"/>&nbsp;&nbsp;
					<!-- 
					<input type="button" name="" value="重置" onclick="resetForm()" style="width: 80px;border: 1px solid #8A93BE;text-align: center;background-color: #E7EEFE;cursor: pointer;margin-top: 6px;" onmouseover="$(this).css('color','red')" onmouseout="$(this).css('color','black')"/>&nbsp;&nbsp;
					 -->
					<input type="button" name="" value="保存为模板" onclick="saveTemplate()" style="width: 80px;border: 1px solid #8A93BE;text-align: center;background-color: #E7EEFE;cursor: pointer;margin-top: 6px;" onmouseover="$(this).css('color','red')" onmouseout="$(this).css('color','black')"/>
				</div>
			</form>
		</div>
		<div region="east" split="true" title="彩信资源库" style="width:250px;">
			<div class="easyui-accordion" fit="true">
				<div id="tabs" class="easyui-tabs" fit="true" border="false" onclick="search(this)">
					<div title="图片选择" closable="false" >
						<iframe id="mmPicFrame" name="mmPicFrame" scrolling="auto" frameborder="0" style="width: 100%;height: 100%;" src="${path}/source/mmPicBean!chooseMmPic.qt?chkAccess=${param.chkAccess}"></iframe>
					</div>
					<div title="音乐选择" closable="false" >
						<iframe id="mmMusicFrame" name="mmMusicFrame" scrolling="auto" frameborder="0" style="width: 100%;height: 100%;"></iframe>
					</div>
					<div title="短语选择" closable="false" >
						<iframe id="mmPhraseFrame" name="mmPhraseFrame" scrolling="auto" frameborder="0" style="width: 100%;height: 100%;"></iframe>
					</div>
				</div>
			</div>
		</div>
	</div>
  </body>
</html>
