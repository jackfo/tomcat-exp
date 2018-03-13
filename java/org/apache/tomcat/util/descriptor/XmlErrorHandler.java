package org.apache.tomcat.util.descriptor;

import java.util.ArrayList;
import java.util.List;

import org.apache.juli.logging.Log;
import org.apache.tomcat.util.res.StringManager;
import org.apache.util.Debug;
import org.xml.sax.ErrorHandler;
import org.xml.sax.SAXException;
import org.xml.sax.SAXParseException;

public class XmlErrorHandler implements ErrorHandler {

    public static final String module = XmlErrorHandler.class.getName();

    private static final StringManager sm =
        StringManager.getManager(Constants.PACKAGE_NAME);

    private final List<SAXParseException> errors = new ArrayList<>();

    private final List<SAXParseException> warnings = new ArrayList<>();

    @Override
    public void error(SAXParseException exception) throws SAXException {
        // Collect non-fatal errors
        errors.add(exception);
    }

    @Override
    public void fatalError(SAXParseException exception) throws SAXException {
        // Re-throw fatal errors
        throw exception;
    }

    @Override
    public void warning(SAXParseException exception) throws SAXException {
        // Collect warnings
        warnings.add(exception);
    }

    public List<SAXParseException> getErrors() {
        // Internal use only - don't worry about immutability
        return errors;
    }

    public List<SAXParseException> getWarnings() {
        // Internal use only - don't worry about immutability
        return warnings;
    }

    public void logFindings(Log log, String source) {
        for (SAXParseException e : getWarnings()) {
            Debug.logWarning(sm.getString("xmlErrorHandler.warning", e.getMessage(), source),module);
        }
        for (SAXParseException e : getErrors()) {
            Debug.logWarning(sm.getString("xmlErrorHandler.error", e.getMessage(), source),module);
        }
    }
}
