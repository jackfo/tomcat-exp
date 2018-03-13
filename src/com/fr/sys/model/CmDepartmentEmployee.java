package com.fr.sys.model;

import javax.persistence.Column;
import javax.persistence.Id;
import javax.persistence.Table;

@Table(name = "cm_department_employee")
public class CmDepartmentEmployee {
    @Id
    @Column(name = "department_id")
    private String departmentId;

    @Id
    @Column(name = "employee_id")
    private String employeeId;

    /**
     * @return department_id
     */
    public String getDepartmentId() {
        return departmentId;
    }

    /**
     * @param departmentId
     */
    public void setDepartmentId(String departmentId) {
        this.departmentId = departmentId;
    }

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
}