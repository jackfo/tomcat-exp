package com.fr.sys.mapper;

import com.fr.mapper.common.Mapper;
import com.fr.sys.model.CmEmployee;
import com.fr.sys.model.SysRole;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;


/**
 * Created by jack on 2017/10/26.
 */
@Repository
public interface SysRoleMapper extends Mapper<SysRole> {

    public List<SysRole> getRoleList(@Param(value = "keyword") String keyword);
}
