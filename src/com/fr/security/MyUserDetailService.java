package com.fr.security;


import com.fr.sys.mapper.SysPermissionMapper;
import com.fr.sys.mapper.SysRoleMapper;
import com.fr.sys.mapper.SysUserRoleMapper;
import com.fr.sys.mapper.SysUserMapper;
import com.fr.sys.model.SysPermission;
import com.fr.sys.model.SysRole;
import com.fr.sys.model.SysUser;
import com.fr.sys.model.SysUserRole;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

@Service
public class MyUserDetailService implements UserDetailsService {

    @Resource
    SysUserMapper sysUserMapper;

    @Resource
    SysRoleMapper sysRoleMapper;

    @Resource
    SysPermissionMapper sysPermissionMapper;

    @Resource
    SysUserRoleMapper sysUserRoleMapper;


    public UserDetails loadUserByUsername(String userLoginId)
            throws UsernameNotFoundException {
        //查找出当前用户
        SysUser sysUser =sysUserMapper.getSysUserWithPermission(userLoginId);

        SysPermission sysPermission = sysPermissionMapper.getPermissionByRoleId("ROLE_ADMIN");
        //验证用户是否为空
        if(sysUser==null)
        {
            throw new  UsernameNotFoundException("找不到该用户");
        }
        /**将用户和角色共同构建一个MyUserDetail实例*/
        return new MyUserDetail(sysUser,getAuthorities(sysUser));
    }

    /**
     * GrantedAuthority 可访问该资源的角色组
     *
     * 实现逻辑:
     * 根据用户id查询出所有的与当前用户关系的角色id
     * 再根据角色id找到对应的角色
     * */
    private Collection<GrantedAuthority> getAuthorities(String userLoginId) {
        Collection<GrantedAuthority> grantedAuthorities = new ArrayList<>();
        List<SysUserRole> sysUserAndRoleList =sysUserRoleMapper.getRoleList(userLoginId);
        if(sysUserAndRoleList!=null&&sysUserAndRoleList.size()>0){
            for(SysUserRole sysUserAndRole:sysUserAndRoleList){
                SimpleGrantedAuthority grantedAuthority = new SimpleGrantedAuthority(sysUserAndRole.getRoleId());
                grantedAuthorities.add(grantedAuthority);
            }
        }
        return grantedAuthorities;
    }

    /**
     * 将当前用户的所有权限给加进去
     *  SimpleGrantedAuthority grantedAuthority = new SimpleGrantedAuthority(roleId);
     *  grantedAuthorities.add(grantedAuthority);
     * */
    private Collection<GrantedAuthority> getAuthorities(SysUser sysUser){
        Collection<GrantedAuthority> grantedAuthorities = new ArrayList<>();
        List<SysRole> roleList = sysUser.getRoleList();
        if(roleList!=null&&roleList.size()>0){
            for(SysRole sysRole : roleList){
                List<SysPermission> permissionList = sysRole.getPermissionList();
                if(permissionList!=null&&permissionList.size()>0){
                    for(SysPermission sysPermission:permissionList){
                        SimpleGrantedAuthority grantedAuthority = new SimpleGrantedAuthority(sysPermission.getPermissionId());
                        grantedAuthorities.add(grantedAuthority);
                    }
                }
            }
        }
        return grantedAuthorities;
    }

}