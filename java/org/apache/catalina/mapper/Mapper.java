package org.apache.catalina.mapper;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.CopyOnWriteArrayList;

import org.apache.catalina.Context;
import org.apache.catalina.Host;
import org.apache.catalina.WebResource;
import org.apache.catalina.WebResourceRoot;
import org.apache.catalina.Wrapper;
import org.apache.tomcat.util.buf.Ascii;
import org.apache.tomcat.util.buf.CharChunk;
import org.apache.tomcat.util.buf.MessageBytes;
import org.apache.tomcat.util.res.StringManager;
import org.apache.util.Debug;


public final class Mapper {

    public static final String module = Mapper.class.getName();


    private static final org.apache.juli.logging.Log log =
        org.apache.juli.logging.LogFactory.getLog(Mapper.class);

    static final StringManager sm =
        StringManager.getManager(Mapper.class.getPackage().getName());

    // ----------------------------------------------------- Instance Variables


    /**
     * Array containing the virtual hosts definitions.
     */
    volatile MappedHost[] hosts = new MappedHost[0];


    /**
     * Default host name.
     */
    String defaultHostName = null;


    /**
     * Mapping from Context object to Context version to support
     * RequestDispatcher mappings.
     */
    Map<Context, ContextVersion> contextObjectToContextVersionMap =
            new ConcurrentHashMap<>();


    // --------------------------------------------------------- Public Methods

    /**
     * Set default host.
     *
     * @param defaultHostName Default host name
     */
    public void setDefaultHostName(String defaultHostName) {
        this.defaultHostName = defaultHostName;
    }

    /**
     * @author 郑小康
     *
     * 添加host的map信息
     *
     * @param name host的名字
     *
     * @param aliases 别名
     *
     * @param host host对象
     * */
    public synchronized void addHost(String name, String[] aliases,
                                     Host host) {
        //StandardEngine[Catalina].StandardHost[localhost]
        //创建MappedHost对象的数组，这里长度需要加1  创建一个MappedHost数组在原有的hosts长度上加一
        MappedHost[] newHosts = new MappedHost[hosts.length + 1];
        //创建一个MappedHost对象，用于保存host的map信息
        MappedHost newHost = new MappedHost(name, host);
        //insertMap将hosts这个数组迁移到newHosts并将newHost按name添加到指定位置
        if (insertMap(hosts, newHosts, newHost)) {
            hosts = newHosts;   //指向新的数组
            Debug.log(sm.getString("mapper.addHost.success", name),module);
        } else {
            //不能插入这说明有相同名字的,有两种情况，第一种是在先前通过addContextVersion加入让那个newHost指向，另一种名字相同则直接返回
            MappedHost duplicate = hosts[find(hosts, name)];
            if (duplicate.object == host) {
                Debug.log(sm.getString("mapper.addHost.sameHost", name),module);
                newHost = duplicate;
            } else {
                Debug.logError(sm.getString("mapper.duplicateHost", name, duplicate.getRealHostName()),module);
                return;
            }
        }
        List<MappedHost> newAliases = new ArrayList<>(aliases.length);
        for (String alias : aliases) {
            MappedHost newAlias = new MappedHost(alias, newHost);
            if (addHostAliasImpl(newAlias)) {
                newAliases.add(newAlias);
            }
        }
        newHost.addAliases(newAliases);
    }


    /**
     * Remove a host from the mapper.
     *
     * @param name Virtual host name
     */
    public synchronized void removeHost(String name) {
        // Find and remove the old host
        MappedHost host = exactFind(hosts, name);
        if (host == null || host.isAlias()) {
            return;
        }
        MappedHost[] newHosts = hosts.clone();
        // Remove real host and all its aliases
        int j = 0;
        for (int i = 0; i < newHosts.length; i++) {
            if (newHosts[i].getRealHost() != host) {
                newHosts[j++] = newHosts[i];
            }
        }
        hosts = Arrays.copyOf(newHosts, j);
    }

    /**
     * Add an alias to an existing host.
     * @param name  The name of the host
     * @param alias The alias to add
     */
    public synchronized void addHostAlias(String name, String alias) {
        MappedHost realHost = exactFind(hosts, name);
        if (realHost == null) {
            // Should not be adding an alias for a host that doesn't exist but
            // just in case...
            return;
        }
        /**将主机封装到别名Host里面*/
        MappedHost newAlias = new MappedHost(alias, realHost);
        //将这个添加到realHost的alias中
        if (addHostAliasImpl(newAlias)) {
            realHost.addAlias(newAlias);
        }
    }

    private synchronized boolean addHostAliasImpl(MappedHost newAlias) {
        //新建一个MappedHost数组在原有的hosts长度上+1
        MappedHost[] newHosts = new MappedHost[hosts.length + 1];
        //将新的host插入进去
        if (insertMap(hosts, newHosts, newAlias)) {
            hosts = newHosts;
            if (log.isDebugEnabled()) {
                log.debug(sm.getString("mapper.addHostAlias.success",
                        newAlias.name, newAlias.getRealHostName()));
            }
            return true;
        } else {
            //如果没有插入进去获取最近游标,如果name完全相同则返回false,表示为插入成功
            MappedHost duplicate = hosts[find(hosts, newAlias.name)];
            if (duplicate.getRealHost() == newAlias.getRealHost()) {
                // A duplicate Alias for the same Host.
                // A harmless redundancy. E.g.
                // <Host name="localhost"><Alias>localhost</Alias></Host>
                if (log.isDebugEnabled()) {
                    log.debug(sm.getString("mapper.addHostAlias.sameHost",
                            newAlias.name, newAlias.getRealHostName()));
                }
                return false;
            }
            log.error(sm.getString("mapper.duplicateHostAlias", newAlias.name,
                    newAlias.getRealHostName(), duplicate.getRealHostName()));
            return false;
        }
    }

    /**
     * Remove a host alias
     * @param alias The alias to remove
     */
    public synchronized void removeHostAlias(String alias) {
        // Find and remove the alias
        MappedHost hostMapping = exactFind(hosts, alias);
        if (hostMapping == null || !hostMapping.isAlias()) {
            return;
        }
        MappedHost[] newHosts = new MappedHost[hosts.length - 1];
        if (removeMap(hosts, newHosts, alias)) {
            hosts = newHosts;
            hostMapping.getRealHost().removeAlias(hostMapping);
        }

    }

    /**
     * Replace {@link MappedHost#contextList} field in <code>realHost</code> and
     * all its aliases with a new value.
     */
    private void updateContextList(MappedHost realHost,
            ContextList newContextList) {

        realHost.contextList = newContextList;
        for (MappedHost alias : realHost.getAliases()) {
            alias.contextList = newContextList;
        }
    }

    /**
     * Add a new Context to an existing Host.
     *
     * @param hostName Virtual host name this context belongs to
     * @param host Host object
     * @param path Context path
     * @param version Context version
     * @param context Context object
     * @param welcomeResources Welcome files defined for this context
     * @param resources Static resources of the context
     * @deprecated Use {@link #addContextVersion(String, Host, String, String, Context, String[], WebResourceRoot, Collection)}
     */
    @Deprecated
    public void addContextVersion(String hostName, Host host, String path,
            String version, Context context, String[] welcomeResources,
            WebResourceRoot resources) {
        addContextVersion(hostName, host, path, version, context,
                welcomeResources, resources, null);
    }

    /**
     * 为host添加context，其实也就是添加context的map信息
     *
     * 第一个参数是所属的host的名字
     *
     * 第二个是这个context的path(/examples啥的)
     *
     * 第三个是版本，第三个是对应的context对象，接着是首页?，最后是root的资源引用
     */
    public void addContextVersion(String hostName, Host host, String path,
            String version, Context context, String[] welcomeResources,
            WebResourceRoot resources, Collection<WrapperMappingInfo> wrappers) {

        //1. 找到对应的MappedHost，没有就添加到hosts中去
        MappedHost mappedHost  = exactFind(hosts, hostName);
        if (mappedHost == null) {
            addHost(hostName, new String[0], host);
            mappedHost = exactFind(hosts, hostName);  //根据hostName查找其是否存在于hosts，如果不存在就直接进行返回
            if (mappedHost == null) {
                log.error("No host found: " + hostName);
                return;
            }
        }
        //判断是否别名
        if (mappedHost.isAlias()) {
            log.error("No host found: " + hostName);
            return;
        }
        int slashCount = slashCount(path);
        synchronized (mappedHost) {
            //构建ContextVersion
            ContextVersion newContextVersion = new ContextVersion(version,
                    path, slashCount, context, resources, welcomeResources);
            if (wrappers != null) {
                addWrappers(newContextVersion, wrappers);
            }

            //将构建好的ContextVersion添加到MapperHost的contextList中去
            ContextList contextList = mappedHost.contextList;
            MappedContext mappedContext = exactFind(contextList.contexts, path);
            if (mappedContext == null) {
                mappedContext = new MappedContext(path, newContextVersion);
                ContextList newContextList = contextList.addContext(
                        mappedContext, slashCount);
                if (newContextList != null) {
                    updateContextList(mappedHost, newContextList);
                    contextObjectToContextVersionMap.put(context, newContextVersion);
                }
            } else {
                ContextVersion[] contextVersions = mappedContext.versions;
                ContextVersion[] newContextVersions = new ContextVersion[contextVersions.length + 1];
                if (insertMap(contextVersions, newContextVersions,
                        newContextVersion)) {
                    mappedContext.versions = newContextVersions;
                    contextObjectToContextVersionMap.put(context, newContextVersion);
                } else {
                    // Re-registration after Context.reload()
                    // Replace ContextVersion with the new one
                    int pos = find(contextVersions, version);
                    if (pos >= 0 && contextVersions[pos].name.equals(version)) {
                        contextVersions[pos] = newContextVersion;
                        contextObjectToContextVersionMap.put(context, newContextVersion);
                    }
                }
            }
        }

    }


    /**
     * Remove a context from an existing host.
     *
     * @param ctxt      The actual context
     * @param hostName  Virtual host name this context belongs to
     * @param path      Context path
     * @param version   Context version
     */
    public void removeContextVersion(Context ctxt, String hostName,
            String path, String version) {

        contextObjectToContextVersionMap.remove(ctxt);

        MappedHost host = exactFind(hosts, hostName);
        if (host == null || host.isAlias()) {
            return;
        }

        synchronized (host) {
            ContextList contextList = host.contextList;
            MappedContext context = exactFind(contextList.contexts, path);
            if (context == null) {
                return;
            }

            ContextVersion[] contextVersions = context.versions;
            ContextVersion[] newContextVersions =
                new ContextVersion[contextVersions.length - 1];
            if (removeMap(contextVersions, newContextVersions, version)) {
                if (newContextVersions.length == 0) {
                    // Remove the context
                    ContextList newContextList = contextList.removeContext(path);
                    if (newContextList != null) {
                        updateContextList(host, newContextList);
                    }
                } else {
                    context.versions = newContextVersions;
                }
            }
        }
    }


    /**
     * Mark a context as being reloaded. Reversion of this state is performed
     * by calling <code>addContextVersion(...)</code> when context starts up.
     *
     * @param ctxt      The actual context
     * @param hostName  Virtual host name this context belongs to
     * @param contextPath Context path
     * @param version   Context version
     */
    public void pauseContextVersion(Context ctxt, String hostName,
            String contextPath, String version) {

        ContextVersion contextVersion = findContextVersion(hostName,
                contextPath, version, true);
        if (contextVersion == null || !ctxt.equals(contextVersion.object)) {
            return;
        }
        contextVersion.markPaused();
    }


    private ContextVersion findContextVersion(String hostName,
            String contextPath, String version, boolean silent) {
        MappedHost host = exactFind(hosts, hostName);
        if (host == null || host.isAlias()) {
            if (!silent) {
                log.error("No host found: " + hostName);
            }
            return null;
        }
        MappedContext context = exactFind(host.contextList.contexts,
                contextPath);
        if (context == null) {
            if (!silent) {
                log.error("No context found: " + contextPath);
            }
            return null;
        }
        ContextVersion contextVersion = exactFind(context.versions, version);
        if (contextVersion == null) {
            if (!silent) {
                log.error("No context version found: " + contextPath + " "
                        + version);
            }
            return null;
        }
        return contextVersion;
    }


    public void addWrapper(String hostName, String contextPath, String version,
                           String path, Wrapper wrapper, boolean jspWildCard,
                           boolean resourceOnly) {
        ContextVersion contextVersion = findContextVersion(hostName,
                contextPath, version, false);
        if (contextVersion == null) {
            return;
        }
        addWrapper(contextVersion, path, wrapper, jspWildCard, resourceOnly);
    }

    public void addWrappers(String hostName, String contextPath,
            String version, Collection<WrapperMappingInfo> wrappers) {
        ContextVersion contextVersion = findContextVersion(hostName,
                contextPath, version, false);
        if (contextVersion == null) {
            return;
        }
        addWrappers(contextVersion, wrappers);
    }

    /**
     * Adds wrappers to the given context.
     *
     * @param contextVersion The context to which to add the wrappers
     * @param wrappers Information on wrapper mappings
     */
    private void addWrappers(ContextVersion contextVersion,
            Collection<WrapperMappingInfo> wrappers) {
        for (WrapperMappingInfo wrapper : wrappers) {
            addWrapper(contextVersion, wrapper.getMapping(),
                    wrapper.getWrapper(), wrapper.isJspWildCard(),
                    wrapper.isResourceOnly());
        }
    }

    /**
     * Adds a wrapper to the given context.
     *
     * @param context The context to which to add the wrapper
     * @param path Wrapper mapping
     * @param wrapper The Wrapper object
     * @param jspWildCard true if the wrapper corresponds to the JspServlet
     *   and the mapping path contains a wildcard; false otherwise
     * @param resourceOnly true if this wrapper always expects a physical
     *                     resource to be present (such as a JSP)
     */
    protected void addWrapper(ContextVersion context, String path,
            Wrapper wrapper, boolean jspWildCard, boolean resourceOnly) {

        synchronized (context) {
            if (path.endsWith("/*")) { //如果path的map是通配符类型的
                //如果以*结尾,阶段字符串
                String name = path.substring(0, path.length() - 2); //将/*去掉
                MappedWrapper newWrapper = new MappedWrapper(name, wrapper,
                        jspWildCard, resourceOnly);
                MappedWrapper[] oldWrappers = context.wildcardWrappers; // 获取通配符匹配的mappedWrapper数组
                MappedWrapper[] newWrappers = new MappedWrapper[oldWrappers.length + 1]; //将长度加1
                if (insertMap(oldWrappers, newWrappers, newWrapper)) {
                    context.wildcardWrappers = newWrappers;
                    int slashCount = slashCount(newWrapper.name);
                    if (slashCount > context.nesting) {
                        context.nesting = slashCount;  //更新当前context拥有的servlet的path里面最多的斜线数目
                    }
                }
            } else if (path.startsWith("*.")) {   //表示是扩展名的mapper
                // Extension wrapper
                String name = path.substring(2);
                MappedWrapper newWrapper = new MappedWrapper(name, wrapper,
                        jspWildCard, resourceOnly);
                MappedWrapper[] oldWrappers = context.extensionWrappers; //获取扩展名匹配的mappedWrapper的数组
                MappedWrapper[] newWrappers =
                    new MappedWrapper[oldWrappers.length + 1];
                if (insertMap(oldWrappers, newWrappers, newWrapper)) {
                    context.extensionWrappers = newWrappers;
                }
            } else if (path.equals("/")) { // 表示是默认的wrapper
                // Default wrapper
                MappedWrapper newWrapper = new MappedWrapper("", wrapper,
                        jspWildCard, resourceOnly);
                context.defaultWrapper = newWrapper;
            } else {  //最后就是精确的map了
                // Exact wrapper
                final String name;
                if (path.length() == 0) {
                    // Special case for the Context Root mapping which is
                    // treated as an exact match
                    name = "/";
                } else {
                    name = path;
                }
                MappedWrapper newWrapper = new MappedWrapper(name, wrapper,
                        jspWildCard, resourceOnly);
                MappedWrapper[] oldWrappers = context.exactWrappers;
                MappedWrapper[] newWrappers = new MappedWrapper[oldWrappers.length + 1];
                if (insertMap(oldWrappers, newWrappers, newWrapper)) {
                    context.exactWrappers = newWrappers;
                }
            }
        }
    }


    /**
     * Remove a wrapper from an existing context.
     *
     * @param hostName Virtual host name this wrapper belongs to
     * @param contextPath Context path this wrapper belongs to
     * @param path Wrapper mapping
     */
    public void removeWrapper(String hostName, String contextPath,
            String version, String path) {
        ContextVersion contextVersion = findContextVersion(hostName,
                contextPath, version, true);
        if (contextVersion == null || contextVersion.isPaused()) {
            return;
        }
        removeWrapper(contextVersion, path);
    }

    protected void removeWrapper(ContextVersion context, String path) {

        if (log.isDebugEnabled()) {
            log.debug(sm.getString("mapper.removeWrapper", context.name, path));
        }

        synchronized (context) {
            if (path.endsWith("/*")) {
                // Wildcard wrapper
                String name = path.substring(0, path.length() - 2);
                MappedWrapper[] oldWrappers = context.wildcardWrappers;
                if (oldWrappers.length == 0) {
                    return;
                }
                MappedWrapper[] newWrappers =
                    new MappedWrapper[oldWrappers.length - 1];
                if (removeMap(oldWrappers, newWrappers, name)) {
                    // Recalculate nesting
                    context.nesting = 0;
                    for (int i = 0; i < newWrappers.length; i++) {
                        int slashCount = slashCount(newWrappers[i].name);
                        if (slashCount > context.nesting) {
                            context.nesting = slashCount;
                        }
                    }
                    context.wildcardWrappers = newWrappers;
                }
            } else if (path.startsWith("*.")) {
                // Extension wrapper
                String name = path.substring(2);
                MappedWrapper[] oldWrappers = context.extensionWrappers;
                if (oldWrappers.length == 0) {
                    return;
                }
                MappedWrapper[] newWrappers =
                    new MappedWrapper[oldWrappers.length - 1];
                if (removeMap(oldWrappers, newWrappers, name)) {
                    context.extensionWrappers = newWrappers;
                }
            } else if (path.equals("/")) {
                // Default wrapper
                context.defaultWrapper = null;
            } else {
                // Exact wrapper
                String name;
                if (path.length() == 0) {
                    // Special case for the Context Root mapping which is
                    // treated as an exact match
                    name = "/";
                } else {
                    name = path;
                }
                MappedWrapper[] oldWrappers = context.exactWrappers;
                if (oldWrappers.length == 0) {
                    return;
                }
                MappedWrapper[] newWrappers =
                    new MappedWrapper[oldWrappers.length - 1];
                if (removeMap(oldWrappers, newWrappers, name)) {
                    context.exactWrappers = newWrappers;
                }
            }
        }
    }


    /**
     * Add a welcome file to the given context.
     *
     * @param hostName
     * @param contextPath
     * @param welcomeFile
     */
    public void addWelcomeFile(String hostName, String contextPath,
            String version, String welcomeFile) {
        ContextVersion contextVersion = findContextVersion(hostName,
                contextPath, version, false);
        if (contextVersion == null) {
            return;
        }
        int len = contextVersion.welcomeResources.length + 1;
        String[] newWelcomeResources = new String[len];
        System.arraycopy(contextVersion.welcomeResources, 0,
                newWelcomeResources, 0, len - 1);
        newWelcomeResources[len - 1] = welcomeFile;
        contextVersion.welcomeResources = newWelcomeResources;
    }

    /**
     * Remove a welcome file from the given context.
     *
     * @param hostName
     * @param contextPath
     * @param welcomeFile
     */
    public void removeWelcomeFile(String hostName, String contextPath,
            String version, String welcomeFile) {
        ContextVersion contextVersion = findContextVersion(hostName,
                contextPath, version, false);
        if (contextVersion == null || contextVersion.isPaused()) {
            return;
        }
        int match = -1;
        for (int i = 0; i < contextVersion.welcomeResources.length; i++) {
            if (welcomeFile.equals(contextVersion.welcomeResources[i])) {
                match = i;
                break;
            }
        }
        if (match > -1) {
            int len = contextVersion.welcomeResources.length - 1;
            String[] newWelcomeResources = new String[len];
            System.arraycopy(contextVersion.welcomeResources, 0,
                    newWelcomeResources, 0, match);
            if (match < len) {
                System.arraycopy(contextVersion.welcomeResources, match + 1,
                        newWelcomeResources, match, len - match);
            }
            contextVersion.welcomeResources = newWelcomeResources;
        }
    }

    /**
     * Clear the welcome files for the given context.
     *
     * @param hostName
     * @param contextPath
     */
    public void clearWelcomeFiles(String hostName, String contextPath,
            String version) {
        ContextVersion contextVersion = findContextVersion(hostName,
                contextPath, version, false);
        if (contextVersion == null) {
            return;
        }
        contextVersion.welcomeResources = new String[0];
    }

    /**
     * Map the specified host name and URI, mutating the given mapping data.
     *
     * @param host Virtual host name
     * @param uri URI
     * @param mappingData This structure will contain the result of the mapping
     *                    operation
     * @throws IOException if the buffers are too small to hold the results of
     *                     the mapping.
     */
    public void map(MessageBytes host, MessageBytes uri, String version,
                    MappingData mappingData) throws IOException {
        //如果主机为空,设置默认主机名
        if (host.isNull()) {
            host.getCharChunk().append(defaultHostName);
        }
        host.toChars();
        uri.toChars();
        internalMap(host.getCharChunk(), uri.getCharChunk(), version,
                mappingData);

    }


    /**
     * Map the specified URI relative to the context,
     * mutating the given mapping data.
     *
     * @param context The actual context
     * @param uri URI
     * @param mappingData This structure will contain the result of the mapping
     *                    operation
     * @throws IOException if the buffers are too small to hold the results of
     *                     the mapping.
     */
    public void map(Context context, MessageBytes uri,
            MappingData mappingData) throws IOException {

        ContextVersion contextVersion =
                contextObjectToContextVersionMap.get(context);
        uri.toChars();
        CharChunk uricc = uri.getCharChunk();
        uricc.setLimit(-1);
        internalMapWrapper(contextVersion, uricc, mappingData);

    }


    // -------------------------------------------------------- Private Methods


    /**
     * Map the specified URI.
     * @throws IOException
     */
    private final void internalMap(CharChunk host, CharChunk uri,
            String version, MappingData mappingData) throws IOException {

        if (mappingData.host != null) {
            throw new AssertionError();
        }
        uri.setLimit(-1);
        //虚拟主机映射
        //获取所有的主机
        MappedHost[] hosts = this.hosts;
        //根据host字符忽略大小写，找到对应的虚拟主机
        MappedHost mappedHost = exactFindIgnoreCase(hosts, host);
        //如果没有找到匹配的，则获取默认的主机，为什么会存在找不到，是因为根据域名可以获取对应的ip
        if (mappedHost == null) {
            if (defaultHostName == null) {
                return;
            }
            mappedHost = exactFind(hosts, defaultHostName);
            if (mappedHost == null) {
                return;
            }
        }
        //将查找到的Host更新到mappingData
        mappingData.host = mappedHost.object;

        //获取对应的Host中的context集合 即web应用
        ContextList contextList = mappedHost.contextList;
        MappedContext[] contexts = contextList.contexts;
        //根据uri记性二分查找，查找到对应contexts的游标,进而找到对应的context
        int pos = find(contexts, uri);
        //如果没有找到则直接返回
        if (pos == -1) {
            return;
        }

        int lastSlash = -1;
        //获取uri结束位置
        int uriEnd = uri.getEnd();
        int length = -1;
        boolean found = false;
        MappedContext context = null;
        //第一遍寻找的是   应用名/资源名   或者 应用名 这种形式找到Context
        //如果没有找到继续循环
        while (pos >= 0) {//用于从context列表中寻找最匹配的Context
            //根据uri找到的对应的游标，找到其context
            context = contexts[pos];
            //如果uri等于context名称或者以context+"/"开头，找到并跳出while循环
            if (uri.startsWith(context.name)) {
                //获取context的name的长度
                length = context.name.length();
                //如果长度完全相等即uri后面部分完全是context内容  注：找到了就会跳出，即当前Context
                if (uri.getLength() == length) {
                    found = true;
                    break;
                    //如果从context.name这个长度后面一/开始，标识context也找到 剩下是请求内容 形式如:context/具体请求
                } else if (uri.startsWithIgnoreCase("/", length)) {
                    found = true;
                    break;
                }
            }

            //这里标识并没有找到，进行截断然后设置为end 继续根据uri找到对应Context的pos 如果存在相似（或者完全一样）继续循环
            //NOTE:这里的作用是第一次没有找到然后开始进行截断 继续寻找进行匹配
            //目的:  A/B/C/D  先匹配A/B/C Context 存在返回  不存在继续循环匹配A/B Context 在匹配AContext
            if (lastSlash == -1) {
                lastSlash = nthSlash(uri, contextList.nesting + 1);
            } else {
                lastSlash = lastSlash(uri);
            }
            uri.setEnd(lastSlash);
            //根据截断的uri找到对应的Context
            pos = find(contexts, uri);
        }
        uri.setEnd(uriEnd);

        //表示在寻找Context的时候 如果没有找到 匹配 第一个是空字符串的Context应用 <Context Path="" docBase="........"/>
        if (!found) {
            if (contexts[0].name.equals("")) {
                context = contexts[0];
            } else {
                context = null;
            }
        }
        //如果找不到那么应用就请求不到了, 返回空
        if (context == null) {
            return;
        }

        /**
         * 如果context有效，则映射对应的MappedWrapper
         * MappedWrapper分为defaultWrapper(默认) exactWrappers(精确)
         * wildcardWrappers(前缀加通配符匹配)
         * extensionWrappers(扩展名匹配Wrapper)
         *
         * 例子：
         *   ／* wildcardWrappers
         *    *. extensionWrappers
         *    *.action
         */

        //设置当前的mappingData的contextPath为寻找到的context的name
        mappingData.contextPath.setString(context.name);

        ContextVersion contextVersion = null;
        //获取当前context的版本集合
        ContextVersion[] contextVersions = context.versions;
        final int versionCount = contextVersions.length;
        if (versionCount > 1) {
            Context[] contextObjects = new Context[contextVersions.length];
            for (int i = 0; i < contextObjects.length; i++) {
                contextObjects[i] = contextVersions[i].object;
            }
            mappingData.contexts = contextObjects;
            if (version != null) {
                contextVersion = exactFind(contextVersions, version);
            }
        }
        if (contextVersion == null) {
            //如果版本号为空,返回最后的版本号
            contextVersion = contextVersions[versionCount - 1];
        }
        //将对应contextVersion的object赋值给当前context
        mappingData.context = contextVersion.object;
        mappingData.contextSlashCount = contextVersion.slashCount;//斜杠数量

        // Wrapper mapping
        if (!contextVersion.isPaused()) {
            internalMapWrapper(contextVersion, uri, mappingData);
        }

    }


    /**
     * a: 对全新的路径进行精准匹配
     * b: 对全新的路径进行通配符匹配
     * c: 根据全新的路径，进行查找是否存在相应的文件，如果存在相应的文件，则需要将该文件返回。在返回前我们需要进一步确认，这个文件是不是讲文件内容源码返回，还是像jsp文件一样，进行一定的处理然后再返回，所以又要确认下文件的扩展名是怎样的
     *    c1: 尝试寻找能够处理该文件扩展名的servlet，即进行扩展名匹配,如果找到，则使用对应的servlet
     *    c2: 如果没找到，则默认使用defaultWrapper，即DefaultServlet（它只会将文件内容源码返回，不做任何处理）
     *  d: 对全新的路径进行扩展名匹配（与c的目的不同，c的主要目的是想返回一个文件的内容，在返回内容前涉及到扩展名匹配，所以4c的前提是存在对应路径的文件）

     * 案例1： a.html，a、b没有匹配到，到c的时候，找到了该文件，然后又尝试扩展名匹配，来决定是走c1还是c2，由于.html还没有对应的servlet来处理，就使用了默认的DefaultServlet
     * 案例2： a.jsp，同上，在走到c的时候，找到了处理.jsp对应的servlet，所以走了c1
     * 案例3： a.action,如果根目录下有a.action文件，则走到c1的时候，进行扩展名匹配，匹配到了SecondServlet，即走了c1，使用SecondServlet来处理请求；如果根目录下没有a.action文件，则走到了d，进行扩展名匹配，同样匹配到了SecondServlet，即走了d，同样使用SecondServlet来处理请求
     * 案例4： first/abc，执行b的时候，就匹配到了FirstServlet，所以使用FirstServlet来处理请求
     * */
    private final void internalMapWrapper(ContextVersion contextVersion,
                                          CharChunk path,
                                          MappingData mappingData) throws IOException {
        //获取路径开始的位置
        int pathOffset = path.getOffset();
        //获取路径结束的位置
        int pathEnd = path.getEnd();
        boolean noServletPath = false;
        //获取context的长度
        int length = contextVersion.path.length();
        //如果长度和uri长度完全相等则返回true
        if (length == (pathEnd - pathOffset)) {
            noServletPath = true;
        }
        //获取context的长度然后设置为uri的path的新索引
        int servletPath = pathOffset + length;
        path.setOffset(servletPath);

        //根据路径精确匹配
        //获取当前Context中所有的exactWrappers
        MappedWrapper[] exactWrappers = contextVersion.exactWrappers;
        internalMapExactWrapper(exactWrappers, path, mappingData);

        // Rule 2 -- Prefix Match
        boolean checkJspWelcomeFiles = false;
        //获取所有通配的Wrapper
        MappedWrapper[] wildcardWrappers = contextVersion.wildcardWrappers;
        if (mappingData.wrapper == null) {
            internalMapWildcardWrapper(wildcardWrappers, contextVersion.nesting,
                                       path, mappingData);
            //如果找到通配的 且是jspWildCard 即*.jsp
            if (mappingData.wrapper != null && mappingData.jspWildCard) {
                char[] buf = path.getBuffer();
                if (buf[pathEnd - 1] == '/') {
                    //设置wrapper为空，checkJspWelcomeFiles为true
                    mappingData.wrapper = null;
                    checkJspWelcomeFiles = true;
                } else {
                    // See Bugzilla 27704
                    mappingData.wrapperPath.setChars(buf, path.getStart(),
                                                     path.getLength());
                    mappingData.pathInfo.recycle();
                }
            }
        }

        if(mappingData.wrapper == null && noServletPath &&
                contextVersion.object.getMapperContextRootRedirectEnabled()) {
            // The path is empty, redirect to "/"
            path.append('/');
            pathEnd = path.getEnd();
            mappingData.redirectPath.setChars
                (path.getBuffer(), pathOffset, pathEnd - pathOffset);
            path.setEnd(pathEnd - 1);
            return;
        }

        // Rule 3 -- Extension Match
        MappedWrapper[] extensionWrappers = contextVersion.extensionWrappers;
        if (mappingData.wrapper == null && !checkJspWelcomeFiles) {
            internalMapExtensionWrapper(extensionWrappers, path, mappingData,
                    true);
        }

        // Rule 4 -- Welcome resources processing for servlets
        if (mappingData.wrapper == null) {
            boolean checkWelcomeFiles = checkJspWelcomeFiles;
            if (!checkWelcomeFiles) {
                char[] buf = path.getBuffer();
                checkWelcomeFiles = (buf[pathEnd - 1] == '/');
            }
            if (checkWelcomeFiles) {
                for (int i = 0; (i < contextVersion.welcomeResources.length)
                         && (mappingData.wrapper == null); i++) {
                    path.setOffset(pathOffset);
                    path.setEnd(pathEnd);
                    path.append(contextVersion.welcomeResources[i], 0,
                            contextVersion.welcomeResources[i].length());
                    path.setOffset(servletPath);

                    // Rule 4a -- Welcome resources processing for exact macth
                    internalMapExactWrapper(exactWrappers, path, mappingData);

                    // Rule 4b -- Welcome resources processing for prefix match
                    if (mappingData.wrapper == null) {
                        internalMapWildcardWrapper
                            (wildcardWrappers, contextVersion.nesting,
                             path, mappingData);
                    }

                    // Rule 4c -- Welcome resources processing
                    //            for physical folder
                    if (mappingData.wrapper == null
                        && contextVersion.resources != null) {
                        String pathStr = path.toString();
                        WebResource file =
                                contextVersion.resources.getResource(pathStr);
                        if (file != null && file.isFile()) {
                            internalMapExtensionWrapper(extensionWrappers, path,
                                                        mappingData, true);
                            if (mappingData.wrapper == null
                                && contextVersion.defaultWrapper != null) {
                                mappingData.wrapper =
                                    contextVersion.defaultWrapper.object;
                                mappingData.requestPath.setChars
                                    (path.getBuffer(), path.getStart(),
                                     path.getLength());
                                mappingData.wrapperPath.setChars
                                    (path.getBuffer(), path.getStart(),
                                     path.getLength());
                                mappingData.requestPath.setString(pathStr);
                                mappingData.wrapperPath.setString(pathStr);
                            }
                        }
                    }
                }

                path.setOffset(servletPath);
                path.setEnd(pathEnd);
            }

        }

        /* welcome file processing - take 2
         * Now that we have looked for welcome files with a physical
         * backing, now look for an extension mapping listed
         * but may not have a physical backing to it. This is for
         * the case of index.jsf, index.do, etc.
         * A watered down version of rule 4
         */
        if (mappingData.wrapper == null) {
            boolean checkWelcomeFiles = checkJspWelcomeFiles;
            if (!checkWelcomeFiles) {
                char[] buf = path.getBuffer();
                checkWelcomeFiles = (buf[pathEnd - 1] == '/');
            }
            if (checkWelcomeFiles) {
                for (int i = 0; (i < contextVersion.welcomeResources.length)
                         && (mappingData.wrapper == null); i++) {
                    path.setOffset(pathOffset);
                    path.setEnd(pathEnd);
                    path.append(contextVersion.welcomeResources[i], 0,
                                contextVersion.welcomeResources[i].length());
                    path.setOffset(servletPath);
                    internalMapExtensionWrapper(extensionWrappers, path,
                                                mappingData, false);
                }

                path.setOffset(servletPath);
                path.setEnd(pathEnd);
            }
        }


        // Rule 7 -- Default servlet
        if (mappingData.wrapper == null && !checkJspWelcomeFiles) {
            if (contextVersion.defaultWrapper != null) {
                mappingData.wrapper = contextVersion.defaultWrapper.object;
                mappingData.requestPath.setChars
                    (path.getBuffer(), path.getStart(), path.getLength());
                mappingData.wrapperPath.setChars
                    (path.getBuffer(), path.getStart(), path.getLength());
            }
            // Redirection to a folder
            char[] buf = path.getBuffer();
            if (contextVersion.resources != null && buf[pathEnd -1 ] != '/') {
                String pathStr = path.toString();
                WebResource file;
                // Handle context root
                if (pathStr.length() == 0) {
                    file = contextVersion.resources.getResource("/");
                } else {
                    file = contextVersion.resources.getResource(pathStr);
                }
                if (file != null && file.isDirectory() && contextVersion.object.getMapperDirectoryRedirectEnabled()) {
                    // Note: this mutates the path: do not do any processing
                    // after this (since we set the redirectPath, there shouldn't be any)
                    path.setOffset(pathOffset);
                    path.append('/');
                    mappingData.redirectPath.setChars(path.getBuffer(), path.getStart(), path.getLength());
                } else {
                    mappingData.requestPath.setString(pathStr);
                    mappingData.wrapperPath.setString(pathStr);
                }
            }
        }

        path.setOffset(pathOffset);
        path.setEnd(pathEnd);
    }


    /**
     * Exact mapping.
     */
    private final void internalMapExactWrapper(MappedWrapper[] wrappers, CharChunk path, MappingData mappingData) {
        //根据路径获取wrapper
        MappedWrapper wrapper = exactFind(wrappers, path);
        //如果wrapper不为空
        if (wrapper != null) {
            //设置请求name为wrapper的name
            mappingData.requestPath.setString(wrapper.name);
            //设置wrapper实例为mappingData的实例
            mappingData.wrapper = wrapper.object;
            //如果路径是/
            if (path.equals("/")) {
                // Special handling for Context Root mapped servlet
                mappingData.pathInfo.setString("/");
                mappingData.wrapperPath.setString("");
                mappingData.contextPath.setString("");
            } else {
                mappingData.wrapperPath.setString(wrapper.name);
            }
        }
    }


    /**
     * Wildcard mapping.
     */
    private final void internalMapWildcardWrapper
        (MappedWrapper[] wrappers, int nesting, CharChunk path,
         MappingData mappingData) {

        int pathEnd = path.getEnd();

        int lastSlash = -1;
        int length = -1;
        int pos = find(wrappers, path);
        if (pos != -1) {
            boolean found = false;
            while (pos >= 0) {
                if (path.startsWith(wrappers[pos].name)) {
                    length = wrappers[pos].name.length();
                    if (path.getLength() == length) {
                        found = true;
                        break;
                    } else if (path.startsWithIgnoreCase("/", length)) {
                        found = true;
                        break;
                    }
                }
                if (lastSlash == -1) {
                    lastSlash = nthSlash(path, nesting + 1);
                } else {
                    lastSlash = lastSlash(path);
                }
                path.setEnd(lastSlash);
                pos = find(wrappers, path);
            }
            path.setEnd(pathEnd);
            if (found) {
                mappingData.wrapperPath.setString(wrappers[pos].name);
                if (path.getLength() > length) {
                    mappingData.pathInfo.setChars
                        (path.getBuffer(),
                         path.getOffset() + length,
                         path.getLength() - length);
                }
                mappingData.requestPath.setChars
                    (path.getBuffer(), path.getOffset(), path.getLength());
                mappingData.wrapper = wrappers[pos].object;
                mappingData.jspWildCard = wrappers[pos].jspWildCard;
            }
        }
    }


    /**
     * Extension mappings.
     *
     * @param wrappers          Set of wrappers to check for matches
     * @param path              Path to map
     * @param mappingData       Mapping data for result
     * @param resourceExpected  Is this mapping expecting to find a resource
     */
    private final void internalMapExtensionWrapper(MappedWrapper[] wrappers,
            CharChunk path, MappingData mappingData, boolean resourceExpected) {
        char[] buf = path.getBuffer();
        int pathEnd = path.getEnd();
        int servletPath = path.getOffset();
        int slash = -1;
        for (int i = pathEnd - 1; i >= servletPath; i--) {
            if (buf[i] == '/') {
                slash = i;
                break;
            }
        }
        if (slash >= 0) {
            int period = -1;
            for (int i = pathEnd - 1; i > slash; i--) {
                if (buf[i] == '.') {
                    period = i;
                    break;
                }
            }
            if (period >= 0) {
                path.setOffset(period + 1);
                path.setEnd(pathEnd);
                MappedWrapper wrapper = exactFind(wrappers, path);
                if (wrapper != null
                        && (resourceExpected || !wrapper.resourceOnly)) {
                    mappingData.wrapperPath.setChars(buf, servletPath, pathEnd
                            - servletPath);
                    mappingData.requestPath.setChars(buf, servletPath, pathEnd
                            - servletPath);
                    mappingData.wrapper = wrapper.object;
                }
                path.setOffset(servletPath);
                path.setEnd(pathEnd);
            }
        }
    }


    /**
     * Find a map element given its name in a sorted array of map elements.
     * This will return the index for the closest inferior or equal item in the
     * given array.
     */
    private static final <T> int find(MapElement<T>[] map, CharChunk name) {
        return find(map, name, name.getStart(), name.getEnd());
    }


    /**
     * Find a map element given its name in a sorted array of map elements.
     * This will return the index for the closest inferior or equal item in the
     * given array.
     */
    private static final <T> int find(MapElement<T>[] map, CharChunk name,
                                  int start, int end) {

        int a = 0;
        //获取map元素的大小
        int b = map.length - 1;
        //如果等于-1表示map不存在元素,返回-1
        if (b == -1) {
            return -1;
        }

        //如果比第一个还小则返回-1
        if (compare(name, start, end, map[0].name) < 0 ) {
            return -1;
        }
        //在比一个大且map的长度为1,则返回0
        if (b == 0) {
            return 0;
        }

        //开始进行二分查找,找到与其字符串匹配最近的
        int i = 0;
        while (true) {
            i = (b + a) / 2;
            int result = compare(name, start, end, map[i].name);
            if (result == 1) {
                a = i;
            } else if (result == 0) {
                return i;
            } else {
                b = i;
            }
            if ((b - a) == 1) {
                int result2 = compare(name, start, end, map[b].name);
                if (result2 < 0) {
                    return a;
                } else {
                    return b;
                }
            }
        }

    }

    /**
     * Find a map element given its name in a sorted array of map elements.
     * This will return the index for the closest inferior or equal item in the
     * given array.
     */
    private static final <T> int findIgnoreCase(MapElement<T>[] map, CharChunk name) {
        return findIgnoreCase(map, name, name.getStart(), name.getEnd());
    }


    /**
     * Find a map element given its name in a sorted array of map elements.
     * This will return the index for the closest inferior or equal item in the
     * given array.
     */
    private static final <T> int findIgnoreCase(MapElement<T>[] map, CharChunk name, int start, int end) {

        int a = 0;
        int b = map.length - 1;

        // Special cases: -1 and 0
        if (b == -1) {
            return -1;
        }
        if (compareIgnoreCase(name, start, end, map[0].name) < 0 ) {
            return -1;
        }
        if (b == 0) {
            return 0;
        }

        int i = 0;
        while (true) {
            i = (b + a) / 2;
            int result = compareIgnoreCase(name, start, end, map[i].name);
            if (result == 1) {
                a = i;
            } else if (result == 0) {
                return i;
            } else {
                b = i;
            }
            if ((b - a) == 1) {
                int result2 = compareIgnoreCase(name, start, end, map[b].name);
                if (result2 < 0) {
                    return a;
                } else {
                    return b;
                }
            }
        }

    }


    /**
     * Find a map element given its name in a sorted array of map elements.
     * This will return the index for the closest inferior or equal item in the
     * given array.
     * @see #exactFind(MapElement[], String)
     */
    private static final <T> int find(MapElement<T>[] map, String name) {

        int a = 0;
        int b = map.length - 1;

        // Special cases: -1 and 0
        if (b == -1) {
            return -1;
        }

        if (name.compareTo(map[0].name) < 0) {
            return -1;
        }
        if (b == 0) {
            return 0;
        }

        int i = 0;
        while (true) {
            i = (b + a) / 2;
            int result = name.compareTo(map[i].name);
            if (result > 0) {
                a = i;
            } else if (result == 0) {
                return i;
            } else {
                b = i;
            }
            if ((b - a) == 1) {
                int result2 = name.compareTo(map[b].name);
                if (result2 < 0) {
                    return a;
                } else {
                    return b;
                }
            }
        }

    }


    /**
     * 查到到根据与name根据首字母最接近的游标
     *
     * 比较是否与当前name完全相同,完全相同则返回
     */
    private static final <T, E extends MapElement<T>> E exactFind(E[] map,
            String name) {
        //查到到根据与name根据首字母最接近的游标
        int pos = find(map, name);
        if (pos >= 0) {
            E result = map[pos];
            if (name.equals(result.name)) {
                return result;
            }
        }
        return null;
    }

    /**
     * 根据指定的name在排序的map元素中找到指定的map
     * 如果存在会返回你需要的元素,否则返回空
     */
    private static final <T, E extends MapElement<T>> E exactFind(E[] map,
            CharChunk name) {
        int pos = find(map, name);
        if (pos >= 0) {
            E result = map[pos];
            if (name.equals(result.name)) {
                return result;
            }
        }
        return null;
    }

    /**
     * Find a map element given its name in a sorted array of map elements. This
     * will return the element that you were searching for. Otherwise it will
     * return <code>null</code>.
     * @see #findIgnoreCase(MapElement[], CharChunk)
     */
    private static final <T, E extends MapElement<T>> E exactFindIgnoreCase(
            E[] map, CharChunk name) {
        int pos = findIgnoreCase(map, name);
        if (pos >= 0) {
            E result = map[pos];
            if (name.equalsIgnoreCase(result.name)) {
                return result;
            }
        }
        return null;
    }


    /**
     * Compare given char chunk with String.
     * Return -1, 0 or +1 if inferior, equal, or superior to the String.
     */
    private static final int compare(CharChunk name, int start, int end,
                                     String compareTo) {
        int result = 0;
        //获取name的字符型数组
        char[] c = name.getBuffer();
        //获取compareTo的长度
        int len = compareTo.length();
        //如果compareTo的长度大于将其设置为name的长度
        if ((end - start) < len) {
            len = end - start;
        }
        //循环遍历找到第一个不同的字符，如果name的大返回1 如果name的小返回-1
        for (int i = 0; (i < len) && (result == 0); i++) {
            if (c[i + start] > compareTo.charAt(i)) {
                result = 1;
            } else if (c[i + start] < compareTo.charAt(i)) {
                result = -1;
            }
        }
        //如果result为0 就表示完全相等 compareTo的长度大则返回-1 小则返回1  完全相同则返回0
        if (result == 0) {
            if (compareTo.length() > (end - start)) {
                result = -1;
            } else if (compareTo.length() < (end - start)) {
                result = 1;
            }
        }
        return result;
    }


    /**
     * Compare given char chunk with String ignoring case.
     * Return -1, 0 or +1 if inferior, equal, or superior to the String.
     */
    private static final int compareIgnoreCase(CharChunk name, int start, int end,
                                     String compareTo) {
        int result = 0;
        char[] c = name.getBuffer();
        int len = compareTo.length();
        if ((end - start) < len) {
            len = end - start;
        }
        for (int i = 0; (i < len) && (result == 0); i++) {
            if (Ascii.toLower(c[i + start]) > Ascii.toLower(compareTo.charAt(i))) {
                result = 1;
            } else if (Ascii.toLower(c[i + start]) < Ascii.toLower(compareTo.charAt(i))) {
                result = -1;
            }
        }
        if (result == 0) {
            if (compareTo.length() > (end - start)) {
                result = -1;
            } else if (compareTo.length() < (end - start)) {
                result = 1;
            }
        }
        return result;
    }


    /**
     * Find the position of the last slash in the given char chunk.
     */
    private static final int lastSlash(CharChunk name) {

        char[] c = name.getBuffer();
        int end = name.getEnd();
        int start = name.getStart();
        int pos = end;

        while (pos > start) {
            if (c[--pos] == '/') {
                break;
            }
        }

        return (pos);

    }

    /**
     * 这段代码里面有tomcat中常用的两个手段
     * 1.name(CharChunk)这个实例中buff是一个在很多句柄中其buff是完全相同,只是根据起始位置决定其数据内容
     * 2.pos采用后自增的方式,如果达到某种条件,其会继续自增一次,获取在自减一次获取的才是真实有效的pos
     *
     * 功能:根据参数n,找到buff在以当前name的start开始自增遍历
     *     如果在指定n处事/则返回pos 否则返回start
     * */
    private static final int nthSlash(CharChunk name, int n) {

        char[] c = name.getBuffer();
        int end = name.getEnd();
        int start = name.getStart();
        int pos = start;
        int count = 0;

        while (pos < end) {
            if ((c[pos++] == '/') && ((++count) == n)) {
                pos--;
                break;
            }
        }

        return (pos);

    }


    /**
     * Return the slash count in a given string.
     */
    private static final int slashCount(String name) {
        int pos = -1;
        int count = 0;
        while ((pos = name.indexOf('/', pos + 1)) != -1) {
            count++;
        }
        return count;
    }


    /**
     * Insert into the right place in a sorted MapElement array, and prevent
     * duplicates.
     */
    private static final <T> boolean insertMap
        (MapElement<T>[] oldMap, MapElement<T>[] newMap, MapElement<T> newElement) {
        int pos = find(oldMap, newElement.name);//在old里面，最近接新的元素的name的位置，这里返回的pos要么name相当，要么最左侧
        if ((pos != -1) && (newElement.name.equals(oldMap[pos].name))) { //这里表示有名字相同的，那么失败
            return false;
        }
        //分段拷贝，这样拷贝完了之后也是排好序的 注：这里只是将数组拷贝迁移到新的数组
        System.arraycopy(oldMap, 0, newMap, 0, pos + 1); //对数组拷贝，这里相当于先拷贝小的
        //将新元素赋值到数组的pos位置+1,这是因为find找到最接近的主机name
        newMap[pos + 1] = newElement;
        //将oldMap输入pos+1的位置复制到newMap的pos + 2，这是因为newMap的pos+1添加了新的元素 这样的做的目的就是将新的host插入数组并使数组保持有序
        System.arraycopy
            (oldMap, pos + 1, newMap, pos + 2, oldMap.length - pos - 1);
        return true;
    }


    /**
     * Insert into the right place in a sorted MapElement array.
     */
    private static final <T> boolean removeMap
        (MapElement<T>[] oldMap, MapElement<T>[] newMap, String name) {
        int pos = find(oldMap, name);
        if ((pos != -1) && (name.equals(oldMap[pos].name))) {
            System.arraycopy(oldMap, 0, newMap, 0, pos);
            System.arraycopy(oldMap, pos + 1, newMap, pos,
                             oldMap.length - pos - 1);
            return true;
        }
        return false;
    }


    // ------------------------------------------------- MapElement Inner Class


    protected abstract static class MapElement<T> {

        public final String name;
        public final T object;

        public MapElement(String name, T object) {
            this.name = name;     //名字
            this.object = object; //对应的对象，例如是host对象，context对象或者wrapper对象啥的
        }
    }


    // ------------------------------------------------------- Host Inner Class


    //保存当前host所拥有的所有的host对象
    protected static final class MappedHost extends MapElement<Host> {

        public volatile ContextList contextList; //有一个contextList

        /**
         * Link to the "real" MappedHost, shared by all aliases.
         */
        private final MappedHost realHost;

        /**
         * Links to all registered aliases, for easy enumeration. This field
         * is available only in the "real" MappedHost. In an alias this field
         * is <code>null</code>.
         */
        private final List<MappedHost> aliases;

        /**
         * Constructor used for the primary Host
         */
        public MappedHost(String name, Host host) {
            super(name, host);
            realHost = this;
            contextList = new ContextList();
            aliases = new CopyOnWriteArrayList<>();
        }

        /**
         * Constructor used for an Alias
         */
        public MappedHost(String alias, MappedHost realHost) {
            super(alias, realHost.object);
            this.realHost = realHost;
            this.contextList = realHost.contextList;
            this.aliases = null;
        }

        public boolean isAlias() {
            return realHost != this;
        }

        public MappedHost getRealHost() {
            return realHost;
        }

        public String getRealHostName() {
            return realHost.name;
        }

        public Collection<MappedHost> getAliases() {
            return aliases;
        }

        public void addAlias(MappedHost alias) {
            aliases.add(alias);
        }

        public void addAliases(Collection<? extends MappedHost> c) {
            aliases.addAll(c);
        }

        public void removeAlias(MappedHost alias) {
            aliases.remove(alias);
        }
    }


    // ------------------------------------------------ ContextList Inner Class


    protected static final class ContextList {

        public final MappedContext[] contexts;
        public final int nesting;

        public ContextList() {
            this(new MappedContext[0], 0);
        }

        private ContextList(MappedContext[] contexts, int nesting) {
            this.contexts = contexts;
            this.nesting = nesting;
        }

        public ContextList addContext(MappedContext mappedContext,
                int slashCount) {
            MappedContext[] newContexts = new MappedContext[contexts.length + 1];
            if (insertMap(contexts, newContexts, mappedContext)) {
                return new ContextList(newContexts, Math.max(nesting,
                        slashCount));
            }
            return null;
        }

        public ContextList removeContext(String path) {
            MappedContext[] newContexts = new MappedContext[contexts.length - 1];
            if (removeMap(contexts, newContexts, path)) {
                int newNesting = 0;
                for (MappedContext context : newContexts) {
                    newNesting = Math.max(newNesting, slashCount(context.name));
                }
                return new ContextList(newContexts, newNesting);
            }
            return null;
        }
    }


    // ---------------------------------------------------- Context Inner Class


    protected static final class MappedContext extends MapElement<Void> {
        public volatile ContextVersion[] versions; //版本的数组

        public MappedContext(String name, ContextVersion firstVersion) {
            super(name, null);
            this.versions = new ContextVersion[] { firstVersion };
        }
    }

    protected static final class ContextVersion extends MapElement<Context> {
        public final String path;  //path
        public final int slashCount;
        public final WebResourceRoot resources;  //操作当前web应用程序的资源
        public String[] welcomeResources;  //welcome的数据
        public MappedWrapper defaultWrapper = null;
        public MappedWrapper[] exactWrappers = new MappedWrapper[0]; //对wrapper的精确的map
        public MappedWrapper[] wildcardWrappers = new MappedWrapper[0]; //基于通配符的map
        public MappedWrapper[] extensionWrappers = new MappedWrapper[0];  //基于扩展名的map
        public int nesting = 0; // 属于这个context的所有servlet的path里面最大斜线数目
        private volatile boolean paused;

        public ContextVersion(String version, String path, int slashCount,
                Context context, WebResourceRoot resources,
                String[] welcomeResources) {
            super(version, context);
            this.path = path;
            this.slashCount = slashCount;
            this.resources = resources;
            this.welcomeResources = welcomeResources;
        }

        public boolean isPaused() {
            return paused;
        }

        public void markPaused() {
            paused = true;
        }
    }

    // ---------------------------------------------------- Wrapper Inner Class


    protected static class MappedWrapper extends MapElement<Wrapper> {

        public final boolean jspWildCard;
        public final boolean resourceOnly;

        public MappedWrapper(String name, Wrapper wrapper, boolean jspWildCard,
                boolean resourceOnly) {
            super(name, wrapper);
            this.jspWildCard = jspWildCard;
            this.resourceOnly = resourceOnly;
        }
    }
}
