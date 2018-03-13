<%@page language="java" pageEncoding="UTF-8"%>
<%@ include file="/include/include.jsp"%>

<html>
<head>
	<title>导出已发短信年度统计</title>
	<script type="text/javascript" src="${path }/js/easyui/window.js"></script>
	<script type="text/javascript" src="${path }/js/bgshade/jQuery_plug_bgshade.js"></script>
	<style>
		*{margin:0px;padding:0px;}
		body{background:#fafafa;overflow-y:auto;text-align: center;}
		#dataTable{margin-top: 15px;width: 95%;border-left: 1px solid #cccccc;border-top: 1px solid #cccccc;}
		#dataTable td{height: 25px;border-bottom: 1px solid #cccccc;border-right: 1px solid #cccccc;}
		.titleTd{width: 100px;text-align: center;background: #eeeeee;}
		.sendBatchTable{width: 95%;margin:auto;margin-top:50px;border-top:1px solid #cccccc;border-right:1px solid #cccccc;background:#fff;table-layout: fixed;}
		.sendBatchTable td{padding:5px;padding-bottom:3px;height:30px;border-left:1px solid #cccccc;border-bottom:1px solid #cccccc;}
	</style>
	<script type="text/javascript">

		$(document).ready(function(){
		//	document.body.style.overflow = 'scroll';//页面显示滚动条;
		});
		function reset(){
			downloadYearForm.reset();
		}
		
		function submitForm(el){
			if(null==$("#year").val() || ""==$("#year").val()){
				alert("\"年 份\"不能为空！");
			}else{
				$('#downloadYearForm').form('submit',{
					url:'${path}/sms/result!downloadYearSms.qt?chkAccess=${param.chkAccess}&type=pre',
					onSubmit:function(){
						var b = $(this).form('validate');
						if(b){ 
							$(el).linkbutton({disabled:true});
							$(document.body).bgshade("年度查询数据量大，请耐心等待......");
						//	parent.win.refreshParent();
						}
						return b;
					},
					success:function(data){
						$(document.body).bgshade(false);
						var d = eval(data);
						if(d.b){
							for(var i=1;i<=12;i++){
							//	$('#m'+i).text(d.month[i-1].val);
								$('<a href="${path}/sms/result!downloadYearSms.qt?year='+d.year+'&fname='+d.month[i-1].val+'&chkAccess=${param.chkAccess}&type=downM" title="点击下载">'+d.month[i-1].val+'</a>').appendTo('#m'+i);
							}
							$('<a href="${path}/sms/result!downloadYearSms.qt?year='+d.year+'&fname='+d.month[12].val+'&chkAccess=${param.chkAccess}&type=downY" title="点击下载">'+d.month[12].val+'</a>').appendTo('#all');
						}
					},
					onLoadError:function(e){
						$(el).linkbutton({disabled:false});
						parent.jQuery.messager.alert('错误',e.message+'<br/><br/>保存失败！','error');
					}
				});
			}
		}
	</script>
</head>
<body>
	<form id="downloadYearForm" name="downloadYearForm" method="post">
		<center><h2 style="margin-top: 15">导&nbsp;出&nbsp;已&nbsp;发&nbsp;短&nbsp;信&nbsp;年&nbsp;度&nbsp;统&nbsp;计</h2></center>
		<table class="sendBatchTable" align="center" cellpadding="0" cellspacing="0" border="0" style="margin-top: 15px;">
			<tr>
				<td width="150">选择导出已发短信年份：</td>
				<td>
					<input type="text" name="year" id="year" value="${year}" class="easyui-validatebox" methodType="chooseDate{dateFmt:'yyyy'}" />
				</td>
			</tr>
		</table>
		<table id="dataTable" align="center" cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td class="titleTd">1月数据</td><td id="m1">&nbsp;</td>
				<td class="titleTd">2月数据</td><td id="m2">&nbsp;</td>
			</tr>
			<tr>
				<td class="titleTd">3月数据</td><td id="m3">&nbsp;</td>
				<td class="titleTd">4月数据</td><td id="m4">&nbsp;</td>
			</tr>
			<tr>
				<td class="titleTd">5月数据</td><td id="m5">&nbsp;</td>
				<td class="titleTd">6月数据</td><td id="m6">&nbsp;</td>
			</tr>
			<tr>
				<td class="titleTd">7月数据</td><td id="m7">&nbsp;</td>
				<td class="titleTd">8月数据</td><td id="m8">&nbsp;</td>
			</tr>
			<tr>
				<td class="titleTd">9月数据</td><td id="m9">&nbsp;</td>
				<td class="titleTd">10月数据</td><td id="m10">&nbsp;</td>
			</tr>
			<tr>
				<td class="titleTd">11月数据</td><td id="m11">&nbsp;</td>
				<td class="titleTd">12月数据</td><td id="m12">&nbsp;</td>
			</tr>
			<tr>
				<td class="titleTd">全年打包</td><td id="all" colspan="3">&nbsp;</td>
			</tr>
		</table>
		<center style="margin-top: 15">
			<a href="#" onclick="submitForm(this);" id="saveBtn" class="easyui-linkbutton" plain="false" iconCls="icon-save" style="margin-right:10px">下载</a>
	   		<a href="javascript:reset();" class="easyui-linkbutton" plain="false" iconCls="icon-remove">重置</a>
	   	</center>	
	</form>
</body>
</html>