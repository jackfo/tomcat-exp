
package org.apache.util;

import java.net.MalformedURLException;
import java.net.URL;

/**
 * A special location resolver that uses Strings like URLs, but with more options
 *
 */

public class ClasspathLocationResolver implements LocationResolver {
    public URL resolveLocation(String location) throws MalformedURLException {
        return resolveLocation(location, null);
    }

    public URL resolveLocation(String location, ClassLoader loader) throws MalformedURLException {
        String baseLocation = FlexibleLocation.stripLocationType(location);
        // if there is a leading forward slash, remove it
        if (baseLocation.charAt(0) == '/') {
            baseLocation = baseLocation.substring(1);
        }
        return UtilURL.fromResource(baseLocation, loader);
    }
}
