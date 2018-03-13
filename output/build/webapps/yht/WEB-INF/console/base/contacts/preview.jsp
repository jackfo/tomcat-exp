<%@ page language="java" pageEncoding="UTF-8"%>
<%@page import="com.fs.util.ExcelUtil.ReadSetting"%>
<%@page import="java.util.List"%>
<%@page import="com.fs.util.ExcelUtil.Range"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@ include file="/include/include.jsp"%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>预览Excel</title>
		<script type="text/javascript" src="${path }/js/bgshade/jQuery_plug_bgshade.js"></script>
		<style type="text/css">
			*{margin:0px;padding:0px;}
			body{padding:5px;overflow:hidden;}
			.my_menu{position:absolute;padding:2px;border:1px solid #CCC;background: #F8F8F8;width:150px;min-height:100px;display:none;}
			.my_menu_item{margin:3px;padding:0px 3px;float:left;border:1px solid #dcc;white-space:nowrap;height:20px;line-height:20px;cursor:pointer;display:none;}
			.recommend{border:1px solid red;}
			.Excel_table{border-top:1px solid #454545;border-left:1px solid #454545;}
			.Excel_table td{padding:2px;white-space:nowrap;border-bottom:1px solid #454545;border-right:1px solid #454545;}
			.Excel_table td.hover{background:#D0E5F5;}
			.Excel_table td.visited{background:#FBEC88;}
			.visible{display:block;}
		</style>
		<script type="text/javascript">
			jQuery(document).ready(function(){
				$('#newForm').parent().css({width:$(document.body).width()});
				$('#right_menu').hover(function(){
					$(this).data("isOver",true);
				},function(){
					if($(this).data("isOver"))
						$(this).animate({opacity:'hide'},100);
				});
				$('.my_menu_item').hover(function(e){
					
				},function(e){
					
				}).click(function(e){<%--单击可选列名自动将值设置到所选列的最下方的单元格内--%>
					var column = $($(this.parentNode).data('currentCell')).attr('column');
					var html = '<input type="hidden" name="cellColumn" value="'+column+'"/>'
								+'<input type="hidden" name="cellFormat" value="'+$(this).attr('val')+'"/>'+$(this).text();
					var lastCell = $('.Excel_table tr:last').find('td[column="'+column+'"]');
					if(typeof(lastCell.find(':hidden[name="cellFormat"]').val())!='undefined')
						$(this.parentNode).find('div[val="'+lastCell.find(':hidden[name="cellFormat"]').val()+'"]').addClass('visible');
					lastCell.html(html);
					$('.Excel_table tr').find('td[column="'+column+'"]').addClass('visited');
					$(this.parentNode).hide();
					$(this).removeClass('visible');
				});
				$('.Excel_table').mouseover(function(e){
					$(this).find('td.hover').removeClass('hover');
					var column = $(e.target).attr('column');
					if(typeof(column)=='undefined')return false;
					$(this).find('tr').find('td[column="'+column+'"]').addClass('hover');
				}).bind('click',function(e){//为选项卡绑定右键
					if($(e.target).attr('tagName').toUpperCase()=='INPUT') return true;
					$('#right_menu .recommend').removeClass('recommend');
					var column = typeof($(e.target).attr('column'))=='undefined'?'0':parseInt($(e.target).attr('column'))+1;
					$(this).addClass('hover');
					if(0==column||1<$(e.target).attr('colspan')) return false;
					var column = $(e.target).attr('column');
					var menuWidth = $('#right_menu').outerWidth();
					var maxViewWidth = document.body.scrollLeft+document.body.offsetWidth;
					var needMaxViewWidth = $(e.target).offset().left+$(e.target).outerWidth()+menuWidth;
					var _left = $(e.target).offset().left+$(e.target).outerWidth();
					if(maxViewWidth<needMaxViewWidth) _left = $(e.target).offset().left-menuWidth-1;
					$('#right_menu').css({top:$(this).offset().top+1,left: _left}).animate({opacity:'show'},100).data("currentCell",e.target);
					
					var title = $(this).find('tr').find('td[column="'+column+'"]');
					if(0<title.length){
						var s = title[0].innerText.replace(/[\s*]|([(].+?[)])/ig,'');
						$('#right_menu').find('div.my_menu_item:contains("'+s+'")').addClass('recommend');
					}
					
					return false;
				});
				$('#startImportButton').click(startImport);
			});
			/**
			 *	自动适配列名
			 */
			function autoSetting(){
				$('.Excel_table tr:last td').not($('.Excel_table tr:last td.visited')).each(function(i,el){
					if(i==0) return true;
					var title = $('.Excel_table tr').find('td[column="'+$(el).attr("column")+'"]');
					if(0<title.length){
						$('#right_menu').show().data("currentCell",el);
						var s = title[0].innerText.replace(/[\s*]|([(].+?[)])/ig,'');
						$('#right_menu').find('div.my_menu_item.visible:contains("'+s+'"):eq(0)').click();
					}
				});
				$('#right_menu').hide();
			}
			/**
			 *	取消列名设置
			 */
			function cancelSet(el){
				var column = $($(el).data('currentCell')).attr('column');
				var lastCell = $('.Excel_table tr:last').find('td[column="'+column+'"]');
				if(typeof(lastCell.find(':hidden[name="cellFormat"]').val())!='undefined')
					$(el).find('div[val="'+lastCell.find(':hidden[name="cellFormat"]').val()+'"]').addClass('visible');
				lastCell.html('&nbsp;');
				$('.Excel_table tr').find('td[column="'+column+'"]').removeClass('visited');
				$(el).hide();
			}
			/**
			 *	开始导入
			 */
			function startImport(e){
				if($('#startImportButton').linkbutton("options").disabled) return false;
				submitForm($('#startImportButton')[0]);
			}
			function submitForm(el){
				$('#newForm').form('submit',{
					url:'${path}/base/contacts!importContact.qt?random='+getRandomNum(),
					onSubmit:function(){
						var b = $(this).form('validate');
						if(0>=$(this).find('input::hidden[name="cellFormat"]').length){
							b = false;
							parent.jQuery.messager.alert('错误','请配置需要导入的列！','error');
						}
						if(b){
							$(el).linkbutton({disabled:true});
							$(document.body).bgshade("导入中...");
						}
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
						$(document.body).bgshade(false);
						$(el).linkbutton({disabled:false});
						parent.jQuery.messager.alert('错误',e.message+'<br/><br/>保存失败！','error');
					}
				});
			}
			function reset(){
				newForm.reset();
			}
		</script>
	</head>
	<body scoll="no">
		<div style="margin-right:5px;width:100%;height:189px\9;overflow:auto;">
		<form  id="newForm" action="" method="post" style="margin:0px;padding:0px;">
			<input type="hidden" name="chkAccess" value="${param.chkAccess }"/>
			<input type="hidden" name="b" value="import"/>
			<input type="hidden" name="file" value="${param.file }"/>
			<%
				ReadSetting<List<Object>> _setting = (ReadSetting<List<Object>>)request.getAttribute("preview");
				if(null!=_setting&&null!=_setting.data&&null!=_setting.ranges){
					int _maxColumn = 0;
					List<Range> _ranges = _setting.ranges;
					out.println("<table class=\"Excel_table\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\">");
					for(int _r=0;_r<_setting.data.size();_r++){
						List<Object> _row = _setting.data.get(_r);
						if(0>=_row.size()) continue;
						if(_maxColumn < _row.size()) _maxColumn = _row.size();
						out.println("\t\t\t\t<tr>");
						out.println("\t\t\t\t\t<td><input type=\"radio\" name=\"data-start-row\" value=\""+_r+"\""+(_r==2?" checked=\"checked\"":"")+"/></td>");
						for(int _c=0;_c<_row.size();_c++){
							Object _cells = _row.get(_c);
							String _cell = _cells.toString().replace("\"", "\"").replace("\\", "\\");
							if(StringUtils.isBlank(_cell)) _cell = "&nbsp;";
							if(0<_ranges.size()){
								boolean isScope = false;	//是否在合并单元格的范围之内
								for(Range _range : _ranges){
									//判断是不是合并单元格的左上角单元格
									if(_r==_range.topLeftRow&&_c==_range.topLeftColumn){
										int _colspan = _range.bottomRightColumn-_range.topLeftColumn+1;
										int _rowspan = _range.bottomRightRow-_range.topLeftRow+1;
										out.println("\t\t\t\t\t<td "+(_colspan>1?"align=\"center\" ":"column=\""+_c+"\" ")+"colspan=\""+_colspan+"\" rowspan=\""+_rowspan+"\">"+_cell+"</td>");
									}
									//判断是不是在该合并单元格内
									if(_r>=_range.topLeftRow&&_r<=_range.bottomRightRow&&_c>=_range.topLeftColumn&&_c<=_range.bottomRightColumn){
										isScope = true;
										break;
									}
								}
								if(!isScope) out.println("\t\t\t\t\t<td column=\""+_c+"\">"+_cell+"</td>");
							}else out.println("\t\t\t\t\t<td column=\""+_c+"\">"+_cell+"</td>");
						}
						out.println("\t\t\t\t</tr>");
					}
					out.println("\t\t\t\t<tr>");
					out.println("\t\t\t\t\t<td>&nbsp;</td>");
					for(int i=0;i<_maxColumn;i++){
						out.println("\t\t\t\t\t<td column=\""+i+"\" align=\"center\" style=\"color:green;font-weight:bolder;\">&nbsp;</td>");
					}
					out.println("\t\t\t\t</tr>");
					out.print("\t\t\t</table>");
				}
			%>
		</form>
		</div>
		<ol style="margin:5px 20px;">
			<li>页面打开后可以单击表格中的列，选择该列属于“可选列名”中的哪列，导入时将按照选择的列名进行导入</li>
			<li>为了避免将表头行导入进去，请选择开始导入行。选择方式：单击所选行前面的单选框即可</li>
		</ol>
		<div style="text-align:center;padding:5px;">
			<a href="javascript:void(0)" onclick="window.location.href='${path }/base/contacts!importContact.qt?mid=${param.mid }&chkAccess=${param.chkAccess }';return false;" class="easyui-linkbutton" plain="false" iconCls="icon-add" style="margin-right:20px;">返回</a>
			<a href="javascript:void(0)" onclick="autoSetting()" class="easyui-linkbutton" plain="false" iconCls="icon-add" style="margin-right:20px;">自动适配列名</a>
			<a href="javascript:void(0)" id="startImportButton" class="easyui-linkbutton" plain="false" iconCls="icon-add">开始导入</a>
		</div>
		<div id="right_menu" class="my_menu"><c:forEach var="item" items="${keyMap}">
			<div val="${item.key }" class="my_menu_item visible"><c:out value="${item.value}"/></div></c:forEach>
			<div style="clear:both;"></div>
			<div style="text-align:center;">
				<a href="javascript:void(0)" onclick="cancelSet(parentNode.parentNode)" style="text-decoration:underline;margin-right:10px;">取消设置</a>
				<a href="javascript:void(0)" onclick="$(parentNode.parentNode).hide()" style="text-decoration:underline;">隐藏</a>
			</div>
		</div>
	</body>
</html>