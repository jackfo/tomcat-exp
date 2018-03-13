<%@ page import="org.springframework.security.core.context.SecurityContextHolder" %>
<%@ page import="org.springframework.security.core.context.SecurityContext" %>
<%@ page import="org.springframework.security.core.Authentication" %>
<%@ page import="com.fr.security.MyUserDetail" %>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<nav class="navbar-default navbar-static-side" role="navigation">
    <div class="nav-close"><i class="fa fa-times-circle"></i>
    </div>
    <div class="sidebar-collapse">
        <ul class="nav" id="side-menu">
            <li class="nav-header">
                <div class="dropdown profile-element">
                    <span><img alt="image" class="img-circle" src="${contextPath}/hfr/img/profile_small.jpg" /></span>
                    <a data-toggle="dropdown" class="dropdown-toggle" href="#">
                                <span class="clear">
                                <span class="block m-t-xs"><strong class="font-bold"><sec:authentication property="name"/></strong></span>

                                    <span class="text-muted text-xs block">
                                        <% SecurityContext securityContext = SecurityContextHolder.getContext();
                                            Authentication authentication = securityContext.getAuthentication();
                                            MyUserDetail myUserDetail = (MyUserDetail) authentication.getPrincipal();
                                        %>
                                        <%=myUserDetail.getRole() %>
                                        <b class="caret"></b>
                                    </span>
                                </span>
                    </a>
                    <ul class="dropdown-menu animated fadeInRight m-t-xs">
                        <li><a class="J_menuItem" href="form_avatar.html">修改头像</a>
                        </li>
                        <li><a class="J_menuItem" href="profile.html">个人资料</a>
                        </li>
                        <li><a class="J_menuItem" href="contacts.html">联系我们</a>
                        </li>
                        <li><a class="J_menuItem" href="mailbox.html">信箱</a>
                        </li>
                        <li class="divider"></li>
                        <li><a href="login.html">安全退出</a>
                        </li>
                    </ul>
                </div>
                <div class="logo-element">H+
                </div>
            </li>

            <!--上下分界线-->

            <li>
                <a  href="#">
                    <i class="fa fa-columns"></i>
                    <span class="nav-label">组织架构</span>
                    <span class="fa arrow"></span>
                    <ul class="nav nav-second-level">
                        <li><a class="J_menuItem" href="employeeManager"><i class="fa fa-home"></i><span class="nav-label">员工管理</span></a></li>
                        <li><a class="J_menuItem" href="departmentManager"><i class="fa fa-columns"></i> <span class="nav-label">部门管理</span></a></li>
                    </ul>
                </a>
            </li>

            <li>
                <a  href="#">
                    <i class="fa fa-columns"></i>
                    <span class="nav-label">系统管理</span>
                    <span class="fa arrow"></span>
                    <ul class="nav nav-second-level">
                        <li>
                            <a class="J_menuItem" href="permissionManager" data-index="0">权限管理</a>
                        </li>
                        <li>
                            <a class="J_menuItem" href="peopleManager">角色管理</a>
                        </li>
                        <li>
                            <a class="J_menuItem" href="userManager">用户管理</a>
                        </li>
                    </ul>
                </a>
            </li>
        </ul>
    </div>
</nav>