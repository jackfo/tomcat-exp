package com.fr.sys.service.impl;

import com.fr.sys.mapper.SysRoleMapper;
import com.fr.sys.model.SysRole;
import com.fr.sys.service.IRoleService;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * Created by jack on 2018/1/17.
 */
@Service
public class SysRoleServiceImpl implements IRoleService{

    @Autowired
    private SysRoleMapper sysRoleMapper;

    public PageInfo<SysRole> findUserByPage(int page, int limit,String keyword) {
        PageHelper.startPage(page, limit);
        if(keyword==null){
            keyword = "";
        }
        List<SysRole> list = sysRoleMapper.getRoleList(keyword);
        //cmEmployeeMapper.select()
        return new PageInfo<SysRole>(list);
    }

    public SysRole createRole(SysRole sysRole) {
    	sysRoleMapper.insertSelective(sysRole);
        return sysRole;
    }

    @Override
    public SysRole findRoleById(String roleId) {
       return sysRoleMapper.selectByPrimaryKey(roleId);
    }

    @Override
    public int updateRole(SysRole sysRole) {
        return sysRoleMapper.updateByPrimaryKey(sysRole);
    }

    @Override
    public int delRole(String roleId) {
       return sysRoleMapper.deleteByPrimaryKey(roleId);
    }


}
