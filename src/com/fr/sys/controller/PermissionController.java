package com.fr.sys.controller;

import com.fr.sys.model.SysPermission;
import com.fr.sys.service.ISysPermissionService;
import com.fr.util.HttpJsonResponse;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author jack
 * 权限管理控制器
 */
@Controller
public class PermissionController {

    @Autowired
    ISysPermissionService sysPermissionServiceImpl;



    @RequestMapping("permissionManager")
    public String permissionManager(){
        return "system/permission/permissionList";
    }

    @RequestMapping("addPermission")
    public String addPermission(SysPermission syspermission){
        sysPermissionServiceImpl.addPermission(syspermission);
        return "system/permission/permissionList";

    }

    @RequestMapping("delPermission")
    @ResponseBody
    public HttpJsonResponse delPermission(String permissionId){
        int count = sysPermissionServiceImpl.delPermission(permissionId);
        HttpJsonResponse httpJsonResponse = null;
        if(count>0){
            httpJsonResponse = new HttpJsonResponse("1",null);
        }else{
            httpJsonResponse = new HttpJsonResponse("-1",null);
        }
        return httpJsonResponse;
    }

    @RequestMapping("queryPermissionList")
    @ResponseBody
    public Map<String, Object> queryPermissionList(int page, int limit, String keyword){
        Map<String, Object> resultMap = new HashMap<String, Object>();
        PageInfo<SysPermission> pager = sysPermissionServiceImpl.queryAllPermision(page,limit,keyword);
        resultMap.put("count", pager.getTotal());
        resultMap.put("msg", "");
        resultMap.put("code", 0);
        resultMap.put("data", pager.getList());
        return resultMap;
    }

    @RequestMapping("queryAllPermission")
    @ResponseBody
    public List<SysPermission> queryAllPermission(HttpServletRequest request){
        List<SysPermission> sysPermissionList = sysPermissionServiceImpl.queryAllPermision();
        request.setAttribute("sysPermissionList",sysPermissionList);
        return sysPermissionList;
    }

    @RequestMapping("addPer")
    public String addPer(){
        return "system/permission/addPer";
    }

    @RequestMapping("editPer")
    public String editPer(String permissionId, ModelMap modelMap){
        SysPermission syspermission = sysPermissionServiceImpl.findPermissionById(permissionId);
        modelMap.put("syspermission",syspermission);
        return "system/permission/editPer";
    	/*int count = sysPermissionServiceImpl.updatePermission(syspermission);
    	return "system/permission/permissionList";*/
    }

    @RequestMapping("updatePermission")
    public String updatePermission(SysPermission syspermission){
        int count = sysPermissionServiceImpl.updatePermission(syspermission);
        if(count > 0){
            return "system/permission/permissionList";
        }
        else{
            return "system/permission/permissionList";
        }
    }



}
