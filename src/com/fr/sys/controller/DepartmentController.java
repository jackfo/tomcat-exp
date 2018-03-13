package com.fr.sys.controller;

import com.fr.sys.model.CmDepartment;
import com.fr.sys.model.CmDepartmentEmployee;
import com.fr.sys.model.CmEmployee;
import com.fr.sys.service.IDepartmentService;
import com.fr.sys.service.IEmployeeService;
import com.fr.util.HttpJsonResponse;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by jack on 2018/1/18.
 */
@Controller
public class DepartmentController {

    @RequestMapping("departmentManager")
    public String departmentManager(){
        return "system/department/departmentList";
    }

    @Autowired
    IDepartmentService departmentServiceImpl;

    @Autowired
    IEmployeeService employeeServiceImpl;


    @RequestMapping("queryDepartmentList")
    @ResponseBody
    public Map<String, Object> queryDepartmentList(int page, int limit, String keyword){
        Map<String, Object> resultMap = new HashMap<String, Object>();
        PageInfo<CmDepartment> pager = departmentServiceImpl.findUserByPage(page,limit,keyword);
        resultMap.put("count", pager.getTotal());
        resultMap.put("msg", "");
        resultMap.put("code", 0);
        resultMap.put("data", pager.getList());
        return resultMap;
    }

    @RequestMapping("editDepartment")
    public String editDepartment(String departmentId, ModelMap modelMap){
        CmDepartment cmDepartment = departmentServiceImpl.findDepartmentById(departmentId);
        if(departmentId==null||"".equals(departmentId)){
            return "system/department/editDepartment";
        }
        modelMap.put("cmDepartment",cmDepartment);

        return "system/department/editDepartment_update";
    }

    /**
     * 如果创建成功则跳转到列表界面 如果创建失败继续在当前编辑界面
     * */
    @RequestMapping("createDepartment")
    public String createDepartment(CmDepartment cmDepartment){
        departmentServiceImpl.createDepartment(cmDepartment);
        return "system/department/departmentList";
    }

    @RequestMapping("delDepartment")
    @ResponseBody
    public HttpJsonResponse delDepartment(String departmentId){
        int count = departmentServiceImpl.delDepartment(departmentId);
        HttpJsonResponse httpJsonResponse = null;
        if(count>0){
            httpJsonResponse = new HttpJsonResponse("1",null);
        }else{
            httpJsonResponse = new HttpJsonResponse("-1",null);
        }
        return httpJsonResponse;
    }

    @RequestMapping("updateDepartment")
    public String updateDepartment(CmDepartment cmDepartment){
        int count = departmentServiceImpl.updateDepartment(cmDepartment);
        if (count>0){
            return "system/department/departmentList";
        }else{
            return "system/department/departmentList";
        }
    }

    /**
     * 根据id查询当前部门所有的员工
     * */
    @RequestMapping("queryEmployeeByDepartment")
    public String queryEmployee(String departmentId,ModelMap modelMap){
        modelMap.put("departmentId",departmentId);
        List<CmEmployee> employeeList = employeeServiceImpl.queryAllEmployee();
        modelMap.put("employeeList",employeeList);
        return "system/department/department_employeeList";
    }

    @RequestMapping("queryEmployeeListByDepartment")
    @ResponseBody
    public Map<String, Object> queryEmployeeList(int page,int limit,String departmentId,ModelMap modelMap){
        Map<String, Object> resultMap = new HashMap<String, Object>();
        PageInfo<CmEmployee> pager = departmentServiceImpl.getEmployeeByDepartment(page,limit,departmentId);
        resultMap.put("count", pager.getTotal());
        resultMap.put("msg", "");
        resultMap.put("code", 0);
        resultMap.put("data", pager.getList());
        modelMap.put("departmentId",departmentId);
        return resultMap;
    }

    @RequestMapping("addEmployee")
    @ResponseBody
    public HttpJsonResponse addEmployee(CmDepartmentEmployee cmDepartmentEmployee){
        HttpJsonResponse httpJsonResponse = new HttpJsonResponse("1","");
        departmentServiceImpl.addDepartmentEmployee(cmDepartmentEmployee);
        return httpJsonResponse;
    }

    @RequestMapping("delDepartmentEmployee")
    @ResponseBody
    public HttpJsonResponse delDepartmentEmployee(CmDepartmentEmployee cmDepartmentEmployee){
        int count = departmentServiceImpl.deleteDepartmentEmployee(cmDepartmentEmployee);
        HttpJsonResponse httpJsonResponse = null;
        if(count>0){
            httpJsonResponse = new HttpJsonResponse("1",null);
        }else{
            httpJsonResponse = new HttpJsonResponse("-1",null);
        }
        return httpJsonResponse;
    }

}
