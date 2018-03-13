package org.apache.catalina.startup;


import java.lang.reflect.Method;

import org.apache.catalina.Executor;
import org.apache.catalina.Service;
import org.apache.catalina.connector.Connector;
import org.apache.juli.logging.Log;
import org.apache.juli.logging.LogFactory;
import org.apache.tomcat.util.IntrospectionUtils;
import org.apache.tomcat.util.digester.Rule;
import org.apache.util.Debug;
import org.xml.sax.Attributes;


public class ConnectorCreateRule extends Rule {

    public static final String module = ConnectorCreateRule.class.getName();


    /**
     * 获取service实例，尝试获取其线程池
     * 创建Connector实例,如果线程池存在将其注入Connector的协议句柄ProtocolHandler作为其句柄属性
     * */
    @Override
    public void begin(String namespace, String name, Attributes attributes)
            throws Exception {
        //获取栈顶StandardService对象
        Service svc = (Service)digester.peek();
        //获取线程池属性
        java.util.concurrent.Executor ex = null;
        if ( attributes.getValue("executor")!=null ) {
            ex = svc.getExecutor(attributes.getValue("executor"));
        }
        //创建Connector实例
        Connector con = new Connector(attributes.getValue("protocol"));
        //如果ex实例不为空,将它作为Connector句柄注入
        if ( ex != null )  _setExecutor(con,ex);
        //压入digester栈顶
        digester.push(con);
    }

    public void _setExecutor(Connector con, java.util.concurrent.Executor ex) throws Exception {
        Method m = IntrospectionUtils.findMethod(con.getProtocolHandler().getClass(),"setExecutor",new Class[] {java.util.concurrent.Executor.class});
        if (m!=null) {
            m.invoke(con.getProtocolHandler(), new Object[] {ex});
        }else {
            Debug.logWarning("Connector ["+con+"] does not support external executors. Method setExecutor(java.util.concurrent.Executor) not found.",module);

        }
    }

    /**将当前对象压出栈*/
    @Override
    public void end(String namespace, String name) throws Exception {
        digester.pop();
    }


}
