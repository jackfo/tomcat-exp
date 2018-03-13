
package org.apache.util;

import java.net.MalformedURLException;
import java.net.URL;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Properties;

/**
 * A special location resolver that uses Strings like URLs, but with more options.
 *
 */
public final class FlexibleLocation {

    private static final Map<String, LocationResolver> locationResolvers;

    static {
        Map<String, LocationResolver> resolverMap = new HashMap<String, LocationResolver>(8);
        LocationResolver standardUrlResolver = new StandardUrlLocationResolver();
        resolverMap.put("http", standardUrlResolver);
        resolverMap.put("https", standardUrlResolver);
        resolverMap.put("ftp", standardUrlResolver);
        resolverMap.put("jar", standardUrlResolver);
        resolverMap.put("file", standardUrlResolver);
        resolverMap.put("classpath", new ClasspathLocationResolver());
        try {
            /* Note that the file must be placed in framework/base/config -
             * because this class may be initialized before all components
             * are loaded.
             */
            Properties properties = UtilProperties.createProperties("locationresolvers.properties");
            if (properties != null) {
                ClassLoader classLoader = Thread.currentThread().getContextClassLoader();
                for (Entry<Object, Object> entry : properties.entrySet()) {
                    String locationType = (String) entry.getKey();
                    String locationResolverName = (String) entry.getValue();
                    Class<?> lClass = classLoader.loadClass(locationResolverName);
                    resolverMap.put(locationType, (LocationResolver) lClass.newInstance());
                }
            }
        } catch (Throwable e) {
            System.out.println("Exception thrown while loading locationresolvers.properties: " + e);
        }
        locationResolvers = Collections.unmodifiableMap(resolverMap);
    }

    /**
     * Find the location type descriptor for the passed location String;
     *   generally is all text before the first ":" character.
     *   If no type descriptor is found, defaults to "classpath".
     *   截断冒号和冒号前的字符，便于找到compoent等组件 返回值就是compoent 等
     *   如果没有的就是classpath
     */
    private static String getLocationType(String location) {
        int colonIndex = location.indexOf(":");
        if (colonIndex > 0) {
            return location.substring(0, colonIndex);
        } else {
            return "classpath";
        }
    }

    /**
     * Resolves the gives location into a URL object for use in various ways.
     * 解决了位置到一个URL对象以不同的方式使用
     * The general format of the location is like a URL: {locationType}://location/path/file.ext
     * 一般格式的位置就像一个URL:{locationType}://location/path/file.ext
     * Supports standard locationTypes like http, https, ftp, jar, & file
     * 支持标准locationTypes像http、https、ftp, jar, & file
     * Supports a classpath location type for when desired to be used like any other URL
     * 支持类路径位置类型被使用像其他URL
     * Supports OFBiz specific location types like fadphome and component
     * 支持OFBiz特定位置类型fadphome和component
     * Supports additional locationTypes specified in the locationresolvers.properties file
     * 支持额外添加的路径类型
     * @param location The location String to parse and create a URL from
     * @return URL object corresponding to the location String passed in
     * @throws MalformedURLException
     */
    public static URL resolveLocation(String location) throws MalformedURLException {
        return resolveLocation(location, null);
    }

    public static URL resolveLocation(String location, ClassLoader loader) throws MalformedURLException {
         if (UtilValidate.isEmpty(location)) {
            return null;
        }
        String locationType = getLocationType(location);
        LocationResolver resolver = locationResolvers.get(locationType);
        if (resolver != null) {
            if (loader != null && resolver instanceof ClasspathLocationResolver) {
                ClasspathLocationResolver cplResolver = (ClasspathLocationResolver) resolver;
                return cplResolver.resolveLocation(location, loader);
            } else {
                return resolver.resolveLocation(location);
            }
        } else {
            throw new MalformedURLException("Could not find a LocationResolver for the location type: " + locationType);
        }
    }
    //将文件前面的类型名 类如http compent等去去掉 第一层只留下一个分号
    public static String stripLocationType(String location) {
        if (UtilValidate.isEmpty(location)) {
            return "";
        }
        StringBuilder strippedSoFar = new StringBuilder(location);
        // first take care of the colon and everything before it
        int colonIndex = strippedSoFar.indexOf(":");
        if (colonIndex == 0) {
            strippedSoFar.deleteCharAt(0);
        } else if (colonIndex > 0) {
            strippedSoFar.delete(0, colonIndex + 1);
        }
        // now remove any extra forward slashes, ie as long as the first two are forward slashes remove the first one
        while (strippedSoFar.charAt(0) == '/' && strippedSoFar.charAt(1) == '/') {
            strippedSoFar.deleteCharAt(0);
        }
        return strippedSoFar.toString();
    }

    private FlexibleLocation() {}
}
