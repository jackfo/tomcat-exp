package com.fr.sys.mapper;

import com.fr.mapper.common.Mapper;
import com.fr.sys.model.CmDepartmentEmployee;
import org.apache.ibatis.annotations.Param;

public interface CmDepartmentEmployeeMapper extends Mapper<CmDepartmentEmployee> {

    public Integer deleteByEmployeeId(@Param(value = "employeeId") String employeeId);

    public Integer deleteByDepartmentId(@Param(value = "departmentId") String departmentId);
}