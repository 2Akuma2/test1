from de.qfs.apps.qftest.script.modules import ServerContext as _WrappedServerContext
class ServerContext(object):
    """ The current run context"""
    #  redirected constants
    """ Error level for check in case of failure: No error."""
    OK = _WrappedServerContext.OK
    """ Error level for check in case of failure: Warning."""
    WARNING = _WrappedServerContext.WARNING
    """ Error level for check in case of failure: Error."""
    ERROR = _WrappedServerContext.ERROR
    """ Error level for check in case of failure: Exception."""
    EXCEPTION = _WrappedServerContext.EXCEPTION
    """ State of a called test-case, if it has been skipped."""
    SKIPPED = _WrappedServerContext.SKIPPED
    """ State of a called test-case, if it has not been implemented."""
    NOT_IMPLEMENTED = _WrappedServerContext.NOT_IMPLEMENTED
    #  redirected methods
    def __init__(self, languageName):
        self.__wrappedInstance = _WrappedServerContext.instance(languageName)
    
    def callProcedure(self, proc, param=None, **kw):
        """
        Call a 'Procedure' in a test-suite. Note: As a convenience, this method
        can also be called from an 'SUT script'. Care should be taken however,
        because the script is executed inside the AWT event dispatch thread, so
        weird side-effects are possible, though QF-Test does its best to avoid
        these. If possible, call 'Procedures' from a 'Server script' instead.
        
        @param procname
        The fully qualified name of the 'Procedure'.
        @param parameters
        The parameters for the 'Procedure' as Map. Its keys and values
        can be arbitrary values. They are converted to strings for the
        call.
        @return The value returned from the 'Procedure' through an optional
        'Return' node.
        """
        return self.__wrappedInstance.callProcedure(proc, param, kw)
    
    def expand(self, text):
        """
        Expand a string using standard QF-Test variable expansion for $(...) or
        ${...:...} syntax. Note: Remember to double the '$' signs to avoid
        expansion before the script is executed.
        
        @param text
        The string to expand.
        @return The expanded string.
        """
        return self.__wrappedInstance.expand(text)
    
    def addResetListener(self, listener):
        """
        Add a listener for listening on Run -> Reset everything. The listener
        should implement the interface
        de.qfs.apps.qftest.extensions.qftest.ResetListener.
        
        @param listener
        The listener to add.
        """
        self.__wrappedInstance.addResetListener(listener)
    
    def removeResetListener(self, listener):
        """
        Remove a listener listening on Run -> Reset everything.
        
        @param listener
        The listener to remove.
        @return True if the listener was found in the list and was removed.
        """
        return self.__wrappedInstance.removeResetListener(listener)
    
    def isResetListenerRegistered(self, listener):
        """
        Check if a listener is registered.
        
        @param listener
        The listener to check, if it is registered.
        """
        return self.__wrappedInstance.isResetListenerRegistered(listener)
    
    def flushLog(self):
        """
        Server only. Flush buffered log entries to prevent them from being
        compactified. Equivalent to logging an error but without the side
        effects.
        """
        self.__wrappedInstance.flushLog()
    
    def getLastException(self):
        """
        Server only. Get the last exception (caught or uncaught) that was thrown
        during the test-run. In most cases getCaughtException is probably more
        useful.
        
        @return The most recent exception that was thrown.
        """
        return self.__wrappedInstance.getLastException()
    
    def getCaughtException(self):
        """
        Server only. If the script is run inside a 'Catch' node, the exception
        that was caught is returned. Similarly, if a 'Test' node has the
        'Implicitly catch exceptions' attribute set, the caught exception is
        available during execution of the 'Test' node's 'Cleanup' node. In all
        other cases, null is returned.
        
        @return The caught exception.
        """
        return self.__wrappedInstance.getCaughtException()
    
    def logDiagnostics(self, client, engine=None):
        """
        Server only. Adds event information stored in the SUT for possible error
        diagnosis to the run-log.
        
        @param client
        The name of the SUT client from which to get the information.
        """
        self.__wrappedInstance.logDiagnostics(client, engine)
    
    def toSUT(self, client, *args, **kw):
        """
        Server only. Set some global variables in the Jython interpreter of the
        SUT.
        
        @param client
        The name of the SUT client. Except for client, each argument
        can be any of: <b>A string</b> This is treated as the name of
        a global variable in the local interpreter. The variable by
        the same name in SUT's interpreter is set to its value. <b>A
        Jython dictionary with string keys</b> For each key in the
        dictionary, a global variable by that name is set to the
        corresponding value from the dictionary. <b>A keyword argument
        in the form name=value</b> The global variable named name is
        set to value.
        @throws TestException
        @throws RemoteException
        """
        self.__wrappedInstance.toSUT(client, args, kw)
    
    def fromSUT(self, client, name):
        """
        Server only. Retrieve the value of a global variable in the script
        interpreter of the SUT. If the variable is undefined, a KeyError is
        raised.
        
        @param client
        The name of the SUT client.
        @param name
        The name of the variable.
        @return The value of the variable.
        """
        return self.__wrappedInstance.fromSUTJython(client, name)
    
    def clearGlobals(self):
        """ Server only. Undefine all global variables."""
        self.__wrappedInstance.clearGlobals()
    
    def getPropertyGroupNames(self):
        """
        List all available property group names defined by the user. Names are
        returned in alphabetic order.
        """
        return self.__wrappedInstance.getPropertyGroupNames()
    
    def clearProperties(self, group):
        """
        Clear a given group of properties or resources.
        
        @param group
        The group name of the properties or resources.
        """
        self.__wrappedInstance.clearProperties(group)
    
    def syncThreads(self, id, timeout, count=-1, remote=0, throw=True):
        """
        Server only. Synchronize a number of parallel threads for load testing.
        The current thread is blocked until all threads have reached this
        synchronization point or the timeout is exceeded. In the latter case, a
        TestException is thrown or an error logged.
        
        @param id
        An identifier for the synchronization point.
        @param timeout
        The maximum time to wait in milliseconds.
        @param count
        The number of threads to wait for. Default value -1 means all
        threads in the current QF-Test instance.
        @param remote
        The number of QF-Test instances - potentially running on
        different machines - to synchronize. Default 0 means don't do
        remote synchronization.
        @param throwEx
        Whether to throw an exception (default) or just log an error
        if the timeout is exceeded without all threads reaching the
        synchronization point.
        """
        if throw:
            throw = True
        
        else:
            throw = False
        
        return self.__wrappedInstance.syncThreadsJython(id, timeout, count, remote, throw)
    
    def addDaemonLog(self, data, name=None, comment=None, externalizename=None):
        """
        Add a run-log retrieved from a DaemonRunContext to the current run-log.
        
        @param data
        The byte array retrieved via DaemonRunContext.getRunLog().
        @param name
        An optional name for the daemon log node. If unspecified the
        ID of the Daemon is used.
        @param comment
        An optional comment for the daemon log node.
        @param externalizename
        An optional name to externalize the daemon log and save it as
        a partial log of a split run-log.
        """
        self.__wrappedInstance.addDaemonLog(data, name, comment, externalizename)
    
    def callTest(self, testname, param=None, **kw):
        """
        Call a 'Test-Case' or 'Test-Set' in a test-suite.
        
        @param test
        The fully qualified name of the 'Test-Case' or 'Test-Set'.
        @param param
        The parameters for the called node. This should be a
        dictionary. Its keys and values can be arbitrary values. They
        are converted to strings for the call.
        @return The result of the test. Either rc.OK, rc.WARNING, rc.ERROR,
        rc.EXCEPTION, rc.SKIPPED or rc.NOT_IMPLEMENTED.
        """
        return self.__wrappedInstance.callTest(testname, param, kw)
    
    def callTestAsProcedure(self, testname, param=None, **kw):
        return self.__wrappedInstance.callTestAsProcedure(testname, param, kw)
    
    def runCleanup(self, dependency=None):
        self.__wrappedInstance.runCleanup(dependency)
    
    def addDataBinder(self, identifier, binder, counterName=None, intervals=None):
        self.__wrappedInstance.addDataBinder(identifier, binder, counterName, intervals)
    
    def getEngine(self, id):
        return self.__wrappedInstance.getEngine(id)
    
    def addTestRunListener(self, listener):
        """
        Register a TestRunListener with the current run-context.
        
        @param listener
        The listener to register.
        """
        self.__wrappedInstance.addTestRunListener(listener)
    
    def removeTestRunListener(self, listener):
        """
        Unregister a TestRunListener from the current run-context.
        
        @param listener
        The listener to unregister.
        """
        self.__wrappedInstance.removeTestRunListener(listener)
    
    def clearTestRunListeners(self):
        """ Unregister all TestRunListeners from the current run-context."""
        self.__wrappedInstance.clearTestRunListeners()
    
    def getConnectedClients(self):
        """
        Get the names of the currently connected SUT clients.
        
        @return A list with the names of the currently connected SUT clients, an
        empty list in case there are none.
        """
        return self.__wrappedInstance.getConnectedClients()
    
    def resolveDependency(self, dependency, namespace=None, param=None, **kw):
        """
        Resolve a 'Dependency'.
        
        @param dependendy
        The fully qualified name of the 'Dependency' to resolve.
        @param namespace
        An optional namespace to resolve the 'Dependency' in.
        @param parameters
        The parameters for the 'Dependency'. This should be a
        dictionary. Its keys and values can be arbitrary values. They
        are converted to strings for the call.
        """
        self.__wrappedInstance.resolveDependency(dependency, namespace, param, kw)
    
    def rollbackDependencies(self, namespace=None):
        """
        Unroll the dependency stack.
        
        @param namespace
        An optional namespace to unroll the dependencies in.
        """
        self.__wrappedInstance.rollbackDependencies(namespace)
    
    def resetDependencies(self, namespace=None):
        """
        Completely reset the dependency stack without executing any cleanup.
        
        @param namespace
        An optional namespace to reset the dependencies for.
        """
        self.__wrappedInstance.resetDependencies(namespace)
    
    def setContext(self, context):
        self.__wrappedInstance.setContext(context)
    
    def getContext(self):
        return self.__wrappedInstance.getContext()
    
    def _setSharedContext(self, context):
        self.__wrappedInstance._setSharedContext(context)
    
    def _setLocalContext(self, context):
        self.__wrappedInstance._setLocalContext(context)
    
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
    
    context = property(getContext, setContext)
    languageName = property(getLanguageName, None)

