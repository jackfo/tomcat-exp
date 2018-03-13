package com.fr.sys.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.fr.sys.model.SysUser;
import com.fr.sys.service.ISysUserService;
import com.fr.util.HttpJsonResponse;
import com.github.pagehelper.PageInfo;

@Controller
public class UserController {

    @Autowired
    ISysUserService sysUserServiceImpl;



    @RequestMapping("userManager")
    public String queryManager(){
        return "system/userManager/UserList";
    }

    @RequestMapping("queryUserList")
    @ResponseBody
    public Map<String, Object> queryUserList(int page, int limit, String keyword){
        Map<String, Object> resultMap = new HashMap<String, Object>();
        PageInfo<SysUser> pager = sysUserServiceImpl.findUserByPage(page,limit,keyword);
        resultMap.put("count", pager.getTotal());
        resultMap.put("msg", "");
        resultMap.put("code", 0);
        resultMap.put("data", pager.getList());
        return resultMap;
    }

    @RequestMapping("editUser")
    public String editUser(String userId, ModelMap modelMap){
        SysUser sysUser  = sysUserServiceImpl.findUserById(userId);
        if(userId==null||"".equals(userId)){
            return "system/userManager/editUser";
        }
        modelMap.put("sysUser",sysUser);

        return "system/userManager/editUser_update";
    }

    /**
     * 如果创建成功则跳转到列表界面 如果创建失败继续在当前编辑界面
     * */
    @RequestMapping("createUser")
    public String createUser(SysUser sysUser ){
    	sysUserServiceImpl.createUser(sysUser);
        return "system/userManager/UserList";
    }

    @RequestMapping("delUser")
    @ResponseBody
    public HttpJsonResponse delUser(String userId){
    	System.out.println(userId);
        int count = sysUserServiceImpl.delUser(userId);
        HttpJsonResponse httpJsonResponse = null;
        if(count>0){
            httpJsonResponse = new HttpJsonResponse("1",null);
        }else{
            httpJsonResponse = new HttpJsonResponse("-1",null);
        }
        return httpJsonResponse;
    }

    @RequestMapping("updateUser")
    public String updateUser(SysUser sysUser){
        int count = sysUserServiceImpl.updateUser(sysUser);
        if (count>0){
            return "system/userManager/UserList";
        }else{
            return "system/userManager/UserList";
        }
    }


}
