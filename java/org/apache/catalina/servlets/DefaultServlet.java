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
package org.apache.catalina.servlets;

import java.io.BufferedInputStream;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.RandomAccessFile;
import java.io.Reader;
import java.io.StringReader;
import java.io.StringWriter;
import java.security.AccessController;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Enumeration;
import java.util.Iterator;
import java.util.Locale;
import java.util.StringTokenizer;

import javax.servlet.DispatcherType;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.ServletResponse;
import javax.servlet.ServletResponseWrapper;
import javax.servlet.UnavailableException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import org.apache.catalina.Context;
import org.apache.catalina.Globals;
import org.apache.catalina.WebResource;
import org.apache.catalina.WebResourceRoot;
import org.apache.catalina.connector.RequestFacade;
import org.apache.catalina.connector.ResponseFacade;
import org.apache.catalina.util.RequestUtil;
import org.apache.catalina.util.ServerInfo;
import org.apache.catalina.util.URLEncoder;
import org.apache.tomcat.util.res.StringManager;
import org.apache.tomcat.util.security.PrivilegedGetTccl;
import org.apache.tomcat.util.security.PrivilegedSetTccl;
import org.apache.util.Debug;
import org.w3c.dom.Document;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;
import org.xml.sax.ext.EntityResolver2;


/**
 * <p>The default resource-serving servlet for most web applications,
 * used to serve static resources such as HTML pages and images.
 * </p>
 * <p>
 * This servlet is intended to be mapped to <em>/</em> e.g.:
 * </p>
 * <pre>
 *   &lt;servlet-mapping&gt;
 *       &lt;servlet-name&gt;default&lt;/servlet-name&gt;
 *       &lt;url-pattern&gt;/&lt;/url-pattern&gt;
 *   &lt;/servlet-mapping&gt;
 * </pre>
 * <p>It can be mapped to sub-paths, however in all cases resources are served
 * from the web application resource root using the full path from the root
 * of the web application context.
 * <br>e.g. given a web application structure:
 *</p>
 * <pre>
 * /context
 *   /images
 *     tomcat2.jpg
 *   /static
 *     /images
 *       tomcat.jpg
 * </pre>
 * <p>
 * ... and a servlet mapping that maps only <code>/static/*</code> to the default servlet:
 * </p>
 * <pre>
 *   &lt;servlet-mapping&gt;
 *       &lt;servlet-name&gt;default&lt;/servlet-name&gt;
 *       &lt;url-pattern&gt;/static/*&lt;/url-pattern&gt;
 *   &lt;/servlet-mapping&gt;
 * </pre>
 * <p>
 * Then a request to <code>/context/static/images/tomcat.jpg</code> will succeed
 * while a request to <code>/context/images/tomcat2.jpg</code> will fail.
 * </p>
 * @author Craig R. McClanahan
 * @author Remy Maucherat
 */

/**
 * @author 郑小康
 * DefaultServlet是用来处理静态资源的
 * 其配置是在conf/web.xml里面
 * */
public class DefaultServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    /**
     * The string manager for this package.
     */
    protected static final StringManager sm = StringManager.getManager(Constants.Package);

    private static final DocumentBuilderFactory factory;

    private static final SecureEntityResolver secureEntityResolver;

    /**
     * Full range marker.
     */
    protected static final ArrayList<Range> FULL = new ArrayList<>();

    /**
     * MIME multipart separation string
     */
    protected static final String mimeSeparation = "CATALINA_MIME_BOUNDARY";

    /**
     * JNDI resources name.
     */
    protected static final String RESOURCES_JNDI_NAME = "java:/comp/Resources";

    /**
     * Size of file transfer buffer in bytes.
     */
    protected static final int BUFFER_SIZE = 4096;


    // ----------------------------------------------------- Static Initializer

    static {
        if (Globals.IS_SECURITY_ENABLED) {
            factory = DocumentBuilderFactory.newInstance();
            factory.setNamespaceAware(true);
            factory.setValidating(false);
            secureEntityResolver = new SecureEntityResolver();
        } else {
            factory = null;
            secureEntityResolver = null;
        }
    }


    // ----------------------------------------------------- Instance Variables

    /**
     * The debugging detail level for this servlet.
     */
    protected int debug = 0;

    /**
     * The input buffer size to use when serving resources.
     */
    protected int input = 2048;

    /**
     * Should we generate directory listings?
     */
    protected boolean listings = false;

    /**
     * Read only flag. By default, it's set to true.
     */
    protected boolean readOnly = true;

    /**
     * Should be serve gzip versions of files. By default, it's set to false.
     */
    protected boolean gzip = false;

    /**
     * The output buffer size to use when serving resources.
     */
    protected int output = 2048;

    /**
     * Allow customized directory listing per directory.
     */
    protected String localXsltFile = null;

    /**
     * Allow customized directory listing per context.
     */
    protected String contextXsltFile = null;

    /**
     * Allow customized directory listing per instance.
     */
    protected String globalXsltFile = null;

    /**
     * Allow a readme file to be included.
     */
    protected String readmeFile = null;

    /**
     * The complete set of web application resources
     */
    protected transient WebResourceRoot resources = null;

    /**
     * File encoding to be used when reading static files. If none is specified
     * the platform default is used.
     */
    protected String fileEncoding = null;

    /**
     * Minimum size for sendfile usage in bytes.
     */
    protected int sendfileSize = 48 * 1024;

    /**
     * Should the Accept-Ranges: bytes header be send with static resources?
     */
    protected boolean useAcceptRanges = true;

    /**
     * Flag to determine if server information is presented.
     */
    protected boolean showServerInfo = true;


    // --------------------------------------------------------- Public Methods

    /**
     * Finalize this servlet.
     */
    @Override
    public void destroy() {
        // NOOP
    }


    /**
     * Initialize this servlet.
     */
    @Override
    public void init() throws ServletException {

        if (getServletConfig().getInitParameter("debug") != null)
            debug = Integer.parseInt(getServletConfig().getInitParameter("debug"));

        if (getServletConfig().getInitParameter("input") != null)
            input = Integer.parseInt(getServletConfig().getInitParameter("input"));

        if (getServletConfig().getInitParameter("output") != null)
            output = Integer.parseInt(getServletConfig().getInitParameter("output"));

        listings = Boolean.parseBoolean(getServletConfig().getInitParameter("listings"));

        if (getServletConfig().getInitParameter("readonly") != null)
            readOnly = Boolean.parseBoolean(getServletConfig().getInitParameter("readonly"));

        if (getServletConfig().getInitParameter("gzip") != null)
            gzip = Boolean.parseBoolean(getServletConfig().getInitParameter("gzip"));

        if (getServletConfig().getInitParameter("sendfileSize") != null)
            sendfileSize =
                Integer.parseInt(getServletConfig().getInitParameter("sendfileSize")) * 1024;

        fileEncoding = getServletConfig().getInitParameter("fileEncoding");

        globalXsltFile = getServletConfig().getInitParameter("globalXsltFile");
        contextXsltFile = getServletConfig().getInitParameter("contextXsltFile");
        localXsltFile = getServletConfig().getInitParameter("localXsltFile");
        readmeFile = getServletConfig().getInitParameter("readmeFile");

        if (getServletConfig().getInitParameter("useAcceptRanges") != null)
            useAcceptRanges = Boolean.parseBoolean(getServletConfig().getInitParameter("useAcceptRanges"));

        // Sanity check on the specified buffer sizes
        if (input < 256)
            input = 256;
        if (output < 256)
            output = 256;

        if (debug > 0) {
            log("DefaultServlet.init:  input buffer size=" + input +
                ", output buffer size=" + output);
        }

        // Load the web resources
        resources = (WebResourceRoot) getServletContext().getAttribute(
                Globals.RESOURCES_ATTR);

        if (resources == null) {
            throw new UnavailableException("No resources");
        }

        if (getServletConfig().getInitParameter("showServerInfo") != null) {
            showServerInfo = Boolean.parseBoolean(getServletConfig().getInitParameter("showServerInfo"));
        }
    }


    // ------------------------------------------------------ Protected Methods


    /**
     * Return the relative path associated with this servlet.
     *
     * @param request The servlet request we are processing
     */
    protected String getRelativePath(HttpServletRequest request) {
        return getRelativePath(request, false);
    }

    protected String getRelativePath(HttpServletRequest request, boolean allowEmptyPath) {
        // IMPORTANT: DefaultServlet can be mapped to '/' or '/path/*' but always
        // serves resources from the web app root with context rooted paths.
        // i.e. it can not be used to mount the web app root under a sub-path
        // This method must construct a complete context rooted path, although
        // subclasses can change this behaviour.

        String servletPath;
        String pathInfo;
        //javax.servlet.include.request_uri 如果不为空的话
        if (request.getAttribute(RequestDispatcher.INCLUDE_REQUEST_URI) != null) {
            //获取相关属性 javax.servlet.include.path_info javax.servlet.include.servlet_path
            pathInfo = (String) request.getAttribute(RequestDispatcher.INCLUDE_PATH_INFO);
            servletPath = (String) request.getAttribute(RequestDispatcher.INCLUDE_SERVLET_PATH);
        } else {
            //如果include为空获取mappingData中的属性
            pathInfo = request.getPathInfo();
            servletPath = request.getServletPath();
        }
        //servletPath+pathInfo/拼成result
        StringBuilder result = new StringBuilder();
        if (servletPath.length() > 0) {
            result.append(servletPath);
        }
        if (pathInfo != null) {
            result.append(pathInfo);
        }
        if (result.length() == 0 && !allowEmptyPath) {
            result.append('/');
        }

        return result.toString();
    }


    /**
     * Determines the appropriate path to prepend resources with
     * when generating directory listings. Depending on the behaviour of
     * {@link #getRelativePath(HttpServletRequest)} this will change.
     * @param request the request to determine the path for
     * @return the prefix to apply to all resources in the listing.
     */
    protected String getPathPrefix(final HttpServletRequest request) {
        return request.getContextPath();
    }


    @Override
    protected void service(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (req.getDispatcherType() == DispatcherType.ERROR) {
            doGet(req, resp);
        } else {
            //调用父类service即HttpServlet中的service
            super.service(req, resp);
        }
    }


    /**
     * Process a GET request for the specified resource.
     *
     * @param request The servlet request we are processing
     * @param response The servlet response we are creating
     *
     * @exception IOException if an input/output error occurs
     * @exception ServletException if a servlet-specified error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
        throws IOException, ServletException {

        // Serve the requested resource, including the data content
        serveResource(request, response, true, fileEncoding);

    }


    /**
     * Process a HEAD request for the specified resource.
     *
     * @param request The servlet request we are processing
     * @param response The servlet response we are creating
     *
     * @exception IOException if an input/output error occurs
     * @exception ServletException if a servlet-specified error occurs
     */
    @Override
    protected void doHead(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        // Serve the requested resource, without the data content unless we are
        // being included since in that case the content needs to be provided so
        // the correct content length is reported for the including resource
        boolean serveContent = DispatcherType.INCLUDE.equals(request.getDispatcherType());
        serveResource(request, response, serveContent, fileEncoding);
    }


    /**
     * Override default implementation to ensure that TRACE is correctly
     * handled.
     *
     * @param req   the {@link HttpServletRequest} object that
     *                  contains the request the client made of
     *                  the servlet
     *
     * @param resp  the {@link HttpServletResponse} object that
     *                  contains the response the servlet returns
     *                  to the client
     *
     * @exception IOException   if an input or output error occurs
     *                              while the servlet is handling the
     *                              OPTIONS request
     *
     * @exception ServletException  if the request for the
     *                                  OPTIONS cannot be handled
     */
    @Override
    protected void doOptions(HttpServletRequest req, HttpServletResponse resp)
        throws ServletException, IOException {

        StringBuilder allow = new StringBuilder();
        // There is a doGet method
        allow.append("GET, HEAD");
        // There is a doPost
        allow.append(", POST");
        // There is a doPut
        allow.append(", PUT");
        // There is a doDelete
        allow.append(", DELETE");
        // Trace - assume disabled unless we can prove otherwise
        if (req instanceof RequestFacade &&
                ((RequestFacade) req).getAllowTrace()) {
            allow.append(", TRACE");
        }
        // Always allow options
        allow.append(", OPTIONS");

        resp.setHeader("Allow", allow.toString());
    }


    /**
     * Process a POST request for the specified resource.
     *
     * @param request The servlet request we are processing
     * @param response The servlet response we are creating
     *
     * @exception IOException if an input/output error occurs
     * @exception ServletException if a servlet-specified error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
        throws IOException, ServletException {
        doGet(request, response);
    }


    /**
     * Process a PUT request for the specified resource.
     *
     * @param req The servlet request we are processing
     * @param resp The servlet response we are creating
     *
     * @exception IOException if an input/output error occurs
     * @exception ServletException if a servlet-specified error occurs
     */
    @Override
    protected void doPut(HttpServletRequest req, HttpServletResponse resp)
        throws ServletException, IOException {

        if (readOnly) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String path = getRelativePath(req);

        WebResource resource = resources.getResource(path);

        Range range = parseContentRange(req, resp);

        InputStream resourceInputStream = null;

        try {
            // Append data specified in ranges to existing content for this
            // resource - create a temp. file on the local filesystem to
            // perform this operation
            // Assume just one range is specified for now
            if (range != null) {
                File contentFile = executePartialPut(req, range, path);
                resourceInputStream = new FileInputStream(contentFile);
            } else {
                resourceInputStream = req.getInputStream();
            }

            if (resources.write(path, resourceInputStream, true)) {
                if (resource.exists()) {
                    resp.setStatus(HttpServletResponse.SC_NO_CONTENT);
                } else {
                    resp.setStatus(HttpServletResponse.SC_CREATED);
                }
            } else {
                resp.sendError(HttpServletResponse.SC_CONFLICT);
            }
        } finally {
            if (resourceInputStream != null) {
                try {
                    resourceInputStream.close();
                } catch (IOException ioe) {
                    // Ignore
                }
            }
        }
    }


    /**
     * Handle a partial PUT.  New content specified in request is appended to
     * existing content in oldRevisionContent (if present). This code does
     * not support simultaneous partial updates to the same resource.
     */
    protected File executePartialPut(HttpServletRequest req, Range range,
                                     String path)
        throws IOException {

        // Append data specified in ranges to existing content for this
        // resource - create a temp. file on the local filesystem to
        // perform this operation
        File tempDir = (File) getServletContext().getAttribute
            (ServletContext.TEMPDIR);
        // Convert all '/' characters to '.' in resourcePath
        String convertedResourcePath = path.replace('/', '.');
        File contentFile = new File(tempDir, convertedResourcePath);
        if (contentFile.createNewFile()) {
            // Clean up contentFile when Tomcat is terminated
            contentFile.deleteOnExit();
        }

        try (RandomAccessFile randAccessContentFile =
            new RandomAccessFile(contentFile, "rw");) {

            WebResource oldResource = resources.getResource(path);

            // Copy data in oldRevisionContent to contentFile
            if (oldResource.isFile()) {
                try (BufferedInputStream bufOldRevStream =
                    new BufferedInputStream(oldResource.getInputStream(),
                            BUFFER_SIZE);) {

                    int numBytesRead;
                    byte[] copyBuffer = new byte[BUFFER_SIZE];
                    while ((numBytesRead = bufOldRevStream.read(copyBuffer)) != -1) {
                        randAccessContentFile.write(copyBuffer, 0, numBytesRead);
                    }

                }
            }

            randAccessContentFile.setLength(range.length);

            // Append data in request input stream to contentFile
            randAccessContentFile.seek(range.start);
            int numBytesRead;
            byte[] transferBuffer = new byte[BUFFER_SIZE];
            try (BufferedInputStream requestBufInStream =
                new BufferedInputStream(req.getInputStream(), BUFFER_SIZE);) {
                while ((numBytesRead = requestBufInStream.read(transferBuffer)) != -1) {
                    randAccessContentFile.write(transferBuffer, 0, numBytesRead);
                }
            }
        }

        return contentFile;
    }


    /**
     * Process a DELETE request for the specified resource.
     *
     * @param req The servlet request we are processing
     * @param resp The servlet response we are creating
     *
     * @exception IOException if an input/output error occurs
     * @exception ServletException if a servlet-specified error occurs
     */
    @Override
    protected void doDelete(HttpServletRequest req, HttpServletResponse resp)
        throws ServletException, IOException {

        if (readOnly) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String path = getRelativePath(req);

        WebResource resource = resources.getResource(path);

        if (resource.exists()) {
            if (resource.delete()) {
                resp.setStatus(HttpServletResponse.SC_NO_CONTENT);
            } else {
                resp.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
            }
        } else {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }

    }


    /**
     * checkIfHeaders方法检查了4个头：If-Match、If-Modified-Since、If-None-Match、If-Unmodified-Since；
     * 其中如果设置If-None-Match的话，If-Modified-Since会忽略，这两个头分别对应于Etag和Last-Modified，如果没有改变，返回304 Not Modified，对应的方法返回false；
     * 而If-Match头和If-Unmodified-Since头分别表示Etag和last-modified值未改变应该返回文件数据（200 OK），对应的方法返回true，如果不相等返回状态码412，方法返回false；
     * PS：If-Modified-Since和If-None-Match方法会设置last-modified和Etag响应头；
     * 由此可见，只要这个4个方法任何一个返回了false，都直接返回，不返回文件数据，有两种可能：304, 412；
     * */
    protected boolean checkIfHeaders(HttpServletRequest request,
                                     HttpServletResponse response,
                                     WebResource resource)
        throws IOException {

        return checkIfMatch(request, response, resource)
            && checkIfModifiedSince(request, response, resource)
            && checkIfNoneMatch(request, response, resource)
            && checkIfUnmodifiedSince(request, response, resource);

    }


    /**
     * URL rewriter.
     *
     * @param path Path which has to be rewritten
     */
    protected String rewriteUrl(String path) {
        return URLEncoder.DEFAULT.encode(path, "UTF-8");
    }


    /**
     * Serve the specified resource, optionally including the data content.
     *
     * @param request  The servlet request we are processing
     * @param response The servlet response we are creating
     * @param content  Should the content be included?
     * @param encoding The encoding to use if it is necessary to access the
     *                 source as characters rather than as bytes
     *
     * @exception IOException if an input/output error occurs
     * @exception ServletException if a servlet-specified error occurs
     */
    protected void serveResource(HttpServletRequest request,
                                 HttpServletResponse response,
                                 boolean content,
                                 String encoding)
        throws IOException, ServletException {

        boolean serveContent = content;

        //获取请求资源路径 即web应用名的后一级
        String path = getRelativePath(request, true);

        if (serveContent)
            Debug.log("DefaultServlet.serveResource:  Serving resource '" + path + "' headers and data",module);
        else
            Debug.log("DefaultServlet.serveResource:  Serving resource '" + path + "' headers only",module);

        //如果path长度为0则获取Web应用的根
        if (path.length() == 0) {
            // Context root redirect
            doDirectoryRedirect(request, response);
            return;
        }
        //根据path获取对应的WebResource CacheResource
        WebResource resource = resources.getResource(path);
        boolean isError = DispatcherType.ERROR == request.getDispatcherType();

        //如果资源不存在
        if (!resource.exists()) {
            // Check if we're included so we can return the appropriate
            // missing resource name in the error
            String requestUri = (String) request.getAttribute(RequestDispatcher.INCLUDE_REQUEST_URI);
            if (requestUri == null) {
                requestUri = request.getRequestURI();
            } else {
                // We're included
                // SRV.9.3 says we must throw a FNFE
                throw new FileNotFoundException(sm.getString(
                        "defaultServlet.missingResource", requestUri));
            }

            if (isError) {
                response.sendError(((Integer) request.getAttribute(RequestDispatcher.ERROR_STATUS_CODE)).intValue());
            } else {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, requestUri);
            }
            return;
        }

        //检测资源是否可以阅读
        if (!resource.canRead()) {
            // Check if we're included so we can return the appropriate missing resource name in the error
            //检查是否包含
            String requestUri = (String) request.getAttribute(RequestDispatcher.INCLUDE_REQUEST_URI);
            if (requestUri == null) {
                requestUri = request.getRequestURI();
            } else {
                // We're included
                // Spec doesn't say what to do in this case but a FNFE seems
                // reasonable
                throw new FileNotFoundException(sm.getString(
                        "defaultServlet.missingResource", requestUri));
            }

            if (isError) {
                response.sendError(((Integer) request.getAttribute(RequestDispatcher.ERROR_STATUS_CODE)).intValue());
            } else {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, requestUri);
            }
            return;
        }

        // If the resource is not a collection, and the resource path
        // ends with "/" or "\", return NOT FOUND
        if (resource.isFile() && (path.endsWith("/") || path.endsWith("\\"))) {
            // Check if we're included so we can return the appropriate
            // missing resource name in the error
            String requestUri = (String) request.getAttribute(RequestDispatcher.INCLUDE_REQUEST_URI);
            if (requestUri == null) {
                requestUri = request.getRequestURI();
            }
            response.sendError(HttpServletResponse.SC_NOT_FOUND, requestUri);
            return;
        }

        boolean included = false;
        //检查当前WebResource是否是文件 检查相关头部，其中checkIfHeaders方法中就对Etag和lastModified头进行检查
        if (resource.isFile()) {
            // Checking If headers
            included = (request.getAttribute(RequestDispatcher.INCLUDE_CONTEXT_PATH) != null);
            //检查头部 主要是同http缓存机制相关 这里直接返回有两种状态码304 412 一种是调用浏览器自己缓存
            if (!included && !isError && !checkIfHeaders(request, response, resource)) {
                return;
            }
        }

        // 获取资源的 MIME type 根据文件后缀名获取对应类型
        String contentType = resource.getMimeType();
        if (contentType == null) {
            contentType = getServletContext().getMimeType(resource.getName());
            resource.setMimeType(contentType);
        }

        // These need to reflect the original resource, not the potentially
        // gzip'd version of the resource so get them now if they are going to
        // be needed later
        String eTag = null;
        String lastModifiedHttp = null;
        //如果资源是一个文件并且不是错误
        if (resource.isFile() && !isError) {
            //获取资源修改时间的唯一值,解决lastModifiedHttp秒级的问题
            eTag = resource.getETag();
            lastModifiedHttp = resource.getLastModifiedHttp();
        }


        // Serve a gzipped version of the file if present
        boolean usingGzippedVersion = false;
        if (gzip && !included && resource.isFile() && !path.endsWith(".gz")) {
            WebResource gzipResource = resources.getResource(path + ".gz");
            if (gzipResource.exists() && gzipResource.isFile()) {
                Collection<String> varyHeaders = response.getHeaders("Vary");
                boolean addRequired = true;
                for (String varyHeader : varyHeaders) {
                    if ("*".equals(varyHeader) ||
                            "accept-encoding".equalsIgnoreCase(varyHeader)) {
                        addRequired = false;
                        break;
                    }
                }
                if (addRequired) {
                    response.addHeader("Vary", "accept-encoding");
                }
                if (checkIfGzip(request)) {
                    response.addHeader("Content-Encoding", "gzip");
                    resource = gzipResource;
                    usingGzippedVersion = true;
                }
            }
        }

        ArrayList<Range> ranges = null;
        long contentLength = -1L;

        //如果资源文件是一个文件夹且不是以/结尾直接返回
        if (resource.isDirectory()) {
            if (!path.endsWith("/")) {
                doDirectoryRedirect(request, response);
                return;
            }

            //如果是以/结尾但是不列举 则发送状态码404
            if (!listings) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND,
                                   request.getRequestURI());
                return;
            }
            contentType = "text/html;charset=UTF-8";
        } else {
            if (!isError) {
                if (useAcceptRanges) {
                    //告诉客户端，支持断点传输
                    response.setHeader("Accept-Ranges", "bytes");
                }

                //在正常情况下这里会是null
                ranges = parseRange(request, response, resource);

                //响应当前资源的ETag
                response.setHeader("ETag", eTag);

                // 设置最后修改时间
                response.setHeader("Last-Modified", lastModifiedHttp);
            }

            //获取内容长度
            contentLength = resource.getContentLength();
            // Special case for zero length files, which would cause a
            // (silent) ISE when setting the output buffer size
            if (contentLength == 0L) {
                serveContent = false;
            }
        }

        ServletOutputStream ostream = null;
        PrintWriter writer = null;
        //获取相应的输出流CoyoteOutputStream
        if (serveContent) {
            try {
                ostream = response.getOutputStream();
            } catch (IllegalStateException e) {
                // If it fails, we try to get a Writer instead if we're
                // trying to serve a text file
                if (!usingGzippedVersion &&
                        ((contentType == null) ||
                                (contentType.startsWith("text")) ||
                                (contentType.endsWith("xml")) ||
                                (contentType.contains("/javascript")))
                        ) {
                    writer = response.getWriter();
                    // Cannot reliably serve partial content with a Writer
                    ranges = FULL;
                } else {
                    throw e;
                }
            }
        }

        //检查Filter或者wrapper的阀门是否写了一些内容
        ServletResponse r = response;
        long contentWritten = 0;
        while (r instanceof ServletResponseWrapper) {
            r = ((ServletResponseWrapper) r).getResponse();
        }
        if (r instanceof ResponseFacade) {
            contentWritten = ((ResponseFacade) r).getContentWritten();
        }
        if (contentWritten > 0) {
            ranges = FULL;
        }

        if (resource.isDirectory() || isError || ( (ranges == null || ranges.isEmpty())
                        && request.getHeader("Range") == null ) ||
                ranges == FULL ) {

            // Set the appropriate output headers
            if (contentType != null) {
                Debug.log("DefaultServlet.serveFile:  contentType='" + contentType + "'",module);
                response.setContentType(contentType);
            }
            if (resource.isFile() && contentLength >= 0 &&
                    (!serveContent || ostream != null)) {
                Debug.log("DefaultServlet.serveFile:  contentLength=" + contentLength,module);
                //设置相应内容长度
                if (contentWritten == 0) {
                    response.setContentLengthLong(contentLength);
                }
            }

            if (serveContent) {
                try {
                    //设置outputBuffer的上界
                    response.setBufferSize(output);
                } catch (IllegalStateException e) {
                    // Silent catch
                }
                InputStream renderResult = null;
                if (ostream == null) {
                    // Output via a writer so can't use sendfile or write
                    // content directly.
                    if (resource.isDirectory()) {
                        renderResult = render(getPathPrefix(request), resource, encoding);
                    } else {
                        renderResult = resource.getInputStream();
                    }
                    copy(resource, renderResult, writer, encoding);
                } else {
                    // Output is via an InputStream
                    if (resource.isDirectory()) {
                        renderResult = render(getPathPrefix(request), resource, encoding);
                    } else {
                        // Output is content of resource
                        if (!checkSendfile(request, response, resource,
                                contentLength, null)) {
                            //获取资源文件的内容
                            byte[] resourceBody = resource.getContent();
                            if (resourceBody == null) {
                                // Resource content not available, use
                                // inputstream
                                renderResult = resource.getInputStream();
                            } else {
                                //写入outputBuffer中的相应的流中
                                ostream.write(resourceBody);
                            }
                        }
                    }
                    // If a stream was configured, it needs to be copied to
                    // the output (this method closes the stream)
                    if (renderResult != null) {
                        copy(resource, renderResult, ostream);
                    }
                }
            }

        } else {

            if ((ranges == null) || (ranges.isEmpty()))
                return;

            // Partial content response.

            response.setStatus(HttpServletResponse.SC_PARTIAL_CONTENT);

            if (ranges.size() == 1) {

                Range range = ranges.get(0);
                response.addHeader("Content-Range", "bytes "
                                   + range.start
                                   + "-" + range.end + "/"
                                   + range.length);
                long length = range.end - range.start + 1;
                response.setContentLengthLong(length);

                if (contentType != null) {
                    if (debug > 0)
                        log("DefaultServlet.serveFile:  contentType='" +
                            contentType + "'");
                    response.setContentType(contentType);
                }

                if (serveContent) {
                    try {
                        response.setBufferSize(output);
                    } catch (IllegalStateException e) {
                        // Silent catch
                    }
                    if (ostream != null) {
                        if (!checkSendfile(request, response, resource,
                                range.end - range.start + 1, range))
                            copy(resource, ostream, range);
                    } else {
                        // we should not get here
                        throw new IllegalStateException();
                    }
                }
            } else {
                response.setContentType("multipart/byteranges; boundary="
                                        + mimeSeparation);
                if (serveContent) {
                    try {
                        response.setBufferSize(output);
                    } catch (IllegalStateException e) {
                        // Silent catch
                    }
                    if (ostream != null) {
                        copy(resource, ostream, ranges.iterator(), contentType);
                    } else {
                        // we should not get here
                        throw new IllegalStateException();
                    }
                }
            }
        }
    }

    private void doDirectoryRedirect(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        //获取端口后面的URI
        StringBuilder location = new StringBuilder(request.getRequestURI());
        location.append('/');
        if (request.getQueryString() != null) {
            location.append('?');
            location.append(request.getQueryString());
        }
        response.sendRedirect(response.encodeRedirectURL(location.toString()));
    }

    /**
     * Parse the content-range header.
     *
     * @param request The servlet request we a)re processing
     * @param response The servlet response we are creating
     * @return Range
     */
    protected Range parseContentRange(HttpServletRequest request,
                                      HttpServletResponse response)
        throws IOException {

        // Retrieving the content-range header (if any is specified
        String rangeHeader = request.getHeader("Content-Range");

        if (rangeHeader == null)
            return null;

        // bytes is the only range unit supported
        if (!rangeHeader.startsWith("bytes")) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return null;
        }

        rangeHeader = rangeHeader.substring(6).trim();

        int dashPos = rangeHeader.indexOf('-');
        int slashPos = rangeHeader.indexOf('/');

        if (dashPos == -1) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return null;
        }

        if (slashPos == -1) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return null;
        }

        Range range = new Range();

        try {
            range.start = Long.parseLong(rangeHeader.substring(0, dashPos));
            range.end =
                Long.parseLong(rangeHeader.substring(dashPos + 1, slashPos));
            range.length = Long.parseLong
                (rangeHeader.substring(slashPos + 1, rangeHeader.length()));
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return null;
        }

        if (!range.validate()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return null;
        }

        return range;

    }


    /**获取If-Range的值 断点传输*/
    protected ArrayList<Range> parseRange(HttpServletRequest request,
            HttpServletResponse response,
            WebResource resource) throws IOException {

        // Checking If-Range
        String headerValue = request.getHeader("If-Range");

        if (headerValue != null) {
            long headerValueTime = (-1L);
            try {
                headerValueTime = request.getDateHeader("If-Range");
            } catch (IllegalArgumentException e) {
                // Ignore
            }
            String eTag = resource.getETag();
            long lastModified = resource.getLastModified();
            if (headerValueTime == (-1L)) {
                if (!eTag.equals(headerValue.trim()))
                    return FULL;
            } else {
                if (lastModified > (headerValueTime + 1000))
                    return FULL;
            }

        }

        long fileLength = resource.getContentLength();

        if (fileLength == 0)
            return null;

        String rangeHeader = request.getHeader("Range");
        if (rangeHeader == null)
            return null;
        if (!rangeHeader.startsWith("bytes")) {
            response.addHeader("Content-Range", "bytes */" + fileLength);
            response.sendError
                (HttpServletResponse.SC_REQUESTED_RANGE_NOT_SATISFIABLE);
            return null;
        }

        rangeHeader = rangeHeader.substring(6);

        // Vector which will contain all the ranges which are successfully
        // parsed.
        ArrayList<Range> result = new ArrayList<>();
        StringTokenizer commaTokenizer = new StringTokenizer(rangeHeader, ",");

        // Parsing the range list
        while (commaTokenizer.hasMoreTokens()) {
            String rangeDefinition = commaTokenizer.nextToken().trim();

            Range currentRange = new Range();
            currentRange.length = fileLength;

            int dashPos = rangeDefinition.indexOf('-');

            if (dashPos == -1) {
                response.addHeader("Content-Range", "bytes */" + fileLength);
                response.sendError
                    (HttpServletResponse.SC_REQUESTED_RANGE_NOT_SATISFIABLE);
                return null;
            }

            if (dashPos == 0) {

                try {
                    long offset = Long.parseLong(rangeDefinition);
                    currentRange.start = fileLength + offset;
                    currentRange.end = fileLength - 1;
                } catch (NumberFormatException e) {
                    response.addHeader("Content-Range",
                                       "bytes */" + fileLength);
                    response.sendError
                        (HttpServletResponse
                         .SC_REQUESTED_RANGE_NOT_SATISFIABLE);
                    return null;
                }

            } else {

                try {
                    currentRange.start = Long.parseLong
                        (rangeDefinition.substring(0, dashPos));
                    if (dashPos < rangeDefinition.length() - 1)
                        currentRange.end = Long.parseLong
                            (rangeDefinition.substring
                             (dashPos + 1, rangeDefinition.length()));
                    else
                        currentRange.end = fileLength - 1;
                } catch (NumberFormatException e) {
                    response.addHeader("Content-Range",
                                       "bytes */" + fileLength);
                    response.sendError
                        (HttpServletResponse
                         .SC_REQUESTED_RANGE_NOT_SATISFIABLE);
                    return null;
                }

            }

            if (!currentRange.validate()) {
                response.addHeader("Content-Range", "bytes */" + fileLength);
                response.sendError
                    (HttpServletResponse.SC_REQUESTED_RANGE_NOT_SATISFIABLE);
                return null;
            }

            result.add(currentRange);
        }

        return result;
    }



    /**
     *  Decide which way to render. HTML or XML.
     */
    protected InputStream render(String contextPath, WebResource resource)
        throws IOException, ServletException {
        return render(contextPath, resource, null);
    }

    protected InputStream render(String contextPath, WebResource resource, String encoding)
        throws IOException, ServletException {

        Source xsltSource = findXsltSource(resource);

        if (xsltSource == null) {
            return renderHtml(contextPath, resource, encoding);
        }
        return renderXml(contextPath, resource, xsltSource, encoding);

    }

    /**
     * Return an InputStream to an HTML representation of the contents
     * of this directory.
     *
     * @param contextPath Context path to which our internal paths are
     *  relative
     */
    protected InputStream renderXml(String contextPath, WebResource resource, Source xsltSource)
        throws IOException, ServletException {
        return renderXml(contextPath, resource, xsltSource, null);
    }

    protected InputStream renderXml(String contextPath, WebResource resource, Source xsltSource,
            String encoding)
        throws IOException, ServletException {

        StringBuilder sb = new StringBuilder();

        sb.append("<?xml version=\"1.0\"?>");
        sb.append("<listing ");
        sb.append(" contextPath='");
        sb.append(contextPath);
        sb.append("'");
        sb.append(" directory='");
        sb.append(resource.getName());
        sb.append("' ");
        sb.append(" hasParent='").append(!resource.getName().equals("/"));
        sb.append("'>");

        sb.append("<entries>");

        String[] entries = resources.list(resource.getWebappPath());

        // rewriteUrl(contextPath) is expensive. cache result for later reuse
        String rewrittenContextPath =  rewriteUrl(contextPath);
        String directoryWebappPath = resource.getWebappPath();

        for (String entry : entries) {

            if (entry.equalsIgnoreCase("WEB-INF") ||
                    entry.equalsIgnoreCase("META-INF") ||
                    entry.equalsIgnoreCase(localXsltFile))
                continue;

            if ((directoryWebappPath + entry).equals(contextXsltFile))
                continue;

            WebResource childResource =
                    resources.getResource(directoryWebappPath + entry);
            if (!childResource.exists()) {
                continue;
            }

            sb.append("<entry");
            sb.append(" type='")
              .append(childResource.isDirectory()?"dir":"file")
              .append("'");
            sb.append(" urlPath='")
              .append(rewrittenContextPath)
              .append(rewriteUrl(directoryWebappPath + entry))
              .append(childResource.isDirectory()?"/":"")
              .append("'");
            if (childResource.isFile()) {
                sb.append(" size='")
                  .append(renderSize(childResource.getContentLength()))
                  .append("'");
            }
            sb.append(" date='")
              .append(childResource.getLastModifiedHttp())
              .append("'");

            sb.append(">");
            sb.append(RequestUtil.filter(entry));
            if (childResource.isDirectory())
                sb.append("/");
            sb.append("</entry>");
        }
        sb.append("</entries>");

        String readme = getReadme(resource, encoding);

        if (readme!=null) {
            sb.append("<readme><![CDATA[");
            sb.append(readme);
            sb.append("]]></readme>");
        }

        sb.append("</listing>");

        // Prevent possible memory leak. Ensure Transformer and
        // TransformerFactory are not loaded from the web application.
        ClassLoader original;
        if (Globals.IS_SECURITY_ENABLED) {
            PrivilegedGetTccl pa = new PrivilegedGetTccl();
            original = AccessController.doPrivileged(pa);
        } else {
            original = Thread.currentThread().getContextClassLoader();
        }
        try {
            if (Globals.IS_SECURITY_ENABLED) {
                PrivilegedSetTccl pa =
                        new PrivilegedSetTccl(DefaultServlet.class.getClassLoader());
                AccessController.doPrivileged(pa);
            } else {
                Thread.currentThread().setContextClassLoader(
                        DefaultServlet.class.getClassLoader());
            }

            TransformerFactory tFactory = TransformerFactory.newInstance();
            Source xmlSource = new StreamSource(new StringReader(sb.toString()));
            Transformer transformer = tFactory.newTransformer(xsltSource);

            ByteArrayOutputStream stream = new ByteArrayOutputStream();
            OutputStreamWriter osWriter = new OutputStreamWriter(stream, "UTF8");
            StreamResult out = new StreamResult(osWriter);
            transformer.transform(xmlSource, out);
            osWriter.flush();
            return (new ByteArrayInputStream(stream.toByteArray()));
        } catch (TransformerException e) {
            throw new ServletException("XSL transformer error", e);
        } finally {
            if (Globals.IS_SECURITY_ENABLED) {
                PrivilegedSetTccl pa = new PrivilegedSetTccl(original);
                AccessController.doPrivileged(pa);
            } else {
                Thread.currentThread().setContextClassLoader(original);
            }
        }
    }

    /**
     * Return an InputStream to an HTML representation of the contents
     * of this directory.
     *
     * @param contextPath Context path to which our internal paths are
     *  relative
     */
    protected InputStream renderHtml(String contextPath, WebResource resource)
        throws IOException {
        return renderHtml(contextPath, resource, null);
    }

    protected InputStream renderHtml(String contextPath, WebResource resource, String encoding)
        throws IOException {
        //创建一个字节数组输出流
        ByteArrayOutputStream stream = new ByteArrayOutputStream();
        //将字节流转换为字符流
        OutputStreamWriter osWriter = new OutputStreamWriter(stream, "UTF8");

        PrintWriter writer = new PrintWriter(osWriter);

        StringBuilder sb = new StringBuilder();

        String[] entries = resources.list(resource.getWebappPath());

        // rewriteUrl(contextPath) is expensive. cache result for later reuse
        String rewrittenContextPath =  rewriteUrl(contextPath);
        String directoryWebappPath = resource.getWebappPath();

        // Render the page header
        sb.append("<html>\r\n");
        sb.append("<head>\r\n");
        sb.append("<title>");
        sb.append(sm.getString("directory.title", directoryWebappPath));
        sb.append("</title>\r\n");
        sb.append("<STYLE><!--");
        sb.append(org.apache.catalina.util.TomcatCSS.TOMCAT_CSS);
        sb.append("--></STYLE> ");
        sb.append("</head>\r\n");
        sb.append("<body>");
        sb.append("<h1>");
        sb.append(sm.getString("directory.title", directoryWebappPath));

        // Render the link to our parent (if required)
        String parentDirectory = directoryWebappPath;
        if (parentDirectory.endsWith("/")) {
            parentDirectory =
                parentDirectory.substring(0, parentDirectory.length() - 1);
        }
        int slash = parentDirectory.lastIndexOf('/');
        if (slash >= 0) {
            String parent = directoryWebappPath.substring(0, slash);
            sb.append(" - <a href=\"");
            sb.append(rewrittenContextPath);
            if (parent.equals(""))
                parent = "/";
            sb.append(rewriteUrl(parent));
            if (!parent.endsWith("/"))
                sb.append("/");
            sb.append("\">");
            sb.append("<b>");
            sb.append(sm.getString("directory.parent", parent));
            sb.append("</b>");
            sb.append("</a>");
        }

        sb.append("</h1>");
        sb.append("<HR size=\"1\" noshade=\"noshade\">");

        sb.append("<table width=\"100%\" cellspacing=\"0\"" +
                     " cellpadding=\"5\" align=\"center\">\r\n");

        // Render the column headings
        sb.append("<tr>\r\n");
        sb.append("<td align=\"left\"><font size=\"+1\"><strong>");
        sb.append(sm.getString("directory.filename"));
        sb.append("</strong></font></td>\r\n");
        sb.append("<td align=\"center\"><font size=\"+1\"><strong>");
        sb.append(sm.getString("directory.size"));
        sb.append("</strong></font></td>\r\n");
        sb.append("<td align=\"right\"><font size=\"+1\"><strong>");
        sb.append(sm.getString("directory.lastModified"));
        sb.append("</strong></font></td>\r\n");
        sb.append("</tr>");

        boolean shade = false;
        for (String entry : entries) {
            if (entry.equalsIgnoreCase("WEB-INF") ||
                entry.equalsIgnoreCase("META-INF"))
                continue;

            WebResource childResource =
                    resources.getResource(directoryWebappPath + entry);
            if (!childResource.exists()) {
                continue;
            }

            sb.append("<tr");
            if (shade)
                sb.append(" bgcolor=\"#eeeeee\"");
            sb.append(">\r\n");
            shade = !shade;

            sb.append("<td align=\"left\">&nbsp;&nbsp;\r\n");
            sb.append("<a href=\"");
            sb.append(rewrittenContextPath);
            sb.append(rewriteUrl(directoryWebappPath + entry));
            if (childResource.isDirectory())
                sb.append("/");
            sb.append("\"><tt>");
            sb.append(RequestUtil.filter(entry));
            if (childResource.isDirectory())
                sb.append("/");
            sb.append("</tt></a></td>\r\n");

            sb.append("<td align=\"right\"><tt>");
            if (childResource.isDirectory())
                sb.append("&nbsp;");
            else
                sb.append(renderSize(childResource.getContentLength()));
            sb.append("</tt></td>\r\n");

            sb.append("<td align=\"right\"><tt>");
            sb.append(childResource.getLastModifiedHttp());
            sb.append("</tt></td>\r\n");

            sb.append("</tr>\r\n");
        }

        // Render the page footer
        sb.append("</table>\r\n");

        sb.append("<HR size=\"1\" noshade=\"noshade\">");

        String readme = getReadme(resource, encoding);
        if (readme!=null) {
            sb.append(readme);
            sb.append("<HR size=\"1\" noshade=\"noshade\">");
        }

        if (showServerInfo) {
            sb.append("<h3>").append(ServerInfo.getServerInfo()).append("</h3>");
        }
        sb.append("</body>\r\n");
        sb.append("</html>\r\n");

        // Return an input stream to the underlying bytes
        writer.write(sb.toString());
        writer.flush();
        return (new ByteArrayInputStream(stream.toByteArray()));

    }


    /**
     * Render the specified file size (in bytes).
     *
     * @param size File size (in bytes)
     */
    protected String renderSize(long size) {

        long leftSide = size / 1024;
        long rightSide = (size % 1024) / 103;   // Makes 1 digit
        if ((leftSide == 0) && (rightSide == 0) && (size > 0))
            rightSide = 1;

        return ("" + leftSide + "." + rightSide + " kb");

    }


    /**
     * Get the readme file as a string.
     */
    protected String getReadme(WebResource directory) {
        return getReadme(directory, null);
    }

    protected String getReadme(WebResource directory, String encoding) {

        if (readmeFile != null) {
            WebResource resource = resources.getResource(
                    directory.getWebappPath() + readmeFile);
            if (resource.isFile()) {
                StringWriter buffer = new StringWriter();
                InputStreamReader reader = null;
                try (InputStream is = resource.getInputStream();){
                    if (encoding != null) {
                        reader = new InputStreamReader(is, encoding);
                    } else {
                        reader = new InputStreamReader(is);
                    }
                    copyRange(reader, new PrintWriter(buffer));
                } catch (IOException e) {
                    log("Failure to close reader", e);
                } finally {
                    if (reader != null) {
                        try {
                            reader.close();
                        } catch (IOException e) {
                        }
                    }
                }
                return buffer.toString();
            } else {
                if (debug > 10)
                    log("readme '" + readmeFile + "' not found");

                return null;
            }
        }

        return null;
    }


    /**
     * Return a Source for the xsl template (if possible)
     */
    protected Source findXsltSource(WebResource directory)
        throws IOException {

        if (localXsltFile != null) {
            WebResource resource = resources.getResource(
                    directory.getWebappPath() + localXsltFile);
            if (resource.isFile()) {
                InputStream is = resource.getInputStream();
                if (is != null) {
                    if (Globals.IS_SECURITY_ENABLED) {
                        return secureXslt(is);
                    } else {
                        return new StreamSource(is);
                    }
                }
            }
            if (debug > 10) {
                log("localXsltFile '" + localXsltFile + "' not found");
            }
        }

        if (contextXsltFile != null) {
            InputStream is =
                getServletContext().getResourceAsStream(contextXsltFile);
            if (is != null) {
                if (Globals.IS_SECURITY_ENABLED) {
                    return secureXslt(is);
                } else {
                    return new StreamSource(is);
                }
            }

            if (debug > 10)
                log("contextXsltFile '" + contextXsltFile + "' not found");
        }

        /*  Open and read in file in one fell swoop to reduce chance
         *  chance of leaving handle open.
         */
        if (globalXsltFile != null) {
            File f = validateGlobalXsltFile();
            if (f != null){
                try (FileInputStream fis = new FileInputStream(f)){
                    byte b[] = new byte[(int)f.length()]; /* danger! */
                    fis.read(b);
                    return new StreamSource(new ByteArrayInputStream(b));
                }
            }
        }

        return null;
    }


    private File validateGlobalXsltFile() {
        Context context = resources.getContext();

        File baseConf = new File(context.getCatalinaBase(), "conf");
        File result = validateGlobalXsltFile(baseConf);
        if (result == null) {
            File homeConf = new File(context.getCatalinaHome(), "conf");
            if (!baseConf.equals(homeConf)) {
                result = validateGlobalXsltFile(homeConf);
            }
        }

        return result;
    }


    private File validateGlobalXsltFile(File base) {
        File candidate = new File(globalXsltFile);
        if (!candidate.isAbsolute()) {
            candidate = new File(base, globalXsltFile);
        }

        if (!candidate.isFile()) {
            return null;
        }

        // First check that the resulting path is under the provided base
        try {
            if (!candidate.getCanonicalPath().startsWith(base.getCanonicalPath())) {
                return null;
            }
        } catch (IOException ioe) {
            return null;
        }

        // Next check that an .xsl or .xslt file has been specified
        String nameLower = candidate.getName().toLowerCase(Locale.ENGLISH);
        if (!nameLower.endsWith(".xslt") && !nameLower.endsWith(".xsl")) {
            return null;
        }

        return candidate;
    }


    private Source secureXslt(InputStream is) {
        // Need to filter out any external entities
        Source result = null;
        try {
            DocumentBuilder builder = factory.newDocumentBuilder();
            builder.setEntityResolver(secureEntityResolver);
            Document document = builder.parse(is);
            result = new DOMSource(document);
        } catch (ParserConfigurationException | SAXException | IOException e) {
            if (debug > 0) {
                log(e.getMessage(), e);
            }
        } finally {
            if (is != null) {
                try {
                    is.close();
                } catch (IOException e) {
                    // Ignore
                }
            }
        }
        return result;
    }


    // -------------------------------------------------------- protected Methods

    /**
     * Check if sendfile can be used.
     */
    protected boolean checkSendfile(HttpServletRequest request,
                                  HttpServletResponse response,
                                  WebResource resource,
                                  long length, Range range) {
        String canonicalPath;
        if (sendfileSize > 0
            && length > sendfileSize
            && (Boolean.TRUE.equals(request.getAttribute(Globals.SENDFILE_SUPPORTED_ATTR)))
            && (request.getClass().getName().equals("org.apache.catalina.connector.RequestFacade"))
            && (response.getClass().getName().equals("org.apache.catalina.connector.ResponseFacade"))
            && resource.isFile()
            && ((canonicalPath = resource.getCanonicalPath()) != null)
            ) {
            request.setAttribute(Globals.SENDFILE_FILENAME_ATTR, canonicalPath);
            if (range == null) {
                request.setAttribute(Globals.SENDFILE_FILE_START_ATTR, Long.valueOf(0L));
                request.setAttribute(Globals.SENDFILE_FILE_END_ATTR, Long.valueOf(length));
            } else {
                request.setAttribute(Globals.SENDFILE_FILE_START_ATTR, Long.valueOf(range.start));
                request.setAttribute(Globals.SENDFILE_FILE_END_ATTR, Long.valueOf(range.end + 1));
            }
            return true;
        }
        return false;
    }



    /**
     * 检查http的If-Match
     * 如果存在则和ETag匹配
     * 存在相同的值则返回真,不存在则返回状态码412并且返回false
     * */
    protected boolean checkIfMatch(HttpServletRequest request,
            HttpServletResponse response, WebResource resource)
            throws IOException {
        //获取资源文件的ETag
        String eTag = resource.getETag();
        //获取http首部的If-Match
        String headerValue = request.getHeader("If-Match");

        if (headerValue != null) {
            if (headerValue.indexOf('*') == -1) {

                StringTokenizer commaTokenizer = new StringTokenizer(headerValue, ",");
                boolean conditionSatisfied = false;

                while (!conditionSatisfied && commaTokenizer.hasMoreTokens()) {
                    String currentToken = commaTokenizer.nextToken();
                    if (currentToken.trim().equals(eTag))
                        conditionSatisfied = true;
                }

                if (!conditionSatisfied) {
                    response.sendError
                        (HttpServletResponse.SC_PRECONDITION_FAILED);
                    return false;
                }

            }
        }
        return true;
    }


    /**
     * If-Modified-Since 这个标签的值来自于第一次请求的时候服务器传来的last-Modified的值
     * 获取http头部If-Modified-Since得值赋给headerValue
     * 获取资源文件最后修改时间赋给lastModified
     * 在If-None-Match为空的情况，并且lastModified小于headerValue + 1000即资源文件在修改之后的一秒之后为发生任何改变则返回false,即调用缓存
     * */
    protected boolean checkIfModifiedSince(HttpServletRequest request,
            HttpServletResponse response, WebResource resource) {
        try {
            long headerValue = request.getDateHeader("If-Modified-Since");
            long lastModified = resource.getLastModified();
            if (headerValue != -1) {
                if ((request.getHeader("If-None-Match") == null) && (lastModified < headerValue + 1000)) {
                    response.setStatus(HttpServletResponse.SC_NOT_MODIFIED);
                    response.setHeader("ETag", resource.getETag());

                    return false;
                }
            }
        } catch (IllegalArgumentException illegalArgument) {
            return true;
        }
        return true;
    }


    /**
     * 检查http的If-None-Match 如果和ETag匹配成功并使Get和Post请求则返回304,浏览器调用自身缓存
     * 如果未成功匹配则直接返回true,说明不调用浏览器缓存
     * */
    protected boolean checkIfNoneMatch(HttpServletRequest request,
            HttpServletResponse response, WebResource resource)
            throws IOException {

        String eTag = resource.getETag();
        //获取request请求头部If-None-Match
        String headerValue = request.getHeader("If-None-Match");
        //如果If-None-Match不为空
        if (headerValue != null) {
            boolean conditionSatisfied = false;
            /**
             * 如果headerValue不为*,构建一个字符串分解器，如果其中存在一个字符串值与eTag相同则conditionSatisfied = true;
             * 如果headerValue为* 则conditionSatisfied = true
             *
             * 在conditionSatisfied为true的时候针对Get请求和Post请求返回false,其它请求发送412错误(未满足前提条件)
             * 原因:浏览器在第一次请求静态资源 服务器会返回一个ETag
             *      在第二次启动请求的时候或根据ETag发送If-None-Match如果是*或者有一个,则表示是否采用本地缓存资源
             *      浏览器根据文件的ETag来判断文件是否具有刷新(当然为*则不管是否刷新)绝对浏览器是否调用其自身缓存
             *      如果值相同则返回http 304 表明客户端调用自身缓存资源有效
             * */
            if (!headerValue.equals("*")) {
                StringTokenizer commaTokenizer = new StringTokenizer(headerValue, ",");

                while (!conditionSatisfied && commaTokenizer.hasMoreTokens()) {
                    String currentToken = commaTokenizer.nextToken();
                    if (currentToken.trim().equals(eTag))
                        conditionSatisfied = true;
                }
            } else {
                conditionSatisfied = true;
            }

            if (conditionSatisfied) {
                if ( ("GET".equals(request.getMethod()))
                     || ("HEAD".equals(request.getMethod())) ) {
                    //304
                    response.setStatus(HttpServletResponse.SC_NOT_MODIFIED);
                    response.setHeader("ETag", eTag);

                    return false;
                }
                //412
                response.sendError(HttpServletResponse.SC_PRECONDITION_FAILED);
                return false;
            }
        }
        return true;
    }

    /**
     * Check if the user agent supports gzip encoding.
     *
     * @param request   The servlet request we are processing
     * @return boolean true if the user agent supports gzip encoding,
     * and false if the user agent does not support gzip encoding
     */
    protected boolean checkIfGzip(HttpServletRequest request) {
        Enumeration<String> headers = request.getHeaders("Accept-Encoding");
        while (headers.hasMoreElements()) {
            String header = headers.nextElement();
            if (header.indexOf("gzip") != -1) {
                return true;
            }
        }
        return false;
    }


    /**
     * Check if the if-unmodified-since condition is satisfied.
     *
     * @param request   The servlet request we are processing
     * @param response  The servlet response we are creating
     * @param resource  The resource
     * @return boolean true if the resource meets the specified condition,
     * and false if the condition is not satisfied, in which case request
     * processing is stopped
     */
    protected boolean checkIfUnmodifiedSince(HttpServletRequest request,
            HttpServletResponse response, WebResource resource)
            throws IOException {
        try {
            long lastModified = resource.getLastModified();
            long headerValue = request.getDateHeader("If-Unmodified-Since");
            if (headerValue != -1) {
                if ( lastModified >= (headerValue + 1000)) {
                    // The entity has not been modified since the date
                    // specified by the client. This is not an error case.
                    response.sendError(HttpServletResponse.SC_PRECONDITION_FAILED);
                    return false;
                }
            }
        } catch(IllegalArgumentException illegalArgument) {
            return true;
        }
        return true;
    }


    /**
     * Copy the contents of the specified input stream to the specified
     * output stream, and ensure that both streams are closed before returning
     * (even in the face of an exception).
     *
     * @param resource  The source resource
     * @param is        The input stream to read the source resource from
     * @param ostream   The output stream to write to
     *
     * @exception IOException if an input/output error occurs
     */
    protected void copy(WebResource resource, InputStream is,
                      ServletOutputStream ostream)
        throws IOException {

        IOException exception = null;

        InputStream istream = new BufferedInputStream(is, input);

        // Copy the input stream to the output stream
        exception = copyRange(istream, ostream);

        // Clean up the input stream
        istream.close();

        // Rethrow any exception that has occurred
        if (exception != null)
            throw exception;
    }


    /**
     * Copy the contents of the specified input stream to the specified
     * output stream, and ensure that both streams are closed before returning
     * (even in the face of an exception).
     *
     * @param resource  The source resource
     * @param is        The input stream to read the source resource from
     * @param writer    The writer to write to
     * @param encoding  The encoding to use when reading the source input stream
     *
     * @exception IOException if an input/output error occurs
     */
    protected void copy(WebResource resource, InputStream is, PrintWriter writer,
            String encoding) throws IOException {

        IOException exception = null;

        InputStream resourceInputStream = null;
        if (resource.isFile()) {
            resourceInputStream = resource.getInputStream();
        } else {
            resourceInputStream = is;
        }

        Reader reader;
        if (encoding == null) {
            reader = new InputStreamReader(resourceInputStream);
        } else {
            reader = new InputStreamReader(resourceInputStream, encoding);
        }

        // Copy the input stream to the output stream
        exception = copyRange(reader, writer);

        // Clean up the reader
        reader.close();

        // Rethrow any exception that has occurred
        if (exception != null)
            throw exception;
    }


    /**
     * Copy the contents of the specified input stream to the specified
     * output stream, and ensure that both streams are closed before returning
     * (even in the face of an exception).
     *
     * @param resource  The source resource
     * @param ostream   The output stream to write to
     * @param range     Range the client wanted to retrieve
     * @exception IOException if an input/output error occurs
     */
    protected void copy(WebResource resource, ServletOutputStream ostream,
                      Range range)
        throws IOException {

        IOException exception = null;

        InputStream resourceInputStream = resource.getInputStream();
        InputStream istream =
            new BufferedInputStream(resourceInputStream, input);
        exception = copyRange(istream, ostream, range.start, range.end);

        // Clean up the input stream
        istream.close();

        // Rethrow any exception that has occurred
        if (exception != null)
            throw exception;

    }


    /**
     * Copy the contents of the specified input stream to the specified
     * output stream, and ensure that both streams are closed before returning
     * (even in the face of an exception).
     *
     * @param resource      The source resource
     * @param ostream       The output stream to write to
     * @param ranges        Enumeration of the ranges the client wanted to
 *                          retrieve
     * @param contentType   Content type of the resource
     * @exception IOException if an input/output error occurs
     */
    protected void copy(WebResource resource, ServletOutputStream ostream,
                      Iterator<Range> ranges, String contentType)
        throws IOException {

        IOException exception = null;

        while ( (exception == null) && (ranges.hasNext()) ) {

            InputStream resourceInputStream = resource.getInputStream();
            try (InputStream istream = new BufferedInputStream(resourceInputStream, input)) {

                Range currentRange = ranges.next();

                // Writing MIME header.
                ostream.println();
                ostream.println("--" + mimeSeparation);
                if (contentType != null)
                    ostream.println("Content-Type: " + contentType);
                ostream.println("Content-Range: bytes " + currentRange.start
                               + "-" + currentRange.end + "/"
                               + currentRange.length);
                ostream.println();

                // Printing content
                exception = copyRange(istream, ostream, currentRange.start,
                                      currentRange.end);
            }
        }

        ostream.println();
        ostream.print("--" + mimeSeparation + "--");

        // Rethrow any exception that has occurred
        if (exception != null)
            throw exception;

    }


    /**
     * Copy the contents of the specified input stream to the specified
     * output stream, and ensure that both streams are closed before returning
     * (even in the face of an exception).
     *
     * @param istream The input stream to read from
     * @param ostream The output stream to write to
     * @return Exception which occurred during processing
     */
    protected IOException copyRange(InputStream istream,
                                  ServletOutputStream ostream) {

        // Copy the input stream to the output stream
        IOException exception = null;
        byte buffer[] = new byte[input];
        int len = buffer.length;
        while (true) {
            try {
                len = istream.read(buffer);
                if (len == -1)
                    break;
                ostream.write(buffer, 0, len);
            } catch (IOException e) {
                exception = e;
                len = -1;
                break;
            }
        }
        return exception;

    }


    /**
     * Copy the contents of the specified input stream to the specified
     * output stream, and ensure that both streams are closed before returning
     * (even in the face of an exception).
     *
     * @param reader The reader to read from
     * @param writer The writer to write to
     * @return Exception which occurred during processing
     */
    protected IOException copyRange(Reader reader, PrintWriter writer) {

        // Copy the input stream to the output stream
        IOException exception = null;
        char buffer[] = new char[input];
        int len = buffer.length;
        while (true) {
            try {
                len = reader.read(buffer);
                if (len == -1)
                    break;
                writer.write(buffer, 0, len);
            } catch (IOException e) {
                exception = e;
                len = -1;
                break;
            }
        }
        return exception;

    }


    /**
     * Copy the contents of the specified input stream to the specified
     * output stream, and ensure that both streams are closed before returning
     * (even in the face of an exception).
     *
     * @param istream The input stream to read from
     * @param ostream The output stream to write to
     * @param start Start of the range which will be copied
     * @param end End of the range which will be copied
     * @return Exception which occurred during processing
     */
    protected IOException copyRange(InputStream istream,
                                  ServletOutputStream ostream,
                                  long start, long end) {

        if (debug > 10)
            log("Serving bytes:" + start + "-" + end);

        long skipped = 0;
        try {
            skipped = istream.skip(start);
        } catch (IOException e) {
            return e;
        }
        if (skipped < start) {
            return new IOException(sm.getString("defaultservlet.skipfail",
                    Long.valueOf(skipped), Long.valueOf(start)));
        }

        IOException exception = null;
        long bytesToRead = end - start + 1;

        byte buffer[] = new byte[input];
        int len = buffer.length;
        while ( (bytesToRead > 0) && (len >= buffer.length)) {
            try {
                len = istream.read(buffer);
                if (bytesToRead >= len) {
                    ostream.write(buffer, 0, len);
                    bytesToRead -= len;
                } else {
                    ostream.write(buffer, 0, (int) bytesToRead);
                    bytesToRead = 0;
                }
            } catch (IOException e) {
                exception = e;
                len = -1;
            }
            if (len < buffer.length)
                break;
        }

        return exception;

    }


    protected static class Range {

        public long start;
        public long end;
        public long length;

        /**
         * Validate range.
         *
         * @return true if the range is valid, otherwise false
         */
        public boolean validate() {
            if (end >= length)
                end = length - 1;
            return (start >= 0) && (end >= 0) && (start <= end) && (length > 0);
        }
    }


    /**
     * This is secure in the sense that any attempt to use an external entity
     * will trigger an exception.
     */
    private static class SecureEntityResolver implements EntityResolver2  {

        @Override
        public InputSource resolveEntity(String publicId, String systemId)
                throws SAXException, IOException {
            throw new SAXException(sm.getString("defaultServlet.blockExternalEntity",
                    publicId, systemId));
        }

        @Override
        public InputSource getExternalSubset(String name, String baseURI)
                throws SAXException, IOException {
            throw new SAXException(sm.getString("defaultServlet.blockExternalSubset",
                    name, baseURI));
        }

        @Override
        public InputSource resolveEntity(String name, String publicId,
                String baseURI, String systemId) throws SAXException,
                IOException {
            throw new SAXException(sm.getString("defaultServlet.blockExternalEntity2",
                    name, publicId, baseURI, systemId));
        }
    }
}
