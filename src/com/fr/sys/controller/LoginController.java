package com.fr.sys.controller;

import com.fr.security.MyUserDetail;
import com.fr.util.UtilResponse;
import com.fr.security.common.HttpJsonResponse;
import com.fr.sys.model.SysUser;
import com.fr.sys.service.ISysUserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.annotation.Secured;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


@Controller
public class LoginController {

    @RequestMapping("/login")
    public String login(){
        return "login/loginAjax";

    }

    @RequestMapping("/loginSuccess")
    public void  success(HttpServletResponse response) {
        UtilResponse.json(new HttpJsonResponse("1", "success"),response);
    }

    @RequestMapping("/loginError")
    public void  failure(HttpServletRequest request, HttpServletResponse response) {
        UtilResponse.json(new HttpJsonResponse("-1", "登录失败"),response);
    }

    @Autowired
    private ISysUserService sysUserServiceImpl;

    @RequestMapping("/main")
    @Secured("ROLE_ADMIN")
    public String main(ModelMap model) {
        model.addAttribute("message", "Spring 4 MVC Hello World");
        SecurityContext securityContext = SecurityContextHolder.getContext();
        Authentication authentication = securityContext.getAuthentication();
        MyUserDetail myUserDetail = (MyUserDetail) authentication.getPrincipal();
        myUserDetail.getRole();
        authentication.getAuthorities();
        return "main/main";
    }



    @RequestMapping("/findSysUser")
    public String findSysUser(String userLoginId,ModelMap modelMap){
        SysUser sysUser = sysUserServiceImpl.getSysUser(userLoginId);
        System.out.println(sysUser.getUserName());
        modelMap.addAttribute("sysUser",sysUser);
        return "testSysUser";
    }
}
