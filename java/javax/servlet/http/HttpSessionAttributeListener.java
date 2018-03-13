package javax.servlet.http;

import java.util.EventListener;

/**
 * This listener interface can be implemented in order to get notifications of
 * changes to the attribute lists of sessions within this web application.
 *
 * @since v 2.3
 */
public interface HttpSessionAttributeListener extends EventListener {

    /**
     * Notification that an attribute has been added to a session. Called after
     * the attribute is added.
     *
     * @param se Information about the added attribute
     */
    public void attributeAdded(HttpSessionBindingEvent se);

    /**
     * Notification that an attribute has been removed from a session. Called
     * after the attribute is removed.
     *
     * @param se Information about the removed attribute
     */
    public void attributeRemoved(HttpSessionBindingEvent se);

    /**
     * Notification that an attribute has been replaced in a session. Called
     * after the attribute is replaced.
     *
     * @param se Information about the replaced attribute
     */
    public void attributeReplaced(HttpSessionBindingEvent se);
}
