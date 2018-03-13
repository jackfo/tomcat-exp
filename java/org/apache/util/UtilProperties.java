
package org.apache.util;


import java.io.BufferedInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.Serializable;
import java.math.BigDecimal;
import java.math.BigInteger;
import java.net.URL;
import java.util.*;

/** Generic Property Accessor with Cache - Utilities for working with properties files.
 * <p>UtilProperties divides properties files into two classes: non-locale-specific -
 * which are used for application parameters, configuration settings, etc; and
 * locale-specific - which are used for UI labels, system messages, etc. Each class
 * of properties files is kept in its own cache.</p>
 * <p>The locale-specific class of properties files can be in any one of three
 * formats: the standard text-based key=value format (*.properties file), the Java
 * XML properties format, and the OFBiz-specific XML file format
 * (see the <a href="#xmlToProperties(java.io.InputStream,%20java.util.Locale,%20java.util.Properties)">xmlToProperties</a>
 * method).</p>
 */
@SuppressWarnings("serial")
public class UtilProperties implements Serializable {

    public static final String module = UtilProperties.class.getName();




    private static final Set<String> propertiesNotFound = new HashSet<String>();

    /** Compares the specified property to the compareString, returns true if they are the same, false otherwise
     * @param resource The name of the resource - if the properties file is 'webevent.properties', the resource name is 'webevent'
     * @param name The name of the property in the properties file
     * @param compareString The String to compare the property value to
     * @return True if the strings are the same, false otherwise
     */
    public static boolean propertyValueEquals(String resource, String name, String compareString) {
        String value = getPropertyValue(resource, name);

        if (value == null) return false;
        return value.trim().equals(compareString);
    }

    /** Compares Ignoring Case the specified property to the compareString, returns true if they are the same, false otherwise
     * @param resource The name of the resource - if the properties file is 'webevent.properties', the resource name is 'webevent'
     * @param name The name of the property in the properties file
     * @param compareString The String to compare the property value to
     * @return True if the strings are the same, false otherwise
     */
    public static boolean propertyValueEqualsIgnoreCase(String resource, String name, String compareString) {
        String value = getPropertyValue(resource, name);

        if (value == null) return false;
        return value.trim().equalsIgnoreCase(compareString);
    }

    /** Returns the value of the specified property name from the specified resource/properties file.
     * If the specified property name or properties file is not found, the defaultValue is returned.
     * @param resource The name of the resource - if the properties file is 'webevent.properties', the resource name is 'webevent'
     * @param name The name of the property in the properties file
     * @param defaultValue The value to return if the property is not found
     * @return The value of the property in the properties file, or if not found then the defaultValue
     */
    public static String getPropertyValue(String resource, String name, String defaultValue) {
        String value = getPropertyValue(resource, name);

        if (UtilValidate.isEmpty(value))
            return defaultValue;
        else
            return value;
    }

    public static double getPropertyNumber(String resource, String name, double defaultValue) {
        String str = getPropertyValue(resource, name);
        if (str == null) {
            return defaultValue;
        }

        try {
            return Double.parseDouble(str);
        } catch (NumberFormatException nfe) {
            return defaultValue;
        }
    }

    public static double getPropertyNumber(String resource, String name) {
        return getPropertyNumber(resource, name, 0.00000);
    }



    /**
     * Returns a Boolean-Object of the specified property name from the specified resource/properties file.
     * If the specified property name or properties file is not found, the defaultValue is returned.
     * @param resource The name of the resource - if the properties file is 'webevent.properties', the resource name is 'webevent'
     * @param name The name of the property in the properties file
     * @param defaultValue Optional: The Value to return if the property is not found or not the correct format.
     * @return A Boolean-Object of the property; or if not found the defaultValue
     */
    public static Boolean getPropertyAsBoolean(String resource, String name, boolean defaultValue) {
        String str = getPropertyValue(resource, name);
        if ("true".equalsIgnoreCase(str)) return Boolean.TRUE;
        else if ("false".equalsIgnoreCase(str)) return Boolean.FALSE;
        else return defaultValue;
    }


    /**
     * Returns a BigInteger-Object of the specified property name from the specified resource/properties file.
     * If the specified property name or properties file is not found, the defaultNumber is returned.
     * @param resource The name of the resource - if the properties file is 'webevent.properties', the resource name is 'webevent'
     * @param name The name of the property in the properties file
     * @param defaultNumber Optional: The Value to return if the property is not found.
     * @return A BigInteger-Object of the property; or if not found the defaultNumber
     */
    public static BigInteger getPropertyAsBigInteger(String resource, String name, BigInteger defaultNumber) {
        String strValue = getPropertyValue(resource, name);
        BigInteger result = defaultNumber;
        try {
            result = new BigInteger(strValue);
        } catch (NumberFormatException nfe) {
            Debug.logWarning("Couldnt convert String \"" + strValue + "\" to BigInteger; using defaultNumber " + defaultNumber.toString() + ".", module);
        }
        return result;
    }

    /**
     * Returns a BigDecimal-Object of the specified property name from the specified resource/properties file.
     * If the specified property name or properties file is not found, the defaultNumber is returned.
     * @param resource The name of the resource - if the properties file is 'webevent.properties', the resource name is 'webevent'
     * @param name The name of the property in the properties file
     * @param defaultNumber Optional: The Value to return if the property is not found.
     * @return A BigDecimal-Object of the property; or if not found the defaultNumber
     */
    public static BigDecimal getPropertyAsBigDecimal(String resource, String name, BigDecimal defaultNumber) {
        String strValue = getPropertyValue(resource, name);
        BigDecimal result = defaultNumber;
        try {
            result = new BigDecimal(strValue);
        } catch (NumberFormatException nfe) {
            Debug.logWarning("Couldnt convert String \"" + strValue + "\" to BigDecimal; using defaultNumber " + defaultNumber.toString() + ".", module);
        }
        return result;
    }

    /** Returns the value of the specified property name from the specified resource/properties file
     * @param resource The name of the resource - can be a file, class, or URL
     * @param name The name of the property in the properties file
     * @return The value of the property in the properties file
     */
    public static String getPropertyValue(String resource, String name) {
        if (resource == null || resource.length() <= 0) return "";
        if (name == null || name.length() <= 0) return "";

        Properties properties = getProperties(resource);
        if (properties == null) {
            return "";
        }

        String value = null;

        try {
            value = properties.getProperty(name);
        } catch (Exception e) {
            Debug.logInfo(e, module);
        }
        return value == null ? "" : value.trim();
    }

    /**
     * Returns a new <code>Properties</code> instance created from <code>fileName</code>.
     * <p>This method is intended for low-level framework classes that need to read
     * properties files before OFBiz has been fully initialized.</p>
     * 
     * @param fileName The full name of the properties file ("foo.properties")
     * @return A new <code>Properties</code> instance created from <code>fileName</code>, or
     * <code>null</code> if the file was not found
     * @throws IllegalArgumentException if <code>fileName</code> is empty
     * @throws IllegalStateException if there was a problem reading the file
     */
    public static Properties createProperties(String fileName) {
        InputStream inStream = null;
        try {
            URL url = Thread.currentThread().getContextClassLoader().getResource(fileName);
            if (url == null) {
                return null;
            }
            inStream = url.openStream();
            Properties properties = new Properties();
            properties.load(inStream);
            return properties;
        } catch (Exception e) {
            throw new IllegalStateException("Exception thrown while reading " + fileName + ": " + e);
        } finally {
            if (inStream != null) {
                try {
                    inStream.close();
                } catch (IOException e) {
                    System.out.println("Exception thrown while closing InputStream: " + e);
                }
            }
        }
    }






    // ========= URL Based Methods ==========

    /** Compares the specified property to the compareString, returns true if they are the same, false otherwise
     * @param url URL object specifying the location of the resource
     * @param name The name of the property in the properties file
     * @param compareString The String to compare the property value to
     * @return True if the strings are the same, false otherwise
     */
    public static boolean propertyValueEquals(URL url, String name, String compareString) {
        String value = getPropertyValue(url, name);

        if (value == null) return false;
        return value.trim().equals(compareString);
    }

    /** Compares Ignoring Case the specified property to the compareString, returns true if they are the same, false otherwise
     * @param url URL object specifying the location of the resource
     * @param name The name of the property in the properties file
     * @param compareString The String to compare the property value to
     * @return True if the strings are the same, false otherwise
     */
    public static boolean propertyValueEqualsIgnoreCase(URL url, String name, String compareString) {
        String value = getPropertyValue(url, name);

        if (value == null) return false;
        return value.trim().equalsIgnoreCase(compareString);
    }

    /** Returns the value of the specified property name from the specified resource/properties file.
     * If the specified property name or properties file is not found, the defaultValue is returned.
     * @param url URL object specifying the location of the resource
     * @param name The name of the property in the properties file
     * @param defaultValue The value to return if the property is not found
     * @return The value of the property in the properties file, or if not found then the defaultValue
     */
    public static String getPropertyValue(URL url, String name, String defaultValue) {
        String value = getPropertyValue(url, name);

        if (value == null || value.length() <= 0)
            return defaultValue;
        else
            return value;
    }

    public static double getPropertyNumber(URL url, String name, double defaultValue) {
        String str = getPropertyValue(url, name);
        if (str == null) {
            return defaultValue;
        }

        try {
            return Double.parseDouble(str);
        } catch (NumberFormatException nfe) {
            return defaultValue;
        }
    }

    public static double getPropertyNumber(URL url, String name) {
        return getPropertyNumber(url, name, 0.00000);
    }

    /** Returns the value of the specified property name from the specified resource/properties file
     * @param url URL object specifying the location of the resource
     * @param name The name of the property in the properties file
     * @return The value of the property in the properties file
     */
    public static String getPropertyValue(URL url, String name) {
        if (url == null) return "";
        if (name == null || name.length() <= 0) return "";
        Properties properties = getProperties(url);

        if (properties == null) {
            return null;
        }

        String value = null;

        try {
            value = properties.getProperty(name);
        } catch (Exception e) {
            Debug.logInfo(e, module);
        }
        return value == null ? "" : value.trim();
    }



    protected static Set<String> resourceNotFoundMessagesShown = new HashSet<String>();
    /** Returns the specified resource/properties file as a ResourceBundle
     * @param resource The name of the resource - can be a file, class, or URL
     * @param locale The locale that the given resource will correspond to
     * @return The ResourceBundle
     */

    private static Properties properties ;

    public static Properties getProperties(URL url) {
        if (url == null) {
            return null;
        }
        String cacheKey = url.toString();
        if (properties == null) {
            try {
                properties = new ExtendedProperties(url, null);
            } catch (Exception e) {
                Debug.logInfo(e, module);
            }
        }
        if (properties == null) {
            Debug.logInfo("[UtilProperties.getProperties] could not find resource: " + url, module);
            return null;
        }
        return properties;
    }

    public static Properties getProperties(String resource) {
        if (resource == null || resource.length() <= 0) {
            return null;
        }
        URL url = resolvePropertiesUrl(resource, null);
        return getProperties(url);
    }

    /** Returns the specified resource/properties file.<p>Note that this method
     * will return a Properties instance for the specified locale <em>only</em> -
     * if you need <a href="http://www.w3.org/International/">I18n</a> properties, then use
     * <a href="#getResourceBundle(java.lang.String,%20java.util.Locale)">
     * getResourceBundle(String resource, Locale locale)</a>. This method is
     * intended to be used primarily by the UtilProperties class.</p>
     * @param resource The name of the resource - can be a file, class, or URL
     * @param locale The desired locale
     * @return The Properties instance, or null if no matching properties are found
     */
    public static Properties getProperties(String resource, Locale locale) {
        if (UtilValidate.isEmpty(resource)) {
            throw new IllegalArgumentException("resource cannot be null or empty");
        }
        if (locale == null) {
            throw new IllegalArgumentException("locale cannot be null");
        }
        Properties properties = null;
        URL url = resolvePropertiesUrl(resource, locale);
        if (url != null) {
            try {
                properties = new ExtendedProperties(url, locale);
            } catch (Exception e) {
                if (UtilValidate.isNotEmpty(e.getMessage())) {
                    Debug.logInfo(e.getMessage(), module);
                } else {
                    Debug.logInfo("Exception thrown: " + e.getClass().getName(), module);
                }
                properties = null;
            }
        }
        if (UtilValidate.isNotEmpty(properties)) {
            if (Debug.verboseOn()) Debug.logVerbose("Loaded " + properties.size() + " properties for: " + resource + " (" + locale + ")", module);
        }
        return properties;
    }

    // ========= Classes and Methods for expanded Properties file support ========== //





    /** Create a localized resource name based on a resource name and
     * a locale.
     * @param resource The desired resource
     * @param locale The desired locale
     * @param removeExtension Remove file extension from resource String
     * @return Localized resource name
     */
    public static String createResourceName(String resource, Locale locale, boolean removeExtension) {
        String resourceName = resource;
        if (removeExtension) {
            if (resourceName.endsWith(".xml")) {
                resourceName = resourceName.replace(".xml", "");
            } else if (resourceName.endsWith(".properties")) {
                resourceName = resourceName.replace(".properties", "");
            }
        }
        if (locale != null) {
            if (UtilValidate.isNotEmpty(locale.toString())) {
                resourceName = resourceName + "_" + locale;
            }
        }
        return resourceName;
    }

    public static boolean isPropertiesResourceNotFound(String resource, Locale locale, boolean removeExtension) {
        return propertiesNotFound.contains(createResourceName(resource, locale, removeExtension));
    }

    /** Resolve a properties file URL.
     * <p>This method uses the following strategy:<br />
     * <ul>
     * <li>Locate the XML file specified in <code>resource (MyProps.xml)</code></li>
     * <li>Locate the file that starts with the name specified in
     * <code>resource</code> and ends with the locale's string and
     * <code>.xml (MyProps_en.xml)</code></li>
     * <li>Locate the file that starts with the name specified in
     * <code>resource</code> and ends with the locale's string and
     * <code>.properties (MyProps_en.properties)</code></li>
     * <li>Locate the file that starts with the name specified in
     * <code>resource and ends with the locale's string (MyProps_en)</code></li>
     * </ul>
     * <br />
     * The <code>component://</code> protocol is supported in the
     * <code>resource</code> parameter.
     * </p>
     *
     * @param resource The resource to resolve
     * @param locale The desired locale
     * @return A URL instance or null if not found.
     */
    public static URL resolvePropertiesUrl(String resource, Locale locale) {
        if (UtilValidate.isEmpty(resource)) {
            throw new IllegalArgumentException("resource cannot be null or empty");
        }
        String resourceName = createResourceName(resource, locale, false);
        if (propertiesNotFound.contains(resourceName)) {
            return null;
        }
        boolean containsProtocol = resource.contains(":");
        ClassLoader loader = Thread.currentThread().getContextClassLoader();
        URL url = null;
        try {
            // Check for complete URL first
            if (resource.endsWith(".xml") || resource.endsWith(".properties")) {
                if (containsProtocol) {
                    url = FlexibleLocation.resolveLocation(resource, loader);
                } else {
                    url = UtilURL.fromResource(resource, loader);
                }
                if (url != null) {
                    return url;
                }
            }
            // Check for *.properties file
            if (containsProtocol) {
                url = FlexibleLocation.resolveLocation(resourceName + ".properties", loader);
            } else {
                url = UtilURL.fromResource(resourceName + ".properties", loader);
            }
            if (url != null) {
                return url;
            }
            // Check for Java XML properties file
            if (containsProtocol) {
                url = FlexibleLocation.resolveLocation(resourceName + ".xml", loader);
            } else {
                url = UtilURL.fromResource(resourceName + ".xml", loader);
            }
            if (url != null) {
                return url;
            }
            // Check for Custom XML properties file
            if (containsProtocol) {
                url = FlexibleLocation.resolveLocation(resource + ".xml", loader);
            } else {
                url = UtilURL.fromResource(resource + ".xml", loader);
            }
            if (url != null) {
                return url;
            }
            if (containsProtocol) {
                url = FlexibleLocation.resolveLocation(resource, loader);
            } else {
                url = UtilURL.fromResource(resource, loader);
            }
            if (url != null) {
                return url;
            }
        } catch (Exception e) {
            Debug.logInfo("Properties resolver: invalid URL - " + e.getMessage(), module);
        }
        if (propertiesNotFound.size() <= 300) {
            // Sanity check - list could get quite large
            propertiesNotFound.add(resourceName);
        }
        return null;
    }

    public static class ExtendedProperties extends Properties {
        public ExtendedProperties() {
            super();
        }
        public ExtendedProperties(Properties defaults) {
            super(defaults);
        }
        public ExtendedProperties(URL url, Locale locale) throws IOException, InvalidPropertiesFormatException {
            InputStream in = null;
            try {
                in = new BufferedInputStream(url.openStream());

            } finally {
                if (in != null) {
                    in.close();
                }
            }
        }
        @Override
        public void loadFromXML(InputStream in) throws IOException, InvalidPropertiesFormatException {
            try {
                //xmlToProperties(in, null, this);
            } finally {
                in.close();
            }
        }
    }


}
