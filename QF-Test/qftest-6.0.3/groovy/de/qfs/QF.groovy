package de.qfs
import java.util.regex.Pattern
class QF{
    //  redirected constants
    //  redirected methods
    /**
     * Get the fully qualified name of the Class of a Java object, or of a Java
     * class itself.
     * 
     * @param objectOrClass
     * The Java object or class to get the class name for.
     * @return The class name or "null" in case something non-Java is passed in.
     */
    public  static String getClassName(Object objectOrClass){
        return de.qfs.apps.qftest.shared.script.modules.QF.getClassName(objectOrClass)
    }
    /**
     * Test whether an object is an instance of a given class or implements a
     * given interface. The test is deliberately performed on class names to
     * avoid class loader problems.
     * 
     * @param object
     * The object to test.
     * @param className
     * The name of an interface or class.
     * 
     * @return true if the object is an instance of the given class or
     * implements the given interface, false otherwise.
     */
    public  static boolean isInstance(Object object, String className){
        return de.qfs.apps.qftest.shared.script.modules.QF.isInstance(object, className)
    }
    /**
     * Get the string representation of an object.
     * 
     * @param object
     * The object to get the string representation for.
     * @param nullValue
     * The value to return if object is None, the empty string by
     * default.
     * @return The string value of the object. For Jython, 8-bit or unicode
     * strings are returned unchanged, Java objects are turned into a
     * unicode string via toString, everything else is converted to an
     * 8-bit Jython string.
     */
    public  static Object toString(Object object, Object nullValue=""){
        return de.qfs.apps.qftest.shared.script.modules.QF.toString(object, nullValue)
    }
    /**
     * Get the string representation of an object.
     * 
     * @param object
     * The object to get the string representation for.
     * @param nullValue
     * The value to return if object is None, the empty string by
     * default.
     * @return The string value of the object. For Jython, 8-bit or unicode
     * strings are returned unchanged, Java objects are turned into a
     * unicode string via toString, everything else is converted to an
     * 8-bit Jython string.
     */
    public  static Object toString(Map mappedParams, Object object){
        if(mappedParams == null){
            return de.qfs.apps.qftest.shared.script.modules.QF.toString(mappedParams, object)
        }
        def nullValue = ""
        if(mappedParams.containsKey("nullValue")){
            nullValue = mappedParams.nullValue
        }
        return de.qfs.apps.qftest.shared.script.modules.QF.toString(object, nullValue)
    }
    /**
     * Set an arbitrary property for an object. For Swing, SWT or web components
     * the value is stored in the respective user data via putClientProperty,
     * setData or setProperty respectively. For everything else a WeakHashMap is
     * used. Either way the property will not prevent garbage collection of the
     * object.
     * 
     * @param object
     * The object to set the property for.
     * @param name
     * The name of the property.
     * @param value
     * The value to set. Null to remove the property.
     */
    public  static void setProperty(Object object, String name, Object value){
        de.qfs.apps.qftest.shared.script.modules.QF.setProperty(object, name, value)
    }
    /**
     * Get a property for an object that was previously set via setProperty.
     * 
     * @param object
     * The object to get the property for.
     * @param name
     * The name of the property.
     * 
     * @return The property value.
     */
    public  static Object getProperty(Object object, String name){
        return de.qfs.apps.qftest.shared.script.modules.QF.getProperty(object, name)
    }
    /**
     * Add a plain message to the run log. @param msg The message to log.
     * 
     * @param dontcompactify
     * If true, the message will never be removed from a compact
     * run-log.
     * @param report
     * If true, the message will appear in the report.
     * @param nowrap
     * If true, lines of the message will not be wrapped in the
     * report. Use for potentially long messages.
     */
    public  static void logMessage(String msg, boolean dontcompactify=false, boolean report=false, boolean nowrap=false){
        de.qfs.apps.qftest.shared.script.modules.QF.logMessage(msg, dontcompactify, report, nowrap)
    }
    /**
     * Add a plain message to the run log. @param msg The message to log.
     * 
     * @param dontcompactify
     * If true, the message will never be removed from a compact
     * run-log.
     * @param report
     * If true, the message will appear in the report.
     * @param nowrap
     * If true, lines of the message will not be wrapped in the
     * report. Use for potentially long messages.
     */
    public  static void logMessage(Map mappedParams, String msg){
        def dontcompactify = false
        if(mappedParams.containsKey("dontcompactify")){
            dontcompactify = mappedParams.dontcompactify
        }
        def report = false
        if(mappedParams.containsKey("report")){
            report = mappedParams.report
        }
        def nowrap = false
        if(mappedParams.containsKey("nowrap")){
            nowrap = mappedParams.nowrap
        }
        de.qfs.apps.qftest.shared.script.modules.QF.logMessage(msg, dontcompactify, report, nowrap)
    }
    /**
     * Add a warning message to the run log.
     * 
     * @param msg
     * The message to log.
     * @param report
     * If true, the message will appear in the report.
     * @param nowrap
     * If true, lines of the message will not be wrapped in the
     * report. Use for potentially long messages.
     */
    public  static void logWarning(String msg, boolean report=true, boolean nowrap=false){
        de.qfs.apps.qftest.shared.script.modules.QF.logWarning(msg, report, nowrap)
    }
    /**
     * Add a warning message to the run log.
     * 
     * @param msg
     * The message to log.
     * @param report
     * If true, the message will appear in the report.
     * @param nowrap
     * If true, lines of the message will not be wrapped in the
     * report. Use for potentially long messages.
     */
    public  static void logWarning(Map mappedParams, String msg){
        def report = true
        if(mappedParams.containsKey("report")){
            report = mappedParams.report
        }
        def nowrap = false
        if(mappedParams.containsKey("nowrap")){
            nowrap = mappedParams.nowrap
        }
        de.qfs.apps.qftest.shared.script.modules.QF.logWarning(msg, report, nowrap)
    }
    /**
     * Add an error message to the run log.
     * 
     * @param msg
     * The message to log.
     * @param nowrap
     * If true, lines of the message will not be wrapped in the
     * report. Use for potentially long messages.
     */
    public  static void logError(String msg, boolean nowrap=false){
        de.qfs.apps.qftest.shared.script.modules.QF.logError(msg, nowrap)
    }
    /**
     * Add an error message to the run log.
     * 
     * @param msg
     * The message to log.
     * @param nowrap
     * If true, lines of the message will not be wrapped in the
     * report. Use for potentially long messages.
     */
    public  static void logError(Map mappedParams, String msg){
        if(mappedParams == null){
            de.qfs.apps.qftest.shared.script.modules.QF.logError(mappedParams, msg)
        }
        def nowrap = false
        if(mappedParams.containsKey("nowrap")){
            nowrap = mappedParams.nowrap
        }
        de.qfs.apps.qftest.shared.script.modules.QF.logError(msg, nowrap)
    }
    /**
     * Clean a given text. It replaces HTML 'nbsp' character and replace all
     * linebreak variants with \n.
     * 
     * @param text
     * The text to clean.
     * @return The cleaned text
     */
    public  static String getCleanText(String text){
        return de.qfs.apps.qftest.shared.script.modules.QF.getCleanText(text)
    }
    /**
     * Creates a pattern object from the given regex string
     * 
     * @param regex
     * The string to compile to a Pattern.
     * 
     * @return Pattern created by using the string as regular expression
     */
    public  static Pattern asPattern(String regexp){
        return de.qfs.apps.qftest.shared.script.modules.QF.asPattern(regexp)
    }
    /**
     * Calls internal method to obtain a RunContext object. Useful in situations, where the "rc" variable
     * is not available or outdated.
     * 
     * Depending on the situation where the script is executed, there is no vaild run context available,
     * so be prepared that method calls to the returned object might throw exceptions, e.g. when used
     * in checkers or called during component highlighting.
     * 
     * @return A RunContext object
     */
    public  static Object getRC(){
        return de.qfs.apps.qftest.shared.script.modules.QF.getRC()
    }
    public  static void setRCProvider(Object rcProviderMethod){
        de.qfs.apps.qftest.shared.script.modules.QF.setRCProvider(rcProviderMethod)
    }
    public  static String getCurrentInterpreterName(){
        return de.qfs.apps.qftest.shared.script.modules.QF.getCurrentInterpreterName()
    }
    /**
     * Prints one or several objects to the terminal using the String.valueOf(Object) method.
     * 
     * @param obj...
     * The objects to print on the terminal. If several objects are given, they
     * are concatenated using a space symbol.
     */
    public  static void print(Object... obj){
        de.qfs.apps.qftest.shared.script.modules.QF.print(obj)
    }
    /**
     * Prints one or several objects to the terminal using the String.valueOf(Object) method and then terminates the line.
     * 
     * @param obj...
     * The objects to print on the terminal. If several objects are given, they
     * are concatenated using a space symbol.
     */
    public  static void println(Object... obj){
        de.qfs.apps.qftest.shared.script.modules.QF.println(obj)
    }
}
