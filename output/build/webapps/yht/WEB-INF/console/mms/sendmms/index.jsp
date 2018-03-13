<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/include/include.jsp"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
  	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title></title>
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
	<style>
		.leftMM{float: left;width: 220px;margin: 10px 0px 0px 0px;height: 400px;background: url(${path}/images/phonebg.jpg) no-repeat center top;text-align: center;overflow: hidden;}
		.rightInfo{float: left;height: 380px;width: 310px;margin: 10px 0px;overflow: hidden;}
		
		.leftMM .leftMM0{width: 120px;height: 90px;margin: 0px auto 0px auto;padding: 0px;}
		.leftMM .leftMM1{width: 120px;height: 80px;margin: 5px auto 7px auto;border: 1px solid #cccccc;}
		.leftMM .leftMM2{width: 120px;height: 65px;margin: 5px auto 7px auto;text-align: left;word-break:break-all;word-wrap: break-word;overflow-y: auto;}
		.leftMM .leftMM3{width: 70%;height: 25px;margin: 20px auto 10px auto;color: #ffffff;}
		.leftMM .leftMM4{width: 90%;height: 25px;margin: 30px auto 10px auto;}
		.leftMM .leftMM5{width: 90%;height: 20px;margin: 5px auto 10px auto;line-height: 20px;}
		.mmTable{width: 100%;}
		.mmTable .td1{width: 100%;width: 60px;text-align: center;}
	</style>
		
	<script>
		var parentJson;
		var win; 
		$(document).ready(function(){
			getColorStyle();
			win = new Jwindow();
			$('#operatorFrame').height(document.body.clientHeight-55);
		//	$('#personFrame').height(document.body.clientHeight-55);
			$('#addressBookFrame').height(document.body.clientHeight-55);
			$('#operatorFrame').attr('src','${path}/mms/mmSend!listOperator.qt?random='+getRandomNum()+'&chkAccess=${fs:chkAccess(param.mid,"QUERY")}');
		});
		
		//查询彩信人员库
		function search(){
			var p = $('#tabs').tabs("getSelected");
			if($(p).children('iframe').attr('name')=='operatorFrame'){
				if($('#operatorFrame').attr('src')==null || $('#operatorFrame').attr('src')==''){
					$('#operatorFrame').attr('src','${path}/mms/mmSend!listOperator.qt?random='+getRandomNum()+'&chkAccess=${fs:chkAccess(param.mid,"QUERY")}');
				}
			}
			/*
			if($(p).children('iframe').attr('name')=='personFrame'){
				if($('#personFrame').attr('src')==null || $('#personFrame').attr('src')==''){
					$('#personFrame').attr('src','${path}/mms/mmSend!listPerson.qt?random='+getRandomNum()+'&chkAccess=${fs:chkAccess(param.mid,"QUERY")}');
				}
			}
			*/
			if($(p).children('iframe').attr('name')=='addressBookFrame'){
				if($('#addressBookFrame').attr('src')==null || $('#addressBookFrame').attr('src')==''){
					$('#addressBookFrame').attr('src','${path}/mms/mmSend!listAddressBook.qt?random='+getRandomNum()+'&chkAccess=${fs:chkAccess(param.mid,"QUERY")}');
				}
			}
		}
	
		//检查定时设置
		function checkSet(){
			if($('input[name=timeSet][checked=true]').val()==1){
				$('input[name=sendTime]').val('');
				$('input[name=sendTime]').css('display','none');				
			}else{
				$('input[name=sendTime]').css('display','block');							
			}
		}
		
		//添加一个手机号码
		function addPhone(){
			var phoneBox = $('input[type=text][name=phone]');
			var flag = false;
			$('select[name=receivePhones] option').each(function(i,obj){
				if($(obj).val()==$(phoneBox).val()){
					flag = true;
				}
			});
		//	alert(flag);
			if(/^(13[0-9]|15[0-9]|18[0-9])\d{8}$/.test($(phoneBox).val()) && flag==false){
				$('select[name=receivePhones]').append('<option value='+$(phoneBox).val()+'>'+$(phoneBox).val()+'</option>');
			}
		}
		
		//添加一组手机号码
		function addPhonesToSelect(phones){
			var oldPhones = '';
			$('select[name=receivePhones] option').each(function(i,obj){
				if(oldPhones != '') oldPhones += ',';
				oldPhones += $(obj).val();
			});
			var phoneArray = phones.split(',');
			for(var i=0;i<phoneArray.length;i++){
				if(oldPhones.indexOf(phoneArray[i])==-1 && /^(13[0-9]|15[0-9]|18[0-9])\d{8}$/.test(phoneArray[i])){
					$('select[name=receivePhones]').append('<option value='+phoneArray[i]+'>'+phoneArray[i]+'</option>');
					if(oldPhones != '') oldPhones += ',';
					oldPhones += phoneArray[i];
				}
			}
		}
		
		//移除所有号码
		function removeAllPhone(){
			$('select[name=receivePhones] option').remove();
		}
		//移除选中号码
		function removePhone(){
			$('select[name=receivePhones] option:selected').remove();
		}
		
		//新增制作彩信
		function addMms(){
			parentJson=[{'sort':1,'dur':2,'region':1,'picture':{'id':'','name':'','path':''},'music':{'id':'','name':'','path':''},'phrase':''}];
			win.show('制作彩信','${path}/mms/mmSend!preMakeMms.qt?random='+getRandomNum()+'&mid=${param.mid}&chkAccess=${fs:chkAccess(param.mid,"MAKEMMS")}',function(parJsonStr){
				var parJsonTemp = [];
				for(var i=0;i< parJsonStr.length;i++){
					parJsonTemp.push(parJsonStr[i]);
				}
				parentJson = parJsonTemp;
			//	alert(obj2Str(parentJson));
				$('#parJson').val(obj2Str(parentJson));
				$('input[type=button][name=edit]:first').removeAttr('disabled');
				showPar(0);
			});
			win.reSize(770,480);
		}
		
		//编辑已制作的彩信
		function editMms(){
		//	alert(parentJson.length);
			win.show('制作彩信','${path}/mms/mmSend!preMakeMms.qt?random='+getRandomNum()+'&mid=${param.mid}&chkAccess=${fs:chkAccess(param.mid,"MAKEMMS")}',function(parJsonStr){
				var parJsonTemp = [];
				for(var i=0;i< parJsonStr.length;i++){
					parJsonTemp.push(parJsonStr[i]);
				}
				parentJson = parJsonTemp;
			//	alert(obj2Str(parentJson));
				$('#parJson').val(obj2Str(parentJson));
				$('input[type=button][name=edit]:first').removeAttr('disabled');
				showPar(0);
			});
			win.reSize(770,480);
		}
		
		//从彩信模板中选择已有的彩信
		function chooseMmTemplate(){
			win.show('彩信模板选择','${path}/mms/mmSend!chooseMmTemplate.qt?random='+getRandomNum()+'&mid=${param.mid}&chkAccess=${fs:chkAccess(param.mid,"CHOTEMP")}',function(data){
				var mmData = eval(data);
				parentJson = mmData[0].parJson;
				$('#parJson').val(obj2Str(parentJson));
				$('input[type=button][name=edit]:first').removeAttr('disabled');
				showPar(0);
			});
			win.reSize('80%','80%');
		}
		
		//进入粘贴号码页面进行添加手机号码
		function addPhones(){
			win.show('号码粘贴','${path}/mms/mmSend!addPhones.qt?random='+getRandomNum()+'&chkAccess=${fs:chkAccess(param.mid,"MAKEMMS")}',function(phones){
				addPhonesToSelect(phones);
			});
			win.reSize(500,350);
		}
		
		//上一帧
		function prevPar(){
			if(parseInt($('#pageNo').html())>1){
				showPar(parseInt($('#pageNo').html())-2);
			}
		}
		
		//下一帧
		function nextPar(){
			if(parseInt($('#pageNo').html())<parentJson.length){
				showPar(parseInt($('#pageNo').html()));
			}
		}
		
		//第一帧
		function firstPar(){
			showPar(0);
		}
		
		//最后一帧
		function lastPar(){
			showPar(parentJson.length-1);
		}

		//调整当前显示第n帧（n从0开始，是数组的下标）
		function showPar(n){
			if(n >= 0 && parentJson.length > 0 && n < parentJson.length){
				var par = parentJson[n];
				
				changeType(par.region);
				$('div[class=leftMM1]:first').empty();
				if(par.picture.path != ''){
					$('div[class=leftMM1]:first').html('<img name="pic" src="'+CONTEXT_PATH+'/fileDo?random='+getRandomNum()+'&filePath='+par.picture.path+'" style="width: 100%;height: 100%;" />');
				}
				$('div[class=leftMM2]').html(par.phrase);
				
				$('#pageNo').html(n+1);
				$('#pageTotal').html(parseInt(parentJson.length));
			}
		}
		
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
		
		//提交表单
		function submitForm(el){
			$('form[name=mmForm]').form('submit',{
				url:'${path }/mms/mmSend!sendMms.qt?chkAccess=${fs:chkAccess(param.mid,'SENDMMS')}&random='+getRandomNum(),
				onSubmit:function(){
					var b = $(this).form('validate');
					if(b){
						if($('select[name=receivePhones]').text()!=''){
							if($('#parJson').val()!=''){
								$(el).linkbutton({disabled:true});
								$('#loading').css('display','block');
								$('select[name=receivePhones] option').attr('selected','true');
								return true;
							}else{
								jQuery.messager.alert('错误','<br/>请制作彩信！彩信内容不能为空！','error');
								return false;
							}
						}else{
							jQuery.messager.alert('错误','<br/>请添加手机号码！','error');
							return false;
						}
					}else{
						return false;
					}
				},
				success:function(data){
					$(el).linkbutton({disabled:false});
					$('#loading').css('display','none');
					try{
						var obj = eval(data);
						if(obj.b){
							if('${needAudit}'==2){
								parent.jQuery.messager.alert('成功','<br/>彩信发送成功!','info');
							}else{
								parent.jQuery.messager.alert('成功','<br/>彩信成功保存至发送任务中!','info');
							}
							reset();
						}else parent.jQuery.messager.alert('错误','<br/>发送失败！','error');
					}catch(e){parent.jQuery.messager.alert('错误',e.message+'<br/><br/>发送失败！','error');}
				},
				onLoadError:function(e){
					$('#loading').css('display','none');
					$(el).linkbutton({disabled:false});
					parent.jQuery.messager.alert('错误',e.message+'<br/><br/>发送失败！','error');
				}
			});
		}
		
		//重置页面
		function reset(){
			removeAllPhone();
			$('#parJson').val('');
			$('#loading').css('display','none');
			$('#pageTotal').val('1');
			$('div[class=leftMM1]:first').empty();
			$('div[class=leftMM2]').html('');
			mmForm.reset();
		}
	</script>
  </head>
  
  <body>
	<div class="easyui-layout" style="width:100%;height:100%;">
		<!-- 
		<div region="north" style="height:35px;background:#efefef;overflow:hidden;">
			<div class="inTitle">彩信发送</div>
		</div>
		 -->
		<div region="center" title="彩信编辑区" style="background:#ffffff;">
			<form name="mmForm" action="${path }/mms/mmSend!sendMms.qt?chkAccess=${fs:chkAccess(param.mid,'SENDMMS')}" method="post">
				<input type="hidden" id="parJson" name="parJson" value=""/>
				<div class="leftMM">
					<div class="leftMM0"></div>
					<div class="leftMM1"></div>
					<div class="leftMM2"></div>
					<div class="leftMM3">
						<img src="${path }/images/mm1.gif" onclick="firstPar()" title="第一帧" style="width: 18px;height: 23px;vertical-align: top;margin: 0px 1px;"/>
						<img src="${path }/images/mm2.gif" onclick="prevPar()" title="上一帧" style="width: 18px;height: 23px;vertical-align: top;margin: 0px 1px;"/>
						<img src="${path }/images/mm3.gif" onclick="nextPar()" title="下一帧" style="width: 18px;height: 23px;vertical-align: top;margin: 0px 1px;"/>
						<img src="${path }/images/mm4.gif" onclick="lastPar()" title="最后帧" style="width: 18px;height: 23px;vertical-align: top;margin: 0px 1px;"/>
						<font id="pageNo" color="#ffffff">1</font>/<font id="pageTotal" color="#ffffff">1</font>帧
					</div>
					<div class="leftMM4">
						<input type="button" name="add" value="制作彩信" onclick="addMms()" title="点击进行制作一个新的彩信" style="width: 60px;border: 1px solid #8A93BE;text-align: center;background-color: #E7EEFE;cursor: pointer;" onmouseover="$(this).css('color','red')" onmouseout="$(this).css('color','black')"/>
						<input type="button" name="edit" value="编辑彩信" onclick="editMms()" title="点击进行编辑当前已制作的彩信" disabled="disabled" style="width: 60px;border: 1px solid #8A93BE;text-align: center;background-color: #E7EEFE;cursor: pointer;" onmouseover="$(this).css('color','red')" onmouseout="$(this).css('color','black')"/>
						<input type="button" name="add" value="选择模板" onclick="chooseMmTemplate()" title="点击进行选择一个彩信模板" style="width: 60px;border: 1px solid #8A93BE;text-align: center;background-color: #E7EEFE;cursor: pointer;" onmouseover="$(this).css('color','red')" onmouseout="$(this).css('color','black')"/>
					</div>
					<div class="leftMM5"><!-- 彩信内容最大可输入100KB --></div>
				</div>
				<div id="rightInfo" class="rightInfo">
					<table border="0" cellpadding="0" cellspacing="0" class="mmTable">
						<tr>
							<td class="td1">标&nbsp;&nbsp;题：</td>
							<td><input type="text" name="title" value="" class="easyui-validatebox" required="true" maxlength="50" style="width: 100%;"/></td>
						</tr>
						<tr>
							<td class="td1" rowspan="2">收件人：</td>
							<td><input type="button" name="" value="添加到收件人" onclick="addPhone()" style="width: 35%;margin-right: 5%;border: 1px solid #8A93BE;text-align: center;background-color: #E7EEFE;cursor: pointer;" onmouseover="$(this).css('color','red')" onmouseout="$(this).css('color','black')"/><input type="text" name="phone" value="" class="easyui-validatebox" validType="mobile" maxlength="11" style="width: 60%;" /></td>
						</tr>
						<tr>
							<td><select name="receivePhones" multiple="multiple" size="10" style="width: 255px;overflow-y: auto;"></select></td>
						</tr>
						<tr>
							<td class="td1"></td>
							<td style="height: 30px;"><input type="button" name="" value="删除收件人" onclick="removePhone()" style="width: 30%;margin-right: 5%;border: 1px solid #8A93BE;text-align: center;background-color: #E7EEFE;cursor: pointer;" onmouseover="$(this).css('color','red')" onmouseout="$(this).css('color','black')"/><input type="button" name="" value="清空列表" onclick="removeAllPhone()" style="width: 25%;margin-right: 5%;border: 1px solid #8A93BE;text-align: center;background-color: #E7EEFE;cursor: pointer;" onmouseover="$(this).css('color','red')" onmouseout="$(this).css('color','black')"/><input type="button" name="" value="号码粘贴" onclick="addPhones()" style="width: 25%;margin-right: 5%;border: 1px solid #8A93BE;text-align: center;background-color: #E7EEFE;cursor: pointer;" onmouseover="$(this).css('color','red')" onmouseout="$(this).css('color','black')"/></td>
						</tr>
						<tr>
							<td class="td1"></td>
							<td style="height: 30px;">
								<input type="checkbox" name="needReport" value="1" /> 接收报告 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
								发送审核<input type="radio" name="needAudit" value="1" checked="checked"/>是 
								<input type="radio" name="needAudit" value="2" />否
								<!-- 
									<input type="checkbox" name=""  value="1" checked="checked"/> 附加账号信息
								 -->
							</td>
						</tr>
						<tr>
							<td class="td1"></td>
							<td style="height: 30px;">
								<input type="radio" name="timeSet" value="1" checked="checked" onclick="checkSet()"/>立即发送
								<input type="radio" name="timeSet" value="2" style="margin-left: 20px;" onclick="checkSet()"/>定时发送
							</td>
						</tr>
						<tr>
							<td class="td1"></td>
							<td style="height: 30px;"><input type="text" name="sendTime" value="" style="width: 100%;display: none;" class="easyui-validatebox" methodType="chooseDate{dateFmt:'yyyy-MM-dd HH:mm:ss'}"/></td>
						</tr>
						<tr id="loading" style="display: none;">
							<td colspan="2" style="text-align: center;border: 1px solid #cccccc;height: 50px;vertical-align: middle;">
								<img src="${path }/images/ajax-loader.gif" style="width: 128px;height: 15px;"/></br>
								彩信整理发送中，请耐心等待......
							</td>
						</tr>
					</table>
				</div>
				<div style="clear: both;"></div>
				<div style="width: 100%;text-align: center;">
					<a href="#" onclick="submitForm(this);" class="easyui-linkbutton" plain="false" iconCls="icon-save" style="margin-right:10px">保存</a>
    				<a href="javascript:reset();" class="easyui-linkbutton" plain="false" iconCls="icon-remove">重置</a>
	    			<!-- 
					<input type="button" name="" onclick="submitForm()" value="提交" style="border: 1px solid #8A93BE;text-align: center;background-color: #E7EEFE;cursor: pointer;margin-top: 6px;"/>	&nbsp;&nbsp;&nbsp;&nbsp;
					<input type="button" name="" value="重置" style="border: 1px solid #8A93BE;text-align: center;background-color: #E7EEFE;cursor: pointer;margin-top: 6px;"/>	
	    			 -->	
				</div>
			</form>
		</div>
		<div region="east" split="true" title="人员信息库" style="width:250px;">
			<div class="easyui-accordion" fit="true">
				<div id="tabs" class="easyui-tabs" fit="true" border="false" onclick="search()">
					<div title="平台用户选择" closable="false">
						<iframe id="operatorFrame" name="operatorFrame" scrolling="auto" frameborder="0" style="width: 100%;height: 100%;" src="${path}/mms/mmSend!listOperator.qt?chkAccess=${fs:chkAccess(param.mid,'QUERY')}"></iframe>
					</div>
					<!-- 
					<div title="人员选择" closable="false">
						<iframe id="personFrame" name="personFrame" scrolling="auto" frameborder="0" style="width: 100%;height: 100%;"></iframe>
					</div>
					 -->
					<div title="人员通讯录选择" closable="false">
						<iframe id="addressBookFrame" name="addressBookFrame" scrolling="auto" frameborder="0" style="width: 100%;height: 100%;"></iframe>
					</div>
				</div>
			</div>
		</div>
	</div>
  </body>
</html>
