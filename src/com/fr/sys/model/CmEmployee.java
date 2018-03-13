package com.fr.sys.model;

import javax.persistence.*;

@Table(name = "cm_employee")
public class CmEmployee {
    @Id
    @GeneratedValue(generator = "UUID")
    @Column(name = "employee_id")
    private String employeeId;


    @Column(name = "e_sex")
    private String eSex;

    @Column(name = "e_age")
    private String eAge;

    @Column(name = "e_name")
    private String eName;

    /**
     * @return employee_id
     */
    public String getEmployeeId() {
        return employeeId;
    }

    /**
     * @param employeeId
     */
    public void setEmployeeId(String employeeId) {
        this.employeeId = employeeId;
    }

    /**
     * @return e_sex
     */
    public String geteSex() {
        return eSex;
    }

    /**
     * @param eSex
     */
    public void seteSex(String eSex) {
        this.eSex = eSex;
    }

    /**
     * @return e_age
     */
    public String geteAge() {
        return eAge;
    }

    /**
     * @param eAge
     */
    public void seteAge(String eAge) {
        this.eAge = eAge;
    }

    /**
     * @return e_name
     */
    public String geteName() {
        return eName;
    }

    /**
     * @param eName
     */
    public void seteName(String eName) {
        this.eName = eName;
    }
}