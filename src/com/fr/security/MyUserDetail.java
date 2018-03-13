package com.fr.security;

import com.fr.sys.model.SysRole;
import com.fr.sys.model.SysUser;
import com.fr.util.UtilValidate;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.Collection;
import java.util.List;

public class MyUserDetail implements UserDetails {
    private SysUser sysUser;
    private Collection<? extends GrantedAuthority> authorities;

    public MyUserDetail(SysUser sysUser, Collection<? extends GrantedAuthority> authorities) {
        this.sysUser = sysUser;
        this.authorities = authorities;
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        // TODO Auto-generated method stub
        return authorities;
    }

    @Override
    public String getPassword() {
        return sysUser.getPassword();
    }

    @Override
    public String getUsername() {
        return sysUser.getUserLoginId();
    }

    //下面的方法可以以后再添加
    @Override
    public boolean isAccountNonExpired() {
        // TODO Auto-generated method stub
        return false;
    }

    @Override
    public boolean isAccountNonLocked() {
        // TODO Auto-generated method stub
        return false;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        // TODO Auto-generated method stub
        return false;
    }

    @Override
    public boolean isEnabled() {
        // TODO Auto-generated method stub
        return false;
    }


    public String getRole(){
       List<SysRole> roleList = sysUser.getRoleList();
       if(UtilValidate.isNotEmpty(roleList)){
           SysRole sysRole = roleList.get(0);
           return sysRole.getRoleName();
       }
       return "";
    }
}