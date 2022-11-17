from de.qfs.apps.qftest.shared.script.modules import QF as _WrappedQF
#  redirected constants
#  redirected methods
def getClassName(objectOrClass):
    """
    Get the fully qualified name of the Class of a Java object, or of a Java
    class itself.
    
    @param objectOrClass
    The Java object or class to get the class name for.
    @return The class name or "null" in case something non-Java is passed in.
    """
    return _WrappedQF.getClassName(objectOrClass)

def isInstance(object, className):
    """
    Test whether an object is an instance of a given class or implements a
    given interface. The test is deliberately performed on class names to
    avoid class loader problems.
    
    @param object
    The object to test.
    @param className
    The name of an interface or class.
    
    @return true if the object is an instance of the given class or
    implements the given interface, false otherwise.
    """
    return _WrappedQF.isInstance(object, className)

def toString(object, nullValue=""):
    """
    Get the string representation of an object.
    
    @param object
    The object to get the string representation for.
    @param nullValue
    The value to return if object is None, the empty string by
    default.
    @return The string value of the object. For Jython, 8-bit or unicode
    strings are returned unchanged, Java objects are turned into a
    unicode string via toString, everything else is converted to an
    8-bit Jython string.
    """
    return _WrappedQF.toString(object, nullValue)

def setProperty(object, name, value):
    """
    Set an arbitrary property for an object. For Swing, SWT or web components
    the value is stored in the respective user data via putClientProperty,
    setData or setProperty respectively. For everything else a WeakHashMap is
    used. Either way the property will not prevent garbage collection of the
    object.
    
    @param object
    The object to set the property for.
    @param name
    The name of the property.
    @param value
    The value to set. Null to remove the property.
    """
    _WrappedQF.setProperty(object, name, value)

def getProperty(object, name):
    """
    Get a property for an object that was previously set via setProperty.
    
    @param object
    The object to get the property for.
    @param name
    The name of the property.
    
    @return The property value.
    """
    return _WrappedQF.getProperty(object, name)

def logMessage(msg, dontcompactify=False, report=False, nowrap=False):
    """
    Add a plain message to the run log. @param msg The message to log.
    
    @param dontcompactify
    If true, the message will never be removed from a compact
    run-log.
    @param report
    If true, the message will appear in the report.
    @param nowrap
    If true, lines of the message will not be wrapped in the
    report. Use for potentially long messages.
    """
    if dontcompactify:
        dontcompactify = True
    
    else:
        dontcompactify = False
    
    if report:
        report = True
    
    else:
        report = False
    
    if nowrap:
        nowrap = True
    
    else:
        nowrap = False
    
    _WrappedQF.logMessage(msg, dontcompactify, report, nowrap)

def logWarning(msg, report=True, nowrap=False):
    """
    Add a warning message to the run log.
    
    @param msg
    The message to log.
    @param report
    If true, the message will appear in the report.
    @param nowrap
    If true, lines of the message will not be wrapped in the
    report. Use for potentially long messages.
    """
    if report:
        report = True
    
    else:
        report = False
    
    if nowrap:
        nowrap = True
    
    else:
        nowrap = False
    
    _WrappedQF.logWarning(msg, report, nowrap)

def logError(msg, nowrap=False):
    """
    Add an error message to the run log.
    
    @param msg
    The message to log.
    @param nowrap
    If true, lines of the message will not be wrapped in the
    report. Use for potentially long messages.
    """
    if nowrap:
        nowrap = True
    
    else:
        nowrap = False
    
    _WrappedQF.logError(msg, nowrap)

def getCleanText(text):
    """
    Clean a given text. It replaces HTML 'nbsp' character and replace all
    linebreak variants with \n.
    
    @param text
    The text to clean.
    @return The cleaned text
    """
    return _WrappedQF.getCleanText(text)

def asPattern(regexp):
    """
    Creates a pattern object from the given regex string
    
    @param regex
    The string to compile to a Pattern.
    
    @return Pattern created by using the string as regular expression
    """
    return _WrappedQF.asPattern(regexp)

def getRC():
    """
    Calls internal method to obtain a RunContext object. Useful in situations, where the "rc" variable
    is not available or outdated.
    
    Depending on the situation where the script is executed, there is no vaild run context available,
    so be prepared that method calls to the returned object might throw exceptions, e.g. when used
    in checkers or called during component highlighting.
    
    @return A RunContext object
    """
    return _WrappedQF.getRC()

def setRCProvider(rcProviderMethod):
    _WrappedQF.setRCProvider(rcProviderMethod)

def getCurrentInterpreterName():
    return _WrappedQF.getCurrentInterpreterName()

def _print(*obj):
    """ Prints an object to the terminal using the String.valueOf(Object) method."""
    _WrappedQF._print(obj)

def println(*obj):
    """
    Prints one or several objects to the terminal using the String.valueOf(Object) method and then terminates the line.
    
    @param obj...
    The objects to print on the terminal. If several objects are given, they
    are concatenated using a space symbol.
    """
    _WrappedQF.println(obj)

