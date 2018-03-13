package org.apache.catalina.session;

import java.util.Enumeration;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpSession;

/**
 * StandardSession对象的外观模式
 * */
public class StandardSessionFacade implements HttpSession {

    // ----------------------------------------------------------- Constructors

    /**由于这是一个门面,所以必须存在具体实例,从而没有默认的构造器*/
    public StandardSessionFacade(HttpSession session) {
        this.session = session;
    }


    // ----------------------------------------------------- Instance Variables

    /**封装的session对象*/
    private final HttpSession session;


    //获取Session的创建时间
    @Override
    public long getCreationTime() {
        return session.getCreationTime();
    }

    //获取Session的ID
    @Override
    public String getId() {
        return session.getId();
    }

    //获取最近一次请求的完成时间
    @Override
    public long getLastAccessedTime() {
        return session.getLastAccessedTime();
    }


    @Override
    public ServletContext getServletContext() {
        // FIXME : Facade this object ?
        return session.getServletContext();
    }


    @Override
    public void setMaxInactiveInterval(int interval) {
        session.setMaxInactiveInterval(interval);
    }


    @Override
    public int getMaxInactiveInterval() {
        return session.getMaxInactiveInterval();
    }


    /**
     * @deprecated As of Version 2.1, this method is deprecated and has no
     *             replacement.
     */
    @Override
    @Deprecated
    public javax.servlet.http.HttpSessionContext getSessionContext() {
        return session.getSessionContext();
    }


    @Override
    public Object getAttribute(String name) {
        return session.getAttribute(name);
    }


    /**
     * @deprecated As of Version 2.2, this method is replaced by
     *             {@link #getAttribute}.
     */
    @Override
    @Deprecated
    public Object getValue(String name) {
        return session.getAttribute(name);
    }


    @Override
    public Enumeration<String> getAttributeNames() {
        return session.getAttributeNames();
    }


    /**
     * @deprecated As of Version 2.2, this method is replaced by
     *             {@link #getAttributeNames}
     */
    @Override
    @Deprecated
    public String[] getValueNames() {
        return session.getValueNames();
    }


    @Override
    public void setAttribute(String name, Object value) {
        session.setAttribute(name, value);
    }


    /**
     * @deprecated As of Version 2.2, this method is replaced by
     *             {@link #setAttribute}
     */
    @Override
    @Deprecated
    public void putValue(String name, Object value) {
        session.setAttribute(name, value);
    }


    @Override
    public void removeAttribute(String name) {
        session.removeAttribute(name);
    }


    /**
     * @deprecated As of Version 2.2, this method is replaced by
     *             {@link #removeAttribute}
     */
    @Override
    @Deprecated
    public void removeValue(String name) {
        session.removeAttribute(name);
    }


    @Override
    public void invalidate() {
        session.invalidate();
    }


    @Override
    public boolean isNew() {
        return session.isNew();
    }
}
