package com.fr.sys.service.impl;

import com.fr.sys.mapper.CmDepartmentEmployeeMapper;
import com.fr.sys.mapper.CmEmployeeMapper;
import com.fr.sys.model.CmDepartmentEmployee;
import com.fr.sys.model.CmEmployee;
import com.fr.sys.service.IEmployeeService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * Created by jack on 2018/1/17.
 */
@Service
public class EmployeeServiceImpl implements IEmployeeService{

    @Autowired
    private CmEmployeeMapper cmEmployeeMapper;

    @Autowired
    private CmDepartmentEmployeeMapper cmDepartmentEmployeeMapper;

    @Override
    public PageInfo<CmEmployee> findUserByPage(int page, int limit,String keyword) {
        PageHelper.startPage(page, limit);
        if(keyword==null){
            keyword = "";
        }
        List<CmEmployee> list = cmEmployeeMapper.getEmployeeList(keyword);
        //cmEmployeeMapper.select()
        return new PageInfo<CmEmployee>(list);
    }

    @Override
    public CmEmployee createEmployee(CmEmployee cmEmployee) {
        cmEmployeeMapper.insertSelective(cmEmployee);
        return cmEmployee;
    }

    @Override
    public CmEmployee findEmployeeById(String employeeId) {
       return cmEmployeeMapper.selectByPrimaryKey(employeeId);
    }

    @Override
    public int updateEmployee(CmEmployee cmEmployee) {
        return cmEmployeeMapper.updateByPrimaryKey(cmEmployee);
    }


    @Override
    @Transactional(rollbackFor = Exception.class)
    public int delEmployee(String employeeId) {
        cmDepartmentEmployeeMapper.deleteByEmployeeId(employeeId);
        return cmEmployeeMapper.deleteByPrimaryKey(employeeId);
    }

    @Override
    public List<CmEmployee> queryAllEmployee() {
        return cmEmployeeMapper.selectAll();
    }




}
