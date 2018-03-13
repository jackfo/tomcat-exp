package com.fr.sys.service;

import com.fr.sys.model.SysUser;
import com.github.pagehelper.PageInfo;

public interface ISysUserService {
    public SysUser getSysUser(String userLoginId);

    public PageInfo<SysUser> findUserByPage(int page, int limit, String keyword);

    public SysUser createUser(SysUser sysUser);

    public SysUser findUserById(String UserId);

    public int updateUser(SysUser sysUser);

    public int delUser(String UserId);
}
