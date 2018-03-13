
package org.apache.util;

import java.net.MalformedURLException;
import java.net.URL;

/**
 * A special location resolver that uses Strings like URLs, but with more options
 *
 */

public interface LocationResolver {
    public URL resolveLocation(String location) throws MalformedURLException;
}
