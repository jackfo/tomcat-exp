package com.fr.sys.model;

import javax.persistence.*;

@Table(name = "sys_user_role")
public class SysUserRole {
    @Id
    @Column(name = "user_login_id")
    private String userLoginId;

    @Id
    @Column(name = "role_id")
    private String roleId;

    /**
     * @return user_login_id
     */
    public String getUserLoginId() {
        return userLoginId;
    }

    /**
     * @param userLoginId
     */
    public void setUserLoginId(String userLoginId) {
        this.userLoginId = userLoginId;
    }

    /**
     * @return role_id
     */
    public String getRoleId() {
        return roleId;
    }

    /**
     * @param roleId
     */
    public void setRoleId(String roleId) {
        this.roleId = roleId;
    }
}