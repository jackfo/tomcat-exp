/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.apache.catalina.core;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletResponse;

import org.apache.catalina.Host;
import org.apache.catalina.comet.CometEvent;
import org.apache.catalina.connector.Request;
import org.apache.catalina.connector.Response;
import org.apache.catalina.valves.ValveBase;
import org.apache.tomcat.util.res.StringManager;

/**
 * 当前类不可被继承
 * */
final class StandardEngineValve extends ValveBase {

    //------------------------------------------------------ Constructor
    public StandardEngineValve() {
        super(true);
    }


    // ----------------------------------------------------- Instance Variables

    /**
     * The string manager for this package.
     */
    private static final StringManager sm =
        StringManager.getManager(Constants.Package);


    // --------------------------------------------------------- Public Methods

    /**
     * 基于请求的服务名选择合适的虚拟主机进行请求处理
     *
     * 如果不能匹配到对应主机，返回对应的http错误
     *
     * @param request 执行请求
     * @param response Response to be produced
     *
     */
    @Override
    public final void invoke(Request request, Response response)
        throws IOException, ServletException {

        //根据请求找到对应的host
        Host host = request.getHost();
        if (host == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST,
                 sm.getString("standardEngine.noHost",
                              request.getServerName()));
            return;
        }
        //如果request本身支持异步则将其设置同其管道相同
        if (request.isAsyncSupported()) {
            request.setAsyncSupported(host.getPipeline().isAsyncSupported());
        }

        //org.apache.catalina.valves.AccessLogValve[localhost]
        //org.apache.catalina.valves.ErrorReportValve[localhost]
        //org.apache.catalina.core.StandardHostValve[localhost]
        /**
         * 调用host的第一个valve
         *
         * 其执行原理是获取根据管道获取第一个阀门AccessLogValve调用其invoke方法
         *
         * AccessLogValve的invoke第一行调用getNext().invoke() 调用了ErrorReportValve
         *
         * 同理调用了StandardHostValve的invoke方法 所以实际调用的最先的是invoke方法
         * */
        host.getPipeline().getFirst().invoke(request, response);

    }


    /**
     * Process Comet event.
     *
     * @param request Request to be processed
     * @param response Response to be produced
     * @param event the event
     *
     * @exception IOException if an input/output error occurred
     * @exception ServletException if a servlet error occurred
     */
    @Override
    public final void event(Request request, Response response, CometEvent event)
        throws IOException, ServletException {

        // Ask this Host to process this request
        request.getHost().getPipeline().getFirst().event(request, response, event);

    }

}
