
package com.fr.exception;

/** ConversionException class. */
@SuppressWarnings("serial")
public class ConversionException extends Exception {
    public ConversionException(String message, Throwable cause) {
        super(message, cause);
    }

    public ConversionException(String message) {
        super(message);
    }

    public ConversionException(Throwable cause) {
        super(cause);
    }
}
