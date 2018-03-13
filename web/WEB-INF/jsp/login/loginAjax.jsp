<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}"></c:set>
<!DOCTYPE html>
<html lang="zh-cn">
<head>
  <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
  <meta charset="utf-8" />
  <title>人力资源管理 - 登录</title>
  <meta name="description" content="人力资源管理 |登录页面" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0" />
    <meta name="_csrf" content="${_csrf.token}"/>
    <!-- default header name is X-CSRF-TOKEN -->
    <meta name="_csrf_header" content="${_csrf.headerName}"/>
  <link rel="stylesheet" href="${contextPath}/assets/css/bootstrap.css" />
  <link rel="stylesheet" href="${contextPath}/assets/css/font-awesome.css" />
  <link rel="stylesheet" href="${contextPath}/assets/css/ace-fonts.css" />
  <link rel="stylesheet" href="${contextPath}/assets/css/ace.css" />
  <!--[if lte IE 9]>
  <link rel="stylesheet" href="${contextPath}/assets/css/ace-part2.css" />
  <![endif]-->
  <link rel="stylesheet" href="${contextPath}/assets/css/ace-rtl.css" />

  <!--[if lte IE 9]>
  <link rel="stylesheet" href="${contextPath}/assets/css/ace-ie.css" />
  <![endif]-->

  <!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
  <!--[if lt IE 9]>
  <script src="${contextPath}/assets/js/html5shiv.js"></script>
  <script src="${contextPath}/assets/js/respond.js"></script>
  <![endif]-->
</head>

<body class="login-layout light-login">
<div class="main-container">
  <div class="main-content">
    <div class="row">
      <div class="col-sm-10 col-sm-offset-1">
        <div class="login-container">
          <div class="center">
            <h1>
              <span class="red">&nbsp;</span>
            </h1>
          </div>

           <!--登陆界面-->
          <div class="space-6"></div>
          <div class="position-relative">
            <div id="login-box" class="login-box visible widget-box no-border">
              <div class="widget-body">
                <div class="widget-main">
                  <h4 class="header blue lighter bigger">
                    <i class="ace-icon fa fa-coffee green"></i>
                    登录人力资源管理平台
                  </h4>
                  <div class="space-6"></div>
                  <form id="validationLoginForm" method="post" action="hello">
                    <fieldset>
                      <label class="block clearfix">
							<span class="block input-icon input-icon-right">
							    <input id="loginUserLogin" name="userLoginId" type="text" class="form-control" placeholder="用户名" />
								<i class="ace-icon fa fa-user"></i>
							</span>
                      </label>

                      <label class="block clearfix">
							<span class="block input-icon input-icon-right">
								<input id="loginPassword" name="password" type="password" class="form-control" placeholder="密码" />
								<i class="ace-icon fa fa-lock"></i>
							</span>
                      </label>

                      <label class="block clearfix">
							<span class="block input-icon input-icon-right">
									<span id="loginTip" style="color:#A94442"></span>
							</span>
                      </label>

                      <div class="space"></div>

                      <div class="clearfix">
                        <label class="inline">
                          <input id="rememberMe" name="rememberMe" type="checkbox" class="ace" />
                          <span class="lbl">下次自动登录</span>
                        </label>

                        <button id="loginButton" type="button" class="width-35 pull-right btn btn-sm btn-primary">
                          <i class="ace-icon fa fa-key"></i>
                          <span class="bigger-110">登录</span>
                        </button>
                      </div>

                      <div class="space-4"></div>
                    </fieldset>
                  </form>
                </div><!-- /.widget-main -->

                <div class="toolbar clearfix">
                  <div>
                    <a href="#" data-target="#forgot-box" class="forgot-password-link">
                      <i class="ace-icon fa fa-arrow-left"></i>
                      忘记密码？
                    </a>
                  </div>

                  <div>
                    <a href="#" data-target="#signup-box" class="user-signup-link">
                      立即注册
                      <i class="ace-icon fa fa-arrow-right"></i>
                    </a>
                  </div>
                </div>
              </div><!-- /.widget-body -->
            </div><!-- /.login-box -->

            <div id="forgot-box" class="forgot-box widget-box no-border">
              <div class="widget-body">
                <div class="widget-main">
                  <h4 class="header red lighter bigger">
                    <i class="ace-icon fa fa-key"></i>
                    找回密码
                  </h4>

                  <div class="space-6"></div>
                  <p>
                    输入您的电子邮箱
                  </p>

                  <form id="validationRetrieveForm" method="post" action="#">
                    <fieldset>
                      <label class="block clearfix">
														<span class="block input-icon input-icon-right">
															<input id="retrieveEmail" name="email" type="email" class="form-control" placeholder="邮箱" title="邮箱作为用户名" />
															<i class="ace-icon fa fa-envelope"></i>
														</span>
                      </label>

                      <label class="block clearfix">
														<span class="block input-icon input-icon-right">
															<span id="retrieveTip" style="color:#A94442"></span>
														</span>
                      </label>

                      <div class="clearfix">
                        <button id="retrieveButton" type="button" class="width-35 pull-right btn btn-sm btn-danger">
                          <i class="ace-icon fa fa-lightbulb-o"></i>
                          <span class="bigger-110">发送</span>
                        </button>
                      </div>
                    </fieldset>
                  </form>
                </div><!-- /.widget-main -->

                <div class="toolbar center">
                  <a href="#" data-target="#login-box" class="back-to-login-link">
                    登录
                    <i class="ace-icon fa fa-arrow-right"></i>
                  </a>
                </div>
              </div><!-- /.widget-body -->
            </div><!-- /.forgot-box -->

            <div id="signup-box" class="signup-box widget-box no-border">
              <div class="widget-body">
                <div class="widget-main">
                  <h4 class="header green lighter bigger">
                    <i class="ace-icon fa fa-users blue"></i>
                    注册Java企业通用开发平台框架
                  </h4>

                  <div class="space-6"></div>

                  <form id="validationRegisterForm" method="post" action="#">
                    <fieldset>
                      <label class="block clearfix">
														<span class="block input-icon input-icon-right">
															<input id="userName" name="userName" type="text" class="form-control" placeholder="姓名" />
															<i class="ace-icon fa fa-user"></i>
														</span>
                      </label>

                      <label class="block clearfix">
                        <label>
                          <input name="sex" type="radio" class="ace" value="1" checked />
                          <span class="lbl">男</span>
                        </label>
                        <label class="pull-right">
                          <input name="sex" type="radio" class="ace" value="2" />
                          <span class="lbl">女</span>
                        </label>
                      </label>

                      <label class="block clearfix">
														<span class="block input-icon input-icon-right">
															<input id="email" name="email" type="email" class="form-control" placeholder="邮箱" title="邮箱用于登录和找回密码" />
															<i class="ace-icon fa fa-envelope"></i>
														</span>
                      </label>

                      <label class="block clearfix">
														<span class="block input-icon input-icon-right">
															<input id="phone" name="phone" type="text" class="form-control" placeholder="联系电话" />
															<i class="ace-icon fa fa-phone"></i>
														</span>
                      </label>

                      <label class="block clearfix">
														<span class="block input-icon input-icon-right">
															<input id="birthday" name="birthday" type="text" class="form-control" placeholder="生日" readonly />
															<i class="ace-icon fa fa-clock-o"></i>
														</span>
                      </label>

                      <label class="block clearfix">
														<span class="block input-icon input-icon-right">
															<input id="password" name="password" type="password" class="form-control" placeholder="密码" />
															<i class="ace-icon fa fa-lock"></i>
														</span>
                      </label>

                      <label class="block clearfix">
														<span class="block input-icon input-icon-right">
															<input id="repeatPassword" name="repeatPassword" type="password" class="form-control" placeholder="确认密码" />
															<i class="ace-icon fa fa-retweet"></i>
														</span>
                      </label>

                      <label class="block clearfix">
														<span class="block input-icon input-icon-right">
															<input name="agree" id="agree" type="checkbox" class="ace" />
															<span class="lbl">
																我已阅读并接受
																<a href="#">用户协议</a>
															</span>
														</span>
                      </label>

                      <label class="block clearfix">
														<span class="block input-icon input-icon-right">
															<span id="registerTip" style="color:#A94442"></span>
														</span>
                      </label>

                      <div class="space-24"></div>

                      <div class="clearfix">
                        <button type="reset" class="width-30 pull-left btn btn-sm">
                          <i class="ace-icon fa fa-refresh"></i>
                          <span class="bigger-110">重置</span>
                        </button>

                        <button id="registerButton" type="button" class="width-65 pull-right btn btn-sm btn-success">
                          <span class="bigger-110">注册</span>
                          <i class="ace-icon fa fa-arrow-right icon-on-right"></i>
                        </button>
                      </div>
                    </fieldset>
                  </form>
                </div>

                <div class="toolbar center">
                  我已注册，现在就
                  <a href="#" data-target="#login-box" class="back-to-login-link">
                    <i class="ace-icon fa fa-arrow-left"></i>
                    登录
                  </a>
                </div>
              </div><!-- /.widget-body -->
            </div><!-- /.signup-box -->
          </div><!-- /.position-relative -->
          <div class="navbar-fixed-top align-right">
            <br />
            &nbsp;
            <a id="btn-login-dark" href="#">花瓣</a>
            &nbsp;
            <span class="blue">/</span>
            &nbsp;
            <a id="btn-login-blur" href="#">风车</a>
            &nbsp;
            <span class="blue">/</span>
            &nbsp;
            <a id="btn-login-light" href="#">阳光</a>
            &nbsp; &nbsp; &nbsp;
          </div>
        </div>
      </div><!-- /.col -->
    </div><!-- /.row -->
  </div><!-- /.main-content -->
  <div class="footer">
    <div class="footer-inner">
      <!-- #section:basics/footer -->
      <div class="footer-content-nobordertop">
                        <span class="bigger-120">
                            <span class="blue bolder">
                                                                                                研发中心
                            </span>
                            &copy;
                            2015-2017
                        </span>
      </div>
      <!-- /section:basics/footer -->
    </div>
  </div>
</div><!-- /.main-container -->

<!-- basic scripts -->

<!--[if !IE]> -->
<script type="text/javascript">
    window.jQuery || document.write("<script src='${contextPath}/assets/js/jquery.js'>"+"<"+"/script>");
</script>
<!-- <![endif]-->

<!--[if IE]>
<script type="text/javascript">
  window.jQuery || document.write("<script src='${contextPath}/assets/js/jquery1x.js'>"+"<"+"/script>");
</script>
<![endif]-->

<script type="text/javascript">
    if('ontouchstart' in document.documentElement) document.write("<script src='${contextPath}/assets/js/jquery.mobile.custom.js'>"+"<"+"/script>");
</script>

<script type="text/javascript" src="${contextPath}/assets/js/jquery.validate.js"></script>
<script type="text/javascript" src="${contextPath}/assets/js/tooltip.js"></script>
<script type="text/javascript" src="${contextPath}/assets/js/date-time/bootstrap-datepicker.js"></script>
<script type="text/javascript" src="${contextPath}/assets/js/date-time/locales/bootstrap-datepicker.zh-CN.js"></script>
<script type="text/javascript" src="${contextPath}/assets/js/custom/login.js"></script>
<script type="text/javascript" src="${contextPath}/assets/js/jquery.cookie.js"></script>


</body>
</html>
