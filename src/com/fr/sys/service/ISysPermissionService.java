package com.fr.sys.service;

import com.fr.sys.mapper.SysPermissionMapper;
import com.fr.sys.model.SysPermission;
import com.github.pagehelper.PageInfo;

import java.util.List;

/**
 * Created by jack on 2018/1/15.
 */
public interface ISysPermissionService {



    public List<SysPermission> queryAllPermision();

    public SysPermission addPermission(SysPermission syspermission);
    public int delPermission(String permissionId);
    public PageInfo<SysPermission> queryAllPermision(int page, int limit, String keyword);
    public SysPermission findPermissionById(String permissionId);
    public int updatePermission(SysPermission syspermission);

}
