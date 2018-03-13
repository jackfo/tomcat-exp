package com.fr.security;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UsernameNotFoundException;

import java.util.Collection;

public class SecurityProvider extends DaoAuthenticationProvider {

    @Autowired
    private MyUserDetailService userDetailsService;

    @Override
    public Authentication authenticate(Authentication authentication)
            throws AuthenticationException {
        String username = authentication.getName(); // 用户名
        String password =authentication.getCredentials().toString(); //密码

        //UsernamePasswordAuthenticationToken token = (UsernamePasswordAuthenticationToken) authentication;
        //加载自定义的用户,在这里是新生成的userDetails实例 其中 getAuthorities是当前用户所具备的所有权限
        UserDetails userDetails = userDetailsService.loadUserByUsername(username);
        //验证是否查询到相应的用户
        if (userDetails == null) {
            throw new UsernameNotFoundException("当前用户名没有找到");
        }
        //验证登录密码是否和验证密码相同
        if(!userDetails.getPassword().equals(password))
        {
            throw new BadCredentialsException("");
        }
        //把用户信息封装成UsernamePasswordAuthenticationToken对象。
        Collection<? extends GrantedAuthority> authorities = userDetails.getAuthorities();
        return new UsernamePasswordAuthenticationToken(userDetails, userDetails.getPassword(),authorities);
    }

    @Override
    public boolean supports(Class<?> authentication) {
        // TODO Auto-generated method stub
        return UsernamePasswordAuthenticationToken.class.equals(authentication);
    }

}