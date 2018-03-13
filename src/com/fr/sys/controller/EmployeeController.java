package com.fr.sys.controller;

import com.fr.sys.model.CmDepartmentEmployee;
import com.fr.sys.model.CmEmployee;
import com.fr.sys.service.IEmployeeService;
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
public class EmployeeController {

    @RequestMapping("employeeManager")
    public String employeeManager(){
        return "system/employee/employeeList";
    }

    @Autowired
    IEmployeeService employeeServiceImpl;


    @RequestMapping("queryEmployeeList")
    @ResponseBody
    public Map<String, Object> queryEmployeeList(int page,int limit,String keyword){
        Map<String, Object> resultMap = new HashMap<String, Object>();
        PageInfo<CmEmployee> pager = employeeServiceImpl.findUserByPage(page,limit,keyword);
        resultMap.put("count", pager.getTotal());
        resultMap.put("msg", "");
        resultMap.put("code", 0);
        resultMap.put("data", pager.getList());
        return resultMap;
    }

    @RequestMapping("editEmployee")
    public String editEmployee(String employeeId, ModelMap modelMap){
        CmEmployee cmEmployee = employeeServiceImpl.findEmployeeById(employeeId);
        if(employeeId==null||"".equals(employeeId)){
            return "system/employee/editEmployee";
        }
        modelMap.put("cmEmployee",cmEmployee);

        return "system/employee/editEmployee_update";
    }

    /**
     * 如果创建成功则跳转到列表界面 如果创建失败继续在当前编辑界面
     * */
    @RequestMapping("createEmployee")
    public String createEmployee(CmEmployee cmEmployee){
        employeeServiceImpl.createEmployee(cmEmployee);
        return "system/employee/employeeList";
    }

    @RequestMapping("delEmployee")
    @ResponseBody
    public HttpJsonResponse delEmployee(String employeeId){
       int count = employeeServiceImpl.delEmployee(employeeId);
       HttpJsonResponse httpJsonResponse = null;
       if(count>0){
            httpJsonResponse = new HttpJsonResponse("1",null);
       }else{
            httpJsonResponse = new HttpJsonResponse("-1",null);
       }
       return httpJsonResponse;
    }

    @RequestMapping("updateEmployee")
    public String updateEmployee(CmEmployee cmEmployee){
        int count = employeeServiceImpl.updateEmployee(cmEmployee);
        if (count>0){
            return "system/employee/employeeList";
        }else{
            return "system/employee/employeeList";
        }
    }



}
