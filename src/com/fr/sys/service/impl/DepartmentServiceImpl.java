package com.fr.sys.service.impl;

import com.fr.sys.mapper.CmDepartmentEmployeeMapper;
import com.fr.sys.mapper.CmDepartmentMapper;
import com.fr.sys.model.CmDepartment;
import com.fr.sys.model.CmDepartmentEmployee;
import com.fr.sys.model.CmEmployee;
import com.fr.sys.service.IDepartmentService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * Created by jack on 2018/1/18.
 */
@Service
public class DepartmentServiceImpl implements IDepartmentService {
    @Autowired
    private CmDepartmentMapper cmDepartmentMapper;

    @Autowired
    private CmDepartmentEmployeeMapper cmDepartmentEmployeeMapper;

    @Override
    public PageInfo<CmDepartment> findUserByPage(int page, int limit, String keyword) {
        PageHelper.startPage(page, limit);
        if(keyword==null){
            keyword = "";
        }
        List<CmDepartment> list = cmDepartmentMapper.getDepartmentList(keyword);
        //CmDepartmentMapper.select()
        return new PageInfo<CmDepartment>(list);
    }

    @Override
    public CmDepartment createDepartment(CmDepartment cmDepartment) {
        cmDepartmentMapper.insertSelective(cmDepartment);
        return cmDepartment;
    }

    @Override
    public CmDepartment findDepartmentById(String departmentId) {
        return cmDepartmentMapper.selectByPrimaryKey(departmentId);
    }

    @Override
    public int updateDepartment(CmDepartment cmDepartment) {
        return cmDepartmentMapper.updateByPrimaryKey(cmDepartment);
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public int delDepartment(String departmentId) {
        cmDepartmentEmployeeMapper.deleteByDepartmentId(departmentId);
        return cmDepartmentMapper.deleteByPrimaryKey(departmentId);
    }

    @Override
    public PageInfo<CmEmployee> getEmployeeByDepartment(int page, int limit,String departmentId){
        PageHelper.startPage(page, limit);
        if(departmentId==null){
            departmentId = "";
        }
        List<CmEmployee> list = cmDepartmentMapper.getEmployeeByDepartment(departmentId);
        //cmEmployeeMapper.select()
        return new PageInfo<CmEmployee>(list);
    }

    @Override
    public int addDepartmentEmployee(CmDepartmentEmployee cmDepartmentEmployee) {
        int queryCount =  cmDepartmentEmployeeMapper.selectCount(cmDepartmentEmployee);
        int count = 0;
        if(queryCount <= 0){
            count = cmDepartmentEmployeeMapper.insert(cmDepartmentEmployee);
        }
        return count;
    }

    @Override
    public int deleteDepartmentEmployee(CmDepartmentEmployee cmDepartmentEmployee) {
        return cmDepartmentEmployeeMapper.delete(cmDepartmentEmployee);
    }


}
