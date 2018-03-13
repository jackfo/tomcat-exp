package com.fr.sys.model;

import javax.persistence.*;
import java.util.List;

@Table(name = "sys_user")
public class SysUser {
    @Id
    @Column(name = "user_login_id")
    private String userLoginId;

    @Column(name = "user_name")
    private String userName;

    private String sex;

    private String password;

    @Transient
    private List<SysRole> roleList;

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
     * @return user_name
     */
    public String getUserName() {
        return userName;
    }

    /**
     * @param userName
     */
    public void setUserName(String userName) {
        this.userName = userName;
    }

    /**
     * @return sex
     */
    public String getSex() {
        return sex;
    }

    /**
     * @param sex
     */
    public void setSex(String sex) {
        this.sex = sex;
    }

    /**
     * @return password
     */
    public String getPassword() {
        return password;
    }

    /**
     * @param password
     */
    public void setPassword(String password) {
        this.password = password;
    }

    public List<SysRole> getRoleList() {
        return roleList;
    }

    public void setRoleLIst(List<SysRole> roleList) {
        this.roleList = roleList;
    }
}