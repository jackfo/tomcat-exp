package org.apache.catalina;


/**
 * Interface defining a listener for significant events related to a
 * specific servlet instance, rather than to the Wrapper component that
 * is managing that instance.
 *
 * @author Craig R. McClanahan
 *
 * @deprecated Will be removed in 8.5.x onwards
 */
@Deprecated
public interface InstanceListener {


    /**
     * Acknowledge the occurrence of the specified event.
     *
     * @param event InstanceEvent that has occurred
     */
    public void instanceEvent(InstanceEvent event);


}
