package com.fr.sys.mapper;

import com.fr.mapper.common.Mapper;
import com.fr.sys.model.SysUser;
import com.fr.sys.model.SysUserRole;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface SysUserRoleMapper extends Mapper<SysUserRole> {

    public List<SysUserRole> getRoleList(String userLoginId);

    public SysUser getSysUserWithRole(String userLoginId);
}
