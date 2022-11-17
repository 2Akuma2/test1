from de.qfs.apps.qftest.client.script.modules import SutContext as _WrappedSutContext
class SutContext(object):
    """ The current run context"""
    #  redirected constants
    """ Error level for check in case of failure: No error."""
    OK = _WrappedSutContext.OK
    """ Error level for check in case of failure: Warning."""
    WARNING = _WrappedSutContext.WARNING
    """ Error level for check in case of failure: Error."""
    ERROR = _WrappedSutContext.ERROR
    """ Error level for check in case of failure: Exception."""
    EXCEPTION = _WrappedSutContext.EXCEPTION
    """ State of a called test-case, if it has been skipped."""
    SKIPPED = _WrappedSutContext.SKIPPED
    """ State of a called test-case, if it has not been implemented."""
    NOT_IMPLEMENTED = _WrappedSutContext.NOT_IMPLEMENTED
    #  redirected methods
    def __init__(self, language):
        self.__wrappedInstance = _WrappedSutContext.instance(language)
    
    def expand(self, text):
        """
        Expand a string using standard QF-Test variable expansion for $(...) or
        ${...:...} syntax. Note: Remember to double the '$' signs to avoid
        expansion before the script is executed.
        
        @param text
        The string to expand.
        """
        return self.__wrappedInstance.expand(text)
    
    def getComponent(self, id, timeout=-1, hidden=False):
        """
        SUT only. Find a component or a component's sub-item using QF-Test's
        component recognition mechanism.
        
        @param id
        The 'Id' of the 'Component' node that represents the component
        in the test-suite.
        
        @param timeout
        The maximum time to wait for the component if it is not found
        instantly. A negative value, the default, means use the value
        from the option Wait for non-existent component (ms).
        
        @param hidden
        If true, find invisible components as well. Useful for
        menu-items.
        
        @return The actual Java component. For sub-items, a pair of the form
        (component, index) is returned, where the type of index depends
        on the type of the item. For tree nodes it is a
        javax.swing.tree.TreePath object, for tablecells a pair of the
        form (row, column) and an integer for all other kinds of items.
        Note: Column indexes returned are always given in table
        coordinates, not in model coordinates.
        """
        if hidden:
            hidden = True
        
        else:
            hidden = False
        
        return self.__wrappedInstance.getComponent(id, timeout, hidden)
    
    def getLastComponent(self):
        """
        Get the last component that was addressed by QF-Test for replaying some
        event, check or miscellaneous operation. Calls to rc.getComponent() have
        no impact.
        
        @return The last component addressed by QF-Test.
        """
        return self.__wrappedInstance.getLastComponent()
    
    def getLastItem(self):
        """
        Get the last item that was addressed by QF-Test for replaying some event,
        check or miscellaneous operation. Calls to rc.getComponent() have no
        impact.
        
        @return The last item addressed by QF-Test.
        """
        return self.__wrappedInstance.getLastItem()
    
    def callProcedure(self, procname, parameters=None):
        """
        Call a 'Procedure' in a test-suite. Note: As a convenience, this method
        can also be called from an 'SUT script'. Care should be taken however,
        because the script is executed inside the AWT event dispatch thread, so
        weird side-effects are possible, though QF-Test does its best to avoid
        these. If possible, call 'Procedures' from a 'Server script' instead.
        
        @param procname
        The fully qualified name of the 'Procedure'.
        @param parameters
        The parameters for the 'Procedure'. This should be a Map. Its
        keys and values can be arbitrary values. They are converted to
        strings for the call.
        @return The value returned from the 'Procedure' through an optional
        'Return' node.
        """
        return self.__wrappedInstance.callProcedure(procname, parameters)
    
    def toServer(self, *args, **kw):
        """
        SUT only. Set some global variables in the Jython interpreter of QF-Test.
        Each argument can be any of: <b>A string</b> This is treated as the name
        of a global variable in the local interpreter. The variable by the same
        name in QF-Test's interpreter is set to its value. <b>A Jython dictionary
        with string keys</b> For each key in the dictionary, a global variable by
        that name is set to the corresponding value from the dictionary. <b>A
        keyword argument in the form name=value</b> The global variable named
        name is set to value.
        
        @throws TestException
        @throws RemoteException
        """
        self.__wrappedInstance.toServer(args, kw)
    
    def fromServer(self, name):
        """
        SUT only. Retrieve the value of a global variable in the engine of
        QF-Test. If the variable is undefined, a KeyError is raised.
        
        @param name
        The name of the variable.
        @return The value of the variable.
        """
        return self.__wrappedInstance.fromServerJython(name)
    
    def overrideElement(self, id, element):
        """
        SUT only. Override the target GUI element for component recognition for
        an element with the given id statically.
        
        @param id
        The id of the GUI element to override.
        @param element
        The GUI element to return as the resolved target. Null to
        revert to the default mechanism.
        """
        self.__wrappedInstance.overrideElement(id, element)
    
    def pushScope(self, focusID, element):
        """
        SUT only. Push a component scope.
        
        @param focusID
        An identifier for the scope element.
        @param element
        The GUI element to set as scope.
        """
        self.__wrappedInstance.pushScope(focusID, element)
    
    def getAndPushScope(self, id):
        """
        SUT only. Find a component or a component's sub-item using QF-Test's
        component recognition mechanism and push it as the scope component.
        
        @param id
        The 'Id' of the 'Component' node that represents the component
        in the test-suite.
        """
        self.__wrappedInstance.getAndPushScope(id)
    
    def popScope(self, elementOrScopeId=None, popChildren=True):
        """
        SUT only. Pop a component scope.
        
        @param id
        The 'Id' of the 'Component' node that represents the component
        in the test-suite.
        """
        if popChildren:
            popChildren = True
        
        else:
            popChildren = False
        
        self.__wrappedInstance.popScopeJython(elementOrScopeId, popChildren)
    
    def resetScope(self):
        """ SUT only. Completely reset the scope stack."""
        self.__wrappedInstance.resetScope()
    
    def dynamicOverrideElement(self, id, provider):
        """
        SUT only. Override the target GUI element for component recognition for
        an element with the given id dynamically.
        
        @param id
        The id of the GUI element to override.
        @param provider
        Reference to the method to call when the item is about to be
        resolved. Null to revert to the default mechanism.
        """
        self.__wrappedInstance.dynamicOverrideElement(id, provider)
    
    def blockHardEvents(self):
        self.__wrappedInstance.blockHardEvents()
    
    def unblockHardEvents(self):
        self.__wrappedInstance.unblockHardEvents()
    
    def getEngine(self):
        return self.__wrappedInstance.getEngine()
    
    def setEngine(self, engine):
        self.__wrappedInstance.setEngine(engine)
    
    def getAccess(self):
        return self.__wrappedInstance.getAccess()
    
    def setAccess(self, access):
        self.__wrappedInstance.setAccess(access)
    
    def setExContext(self, exContext):
        self.__wrappedInstance.setExContext(exContext)
    
    def getExContext(self):
        return self.__wrappedInstance.getExContext()
    
    def setContext(self, context):
        self.__wrappedInstance.setContext(context)
    
    def getContext(self):
        return self.__wrappedInstance.getContext()
    
    def _pushVars(self, context, access, engine):
        self.__wrappedInstance._pushVars(context, access, engine)
    
    def _popVars(self):
        self.__wrappedInstance._popVars()
    
    def logMessage(self, message, dontcompactify=False, report=False, nowrap=False):
        """
        Add a plain message to the run log.
        
        @param message
        The message to log.
        @param dontcompactify
        If true, the message will never be removed from a compact
        run-log.
        @param report
        If true, the message will appear in the report.
        @param nowrap
        If true, lines of the message will not appear wrapped in the
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
        
        self.__wrappedInstance.logMessage(message, dontcompactify, report, nowrap)
    
    def logWarning(self, message, report=True, nowrap=False):
        """
        Add a warning message to the run log.
        
        @param message
        The message to log.
        @param report
        If true, the message will appear in the report.
        @param nowrap
        If true, lines of the message will not appear wrapped in the
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
        
        self.__wrappedInstance.logWarning(message, report, nowrap)
    
    def logError(self, message, nowrap=False):
        """
        Add an error message to the run log.
        
        @param message
        Add an error message to the run log.
        @param nowrap
        If true, lines of the message will not appear wrapped in the
        report. Use for potentially long messages.
        """
        if nowrap:
            nowrap = True
        
        else:
            nowrap = False
        
        self.__wrappedInstance.logError(message, nowrap)
    
    def logImage(self, image, title=None, dontcompactify=False, report=False):
        """
        Add an image to the run-log
        
        @param image
        The ImageRep for the log.
        @param title
        An optional title for the image.
        @param dontcompactify
        True to ensure that the image is not compactify.
        @param report
        True to log the image in the report (implies dontcompactify).
        """
        if dontcompactify:
            dontcompactify = True
        
        else:
            dontcompactify = False
        
        if report:
            report = True
        
        else:
            report = False
        
        self.__wrappedInstance.logImage(image, title, dontcompactify, report)
    
    def check(self, condition, message, level=2, report=True, nowrap=False):
        """
        Check or "assert" that a condition is true and log a message according to
        the result.
        
        @param condition
        The condition to evaluate.
        @param message
        The message to log. It will be preceded by "Check OK: " or
        "Check failed: " depending on the result. For the old-style
        XML or HTML report the message will be treated like a 'Check'
        node if it starts with an '!' character.
        @param level
        The error level in case of failure. The following constants
        are defined in the run-context: rc.OK rc.WARNING rc.ERROR
        rc.EXCEPTION If the level is rc.EXCEPTION, a UserException
        will be thrown if the check fails.
        @param report
        If true, the check will appear in the report. Only applicable
        if level <= 1.
        @param nowrap
        If true, lines of the message will not appear wrapped in the
        report. Use for potentially long messages.
        @return The result of the check.
        """
        if condition:
            condition = True
        
        else:
            condition = False
        
        if report:
            report = True
        
        else:
            report = False
        
        if nowrap:
            nowrap = True
        
        else:
            nowrap = False
        
        return self.__wrappedInstance.check(condition, message, level, report, nowrap)
    
    def checkEqual(self, actual, expected, message, level=2, report=True, nowrap=False):
        """
        Check or "assert" that an object matches a given value and log a message
        according to the result. Comparison is done using the == operator.
        
        @param actual
        The actual value.
        @param expected
        The expected value.
        @param message
        The message to log. It will be preceded by "Check OK: " or
        "Check failed: " depending on the result. In case of failure,
        the expected and actual values will also be logged. For the
        old-style XML or HTML report the message will be treated like
        a 'Check' node if it starts with an '!' character.
        @param level
        The error level in case of failure. The following constants
        are defined in the run-context: rc.OK rc.WARNING rc.ERROR
        rc.EXCEPTION If the level is rc.EXCEPTION, a UserException
        will be thrown if the check fails.
        @param report
        If true, the check will appear in the report. Only applicable
        if level <= 1.
        @param nowrap
        If true, lines of the message will not appear wrapped in the
        report. Use for potentially long messages.
        @return The result of the check.
        """
        if report:
            report = True
        
        else:
            report = False
        
        if nowrap:
            nowrap = True
        
        else:
            nowrap = False
        
        return self.__wrappedInstance.checkEqual(actual, expected, message, level, report, nowrap)
    
    def checkImage(self, actual, expected, message, level=2, report=True, nowrap=False):
        """
        Compare two ImageRep objects.
        
        @param actual
        The actual image for comparison.
        @param expected
        The expected image for comparison.
        @param message
        Error message for the run-log.
        @param level
        The error level in case of failure. The following constants
        are defined in the run-context: rc.OK rc.WARNING rc.ERROR
        rc.EXCEPTION If the level is rc.EXCEPTION, a UserException
        will be thrown if the check fails.
        @param report
        If true, the check will appear in the report. Only applicable
        if level <= 1.
        @param nowrap
        If true, lines of the message will not appear wrapped in the
        report. Use for potentially long messages.
        
        @return The result of the check
        """
        if report:
            report = True
        
        else:
            report = False
        
        if nowrap:
            nowrap = True
        
        else:
            nowrap = False
        
        return self.__wrappedInstance.checkImage(actual, expected, message, level, report, nowrap)
    
    def checkImageAdvanced(self, actual, expected, message, algorithm, level=2, report=True, nowrap=False):
        """
        Compare two ImageRep objects by using an algorithm.
        
        @param actual
        The actual image for comparison.
        @param expected
        The expected image for comparison.
        @param message
        Error message for the run-log.
        @param algorithm
        The algorithm to use for this check.
        @param level
        The error level in case of failure. The following constants
        are defined in the run-context: rc.OK rc.WARNING rc.ERROR
        rc.EXCEPTION If the level is rc.EXCEPTION, a UserException
        will be thrown if the check fails.
        @param report
        If true, the check will appear in the report. Only applicable
        if level <= 1.
        @param nowrap
        If true, lines of the message will not appear wrapped in the
        report. Use for potentially long messages.
        @return An array with following content: Check result as Boolean. Check
        result as probability. Transformation of expected image if
        available. Transformation of actual image if available.
        """
        if report:
            report = True
        
        else:
            report = False
        
        if nowrap:
            nowrap = True
        
        else:
            nowrap = False
        
        return self.__wrappedInstance.checkImageAdvanced(actual, expected, message, algorithm, level, report, nowrap)
    
    def getStr(self, var1, var2=None, expand=True):
        """
        Look up the value of a QF-Test variable, similar to lookup().
        
        @param var1
        The name of the variable or group.
        @param var2
        The name of the resource or property for the given group.
        @param expand
        Whether to expand the value of the variable recursively. If,
        for example, the value of $(varname) is the literal string
        "$(othervar)", this method will return the expanded value of
        $(othervar) if expand is true and "$(othervar)" itself if
        expand is false. Note that if you want to set this parameter,
        you must use Python keyword syntax to avoid conflicts with
        lookup(String group, String name), i.e. rc.lookup("var",
        expand=False) instead of rc.lookup("var", 0).
        @return The value of the variable as string.
        """
        if expand:
            expand = True
        
        else:
            expand = False
        
        return self.__wrappedInstance.getStr(var1, var2, expand)
    
    def getPattern(self, var1, var2=None, expand=True):
        """
        Return a Pattern using the value of a QF-Test variable as regular expression.
        
        @param var1
        The name of the variable or group.
        @param var2
        The name of the resource or property for the given group.
        @param expand
        Whether to expand the value of the variable recursively. If,
        for example, the value of $(varname) is the literal string
        "$(othervar)", this method will return the expanded value of
        $(othervar) if expand is true and "$(othervar)" itself if
        expand is false. Note that if you want to set this parameter,
        you must use Python keyword syntax to avoid conflicts with
        lookup(String group, String name), i.e. rc.lookup("var",
        expand=False) instead of rc.lookup("var", 0).
        @return The value of the variable as string.
        """
        if expand:
            expand = True
        
        else:
            expand = False
        
        return self.__wrappedInstance.getPattern(var1, var2, expand)
    
    def getInt(self, var1, var2=None, expand=True):
        """
        Return the value of a QF-Test variable as Integer.
        
        @param var1
        The name of the variable or group.
        @param var2
        The name of the resource or property for the given group.
        @return The value of the variable.
        """
        if expand:
            expand = True
        
        else:
            expand = False
        
        return self.__wrappedInstance.getInt(var1, var2, expand)
    
    def getNum(self, var1, var2=None, expand=True):
        """
        Look up the value of a QF-Test variable, similar to lookup(), but treat
        it as a number, i.e. an integer or a float, depending on its format.
        
        @param var1
        The name of the variable or group.
        @param var2
        The name of the resource or property for the given group.
        @return The value of the variable as int.
        """
        if expand:
            expand = True
        
        else:
            expand = False
        
        return self.__wrappedInstance.getNum(var1, var2, expand)
    
    def getBool(self, var1, var2=None, expand=True):
        """
        Look up the value of a QF-Test variable, similar to lookup(), but treat
        it as a boolean.
        
        @param var1
        The name of the variable or group.
        @param var2
        The name of the resource or property for the given group.
        @return The value of the variable as boolean.
        """
        if expand:
            expand = True
        
        else:
            expand = False
        
        return self.__wrappedInstance.getBoolJython(var1, var2, expand)
    
    def lookup(self, var1, var2=None, expand=True):
        """
        Look up the value of a QF-Test variable, similar to ${group:varname}.
        
        @param var1
        The name of the variable or group.
        @param var2
        The name of the resource or property for the given group.
        @param expand
        Whether to expand the value of the variable recursively. If,
        for example, the value of $(varname) is the literal string
        "$(othervar)", this method will return the expanded value of
        $(othervar) if expand is true and "$(othervar)" itself if
        expand is false.
        @return The value of the variable.
        """
        if expand:
            expand = True
        
        else:
            expand = False
        
        return self.__wrappedInstance.lookup(var1, var2, expand)
    
    def setGlobal(self, name, value):
        """
        Define a global QF-Test variable.
        
        @param name
        The name of the variable.
        @param value
        An arbitrary value for the variable. It is automatically
        converted to a string. A value of None unsets the variable.
        """
        self.__wrappedInstance.setGlobal(name, value)
    
    def setLocal(self, name, value):
        """
        Define a local QF-Test variable.
        
        @param name
        The name of the variable.
        @param value
        An arbitrary value for the variable. It is automatically
        converted to a string. A value of None unsets the variable.
        """
        self.__wrappedInstance.setLocal(name, value)
    
    def setProperty(self, group, name, value):
        """
        Set the value of a resource or property in a group. Note: This method
        also works for the special groups 'system' and 'env' and can be used as a
        means to set environment variables and system properties. Values in the
        special group 'qftest' cannot be set or changed that way.
        
        @param group
        The name of the group. A new group is created automatically if
        necessary.
        
        @param name
        The name of the resource or property.
        @param value
        An arbitrary value for the property. It is automatically
        converted to a string. A value of None or null unsets the
        property.
        """
        self.__wrappedInstance.setProperty(group, name, value)
    
    def getGlobals(self):
        """
        Get the global bindings of the context.
        
        @return The global bindings of the context.
        """
        return self.__wrappedInstance.getGlobals()
    
    def getLocals(self, nonEmpty=False):
        """
        Get the innermost local bindings of the context.
        
        @param nonEmpty
        True to get the first non-empty set of bindings, false to get
        the innermost bindings even when empty.
        @return The context's innermost local bindings.
        """
        if nonEmpty:
            nonEmpty = True
        
        else:
            nonEmpty = False
        
        return self.__wrappedInstance.getLocals(nonEmpty)
    
    def getProperties(self, group):
        """
        Get a set of loaded properties or resources.
        
        @param group
        The group name of the properties or resources.
        @return The properties bound for the given group or None if no such group
        exists.
        """
        return self.__wrappedInstance.getProperties(group)
    
    def stopTest(self):
        """ Stop the current test-run by raising a StopException."""
        self.__wrappedInstance.stopTest()
    
    def stopTestCase(self, expectedFail=False):
        """
        Stop the execution of the current test-case.
        
        @param expectedFail
        If true, mark possible errors in this test-case as expected
        failures.
        """
        if expectedFail:
            expectedFail = True
        
        else:
            expectedFail = False
        
        self.__wrappedInstance.stopTestCase(expectedFail)
    
    def stopTestSet(self):
        """ Stop the current test-set by raising a TestCaseStoppedException."""
        self.__wrappedInstance.stopTestSet()
    
    def skipTestCase(self):
        """ Skip the current test-case by raising a TestCaseSkippedException."""
        self.__wrappedInstance.skipTestCase()
    
    def skipTestSet(self):
        """ Skip the current test-set by raising a TestCaseSkippedException."""
        self.__wrappedInstance.skipTestSet()
    
    def getOption(self, name):
        """
        Get an option value.
        
        @param name
        The name of the option to get as defined in the 'Options'
        class.
        """
        return self.__wrappedInstance.getOption(name)
    
    def setOption(self, name, value):
        """
        Set an option value. An option defined in a script has higher precedence
        than the options defined in the Option dialog.
        
        @param name
        The name of the option to set as defined in the 'Options'
        class.
        @param value
        The new value for the option.
        """
        self.__wrappedInstance.setOption(name, value)
    
    def unsetOption(self, name, *ignored):
        """
        Unset an option value by removing the option from those defined at script
        level so that the original option defined in the Option dialog is used
        again.
        
        @param name
        The name of the option to unset as defined in the 'Options'
        class.
        """
        self.__wrappedInstance.unsetOption(name, ignored)
    
    def isOptionSet(self, name):
        """
        Test whether an option has been set at script level.
        
        @param name
        The name of the option to get as defined in the 'Options'
        class.
        @return True if the option has been set, false otherwise.
        """
        return self.__wrappedInstance.isOptionSet(name)
    
    def id(self, id):
        """
        Return the 'QF-Test ID' of a given ${id:QF-Test ID} expression. You
        should use this command to update the script in case of 'QF-Test ID'
        changes.
        
        @param id
        The ${id:QF-Test ID} expression.
        @return The 'QF-Test ID' of the searched component.
        """
        return self.__wrappedInstance.id(id)
    
    def valueToBoolean(self, value):
        return self.__wrappedInstance.valueToBoolean(value)
    
    def logData(self, name=None, kw=None):
        """
        Add a generic node created from the parameters to the current run-log.
        
        @param text
        The name of the node.
        @param kw
        Optional text content for the node. Additional keyword
        arguments are attributes to set for the node.
        """
        self.__wrappedInstance.logData(name, kw)
    
    def logNode(self, node):
        """
        Add a generic node to the current run-log.
        
        @param node
        The node to add.
        """
        self.__wrappedInstance.logNode(node)
    
    def execHTTPRequest(self, url, method, query, logresponse, responsevar=None, islocal=False, timeout=None, statusCodeVar=None, timeoutRet=None, responseHeaders=None, headerMap=None, statusCodeErrorLevel=3):
        if logresponse:
            logresponse = True
        
        else:
            logresponse = False
        
        if islocal:
            islocal = True
        
        else:
            islocal = False
        
        return self.__wrappedInstance.execHTTPRequest(url, method, query, logresponse, responsevar, islocal, timeout, statusCodeVar, timeoutRet, responseHeaders, headerMap, statusCodeErrorLevel)
    
    def getLanguageName(self):
        return self.__wrappedInstance.languageName
    
    engine = property(getEngine, None)
    access = property(getAccess, setAccess)
    exContext = property(getExContext, setExContext)
    context = property(getContext, setContext)
    languageName = property(getLanguageName, None)

