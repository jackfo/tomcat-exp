package com.fr.sys.mapper;

import com.fr.mapper.common.Mapper;
import com.fr.sys.model.CmDepartment;
import com.fr.sys.model.CmEmployee;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * @author unknow
 * */
public interface CmDepartmentMapper extends Mapper<CmDepartment> {

    /**
     * 查找任意列包含当前传入参数的数据
     * @param keyword 搜索关键字
     * @return 包含关键字的所有部门
     * */
    public List<CmDepartment> getDepartmentList(@Param(value = "keyword") String keyword);

    /**
     * 根据部门表示查询当前部门所有的员工
     * @param departmentId 部门id标识
     * @return 当前部门员工实例
     * */
    public List<CmEmployee> getEmployeeByDepartment(@Param(value = "departmentId")String departmentId);
}