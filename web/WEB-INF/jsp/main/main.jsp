<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <meta name="_csrf" content="${_csrf.token}"/>
  <!-- default header name is X-CSRF-TOKEN -->
  <meta name="_csrf_header" content="${_csrf.headerName}"/>
<title>首页</title>
<link rel="stylesheet" href="layui/css/layui.css">
  <script type="text/javascript" src="layui/layui.js"></script>
   <script type="text/javascript" src="js/jquery-3.2.0.min.js"></script>
  <link  rel="stylesheet" href="css/test.css">  
</head>
<body>
<div id="head">
  <font style="padding-left:100px;">员工</font> 
  <font style="padding-left:100px;"><a href="admin.jsp">进入admin页面</a></font> 
</div>



<ul class="layui-nav layui-nav-tree" lay-filter="test">
<!-- 侧边导航: <ul class="layui-nav layui-nav-tree layui-nav-side"> -->
<div class="mainLeft" style="float:left;width:180px;background-color: #404553">
  <li class="layui-nav-item layui-nav-itemed" style="background-color: white;">
  
    <dl class="layui-nav-child"s>
      <dd><a href="javascript:;">用户管理</a></dd>
      <dd><a href="javascript:;">admin</a></dd>
    </dl>
    </div>
  </li>
</ul>






 <div id="creatCompany">
 <div class="mainRight">
<div class=" layui-tab-card">

  <ul class="layui-tab-title">
    <li class="layui-this">简介</li>
    <li>公司</li>
    <li>权限分配</li>
    <li>商品管理</li>
    <li>订单管理</li>
  </ul>
 
  <div class="layui-tab-content" style="height: 100px;">
    <div class="layui-tab-item layui-show">
    
    </div>
  </div>
</div>
</div>
      </div>
      <script>


$(function(){
    $(".mainLeft").height(document.documentElement.clientHeight-$(".mainLeft").offset().top);
    $(".mainRight").height(document.documentElement.clientHeight-$(".mainRight").offset().top);

})


</script>

<script>
    <!--为了进行ajax的POST请求-->

</script>
</body>
</html>