package com.fr.sys.service;

import com.fr.sys.model.SysRole;
import com.github.pagehelper.PageInfo;

/**
 * Created by jack on 2018/1/17.
 */
public interface IRoleService {

    public PageInfo<SysRole> findUserByPage(int page, int limit, String keyword);

    public SysRole createRole(SysRole sysRole);

    public SysRole findRoleById(String roleId);

    public int updateRole(SysRole sysRole);

    public int delRole(String roleId);

}
