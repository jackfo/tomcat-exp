package com.fr.sys.mapper;



import com.fr.mapper.common.Mapper;
import com.fr.sys.model.CmEmployee;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * @author jack
 * */
public interface CmEmployeeMapper extends Mapper<CmEmployee> {
    /**
     * 查找任意列包含当前传入参数的数据
     * */
    public List<CmEmployee> getEmployeeList(@Param(value = "keyword") String keyword);
}