package org.apache.coyote;

import java.io.IOException;
import java.nio.ByteBuffer;
import java.util.concurrent.Executor;

import org.apache.tomcat.util.net.AbstractEndpoint.Handler.SocketState;
import org.apache.tomcat.util.net.SSLSupport;
import org.apache.tomcat.util.net.SocketStatus;
import org.apache.tomcat.util.net.SocketWrapper;


/**
 * Common interface for processors of all protocols.
 */
public interface Processor<S> {
    Executor getExecutor();
    SocketState process(SocketWrapper<S> socketWrapper) throws IOException;
    SocketState event(SocketStatus status) throws IOException;
    SocketState asyncDispatch(SocketStatus status);
    SocketState asyncPostProcess();
    UpgradeToken getUpgradeToken();
    SocketState upgradeDispatch(SocketStatus status) throws IOException;
    void errorDispatch();
    boolean isComet();
    boolean isAsync();
    boolean isUpgrade();
    Request getRequest();
    void recycle(boolean socketClosing);
    void setSslSupport(SSLSupport sslSupport);
    ByteBuffer getLeftoverInput();
}
