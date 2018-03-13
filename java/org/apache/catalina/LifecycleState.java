package org.apache.catalina;


/**
 * 采用枚举的主要作用是，能够对当前状态进行判断看其available
 * 从而实现是否能够调用对应事件
 * */
public enum LifecycleState {
    NEW(false, null),
    INITIALIZING(false, Lifecycle.BEFORE_INIT_EVENT),
    INITIALIZED(false, Lifecycle.AFTER_INIT_EVENT),
    STARTING_PREP(false, Lifecycle.BEFORE_START_EVENT),
    STARTING(true, Lifecycle.START_EVENT),
    STARTED(true, Lifecycle.AFTER_START_EVENT),
    STOPPING_PREP(true, Lifecycle.BEFORE_STOP_EVENT),
    STOPPING(false, Lifecycle.STOP_EVENT),
    STOPPED(false, Lifecycle.AFTER_STOP_EVENT),
    DESTROYING(false, Lifecycle.BEFORE_DESTROY_EVENT),
    DESTROYED(false, Lifecycle.AFTER_DESTROY_EVENT),
    FAILED(false, null),
    /**
     * @deprecated Unused. Will be removed in Tomcat 8.5.x. The state transition
     *             checking in {@link org.apache.catalina.util.LifecycleBase}
     *             makes it impossible to use this state. The intended behaviour
     *             can be obtained by setting the state to
     *             {@link LifecycleState#FAILED} in
     *             <code>LifecycleBase.startInternal()</code>
     */
    @Deprecated
    MUST_STOP(true, null),
    /**
     * @deprecated Unused. Will be removed in Tomcat 8.5.x. The state transition
     *             checking in {@link org.apache.catalina.util.LifecycleBase}
     *             makes it impossible to use this state. The intended behaviour
     *             can be obtained by implementing {@link Lifecycle.SingleUse}.
     */
    @Deprecated
    MUST_DESTROY(false, null);

    private final boolean available;
    private final String lifecycleEvent;

    private LifecycleState(boolean available, String lifecycleEvent) {
        this.available = available;
        this.lifecycleEvent = lifecycleEvent;
    }

    /**
     * 判断该组件状态是否可以获取lifecycleEvent值
     * 以及是否可以调用某些具体方法
     * */
    public boolean isAvailable() {
        return available;
    }

    /**
     * 获取组件的生命周期的状态
     * */
    public String getLifecycleEvent() {
        return lifecycleEvent;
    }

}
