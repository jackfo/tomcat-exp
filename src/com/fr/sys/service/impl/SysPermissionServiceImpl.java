package com.fr.sys.service.impl;

import com.fr.sys.mapper.SysPermissionMapper;
import com.fr.sys.model.SysPermission;
import com.fr.sys.service.ISysPermissionService;
import com.github.pagehelper.PageInfo;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service
public class SysPermissionServiceImpl implements ISysPermissionService {


    @Resource
    SysPermissionMapper sysPermissionMapper;

    @Override
    public List<SysPermission> queryAllPermision() {
        List<SysPermission> sysPermissionList = sysPermissionMapper.selectAll();
        return sysPermissionList;
    }

    @Override
    public SysPermission addPermission(SysPermission syspermission){

        sysPermissionMapper.insertSelective(syspermission);
        return syspermission;
    }


    @Override
    public int delPermission(String permissionId) {

        return sysPermissionMapper.deleteByPrimaryKey(permissionId);
    }


    @Override
    public PageInfo<SysPermission> queryAllPermision(int page, int limit,
                                                     String keyword) {
        if(keyword==null){
            keyword = "";
        }
        List<SysPermission> list = (List<SysPermission>) sysPermissionMapper.getPermissionList(keyword);

        return new PageInfo<SysPermission>(list);
    }


    @Override
    public SysPermission findPermissionById(String permissionId) {

        return sysPermissionMapper.selectByPrimaryKey(permissionId);
    }


    @Override
    public int updatePermission(SysPermission syspermission) {

        return sysPermissionMapper.updateByPrimaryKey(syspermission);
    }

}
