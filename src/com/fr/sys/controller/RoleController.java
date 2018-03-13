package com.fr.sys.controller;

import com.fr.sys.model.SysRole;
import com.fr.sys.service.IRoleService;
import com.fr.util.HttpJsonResponse;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import java.util.HashMap;
import java.util.Map;


@Controller
public class RoleController {

    @RequestMapping("peopleManager")
    public String roleManager(){
        return "system/role/roleList";
    }
    @Autowired
    IRoleService roleServiceImpl;
    
    
    @RequestMapping("queryRoleList")
    @ResponseBody
    public Map<String, Object> queryRoleList(int page,int limit,String keyword){
        Map<String, Object> resultMap = new HashMap<String, Object>();
        PageInfo<SysRole> pager = roleServiceImpl.findUserByPage(page,limit,keyword);
        resultMap.put("count", pager.getTotal());
        resultMap.put("msg", "");
        resultMap.put("code", 0);
        resultMap.put("data", pager.getList());
        return resultMap;
    }

    @RequestMapping("editRole")
    public String editRole(String roleId, ModelMap modelMap){
    	SysRole sysRole = roleServiceImpl.findRoleById(roleId);
        if(roleId==null||"".equals(roleId)){
            return "system/role/editRole";
        }
        modelMap.put("sysRole",sysRole);

        return "system/role/editRole_update";
    }

    
    /**
     * 如果创建成功则跳转到列表界面 如果创建失败继续在当前编辑界面
     * */
    @RequestMapping("createRole")
    public String createRole(SysRole sysRole){
    	roleServiceImpl.createRole(sysRole);
        return "system/role/roleList";
    }

    @RequestMapping("delRole")
    @ResponseBody
    public HttpJsonResponse delRole(String roleId){
       int count = roleServiceImpl.delRole(roleId);
       HttpJsonResponse httpJsonResponse = null;
       if(count>0){
            httpJsonResponse = new HttpJsonResponse("1",null);
       }else{
            httpJsonResponse = new HttpJsonResponse("-1",null);
       }
       return httpJsonResponse;
    }

    @RequestMapping("updateRole")
    public String updateRole(SysRole sysRole){
        int count = roleServiceImpl.updateRole(sysRole);
        if (count>0){
            return "system/role/roleList";
        }else{
            return "system/role/roleList";
        }
    }
}
