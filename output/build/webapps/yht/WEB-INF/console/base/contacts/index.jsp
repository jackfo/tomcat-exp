<%@ page language="java" pageEncoding="UTF-8"%>
<%@ include file="/include/include.jsp"%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<script type="text/javascript" src="${path }/js/easyui/window.js"></script>
		<link rel="stylesheet" type="text/css" href="${path }/css/buttonPanel.css">
		<title>通讯录</title>
		<style type="text/css">
			.g-menu-list{padding:8px 5px;white-space: normal;}
			.g-menu-item{white-space:normal;display:list-item;line-height:166.6%;display:block;font-family:tahoma;}
			a.g-menu-link-hover{background-color:#609DD6;color:white;}
			a.g-menu-link-hover:visited{color:#fff;}
			a.g-menu-link-hover span{color:#fff}
			.g-menu-link{display:block;height:22px;line-height:22px;text-decoration:none;padding:0 25px 0 10px;}
			.g-menu-link span{color:ff0000;}
			.g-menu-link:visited{color:#000}
			.g-menu-link:hover{background-color:#609DD6;color:white;}
			.g-menu-link:hover span{color:#fff}
			.cq{padding:10px;}
			.cq a,.cq a:hover,.cq a:visited{color:#0B68AB;text-decoration:underline;}
		</style>
		<script type="text/javascript">
			var win,table;
			$(document).ready(function(){
				getColorStyle();
				win = new Jwindow(function(table){
					var url = '${path}/base/contacts!index.qt?mid=${param.mid}&gid='+encodeURIComponent($('#groupId').val());
					window.location.href=url;
				});
				table = $('#dataTable').datagrid({
					//url:'${path}/base/contacts!list.qt?chkAccess='+encodeURIComponent('${param.chkAccess}'),
					width:document.body.clientWidth-180,
					height:document.body.clientHeight-$('.buttonPanel').height()-$('#test').height()-$('#pp').height(),
					idField:'id',
					pagination:true,
					pageDiv:'#pp',
					nowrap:true,
					border:false,
					striped:true,
					clickSingleSelect:true,
					fitColumns:true,
					rownumbers:true,
					columns:[[
						{field:'check',width:10,checkbox:'true'},
						{field:'code',width:80,title:'编号'},
						{field:'name',width:80,title:'名称'},
						{field:'sex',width:40,align:'center',title:'性别',formatter:function(value,node){return typeof(value)=='undefined'||value==1?'男':'女'}},
						{field:'birthday',width:120,title:'生日',formatter:function(value,node){
							if(typeof(value)=='undefined'||9>value.length) return'';
							if(value.substring(0,1)=='0') return value.replace(/^\d/,'农历 ').replace(/([\d]{4})([\d]{2})([\d]{2})/ig,'$1-$2-$3');
							else return value.replace(/^\d/,'公历 ').replace(/([\d]{4})([\d]{2})([\d]{2})/ig,'$1-$2-$3');
						}},
						{field:'phone',width:120,title:'手机 (主)'},
						{field:'phoneBK1',width:120,title:'号码 (备1)'},
						{field:'phoneBK2',width:120,title:'号码 (备2)'},
						{field:'glzw',width:100,title:'管理职务'},
						{field:'jszw',width:120,title:'专业技术职务'},
						{field:'status',width:100,title:'状态',formatter:function(value,node){
							var str = (node.createId == '${Operator.id }'?'<span style="color:green;margin-right:5px;">可编辑</span>':'');
							str += value&&value==1?'<span style="color:red;">不发短信</span>':'';
							return str;
						}}
					]],
					onSelect:function(index, row){
						if(row.createId != '${Operator.id }')
							table.datagrid("unselectRow",index);
					},
					onHeaderContextMenu: function(e, field){
						e.preventDefault();
						if (!$('#tmenu').length){
							createColumnMenu(table);
						}
						$('#tmenu').menu('show', {
							left:e.pageX,
							top:e.pageY
						});
					}
				});
				
				$('#group-list .g-menu-link').click(function(){
					$('#group-list .g-menu-link-hover').removeClass('g-menu-link-hover');
					$(this).addClass('g-menu-link-hover');
					$('#groupId').val($(this).attr('s_id'));
					$('#QUERY_BTN').click();
					var b = ${fs:isAccess(param.mid,'SHARE') };
					if($(this).attr('title')=='所有'||$(this).attr('title')=='未分组'||(!b&&$(this).attr('s_type')=='1')){
						$('#MODIFY_GROUP_btn').hide();
						$('#DEL_GROUP_btn').hide();
						$('#GROUP_BUTTON_PANEL').hide();
					}else{
						$('#MODIFY_GROUP_btn').show();
						$('#DEL_GROUP_btn').show();
						$('#GROUP_BUTTON_PANEL').show();
					}
				});
				if('${param.gid }'==''||'${param.gid }'=='未分组'){
					$('#MODIFY_GROUP_btn').hide();
					$('#DEL_GROUP_btn').hide();
					$('#GROUP_BUTTON_PANEL').hide();
				}
				$('#QUERY_BTN').click();
			});
		</script>
	</head>
	<body class="easyui-layout">
		<div region="north" border="false" class="buttonPanel" style="*padding-bottom:0px;*height:72px">
			<div class="formPanel">
				<input type="hidden" id="groupId" name="groupId" value="${param.gid }"/>
				<label for="contacts.code">编号：</label>
				<input type="text" name="contacts.code" id="contacts.code" maxlength="50" style="float:left;width: 100px;"/>
				<label for="contacts.name">名称：</label>
				<input type="text" name="contacts.name" id="contacts.name" style="float:left;width: 100px;"/>
				<label for="contacts.phone">号码：</label>
				<input type="text" name="contacts.phone" id="contacts.phone" style="float:left;width: 100px;"/>
				<label for="contacts.status">发送状态：</label>
				<select type="text" name="contacts.status" id="contacts.status" style="float:left;">
					<option value="999">--请选择--</option>
					<option value="0">可发送</option>
					<option value="1">不发送</option>
				</select>
				<div class="clear"></div>
			</div>
			<fs:button key="MODIFY_GROUP" id="MODIFY_GROUP_btn" name="编辑组" iconCls="icon-edit">
				function(){
					var id = $('#group-list a.g-menu-link-hover').attr('s_id');
					if(id!=''){
						win.show('编辑组','${path}/base/contacts!preGmodify.qt?mid=${param.mid }&id='+id+'&chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum(),table);
						win.reSize(600,400);
					}
				}
			</fs:button>
			<fs:button key="DEL_GROUP" id="DEL_GROUP_btn" name="删除组" iconCls="icon-no">
				function(){
					var group = $('#group-list a.g-menu-link-hover');
					var id = group.attr('s_id');
					parent.jQuery.messager.confirm('提示','确定删除【'+group.attr('s_name')+'】联系组吗？删除组后改组下成员会到未分组中',function(b){
						if(!b) return false;
						jQuery.ajax({
							async: false,
							type: "GET",
							url: '${path}/base/contacts!gdelete.qt?id='+encodeURIComponent(id)+'&chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum(),
							success: function(data){
								data = eval(data);
								if(data&&data.b){
									//$('#group-list a.g-menu-link:eq(0)').click();
									//group.parent().remove();
									var url = '${path}/base/contacts!index.qt';
									window.location.href=url;
								}else jQuery.messager.alert('错误','删除失败，请刷新页面重试！','error');
							}
						});
					});
				}
			</fs:button>
			<div class="datagrid-btn-separator" id="GROUP_BUTTON_PANEL"></div>
			<fs:button key="NEWADD" id="NEWADD_BTN" name="增加" iconCls="icon-add">
				function append(){
					var id = $('#group-list a.g-menu-link-hover').attr('s_id');
					win.show('新增联系人','${path}/base/contacts!preAdd.qt?mid=${param.mid }&gid='+id+'&chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum(),table);
					win.reSize(500,310);
				}
			</fs:button>
			<fs:button key="MODIFY" id="MODIFY_BTN" name="修改" iconCls="icon-edit">
				function modify(){
					var _rows = table.datagrid('getSelections');
					if(_rows&&1 < _rows.length){
						for(var i=0;i< _rows.length;i++){
							if(_rows[i].createId!=${Operator.id }){
								table.datagrid('unselectRow',i);//取消选中不可编辑的行
							}
						}
					}
					var rows = table.datagrid('getSelections');
					if(rows&&0>=rows.length)parent.jQuery.messager.alert('错误','对不起！请至少选择一条记录！','error');
					else if(rows&&1 < rows.length){
						var gid = $('#groupId').val();
						if(typeof(gid)!='undefined'&&gid!=''&&gid!='未分组'){
							gid = '&gid='+gid;
						}else{
							gid = '';
						}
						win.show('修改联系人','${path}/base/contacts!preModify.qt?mid=${param.mid }'+gid+'&chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum(),table);
						win.reSize(500,350);
					}else if(rows&&1==rows.length&&rows[0].createId != '${Operator.id }')
						parent.jQuery.messager.alert('错误','对不起！您不能修改他人创建的联系人！','error');
					else if(rows&&1==rows.length){
						win.show('修改联系人','${path}/base/contacts!preModify.qt?mid=${param.mid }&id='+rows[0].id+'&chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum(),table);
						win.reSize(500,310);
					}
				}
			</fs:button>
			<fs:button key="VIEW" id="VIEW_BTN" name="查阅" iconCls="icon-search">
				function view(){
					var rows = table.datagrid('getSelections');
					if(rows&&1!=rows.length)parent.jQuery.messager.alert('错误','对不起！请选择将要查看的一条记录！','error');
					else{
						win.show('查阅联系人','${path}/base/contacts!view.qt?id='+rows[0].id+'&chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum(),function(){});
						win.reSize(500,320);
					}
				}
			</fs:button>
			<fs:button key="DELETE" id="DELETE_BTN" name="删除" iconCls="icon-no">
				function remove(){
					var _rows = table.datagrid('getSelections');
					if(rows && 1>rows.length) parent.jQuery.messager.alert('错误','对不起！请选择将要删除的一条记录！','error');
					if(_rows&&1 < _rows.length){
						for(var i=0;i< _rows.length;i++){
							if(_rows[i].createId!=${Operator.id }){
								table.datagrid('unselectRow',i);//取消选中不可编辑的行
							}
						}
					}
					var gid = $('#groupId').val();
					if(typeof(gid)!='undefined'&&gid!=''&&gid!='未分组'){
						gid = '&gid='+gid;
					}else{
						gid = '';
					}
					var rows = table.datagrid('getSelections');
					if(rows&&0 < rows.length){
						var ids = '',names = '';
						jQuery.each(rows,function(i,el){
							if(el.createId == '${Operator.id }' || '1' == '${Operator.id }'){
								ids+=','+el.id;
								if(i<10){
									names+=',【'+el.name+'】';
								}
								if(i==10){
									names+='……';
								}
								
							}
						});
						ids = ids.replace(/(^[,]*)|([,]*$)/,'');
						names = names.replace(/(^[,]*)|([,]*$)/,'');
						if(ids == ''){
							
						}else if(gid == ''){
							parent.jQuery.messager.confirm('提示','确定删除'+names+'联系人吗？',function(b){
								if(b){
									jQuery.ajax({
										async: false,
										type: "GET",
										url: '${path}/base/contacts!delete.qt?id='+encodeURIComponent(ids)+gid+'&chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum(),
										success: function(data){
											data = eval(data);
											if(data&&data.b){}else jQuery.messager.alert('错误','删除失败，请刷新页面重试！','error');
											var url = '${path}/base/contacts!index.qt?mid=${param.mid}&gid='+encodeURIComponent($('#groupId').val());
											window.location.href=url;
										}
									});
								}
							});
						}else{
							parent.jQuery.messager.defaults.ok = '是';
							parent.jQuery.messager.defaults.cancel = '否';
							parent.jQuery.messager.confirm('提示','确定将'+names+'等联系人从当前分组中移除吗？<br/><br/><center>移出分组：是；删除用户：否</center>',function(b){
								if(b){
									jQuery.ajax({
										async: false,
										type: "GET",
										url: '${path}/base/contacts!delete.qt?id='+encodeURIComponent(ids)+gid+'&chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum(),
										success: function(data){
											data = eval(data);
											if(data&&data.b){
												var url = '${path}/base/contacts!index.qt?mid=${param.mid}&gid='+encodeURIComponent($('#groupId').val());
												window.location.href=url;
											}else jQuery.messager.alert('错误','删除失败，请刷新页面重试！','error');
										}
									});
								}else parent.jQuery.messager.confirm('提示','确定删除'+names+'等联系人吗？',function(b){
									if(b){
										jQuery.ajax({
											async: false,
											type: "GET",
											url: '${path}/base/contacts!delete.qt?id='+encodeURIComponent(ids)+'&chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum(),
											success: function(data){
												data = eval(data);
												if(data&&data.b){}else jQuery.messager.alert('错误','删除失败，请刷新页面重试！','error');
												var url = '${path}/base/contacts!index.qt?mid=${param.mid}&gid='+encodeURIComponent($('#groupId').val());
												window.location.href=url;
											}
										});
									}
								});
								
							});
							parent.jQuery.messager.defaults.ok = '确定';
							parent.jQuery.messager.defaults.cancel = '取消';
						}
					}
				}
			</fs:button>
			<div class="datagrid-btn-separator"></div>
			<fs:button key="QUERY" id="QUERY_BTN" name="查询" iconCls="icon-search">
				function query(){
					$('#refreshButton').linkbutton('enable');
					table.datagrid('options').url = '${path}/base/contacts!list.qt?mark=${param.mark}'+'&chkAccess='+encodeURIComponent('{#chkAccess}')+'&name='+encodeURIComponent($('#txtSearch').val());
					table.datagrid('options').queryParams=getURLParamsForObj();
					table.datagrid('reload');
					table.datagrid('clearSelections');
				}
			</fs:button>
			<fs:button key="IMPORT" id="IMPORT_BTN" name="导入" iconCls="icon-redo">
				function(){
					win.show('导入联系人','${path}/base/contacts!importContact.qt?mid=${param.mid }&chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum(),table);
					win.reSize(550,350);
				}
			</fs:button>
			<fs:button key="EXPORT" id="EXPORT_BTN" name="导出" iconCls="icon-print">
				function(){
					var param = '';
					$('.formPanel :input').each(function(i,el){
						param+='&'+$(el).attr('name')+'='+encodeURIComponent($(el).val());
					});
					var url = '${path}/base/contacts!exportContact.qt?b=true'+param+'&chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum();
					window.location.href=url;
				}
			</fs:button>
			<div class="clear"></div>
		</div>
		<div region="west" border="false" style="width:180px;background:#E4F1FB;border-right:1px solid #92BED3;">
			<ul id="group-list" class="g-menu-list">
				<li class="g-menu-item">
					<a href="javascript:void(0)" class="g-menu-link<c:if test="${empty param.gid }"> g-menu-link-hover</c:if>" hidefocus="hidefocus" title="所有" s_id="">所有(<c:out value="${allgroup}"/>)</a>
				</li><c:forEach var="item" items="${groups}">
				<li class="g-menu-item">
					<a href="javascript:void(0)" class="g-menu-link<c:if test="${param.gid eq item.id }"> g-menu-link-hover</c:if>" hidefocus="hidefocus" title="${item.name}" s_id="${item.id }" s_type="${item.type }" s_name="${item.name}"><c:if test="${item.type eq 1}">
						<span>[共]</span></c:if><c:out value="${item.name}"/><c:catch>(<c:out value="${fn:length(item.contacts)}"/>)</c:catch></a>
				</li></c:forEach>
				<li class="g-menu-item">
					<a href="javascript:void(0)" class="g-menu-link<c:if test="${param.gid eq '未分组' }"> g-menu-link-hover</c:if>" hidefocus="hidefocus" title="未分组" s_id="未分组">未分组(<c:out value="${ungroup}"/>)</a>
				</li>
				<li class="g-menu-item cq">
					<fs:button key="ADD_GROUP" id="ADD_GROUP_btn" name="新建联系组" classes="add_group_btn">
						function(){
							win.show('新建联系组','${path}/base/contacts!preGadd.qt?mid=${param.mid }&chkAccess='+encodeURIComponent('{#chkAccess}')+'&random='+getRandomNum(),table);
							win.reSize(600,400);
						}
					</fs:button>
				</li>
			</ul>
		</div>
		<div region="center" border="false">
			<table id="dataTable"></table>
		</div>
		<div id="pp" region="south" border="false" style="height:31px"></div>
		<div id="test" style="height:8px;*height:6px;display:none;font-size:1px;"></div>
	</body>
</html>