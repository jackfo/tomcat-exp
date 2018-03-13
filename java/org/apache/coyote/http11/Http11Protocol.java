/*
 *  Licensed to the Apache Software Foundation (ASF) under one or more
 *  contributor license agreements.  See the NOTICE file distributed with
 *  this work for additional information regarding copyright ownership.
 *  The ASF licenses this file to You under the Apache License, Version 2.0
 *  (the "License"); you may not use this file except in compliance with
 *  the License.  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */
package org.apache.coyote.http11;

import java.io.IOException;
import java.net.Socket;
import java.nio.ByteBuffer;

import org.apache.coyote.AbstractProtocol;
import org.apache.coyote.Processor;
import org.apache.coyote.UpgradeToken;
import org.apache.coyote.http11.upgrade.BioProcessor;
import org.apache.juli.logging.Log;
import org.apache.tomcat.util.net.AbstractEndpoint;
import org.apache.tomcat.util.net.JIoEndpoint;
import org.apache.tomcat.util.net.JIoEndpoint.Handler;
import org.apache.tomcat.util.net.SSLImplementation;
import org.apache.tomcat.util.net.SocketWrapper;

/**
 * 实现ProtocolHandler接口,为HTTP1.1而设计的协议处理组件
 * 负责管理Http11ConnectionHandler和JIoEndpoint,前者负责处理HTTP1.1的连接
 * 包括维护请求连接队列，为连接分配线程，设置连接属性等信息；
 * 后者是真正负责监控网络端口的组件，启动一个ServerSocket,不间断监听来自客户端的请求。
 * Http11Protocol还包含了与HTTP1.1相关的许多属性信息,
 * 3个很重要的属性是包含前面提供的两个，还有一个ServerSocketFactory，用于定制ServerSocket。
 * */
public class Http11Protocol extends AbstractHttp11JsseProtocol<Socket> {


    private static final org.apache.juli.logging.Log log
        = org.apache.juli.logging.LogFactory.getLog(Http11Protocol.class);

    @Override
    protected Log getLog() { return log; }


    @Override
    protected AbstractEndpoint.Handler getHandler() {
        return cHandler;
    }


    // ------------------------------------------------------------ Constructor


    public Http11Protocol() {
        endpoint = new JIoEndpoint();
        cHandler = new Http11ConnectionHandler(this);
        ((JIoEndpoint) endpoint).setHandler(cHandler);
        setSoLinger(Constants.DEFAULT_CONNECTION_LINGER);
        setSoTimeout(Constants.DEFAULT_CONNECTION_TIMEOUT);
        setTcpNoDelay(Constants.DEFAULT_TCP_NO_DELAY);
    }


    // ----------------------------------------------------------------- Fields

    private final Http11ConnectionHandler cHandler;


    // ------------------------------------------------ HTTP特定的属性

    /**这个参数是BIO特有的，默认情况BIO在线程池里的线程使用率超过75%时会取消keep-alive，如果不取消的话可以设置为100*/
    private int disableKeepAlivePercentage = 75;
    public int getDisableKeepAlivePercentage() {
        return disableKeepAlivePercentage;
    }
    public void setDisableKeepAlivePercentage(int disableKeepAlivePercentage) {
        if (disableKeepAlivePercentage < 0) {
            this.disableKeepAlivePercentage = 0;
        } else if (disableKeepAlivePercentage > 100) {
            this.disableKeepAlivePercentage = 100;
        } else {
            this.disableKeepAlivePercentage = disableKeepAlivePercentage;
        }
    }


    // ----------------------------------------------------- JMX related methods

    @Override
    protected String getNamePrefix() {
        return ("http-bio");
    }


    // -----------------------------------  Http11ConnectionHandler Inner Class

    protected static class Http11ConnectionHandler
            extends AbstractConnectionHandler<Socket, Http11Processor> implements Handler {

        protected Http11Protocol proto;

        Http11ConnectionHandler(Http11Protocol proto) {
            this.proto = proto;
        }

        @Override
        protected AbstractProtocol<Socket> getProtocol() {
            return proto;
        }

        @Override
        protected Log getLog() {
            return log;
        }

        @Override
        public SSLImplementation getSslImplementation() {
            return proto.sslImplementation;
        }

        /**
         * Expected to be used by the handler once the processor is no longer
         * required.
         *
         * @param socket            Not used in BIO
         * @param processor
         * @param isSocketClosing   Not used in HTTP
         * @param addToPoller       Not used in BIO
         */
        @Override
        public void release(SocketWrapper<Socket> socket,
                Processor<Socket> processor, boolean isSocketClosing,
                boolean addToPoller) {
            processor.recycle(isSocketClosing);
            recycledProcessors.push(processor);
        }

        @Override
        protected void initSsl(SocketWrapper<Socket> socket,
                Processor<Socket> processor) {
            if (proto.isSSLEnabled() && (proto.sslImplementation != null)) {
                processor.setSslSupport(
                        proto.sslImplementation.getSSLSupport(
                                socket.getSocket()));
            } else {
                processor.setSslSupport(null);
            }

        }

        @Override
        protected void longPoll(SocketWrapper<Socket> socket,
                Processor<Socket> processor) {
            // NO-OP
        }

        @Override
        protected Http11Processor createProcessor() {
            Http11Processor processor = new Http11Processor(
                    proto.getMaxHttpHeaderSize(), (JIoEndpoint)proto.endpoint,
                    proto.getMaxTrailerSize(), proto.getAllowedTrailerHeadersAsSet(),
                    proto.getMaxExtensionSize(), proto.getMaxSwallowSize());
            proto.configureProcessor(processor);
            // BIO specific configuration
            processor.setDisableKeepAlivePercentage(proto.getDisableKeepAlivePercentage());
            register(processor);
            return processor;
        }

        @Override
        protected Processor<Socket> createUpgradeProcessor(
                SocketWrapper<Socket> socket, ByteBuffer leftoverInput,
                UpgradeToken upgradeToken)
                throws IOException {
            return new BioProcessor(socket, leftoverInput, upgradeToken,
                    proto.getUpgradeAsyncWriteBufferSize());
        }

        @Override
        public void beforeHandshake(SocketWrapper<Socket> socket) {
        }
    }
}
