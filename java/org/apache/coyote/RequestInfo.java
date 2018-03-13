package org.apache.coyote;

import javax.management.ObjectName;


/**
 * Structure holding the Request and Response objects. It also holds statistical
 * informations about request processing and provide management informations
 * about the requests being processed.
 *
 * Each thread uses a Request/Response pair that is recycled on each request.
 * This object provides a place to collect global low-level statistics - without
 * having to deal with synchronization ( since each thread will have it's own
 * RequestProcessorMX ).
 *
 * TODO: Request notifications will be registered here.
 *       请求广播会被在这里注册
 *
 */
public class RequestInfo  {
    private RequestGroupInfo global=null;

    // ----------------------------------------------------------- Constructors

    public RequestInfo( Request req) {
        this.req=req;
    }

    public RequestGroupInfo getGlobalProcessor() {
        return global;
    }

    public void setGlobalProcessor(RequestGroupInfo global) {
        if( global != null) {
            this.global=global;
            global.addRequestProcessor( this );
        } else {
            if (this.global != null) {
                this.global.removeRequestProcessor( this );
                this.global = null;
            }
        }
    }


    // ----------------------------------------------------- Instance Variables
    private final Request req;
    private int stage = Constants.STAGE_NEW;
    private String workerThreadName;
    private ObjectName rpName;

    // -------------------- Information about the current request  -----------
    // This is useful for long-running requests only

    public String getMethod() {
        return req.method().toString();
    }

    public String getCurrentUri() {
        return req.requestURI().toString();
    }

    public String getCurrentQueryString() {
        return req.queryString().toString();
    }

    public String getProtocol() {
        return req.protocol().toString();
    }

    public String getVirtualHost() {
        return req.serverName().toString();
    }

    public int getServerPort() {
        return req.getServerPort();
    }

    public String getRemoteAddr() {
        req.action(ActionCode.REQ_HOST_ADDR_ATTRIBUTE, null);
        return req.remoteAddr().toString();
    }

    /**
     * Obtain the remote address for this connection as reported by an
     * intermediate proxy (if any).
     */
    public String getRemoteAddrForwarded() {
        String remoteAddrProxy = (String) req.getAttribute(Constants.REMOTE_ADDR_ATTRIBUTE);
        if (remoteAddrProxy == null) {
            return getRemoteAddr();
        }
        return remoteAddrProxy;
    }

    public int getContentLength() {
        return req.getContentLength();
    }

    public long getRequestBytesReceived() {
        return req.getBytesRead();
    }

    public long getRequestBytesSent() {
        return req.getResponse().getContentWritten();
    }

    public long getRequestProcessingTime() {
        // Not perfect, but good enough to avoid returning strange values due to
        // concurrent updates.
        long startTime = req.getStartTime();
        if (getStage() == org.apache.coyote.Constants.STAGE_ENDED || startTime < 0) {
            return 0;
        } else {
            return System.currentTimeMillis() - startTime;
        }
    }

    // -------------------- Statistical data  --------------------
    // Collected at the end of each request.
    private long bytesSent;
    //当前request实例接受数据
    private long bytesReceived;
    //request合计执行时间
    private long processingTime;
    //当前请求最长响应时间
    private long maxTime;
    //请求时间最长的URI
    private String maxRequestUri;
    //请求处理数量
    private int requestCount;
    //大于400的相应数量
    private int errorCount;
    //最后一个请求执行时间
    private long lastRequestProcessingTime = 0;


    /**
     * Called by the processor before recycling the request.
     * It'll collect statistic information.
     */
    void updateCounters() {
        bytesReceived+=req.getBytesRead();
        bytesSent+=req.getResponse().getContentWritten();
        requestCount++;
        if( req.getResponse().getStatus() >=400 )
            errorCount++;
        long t0=req.getStartTime();
        long t1=System.currentTimeMillis();
        long time=t1-t0;
        this.lastRequestProcessingTime = time;
        processingTime+=time;
        if( maxTime < time ) {
            maxTime=time;
            maxRequestUri=req.requestURI().toString();
        }
    }

    public int getStage() {
        return stage;
    }

    public void setStage(int stage) {
        this.stage = stage;
    }

    public long getBytesSent() {
        return bytesSent;
    }

    public void setBytesSent(long bytesSent) {
        this.bytesSent = bytesSent;
    }

    public long getBytesReceived() {
        return bytesReceived;
    }

    public void setBytesReceived(long bytesReceived) {
        this.bytesReceived = bytesReceived;
    }

    public long getProcessingTime() {
        return processingTime;
    }

    public void setProcessingTime(long processingTime) {
        this.processingTime = processingTime;
    }

    public long getMaxTime() {
        return maxTime;
    }

    public void setMaxTime(long maxTime) {
        this.maxTime = maxTime;
    }

    public String getMaxRequestUri() {
        return maxRequestUri;
    }

    public void setMaxRequestUri(String maxRequestUri) {
        this.maxRequestUri = maxRequestUri;
    }

    public int getRequestCount() {
        return requestCount;
    }

    public void setRequestCount(int requestCount) {
        this.requestCount = requestCount;
    }

    public int getErrorCount() {
        return errorCount;
    }

    public void setErrorCount(int errorCount) {
        this.errorCount = errorCount;
    }

    public String getWorkerThreadName() {
        return workerThreadName;
    }

    public ObjectName getRpName() {
        return rpName;
    }

    public long getLastRequestProcessingTime() {
        return lastRequestProcessingTime;
    }

    public void setWorkerThreadName(String workerThreadName) {
        this.workerThreadName = workerThreadName;
    }

    public void setRpName(ObjectName rpName) {
        this.rpName = rpName;
    }

    public void setLastRequestProcessingTime(long lastRequestProcessingTime) {
        this.lastRequestProcessingTime = lastRequestProcessingTime;
    }
}
