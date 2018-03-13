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
package org.apache.catalina.mapper;

import java.util.ArrayList;
import java.util.List;

import org.apache.catalina.Container;
import org.apache.catalina.ContainerEvent;
import org.apache.catalina.ContainerListener;
import org.apache.catalina.Context;
import org.apache.catalina.Engine;
import org.apache.catalina.Host;
import org.apache.catalina.Lifecycle;
import org.apache.catalina.LifecycleEvent;
import org.apache.catalina.LifecycleException;
import org.apache.catalina.LifecycleListener;
import org.apache.catalina.LifecycleState;
import org.apache.catalina.Service;
import org.apache.catalina.WebResourceRoot;
import org.apache.catalina.Wrapper;
import org.apache.catalina.util.LifecycleMBeanBase;
import org.apache.juli.logging.Log;
import org.apache.juli.logging.LogFactory;
import org.apache.tomcat.util.res.StringManager;
import org.apache.util.Debug;


/**
 * Mapper listener.
 *
 * @author Remy Maucherat
 * @author Costin Manolache
 */
public class MapperListener extends LifecycleMBeanBase
        implements ContainerListener, LifecycleListener {


    private static final Log log = LogFactory.getLog(MapperListener.class);


    // ----------------------------------------------------- Instance Variables
    /**
     * Associated mapper.
     */
    private final Mapper mapper;

    /**
     * Associated service
     */
    private final Service service;


    /**
     * The string manager for this package.
     */
    private static final StringManager sm =
        StringManager.getManager(Constants.Package);

    /**
     * The domain (effectively the engine) this mapper is associated with
     */
    private final String domain = null;

    // ----------------------------------------------------------- Constructors


    /**
     * Create mapper listener.
     */
    public MapperListener(Mapper mapper, Service service) {
        this.mapper = mapper;
        this.service = service;
    }


    // ------------------------------------------------------- Lifecycle Methods

    @Override
    public void startInternal() throws LifecycleException {

        setState(LifecycleState.STARTING);

        //获取当前service的container，其实也就是engine
        @SuppressWarnings("deprecation")
        Engine engine = (Engine) service.getContainer();
        if (engine == null) {
            return;
        }

        findDefaultHost();//获取当前engine默认的host

        addListeners(engine);//给当前Mapper添加监听时间

        //找到当前engine下所有host主机
        Container[] conHosts = engine.findChildren();
        for (Container conHost : conHosts) {
            Host host = (Host) conHost;
            if (!LifecycleState.NEW.equals(host.getState())) {
                // 登记host会注册context和 wrappers
                registerHost(host);
            }
        }
    }


    @Override
    public void stopInternal() throws LifecycleException {
        setState(LifecycleState.STOPPING);

        @SuppressWarnings("deprecation")
        Engine engine = (Engine) service.getContainer();
        if (engine == null) {
            return;
        }
        removeListeners(engine);
    }


    @Override
    protected String getDomainInternal() {
        if (service instanceof LifecycleMBeanBase) {
            return ((LifecycleMBeanBase) service).getDomain();
        } else {
            return null;
        }
    }


    @Override
    protected String getObjectNameKeyProperties() {
        // Same as connector but Mapper rather than Connector
        return ("type=Mapper");
    }

    // --------------------------------------------- Container Listener methods

    @Override
    public void containerEvent(ContainerEvent event) {

        if (Container.ADD_CHILD_EVENT.equals(event.getType())) {
            Container child = (Container) event.getData();
            addListeners(child);
            // If child is started then it is too late for life-cycle listener
            // to register the child so register it here
            if (child.getState().isAvailable()) {
                if (child instanceof Host) {
                    registerHost((Host) child);
                } else if (child instanceof Context) {
                    registerContext((Context) child);
                } else if (child instanceof Wrapper) {
                    // Only if the Context has started. If it has not, then it
                    // will have its own "after_start" life-cycle event later.
                    if (child.getParent().getState().isAvailable()) {
                        registerWrapper((Wrapper) child);
                    }
                }
            }
        } else if (Container.REMOVE_CHILD_EVENT.equals(event.getType())) {
            Container child = (Container) event.getData();
            removeListeners(child);
            // No need to unregister - life-cycle listener will handle this when
            // the child stops
        } else if (Host.ADD_ALIAS_EVENT.equals(event.getType())) {
            // Handle dynamically adding host aliases
            mapper.addHostAlias(((Host) event.getSource()).getName(),
                    event.getData().toString());
        } else if (Host.REMOVE_ALIAS_EVENT.equals(event.getType())) {
            // Handle dynamically removing host aliases
            mapper.removeHostAlias(event.getData().toString());
        } else if (Wrapper.ADD_MAPPING_EVENT.equals(event.getType())) {
            // Handle dynamically adding wrappers
            Wrapper wrapper = (Wrapper) event.getSource();
            Context context = (Context) wrapper.getParent();
            String contextPath = context.getPath();
            if ("/".equals(contextPath)) {
                contextPath = "";
            }
            String version = context.getWebappVersion();
            String hostName = context.getParent().getName();
            String wrapperName = wrapper.getName();
            String mapping = (String) event.getData();
            boolean jspWildCard = ("jsp".equals(wrapperName)
                    && mapping.endsWith("/*"));
            mapper.addWrapper(hostName, contextPath, version, mapping, wrapper,
                    jspWildCard, context.isResourceOnlyServlet(wrapperName));
        } else if (Wrapper.REMOVE_MAPPING_EVENT.equals(event.getType())) {
            // Handle dynamically removing wrappers
            Wrapper wrapper = (Wrapper) event.getSource();

            Context context = (Context) wrapper.getParent();
            String contextPath = context.getPath();
            if ("/".equals(contextPath)) {
                contextPath = "";
            }
            String version = context.getWebappVersion();
            String hostName = context.getParent().getName();

            String mapping = (String) event.getData();

            mapper.removeWrapper(hostName, contextPath, version, mapping);
        } else if (Context.ADD_WELCOME_FILE_EVENT.equals(event.getType())) {
            // Handle dynamically adding welcome files
            Context context = (Context) event.getSource();

            String hostName = context.getParent().getName();

            String contextPath = context.getPath();
            if ("/".equals(contextPath)) {
                contextPath = "";
            }

            String welcomeFile = (String) event.getData();

            mapper.addWelcomeFile(hostName, contextPath,
                    context.getWebappVersion(), welcomeFile);
        } else if (Context.REMOVE_WELCOME_FILE_EVENT.equals(event.getType())) {
            // Handle dynamically removing welcome files
            Context context = (Context) event.getSource();

            String hostName = context.getParent().getName();

            String contextPath = context.getPath();
            if ("/".equals(contextPath)) {
                contextPath = "";
            }

            String welcomeFile = (String) event.getData();

            mapper.removeWelcomeFile(hostName, contextPath,
                    context.getWebappVersion(), welcomeFile);
        } else if (Context.CLEAR_WELCOME_FILES_EVENT.equals(event.getType())) {
            // Handle dynamically clearing welcome files
            Context context = (Context) event.getSource();

            String hostName = context.getParent().getName();

            String contextPath = context.getPath();
            if ("/".equals(contextPath)) {
                contextPath = "";
            }

            mapper.clearWelcomeFiles(hostName, contextPath,
                    context.getWebappVersion());
        }
    }


    // ------------------------------------------------------ Protected Methods

    private void findDefaultHost() {

        @SuppressWarnings("deprecation")
        Engine engine = (Engine) service.getContainer();
        String defaultHost = engine.getDefaultHost();

        boolean found = false;

        if (defaultHost != null && defaultHost.length() >0) {
            Container[] containers = engine.findChildren();

            for (Container container : containers) {
                Host host = (Host) container;
                if (defaultHost.equalsIgnoreCase(host.getName())) {
                    found = true;
                    break;
                }

                String[] aliases = host.findAliases();
                for (String alias : aliases) {
                    if (defaultHost.equalsIgnoreCase(alias)) {
                        found = true;
                        break;
                    }
                }
            }
        }

        if(found) {
            mapper.setDefaultHostName(defaultHost);
        } else {
            log.warn(sm.getString("mapperListener.unknownDefaultHost",
                    defaultHost, service));
        }
    }


    /**注册Host*/
    private void registerHost(Host host) {

        String[] aliases = host.findAliases();
        mapper.addHost(host.getName(), aliases, host);

        for (Container container : host.findChildren()) {
            if (container.getState().isAvailable()) {
                registerContext((Context) container);
            }
        }

        Debug.log(sm.getString("mapperListener.registerHost", host.getName(), domain, service),module);
    }


    /**
     * Unregister host.
     */
    private void unregisterHost(Host host) {

        String hostname = host.getName();

        mapper.removeHost(hostname);

        if(log.isDebugEnabled()) {
            log.debug(sm.getString("mapperListener.unregisterHost", hostname,
                    domain, service));
        }
    }


    /**
     * Unregister wrapper.
     */
    private void unregisterWrapper(Wrapper wrapper) {

        Context context = ((Context) wrapper.getParent());
        String contextPath = context.getPath();
        String wrapperName = wrapper.getName();

        if ("/".equals(contextPath)) {
            contextPath = "";
        }
        String version = context.getWebappVersion();
        String hostName = context.getParent().getName();

        String[] mappings = wrapper.findMappings();

        for (String mapping : mappings) {
            mapper.removeWrapper(hostName, contextPath, version,  mapping);
        }

        if(log.isDebugEnabled()) {
            log.debug(sm.getString("mapperListener.unregisterWrapper",
                    wrapperName, contextPath, service));
        }
    }


    /**
     * Register context.
     */
    private void registerContext(Context context) {

        String contextPath = context.getPath(); //获取context的路径
        if ("/".equals(contextPath)) {
            contextPath = "";
        }
        Host host = (Host)context.getParent(); //获取的其host
        //获取相应的WebResourceRoot实例 在这里是其子类StandardRoot
        WebResourceRoot resources = context.getResources(); //获取root
        String[] welcomeFiles =  context.findWelcomeFiles(); //获取欢迎页


        // 准备context 下的所有 wrapper 信息
        List<WrapperMappingInfo> wrappers = new ArrayList<>();
        for (Container container : context.findChildren()) {
            prepareWrapperMappingInfo(context, (Wrapper) container, wrappers);

            Debug.log(sm.getString("mapperListener.registerWrapper", container.getName(), contextPath, service),module);

        }

        // 添加 contextVersion， 在这里面会将该context下的所有wrapper映射信息也构建
        mapper.addContextVersion(host.getName(), host, contextPath,
                context.getWebappVersion(), context, welcomeFiles, resources,
                wrappers);

        Debug.log(sm.getString("mapperListener.registerContext", contextPath, service),module);
    }


    /**
     * Unregister context.
     */
    private void unregisterContext(Context context) {

        String contextPath = context.getPath();
        if ("/".equals(contextPath)) {
            contextPath = "";
        }
        String hostName = context.getParent().getName();

        if (context.getPaused()) {
            if (log.isDebugEnabled()) {
                log.debug(sm.getString("mapperListener.pauseContext",
                        contextPath, service));
            }

            mapper.pauseContextVersion(context, hostName, contextPath,
                    context.getWebappVersion());
        } else {
            if (log.isDebugEnabled()) {
                log.debug(sm.getString("mapperListener.unregisterContext",
                        contextPath, service));
            }

            mapper.removeContextVersion(context, hostName, contextPath,
                    context.getWebappVersion());
        }
    }


    /**
     * Register wrapper.
     */
    private void registerWrapper(Wrapper wrapper) {

        Context context = (Context) wrapper.getParent();
        String contextPath = context.getPath();
        if ("/".equals(contextPath)) {
            contextPath = "";
        }
        String version = context.getWebappVersion();
        String hostName = context.getParent().getName();

        List<WrapperMappingInfo> wrappers = new ArrayList<>();
        prepareWrapperMappingInfo(context, wrapper, wrappers);
        mapper.addWrappers(hostName, contextPath, version, wrappers);

        if(log.isDebugEnabled()) {
            log.debug(sm.getString("mapperListener.registerWrapper",
                    wrapper.getName(), contextPath, service));
        }
    }

    /**
     * Populate <code>wrappers</code> list with information for registration of
     * mappings for this wrapper in this context.
     *
     * @param context
     * @param wrapper
     * @param wrappers
     */
    private void prepareWrapperMappingInfo(Context context, Wrapper wrapper,
            List<WrapperMappingInfo> wrappers) {
        String wrapperName = wrapper.getName();
        boolean resourceOnly = context.isResourceOnlyServlet(wrapperName);
        String[] mappings = wrapper.findMappings();
        for (String mapping : mappings) {
            boolean jspWildCard = (wrapperName.equals("jsp")
                                   && mapping.endsWith("/*"));
            wrappers.add(new WrapperMappingInfo(mapping, wrapper, jspWildCard,
                    resourceOnly));
        }
    }

    @Override
    public void lifecycleEvent(LifecycleEvent event) {
        if (event.getType().equals(Lifecycle.AFTER_START_EVENT)) {
            Object obj = event.getSource();
            if (obj instanceof Wrapper) {
                Wrapper w = (Wrapper) obj;
                // Only if the Context has started. If it has not, then it will
                // have its own "after_start" event later.
                if (w.getParent().getState().isAvailable()) {
                    registerWrapper(w);
                }
            } else if (obj instanceof Context) {
                Context c = (Context) obj;
                // Only if the Host has started. If it has not, then it will
                // have its own "after_start" event later.
                if (c.getParent().getState().isAvailable()) {
                    registerContext(c);
                }
            } else if (obj instanceof Host) {
                registerHost((Host) obj);
            }
        } else if (event.getType().equals(Lifecycle.BEFORE_STOP_EVENT)) {
            Object obj = event.getSource();
            if (obj instanceof Wrapper) {
                unregisterWrapper((Wrapper) obj);
            } else if (obj instanceof Context) {
                unregisterContext((Context) obj);
            } else if (obj instanceof Host) {
                unregisterHost((Host) obj);
            }
        }
    }


    /**
     * Add this mapper to the container and all child containers
     *
     * @param container
     */
    private void addListeners(Container container) {
        container.addContainerListener(this);//将这个container对象的container事件的监听设置为当前对象
        container.addLifecycleListener(this);//设置当前对象来监听状态事件
        for (Container child : container.findChildren()) {
            addListeners(child);//同时将所有的子container的监听设置为当前对象
        }
    }


    /**
     * Remove this mapper from the container and all child containers
     *
     * @param container
     */
    private void removeListeners(Container container) {
        container.removeContainerListener(this);
        container.removeLifecycleListener(this);
        for (Container child : container.findChildren()) {
            removeListeners(child);
        }
    }
}