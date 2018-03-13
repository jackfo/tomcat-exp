$(function(){
	InitLeftMenu();
	tabClose();
	tabCloseEven();
	clockon();
})

//初始化左侧
function InitLeftMenu() {

    var menulist = "";
   
    $.each(_menus.menus, function(i, n) {
        menulist += '<div title="'+n.menuname+'" icon="'+(typeof(n.icon)!='undefined'&&n.icon!=''?n.icon:'default')+'" style="overflow:auto;">';
		menulist += '<ul>';
        $.each(n.menus, function(j, o) {
			menulist += '<li><div><a ref="'+o.menuid+'" href="#" rel="' + (o.url?o.url:'/') + '" ><span class="icon '+o.icon+'" >&nbsp;</span><span class="nav" hideText='+o.menuname+'|'+o.menuid+'>' + o.menuname + '</span></a></div></li> ';
        })
        menulist += '</ul></div>';
    })
    
	$(".easyui-accordion").empty().append(menulist).find('li a').click(function(){
		var tabTitle = $(this).children('.nav').text();

		var url = $(this).attr("rel");
		var menuid = $(this).attr("ref");
		var icon = getIcon(menuid,icon);
		
		addTab(tabTitle,url,icon);
		$('.easyui-accordion li div').removeClass("selected");
		$(this).parent().addClass("selected");
	}).hover(function(){
		$(this).parent().addClass("hover");
	},function(){
		$(this).parent().removeClass("hover");
	}).end().accordion();
}
//获取左侧导航的图标
function getIcon(menuid){
	var icon = 'icon ';
	$.each(_menus.menus, function(i, n) {
		 $.each(n.menus, function(j, o) {
		 	if(o.menuid==menuid){
				icon += o.icon;
			}
		 })
	})
	
	return icon;
}

var addTabMes = '您当前打开了太多的页面，如果继续打开，会造成程序运行缓慢，无法流畅操作，您可以试着关闭部分页面！';
function checkTab(subtitle,url,icon){
	var iii = $('.tabs-inner').length;//当前打开的Tab数量
	if(iii > 8){
		$.messager.alert("系统温馨提示",addTabMes,'info');
	}
}

function addTab(subtitle,url,icon){
	checkTab(subtitle,url,icon);
	if(!$('#tabs').tabs('exists',subtitle)){
		$('#tabs').tabs('add',{
			title:subtitle,
			content:createFrame(url),
			closable:true,
			icon:icon
		});
	}else{
		var iframe = $('#tabs').tabs('getTab',subtitle).children();
	//	$(iframe).attr('src',$(iframe).attr('src'));//刷新该面板数据
		$('#tabs').tabs('select',subtitle);
	}
	tabClose();
}

function createFrame(url){
	var regex = /(^http:\/\/)/;
	var regex2 = /(^\$)/;
	var s = '<iframe scrolling="auto" frameborder="0"  src="'+(regex.test(url)?url:(regex2.test(url)?url.replace(/(^\$)/,''):(CONTEXT_PATH+url)))+'" style="width:100%;height:100%;"></iframe>';
	return s;
}

function tabClose(){
	/*双击关闭TAB选项卡*/
	$(".tabs-inner").dblclick(function(){
		var subtitle = $(this).children(".tabs-closable").text();
		$('#tabs').tabs('close',subtitle);
	})
	/*单击刷新TAB选项卡*/
	$(".tabs-inner").click(function(){
		var iframe = $('#tabs').tabs('getTab',$(this).children(".tabs-title").text()).children();
	//	$(iframe).attr('src',$(iframe).attr('src'));//刷新该面板数据
	//	$('#tabs').tabs('close',subtitle);
	})
	/*为选项卡绑定右键*/
	$(".tabs-inner").bind('contextmenu',function(e){
		$('#mm').menu('show', {
			left: e.pageX,
			top: e.pageY
		});
		
		var subtitle =$(this).children(".tabs-closable").text();
		
		$('#mm').data("currtab",subtitle);
		$('#tabs').tabs('select',subtitle);
		return false;
	});
}
//绑定右键菜单事件
function tabCloseEven(){
	var temp = $('#tabs');
	$('#mm-tabrefresh').click(function(){
		var currtab_title = $('#mm').data("currtab");
		var frame = temp.tabs('getTab', currtab_title).find('iframe')
		frame.attr('src',frame.attr('src'));
	});
	//关闭当前
	$('#mm-tabclose').click(function(){
		var currtab_title = $('#mm').data("currtab");
		$('#tabs').tabs('close',currtab_title);
	})
	//全部关闭
	$('#mm-tabcloseall').click(function(){
		$('.tabs-inner span').each(function(i,n){
			var t = $(n).text();
			$('#tabs').tabs('close',t);
		});	
	});
	//关闭除当前之外的TAB
	$('#mm-tabcloseother').click(function(){
		var currtab_title = $('#mm').data("currtab");
		$('.tabs-inner span').each(function(i,n){
			var t = $(n).text();
			if(t!=currtab_title)
				$('#tabs').tabs('close',t);
		});	
	});
	//关闭当前右侧的TAB
	$('#mm-tabcloseright').click(function(){
		var nextall = $('.tabs-selected').nextAll();
		if(nextall.length==0){
			//msgShow('系统提示','后边没有啦~~','error');
			alert('后边没有啦~~');
			return false;
		}
		nextall.each(function(i,n){
			var t=$('a:eq(0) span',$(n)).text();
			$('#tabs').tabs('close',t);
		});
		return false;
	});
	//关闭当前左侧的TAB
	$('#mm-tabcloseleft').click(function(){
		var prevall = $('.tabs-selected').prevAll();
		if(prevall.length==0){
			alert('到头了，前边没有啦~~');
			return false;
		}
		prevall.each(function(i,n){
			var t=$('a:eq(0) span',$(n)).text();
			$('#tabs').tabs('close',t);
		});
		return false;
	});

	//退出
	$("#mm-exit").click(function(){
		$('#mm').menu('hide');
	})
}

//弹出信息窗口 title:标题 msgString:提示信息 msgType:信息类型 [error,info,question,warning]
function msgShow(title, msgString, msgType) {
	$.messager.alert(title, msgString, msgType);
}

//本地时钟
function clockon() {
    var now = new Date();
    var year = now.getFullYear(); //getFullYear getYear
    var month = now.getMonth();
    var date = now.getDate();
    var day = now.getDay();
    var hour = now.getHours();
    var minu = now.getMinutes();
    var sec = now.getSeconds();
    var week;
    month = month + 1;
    if (month < 10) month = "0" + month;
    if (date < 10) date = "0" + date;
    if (hour < 10) hour = "0" + hour;
    if (minu < 10) minu = "0" + minu;
    if (sec < 10) sec = "0" + sec;
    var arr_week = new Array("星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六");
    week = arr_week[day];
    var time = "";
    time = year + "年" + month + "月" + date + "日" + " " + hour + ":" + minu + ":" + sec + " " + week;

    $("#bgclock").html(time);

    var timer = setTimeout("clockon()", 200);
}

//重新登录
function relogin(){
	location.href=CONTEXT_PATH+"/base/account!reLogin.qt?random="+new Date().getTime();
}

//退出登录
function logout(){
	location.href=CONTEXT_PATH+"/base/account!logout.qt?random="+new Date().getTime();
}
