package com.fr.sys.service.impl;


import com.fr.sys.mapper.SysUserMapper;
import com.fr.sys.model.SysUser;
import com.fr.sys.service.ISysUserService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service
public class SysUserServiceImpl implements ISysUserService {

    @Resource
    private SysUserMapper sysUserMapper;


    @Override
    public PageInfo<SysUser> findUserByPage(int page, int limit, String keyword) {
        PageHelper.startPage(page, limit);
        if(keyword==null){
            keyword = "";
        }
        List<SysUser> list = sysUserMapper.getUserList(keyword);
        //CmDepartmentMapper.select()
        return new PageInfo<SysUser>(list);
    }

    @Override
    public SysUser createUser(SysUser sysUser) {
        sysUserMapper.insertSelective(sysUser);
        return sysUser;
    }

    @Override
    public SysUser findUserById(String UserId) {
        return sysUserMapper.selectByPrimaryKey(UserId);
    }

    @Override
    public int updateUser(SysUser sysUser) {
        return sysUserMapper.updateByPrimaryKey(sysUser);
    }

    @Override
    public int delUser(String UserId) {
        return sysUserMapper.deleteByPrimaryKey(UserId);
    }

    @Override
    public SysUser getSysUser(String userLoginId) {
        return sysUserMapper.getSysUser(userLoginId);
    }
}
