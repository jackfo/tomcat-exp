<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/include/include.jsp"%><%@
	taglib prefix="qt" uri="http://www.flagsky.com/functions" %>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>新建联系组</title>
		<script type="text/javascript" src="${path }/js/sms/validatebox.js"></script>
		<style type="text/css">
			body{padding:10px;background:#fafafa;}
			th{width:80px;height:30px;line-height:30px;text-align:right;font-size:9pt;font-weight:normal;}
			td{height:30px;line-height:30px;font-size:9pt;}
			
			.g-selectBox-item{border-bottom:#F1F1F1 1px solid;overflow:hidden;white-space:nowrap;text-overflow:ellipsis;padding:3px 0;cursor:pointer;text-indent:3px;height:20px;*height:27px;line-height:20px;*line-height:27px;width:100%}
			.g-selectBox-hover{background:#ffffe1;}
			.g-selectBox-checked{background:#FFFFCA;}
			.g-selectBox-name{margin-left:3px;}
			.g-selectBox-phone{margin-left:3px;color:#999;font-style: normal;}
			.g-selectBox-item .txt-impt{color:red;}
			
			.g-targetBox-item{float:left;position:relative;background:#DBE8F2;margin:3px 0 0 3px;padding:0 3px;padding-top:1px;padding-right:20px;white-space:nowrap;height:19px;line-height:19px;*height:20px;*line-height:20px;cursor:default;overflow:hidden;}
			.g-targetBox-item a{position:absolute;top:0px;right:0px;width:20px;height:20px;line-height:20px;font-size:25px;text-align:center;color:#2E95AC}
			.g-targetBox-item a:visited{color:#2E95AC;}
			.g-targetBox-item a:hover{color:#2C737A;}
		</style>
		<script type="text/javascript">
			jQuery(document).ready(function(){
				$('#fastSearchTxt').fastSearch({
					selectBox:document.getElementById('fastSearchSelectBox'),
					targetBox:document.getElementById('fastSearchTargetBox')
				});
			});
			function submitForm(el){
				$('#newForm').form('submit',{
					url:'${path}/base/contacts!gadd.qt?random='+getRandomNum(),
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
				window.location.reload();
			}
			(function($) {
				$.fn.fastSearch=function(options){
					var opt = $.extend({
						selectBox:null,
						targetBox:null,
						orgTotal:parseInt('${pageList.totalCount}'),
						total:parseInt('${pageList.totalCount}'),
						pageSize:parseInt('${pageList.pageSize}')
					},options);
					opt.orgTargetArea=$(opt.targetBox).html();
					opt.orgInputArea=$(this).val();
					this.css({color:'#7d7d7d'}).focus(function(){
						if($(this).val()==opt.orgInputArea)$(this).val('').css({color:'#000000'});
					}).blur(function(){
						if($(this).val()=='')$(this).val(opt.orgInputArea).css({color:'#7d7d7d'});
					}).keyup(function(e){
						var str = $(this).val();
						if(str!=''){
							if(opt.orgTotal>opt.pageSize){
								jQuery.ajax({
									//async:false,
									type:"POST",
									url:'${path}/base/contacts!preGadd.qt?s='+encodeURIComponent(str)+'&chkAccess='+encodeURIComponent('${param.chkAccess}')+'&random='+getRandomNum(),
									dataType:"json",
									success:function(data){
										if(typeof(data.b)=='boolean'&&data.b&&typeof(data.rows)=='object'){
											$(opt.selectBox).find('div.g-selectBox-item').each(function(i,el){
												if($(el).is('.g-selectBox-checked')) return true;
												else $(el).remove();
											});
											for(var i=0,len=data.rows.length;i<len;i++){
												var row = data.rows[i];
												if(0<$(opt.selectBox).find('div.g-selectBox-item[s_id="'+row.id+'"]').length)
													continue;
												var html = '<div class="g-selectBox-item" s_id="'+row.id+'">\n'
													 + '<input type="checkbox" name="conId" value="'+row.id+'">\n'
													 + '<strong class="g-selectBox-name">'+row.name+'</strong>\n'
													 + '<em class="g-selectBox-phone">'+row.phone+'</em>\n'
													 + '</div>';
												jQuery(html).appendTo(opt.selectBox);
											}
											$(opt.selectBox).find('div.g-selectBox-item').textSearch(str);
											initEvent(opt);
										}
									}
								});
							}else{
								$(opt.selectBox).find('div.g-selectBox-item').textSearch(str);
							}
						}else{
							$(opt.selectBox).find("div.g-selectBox-item").show().find('span[rel="mark"]').after(function(){return $(this).html();}).remove();
						}
					});
					initEvent(opt);
				};
				var initEvent=function(options){
					$(options.selectBox).find('div.g-selectBox-item').unbind('click').unbind('hover').hover(function(){
						if(!$(this).is('.g-selectBox-checked'))$(this).addClass('g-selectBox-hover');
					},function(){
						$(this).removeClass('g-selectBox-hover');
					}).click(function(e){
						e.stopPropagation();
						selectItemClick(e,this);
						checkedItem(options);
					}).find(':checkbox').unbind('click').click(function(e){
						e.stopPropagation();
						selectItemClick(e,this);
						checkedItem(options);
					});
				}
				var selectItemClick=function(e,el){
					e.stopPropagation();
					if(!el)el=this;
					if($(el).is(':checkbox')){
						if($(el).is(':checked')) $(el.parentNode).addClass('g-selectBox-checked');
						else $(el.parentNode).removeClass('g-selectBox-checked');
					}else{
						var checkbox = $(el).children(':checkbox:eq(0)');
						if(checkbox.is(':checked')){
							checkbox.attr('checked','');
							$(el).removeClass('g-selectBox-checked');
						}else{
							checkbox.attr('checked','checked');
							$(el).addClass('g-selectBox-checked');
						}
					}
				}
				var checkedItem=function(options){
					var array = $(options.selectBox).children('div.g-selectBox-checked');
					var len = array.length;
					if(0<len){
						$(options.targetBox).html('');
						for(var i=0;i<len;i++){
							var selectItem = array[i];
							var item = jQuery('<div class="g-targetBox-item" s_id="'+$(selectItem).attr('s_id')+'">'+$(selectItem).find('.g-selectBox-name').text()+'</div>').appendTo(options.targetBox);
							var delBtn = jQuery('<a href="javascript:void(0)" hidefocus="hidefocus" title="">×</a>')
							.appendTo(item).click(function(e){
								$(options.selectBox).children('div.g-selectBox-checked[s_id="'+$(this.parentNode).attr('s_id')+'"]').removeClass('g-selectBox-checked').children(':checkbox').attr('checked','');
								$(this.parentNode).remove();
								if(0>=$(options.selectBox).children('div.g-selectBox-checked').length)
									$(options.targetBox).html(options.orgTargetArea);
							});
						}
						jQuery('<div style="clear:both;"></div>').appendTo(options.targetBox);
					}else $(options.targetBox).html(options.orgTargetArea);
				}
				$.fn.textSearch = function(str,options){
					var defaults = {
						divFlag: false,
						divStr: " ",
						markClass: "txt-impt",
						markColor: "red",
						nullReport: true,
						callback:function(el,b){
							if(b) $(el).show();
							else $(el).hide();
							if($(el).is('.g-selectBox-checked')) $(el).find(':checkbox').attr('checked','checked');
						}
					};
					var sets = $.extend({}, defaults, options || {}), clStr;
					if(sets.markClass){
						clStr = "class='"+sets.markClass+"'";	
					}else{
						clStr = "style='color:"+sets.markColor+";'";
					}
					
					//对前一次高亮处理的文字还原
					$("span[rel='mark']").after(function(){return $(this).html();}).remove();
					
					
					//字符串正则表达式关键字转化
					$.regTrim = function(s){
						var imp = /[\^\.\\\|\(\)\*\+\-\$\[\]\?]/g;
						var imp_c = {};
						imp_c["^"] = "\\^";
						imp_c["."] = "\\.";
						imp_c["\\"] = "\\\\";
						imp_c["|"] = "\\|";
						imp_c["("] = "\\(";
						imp_c[")"] = "\\)";
						imp_c["*"] = "\\*";
						imp_c["+"] = "\\+";
						imp_c["-"] = "\\-";
						imp_c["$"] = "\$";
						imp_c["["] = "\\[";
						imp_c["]"] = "\\]";
						imp_c["?"] = "\\?";
						s = s.replace(imp,function(o){
							return imp_c[o];					   
						});	
						return s;
					};
					$(this).each(function(){
						var t = $(this);
						str = $.trim(str);
						if(str === ""){
							//alert("关键字为空");
							return false;
						}else{
							//将关键字push到数组之中
							var arr = [];
							if(sets.divFlag){
								arr = str.split(sets.divStr);	
							}else{
								arr.push(str);	
							}
						}
						var v_html = t.html();
						//删除注释
						v_html = v_html.replace(/<!--(?:.*)\-->/g,"");
						
						//将HTML代码支离为HTML片段和文字片段，其中文字片段用于正则替换处理，而HTML片段置之不理
						var tags = /[^<>]+|<(\/?)([A-Za-z]+)([^<>]*)>/g;
						var a = v_html.match(tags), test = 0;
						$.each(a, function(i, c){
							if(!/<(?:.|\s)*?>/.test(c)){//非标签
								//开始执行替换
								$.each(arr,function(index, con){
									if(con === ""){return;}
									var reg = new RegExp("("+$.regTrim(con)+")", "ig");
									if(reg.test(c)){
										//正则替换
										c = c.replace(reg,"♂$1♀");
										test = 1;
									}
								});
								c = c.replace(/♂/g,"<span rel='mark' "+clStr+">").replace(/♀/g,"</span>");
								a[i] = c;
							}
						});
						//将支离数组重新组成字符串
						var new_html = a.join("");
						
						$(this).html(new_html);
						
						if(test === 0 && sets.nullReport){
							//alert("没有搜索结果");	
							//return false;
						}
						
						//执行回调函数
						sets.callback(this,test === 0?false:true);
					});
				};
			})(jQuery);
		</script>
	</head>
	<body>
		<form id="newForm" name="newForm" method="post">
			<input type="hidden" name="chkAccess" value="${param.chkAccess }">
			<input type="hidden" name="group.parentId" value="0">
			<table style="width:100%;table-layout:fixed;" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<th>组名：</th>
					<td>
						<input type="text" id="group.name" name="group.name" class="easyui-validatebox" required="true" style="width:98%" maxlength="50"/>
					</td>
					<th>编号：</th>
					<td>
						<input type="text" id="group.code" name="group.code" class="easyui-validatebox" validType="exist['${path }/base/contacts!isExistGcode.qt?chkAccess=${param.chkAccess}','']" regex="[\w]+" msg="只能输入字母、数字及'_'" style="width:100%" maxlength="3"/>
					</td>
					<td style="width:50px;" align="right"><c:if test="${fs:isAccess(param.mid,'SHARE') }">
						<input type="checkbox" id="group.type" name="group.type" value="1"/>
						<label for="group.type" style="cursor:pointer;">共享</label></c:if>
					</td>
					<td style="width:50px">&nbsp;</td>
				</tr>
				<tr>
					<th>所有联系人：</th>
					<td>
						<input type="text" id="fastSearchTxt" name="contacts.code" value="快速搜索联系人" style="width:98%"/>
					</td>
					<td colspan="3" style="padding-left:5px;color:#7d7d7d;">
						(选择联系人加入您正在编辑的分组)	
					</td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td colspan="4" style="height:1%">
						<div id="fastSearchSelectBox" style="width:100%;height:135px;*height:137px;border:1px solid #7F9DB9;background:#fff;overflow:auto;overflow-x:hidden;"><c:forEach var="item" items="${pageList.items }">
							<div class="g-selectBox-item" s_id="${item.id }">
								<input type="checkbox" name="conId" value="${item.id }">
								<strong class="g-selectBox-name"><c:out value="${item.name}"/></strong>
								<em class="g-selectBox-phone"><c:set var="phone" value="${item.phone},${item.phoneBK1},${item.phoneBK2}"/><c:if test="${not empty qt:replaceAll(phone,'(^[,]+)|([,]+$)','') }"><c:out value="${qt:replaceAll(phone,'(^[,]+)|([,]+$)','')}"/></c:if></em>
							</div></c:forEach>
						</div>
					</td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<th style="padding:5px 0" valign="top">已添加：</th>
					<td colspan="4" style="height:1%;padding:5px 0">
						<div id="fastSearchTargetBox" style="height:1%;padding:0px 3px 3px 0px;border:1px solid #7F9DB9;background:#fff;color:#7d7d7d;">
							<span style="margin:3px 0 0 3px;height:20px;line-height:22px;display:inline-block;overflow:hidden;">请选择需要加入组的联系人</span>
						</div>
					</td>
					<td>&nbsp;</td>
				</tr>
	    		<tr>
	    			<td colspan="6" align="center" height="40" valign="bottom">
	    				<a href="#" onclick="submitForm(this);" class="easyui-linkbutton" plain="false" iconCls="icon-save" style="margin-right:10px">保存</a>
	    				<a href="javascript:reset();" class="easyui-linkbutton" plain="false" iconCls="icon-remove">重置</a>
	    			</td>
	    		</tr>
	    	</table>
	    </form>
	</body>
</html>