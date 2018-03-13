package org.apache.catalina.util;

import javax.servlet.SessionCookieConfig;

import org.apache.catalina.Context;
import org.apache.util.Debug;

public class SessionConfig {

    public static final String module = SessionConfig.class.getName();

    private static final String DEFAULT_SESSION_COOKIE_NAME = "JSESSIONID";
    private static final String DEFAULT_SESSION_PARAMETER_NAME = "jsessionid";

    /**
     * Determine the name to use for the session cookie for the provided
     * context.
     * @param context
     */
    public static String getSessionCookieName(Context context) {

        String result = getConfiguredSessionCookieName(context);

        if (result == null) {
            result = DEFAULT_SESSION_COOKIE_NAME;
        }

        return result;
    }

    /**
     * Determine the name to use for the session cookie for the provided
     * context.
     * @param context
     */
    public static String getSessionUriParamName(Context context) {
        String result = getConfiguredSessionCookieName(context);
        if (result == null) {
            result = DEFAULT_SESSION_PARAMETER_NAME;
        }
        return result;
    }


    /**
     * 获取配置的sessionCookieName
     * 第一种是配置Web应用的时候 Context标签下
     * 1 <Context path='' docBase='ROOT' sessionCookiePath='/' sessionCookieName='' />
     * 2 <session-config>
     *      <cookie-config>
     *         <name id="sessionId">sessionName</name>
     *      </cookie-config>
     *   </session-config>
     * */
    private static String getConfiguredSessionCookieName(Context context) {

        // Priority is:
        // 1. Cookie name defined in context
        // 2. Cookie name configured for app
        // 3. Default defined by spec
        if (context != null) {
            //获取sessionCookieName,这个来自于解析自己的Context标签
            String cookieName = context.getSessionCookieName();
            if (cookieName != null && cookieName.length() > 0) {
                return cookieName;
            }

            //获取定义在应用的中的web.xml session-config/cookie-config
            SessionCookieConfig scc = context.getServletContext().getSessionCookieConfig();
            cookieName = scc.getName();
            if (cookieName != null && cookieName.length() > 0) {
                return cookieName;
            }
        }

        return null;
    }


    private SessionConfig() {
        Debug.log("实例化SessionConfig",module);
    }
}
