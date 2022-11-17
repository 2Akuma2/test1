package de.qfs
import de.qfs.apps.qftest.shared.extensions.Node
import java.util.regex.Pattern
import de.qfs.apps.qftest.shared.exceptions.TestException
import java.util.List
import de.qfs.apps.qftest.extensions.qftest.TestRunListener
import java.util.Map
import java.util.HashMap
import de.qfs.apps.qftest.run.RMIRunContext
import de.qfs.apps.qftest.extensions.qftest.ResetListener
import de.qfs.apps.qftest.extensions.qftest.DataBinder
import java.util.Properties
import de.qfs.apps.qftest.shared.extensions.image.ImageRep
/** The current run context */
class ServerContext{
    //  redirected constants
    /** Error level for check in case of failure: No error. */
    final public static int OK = de.qfs.apps.qftest.script.modules.ServerContext.OK
    /** Error level for check in case of failure: Warning. */
    final public static int WARNING = de.qfs.apps.qftest.script.modules.ServerContext.WARNING
    /** Error level for check in case of failure: Error. */
    final public static int ERROR = de.qfs.apps.qftest.script.modules.ServerContext.ERROR
    /** Error level for check in case of failure: Exception. */
    final public static int EXCEPTION = de.qfs.apps.qftest.script.modules.ServerContext.EXCEPTION
    /** State of a called test-case, if it has been skipped. */
    final public static int SKIPPED = de.qfs.apps.qftest.script.modules.ServerContext.SKIPPED
    /** State of a called test-case, if it has not been implemented. */
    final public static int NOT_IMPLEMENTED = de.qfs.apps.qftest.script.modules.ServerContext.NOT_IMPLEMENTED
    //  redirected methods
    private final de.qfs.apps.qftest.script.modules.ServerContext __wrappedInstance
    public ServerContext(String languageName){
        __wrappedInstance = de.qfs.apps.qftest.script.modules.ServerContext.instance(languageName)
    }
    /**
     * Call a 'Procedure' in a test-suite. Note: As a convenience, this method
     * can also be called from an 'SUT script'. Care should be taken however,
     * because the script is executed inside the AWT event dispatch thread, so
     * weird side-effects are possible, though QF-Test does its best to avoid
     * these. If possible, call 'Procedures' from a 'Server script' instead.
     * 
     * @param procname
     * The fully qualified name of the 'Procedure'.
     * @param parameters
     * The parameters for the 'Procedure' as Map. Its keys and values
     * can be arbitrary values. They are converted to strings for the
     * call.
     * @return The value returned from the 'Procedure' through an optional
     * 'Return' node.
     */
    public String callProcedure(String procname, Map parameters=null){
        return __wrappedInstance.callProcedure(procname, parameters)
    }
    /**
     * Call a 'Procedure' in a test-suite. Note: As a convenience, this method
     * can also be called from an 'SUT script'. Care should be taken however,
     * because the script is executed inside the AWT event dispatch thread, so
     * weird side-effects are possible, though QF-Test does its best to avoid
     * these. If possible, call 'Procedures' from a 'Server script' instead.
     * 
     * @param procname
     * The fully qualified name of the 'Procedure'.
     * @param parameters
     * The parameters for the 'Procedure' as Map. Its keys and values
     * can be arbitrary values. They are converted to strings for the
     * call.
     * @return The value returned from the 'Procedure' through an optional
     * 'Return' node.
     */
    public String callProcedure(Map mappedParams, String procname){
        return __wrappedInstance.callProcedure(procname, mappedParams)
    }
    /**
     * Expand a string using standard QF-Test variable expansion for $(...) or
     * ${...:...} syntax. Note: Remember to double the '$' signs to avoid
     * expansion before the script is executed.
     * 
     * @param text
     * The string to expand.
     * @return The expanded string.
     */
    public String expand(String text){
        return __wrappedInstance.expand(text)
    }
    /**
     * Add a listener for listening on Run -> Reset everything. The listener
     * should implement the interface
     * de.qfs.apps.qftest.extensions.qftest.ResetListener.
     * 
     * @param listener
     * The listener to add.
     */
    public void addResetListener(ResetListener listener){
        __wrappedInstance.addResetListener(listener)
    }
    /**
     * Remove a listener listening on Run -> Reset everything.
     * 
     * @param listener
     * The listener to remove.
     * @return True if the listener was found in the list and was removed.
     */
    public boolean removeResetListener(ResetListener listener){
        return __wrappedInstance.removeResetListener(listener)
    }
    /**
     * Check if a listener is registered.
     * 
     * @param listener
     * The listener to check, if it is registered.
     */
    public boolean isResetListenerRegistered(ResetListener listener){
        return __wrappedInstance.isResetListenerRegistered(listener)
    }
    /**
     * Server only. Flush buffered log entries to prevent them from being
     * compactified. Equivalent to logging an error but without the side
     * effects.
     */
    public void flushLog(){
        __wrappedInstance.flushLog()
    }
    /**
     * Server only. Get the last exception (caught or uncaught) that was thrown
     * during the test-run. In most cases getCaughtException is probably more
     * useful.
     * 
     * @return The most recent exception that was thrown.
     */
    public TestException getLastException(){
        return __wrappedInstance.getLastException()
    }
    /**
     * Server only. If the script is run inside a 'Catch' node, the exception
     * that was caught is returned. Similarly, if a 'Test' node has the
     * 'Implicitly catch exceptions' attribute set, the caught exception is
     * available during execution of the 'Test' node's 'Cleanup' node. In all
     * other cases, null is returned.
     * 
     * @return The caught exception.
     */
    public TestException getCaughtException(){
        return __wrappedInstance.getCaughtException()
    }
    /**
     * Server only. Adds event information stored in the SUT for possible error
     * diagnosis to the run-log.
     * 
     * @param client
     * The name of the SUT client from which to get the information.
     */
    public void logDiagnostics(String client, String engine=null){
        __wrappedInstance.logDiagnostics(client, engine)
    }
    /**
     * Server only. Adds event information stored in the SUT for possible error
     * diagnosis to the run-log.
     * 
     * @param client
     * The name of the SUT client from which to get the information.
     */
    public void logDiagnostics(Map mappedParams, String client){
        if(mappedParams == null){
            __wrappedInstance.logDiagnostics(mappedParams, client)
        }
        def engine = null
        if(mappedParams.containsKey("engine")){
            engine = mappedParams.engine
        }
        __wrappedInstance.logDiagnostics(client, engine)
    }
    /**
     * Server only. Set some global variables in the script interpreter of the
     * SUT.
     * 
     * @param client
     * The name of the SUT client.
     * @param vars
     * For each key in the map, a global variable by that name is set
     * to the corresponding value from the map.
     */
    public void toSUT(String client, Map vars){
        __wrappedInstance.toSUT(client, vars)
    }
    /**
     * Server only. Set some global variables in the script interpreter of the
     * SUT.
     * 
     * @param client
     * The name of the SUT client.
     * @param vars
     * For each key in the map, a global variable by that name is set
     * to the corresponding value from the map.
     */
    public void toSUT(Map vars, String client){
        __wrappedInstance.toSUT(vars, client)
    }
    /**
     * Server only. Retrieve the value of a global variable in the script
     * interpreter of the SUT. If the variable is undefined, a KeyError is
     * raised.
     * 
     * @param client
     * The name of the SUT client.
     * @param name
     * The name of the variable.
     * @return The value of the variable.
     */
    public Object fromSUT(String client, String name){
        return __wrappedInstance.fromSUT(client, name)
    }
    /** Server only. Undefine all global variables. */
    public void clearGlobals(){
        __wrappedInstance.clearGlobals()
    }
    /**
     * List all available property group names defined by the user. Names are
     * returned in alphabetic order.
     */
    public String getPropertyGroupNames(){
        return __wrappedInstance.getPropertyGroupNames()
    }
    /**
     * Clear a given group of properties or resources.
     * 
     * @param group
     * The group name of the properties or resources.
     */
    public void clearProperties(String group){
        __wrappedInstance.clearProperties(group)
    }
    /**
     * Server only. Synchronize a number of parallel threads for load testing.
     * The current thread is blocked until all threads have reached this
     * synchronization point or the timeout is exceeded. In the latter case, a
     * TestException is thrown or an error logged.
     * 
     * @param id
     * An identifier for the synchronization point.
     * @param timeout
     * The maximum time to wait in milliseconds.
     * @param count
     * The number of threads to wait for. Default value -1 means all
     * threads in the current QF-Test instance.
     * @param remote
     * The number of QF-Test instances - potentially running on
     * different machines - to synchronize. Default 0 means don't do
     * remote synchronization.
     * @param throwEx
     * Whether to throw an exception (default) or just log an error
     * if the timeout is exceeded without all threads reaching the
     * synchronization point.
     */
    public int syncThreads(String id, long timeout, int count=-1, int remote=0, boolean raise=true){
        return __wrappedInstance.syncThreads(id, timeout, count, remote, raise)
    }
    /**
     * Server only. Synchronize a number of parallel threads for load testing.
     * The current thread is blocked until all threads have reached this
     * synchronization point or the timeout is exceeded. In the latter case, a
     * TestException is thrown or an error logged.
     * 
     * @param id
     * An identifier for the synchronization point.
     * @param timeout
     * The maximum time to wait in milliseconds.
     * @param count
     * The number of threads to wait for. Default value -1 means all
     * threads in the current QF-Test instance.
     * @param remote
     * The number of QF-Test instances - potentially running on
     * different machines - to synchronize. Default 0 means don't do
     * remote synchronization.
     * @param throwEx
     * Whether to throw an exception (default) or just log an error
     * if the timeout is exceeded without all threads reaching the
     * synchronization point.
     */
    public int syncThreads(Map mappedParams, String id, long timeout){
        def count = -1
        if(mappedParams.containsKey("count")){
            count = mappedParams.count
        }
        def remote = 0
        if(mappedParams.containsKey("remote")){
            remote = mappedParams.remote
        }
        def raise = true
        if(mappedParams.containsKey("raise")){
            raise = mappedParams.raise
        }
        return __wrappedInstance.syncThreads(id, timeout, count, remote, raise)
    }
    /**
     * Add a run-log retrieved from a DaemonRunContext to the current run-log.
     * 
     * @param data
     * The byte array retrieved via DaemonRunContext.getRunLog().
     * @param name
     * An optional name for the daemon log node. If unspecified the
     * ID of the Daemon is used.
     * @param comment
     * An optional comment for the daemon log node.
     * @param externalizename
     * An optional name to externalize the daemon log and save it as
     * a partial log of a split run-log.
     */
    public void addDaemonLog(byte[] data, String name=null, String comment=null, String externalizename=null){
        __wrappedInstance.addDaemonLog(data, name, comment, externalizename)
    }
    /**
     * Add a run-log retrieved from a DaemonRunContext to the current run-log.
     * 
     * @param data
     * The byte array retrieved via DaemonRunContext.getRunLog().
     * @param name
     * An optional name for the daemon log node. If unspecified the
     * ID of the Daemon is used.
     * @param comment
     * An optional comment for the daemon log node.
     * @param externalizename
     * An optional name to externalize the daemon log and save it as
     * a partial log of a split run-log.
     */
    public void addDaemonLog(Map mappedParams, byte[] data){
        def name = null
        if(mappedParams.containsKey("name")){
            name = mappedParams.name
        }
        def comment = null
        if(mappedParams.containsKey("comment")){
            comment = mappedParams.comment
        }
        def externalizename = null
        if(mappedParams.containsKey("externalizename")){
            externalizename = mappedParams.externalizename
        }
        __wrappedInstance.addDaemonLog(data, name, comment, externalizename)
    }
    /**
     * Call a 'Test-Case' or 'Test-Set' in a test-suite.
     * 
     * @param test
     * The fully qualified name of the 'Test-Case' or 'Test-Set'.
     * @param param
     * The parameters for the called node. This should be a
     * dictionary. Its keys and values can be arbitrary values. They
     * are converted to strings for the call.
     * @return The result of the test. Either rc.OK, rc.WARNING, rc.ERROR,
     * rc.EXCEPTION, rc.SKIPPED or rc.NOT_IMPLEMENTED.
     */
    public int callTest(String testname, Map parameters=null){
        return __wrappedInstance.callTest(testname, parameters)
    }
    /**
     * Call a 'Test-Case' or 'Test-Set' in a test-suite.
     * 
     * @param test
     * The fully qualified name of the 'Test-Case' or 'Test-Set'.
     * @param param
     * The parameters for the called node. This should be a
     * dictionary. Its keys and values can be arbitrary values. They
     * are converted to strings for the call.
     * @return The result of the test. Either rc.OK, rc.WARNING, rc.ERROR,
     * rc.EXCEPTION, rc.SKIPPED or rc.NOT_IMPLEMENTED.
     */
    public int callTest(Map mappedParams, String testname){
        return __wrappedInstance.callTest(testname, mappedParams)
    }
    /**
     * Call a 'Test-case', 'Test-set' or'Test-suite'. In case of a nested test-call the call acts like a procedure call.
     * 
     * @param test
     * The fully qualified name of the 'Test-Case' or 'Test-Set'.
     * @param param
     * The parameters for the called node. This should be a
     * dictionary. Its keys and values can be arbitrary values. They
     * are converted to strings for the call.
     * @return The result of the test. Either rc.OK, rc.WARNING, rc.ERROR,
     * rc.EXCEPTION, rc.SKIPPED or rc.NOT_IMPLEMENTED.
     */
    public int callTestAsProcedure(String testname, Map parameters=null){
        return __wrappedInstance.callTestAsProcedure(testname, parameters)
    }
    /**
     * Call a 'Test-case', 'Test-set' or'Test-suite'. In case of a nested test-call the call acts like a procedure call.
     * 
     * @param test
     * The fully qualified name of the 'Test-Case' or 'Test-Set'.
     * @param param
     * The parameters for the called node. This should be a
     * dictionary. Its keys and values can be arbitrary values. They
     * are converted to strings for the call.
     * @return The result of the test. Either rc.OK, rc.WARNING, rc.ERROR,
     * rc.EXCEPTION, rc.SKIPPED or rc.NOT_IMPLEMENTED.
     */
    public int callTestAsProcedure(Map mappedParams, String testname){
        return __wrappedInstance.callTestAsProcedure(testname, mappedParams)
    }
    public void runCleanup(String dependency=null){
        __wrappedInstance.runCleanup(dependency)
    }
    public void runCleanup(Map mappedParams){
        if(mappedParams == null){
            __wrappedInstance.runCleanup(mappedParams, dependency)
        }
        def dependency = null
        if(mappedParams.containsKey("dependency")){
            dependency = mappedParams.dependency
        }
        __wrappedInstance.runCleanup(dependency)
    }
    public void addDataBinder(String identifier, DataBinder binder, String counterName=null, String intervals=null){
        __wrappedInstance.addDataBinder(identifier, binder, counterName, intervals)
    }
    public void addDataBinder(Map mappedParams, String identifier, DataBinder binder){
        def counterName = null
        if(mappedParams.containsKey("counterName")){
            counterName = mappedParams.counterName
        }
        def intervals = null
        if(mappedParams.containsKey("intervals")){
            intervals = mappedParams.intervals
        }
        __wrappedInstance.addDataBinder(identifier, binder, counterName, intervals)
    }
    public String getEngine(String id){
        return __wrappedInstance.getEngine(id)
    }
    /**
     * Register a TestRunListener with the current run-context.
     * 
     * @param listener
     * The listener to register.
     */
    public void addTestRunListener(TestRunListener listener){
        __wrappedInstance.addTestRunListener(listener)
    }
    /**
     * Unregister a TestRunListener from the current run-context.
     * 
     * @param listener
     * The listener to unregister.
     */
    public void removeTestRunListener(TestRunListener listener){
        __wrappedInstance.removeTestRunListener(listener)
    }
    /** Unregister all TestRunListeners from the current run-context. */
    public void clearTestRunListeners(){
        __wrappedInstance.clearTestRunListeners()
    }
    /**
     * Get the names of the currently connected SUT clients.
     * 
     * @return A list with the names of the currently connected SUT clients, an
     * empty list in case there are none.
     */
    public List<Object> getConnectedClients(){
        return __wrappedInstance.getConnectedClients()
    }
    /**
     * Resolve a 'Dependency'.
     * 
     * @param dependency
     * The fully qualified name of the 'Dependency' to resolve.
     * @param namespace
     * An optional namespace to resolve the 'Dependency' in.
     * @param params
     * The parameters for the 'Dependency'. This should be a
     * dictionary. Its keys and values can be arbitrary values. They
     * are converted to strings for the call.
     */
    public void resolveDependency(String dep, String namespace, Map params=null){
        __wrappedInstance.resolveDependency(dep, namespace, params)
    }
    /**
     * Resolve a 'Dependency'.
     * 
     * @param dependency
     * The fully qualified name of the 'Dependency' to resolve.
     * @param namespace
     * An optional namespace to resolve the 'Dependency' in.
     * @param params
     * The parameters for the 'Dependency'. This should be a
     * dictionary. Its keys and values can be arbitrary values. They
     * are converted to strings for the call.
     */
    public void resolveDependency(Map mappedParams, String dep, String namespace){
        __wrappedInstance.resolveDependency(dep, namespace, mappedParams)
    }
    /**
     * Resolve a 'Dependency'.
     * 
     * @param dependency
     * The fully qualified name of the 'Dependency' to resolve.
     * @param parameters
     * The parameters for the 'Dependency'. This should be a
     * dictionary. Its keys and values can be arbitrary values. They
     * are converted to strings for the call.
     */
    public void resolveDependency(String dep, Map params=null){
        __wrappedInstance.resolveDependency(dep, params)
    }
    /**
     * Resolve a 'Dependency'.
     * 
     * @param dependency
     * The fully qualified name of the 'Dependency' to resolve.
     * @param parameters
     * The parameters for the 'Dependency'. This should be a
     * dictionary. Its keys and values can be arbitrary values. They
     * are converted to strings for the call.
     */
    public void resolveDependency(Map mappedParams, String dep){
        __wrappedInstance.resolveDependency(dep, mappedParams)
    }
    /**
     * Unroll the dependency stack.
     * 
     * @param namespace
     * An optional namespace to unroll the dependencies in.
     */
    public void rollbackDependencies(String namespace=null){
        __wrappedInstance.rollbackDependencies(namespace)
    }
    /**
     * Unroll the dependency stack.
     * 
     * @param namespace
     * An optional namespace to unroll the dependencies in.
     */
    public void rollbackDependencies(Map mappedParams){
        if(mappedParams == null){
            __wrappedInstance.rollbackDependencies(mappedParams, namespace)
        }
        def namespace = null
        if(mappedParams.containsKey("namespace")){
            namespace = mappedParams.namespace
        }
        __wrappedInstance.rollbackDependencies(namespace)
    }
    /**
     * Completely reset the dependency stack without executing any cleanup.
     * 
     * @param namespace
     * An optional namespace to reset the dependencies for.
     */
    public void resetDependencies(String namespace=null){
        __wrappedInstance.resetDependencies(namespace)
    }
    /**
     * Completely reset the dependency stack without executing any cleanup.
     * 
     * @param namespace
     * An optional namespace to reset the dependencies for.
     */
    public void resetDependencies(Map mappedParams){
        if(mappedParams == null){
            __wrappedInstance.resetDependencies(mappedParams, namespace)
        }
        def namespace = null
        if(mappedParams.containsKey("namespace")){
            namespace = mappedParams.namespace
        }
        __wrappedInstance.resetDependencies(namespace)
    }
    public void setContext(Object context){
        __wrappedInstance.setContext(context)
    }
    public RMIRunContext getContext(){
        return __wrappedInstance.getContext()
    }
    public void _setSharedContext(Object context){
        __wrappedInstance._setSharedContext(context)
    }
    public void _setLocalContext(Object context){
        __wrappedInstance._setLocalContext(context)
    }
    /**
     * Add a plain message to the run log.
     * 
     * @param message
     * The message to log.
     * @param dontcompactify
     * If true, the message will never be removed from a compact
     * run-log.
     * @param report
     * If true, the message will appear in the report.
     * @param nowrap
     * If true, lines of the message will not appear wrapped in the
     * report. Use for potentially long messages.
     */
    public void logMessage(Object message, boolean dontcompactify=false, boolean report=false, boolean nowrap=false){
        __wrappedInstance.logMessage(message, dontcompactify, report, nowrap)
    }
    /**
     * Add a plain message to the run log.
     * 
     * @param message
     * The message to log.
     * @param dontcompactify
     * If true, the message will never be removed from a compact
     * run-log.
     * @param report
     * If true, the message will appear in the report.
     * @param nowrap
     * If true, lines of the message will not appear wrapped in the
     * report. Use for potentially long messages.
     */
    public void logMessage(Map mappedParams, Object message){
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
        __wrappedInstance.logMessage(message, dontcompactify, report, nowrap)
    }
    /**
     * Add a warning message to the run log.
     * 
     * @param message
     * The message to log.
     * @param report
     * If true, the message will appear in the report.
     * @param nowrap
     * If true, lines of the message will not appear wrapped in the
     * report. Use for potentially long messages.
     */
    public void logWarning(Object message, boolean report=true, boolean nowrap=false){
        __wrappedInstance.logWarning(message, report, nowrap)
    }
    /**
     * Add a warning message to the run log.
     * 
     * @param message
     * The message to log.
     * @param report
     * If true, the message will appear in the report.
     * @param nowrap
     * If true, lines of the message will not appear wrapped in the
     * report. Use for potentially long messages.
     */
    public void logWarning(Map mappedParams, Object message){
        def report = true
        if(mappedParams.containsKey("report")){
            report = mappedParams.report
        }
        def nowrap = false
        if(mappedParams.containsKey("nowrap")){
            nowrap = mappedParams.nowrap
        }
        __wrappedInstance.logWarning(message, report, nowrap)
    }
    /**
     * Add an error message to the run log.
     * 
     * @param message
     * Add an error message to the run log.
     * @param nowrap
     * If true, lines of the message will not appear wrapped in the
     * report. Use for potentially long messages.
     */
    public void logError(Object message, boolean nowrap=false){
        __wrappedInstance.logError(message, nowrap)
    }
    /**
     * Add an error message to the run log.
     * 
     * @param message
     * Add an error message to the run log.
     * @param nowrap
     * If true, lines of the message will not appear wrapped in the
     * report. Use for potentially long messages.
     */
    public void logError(Map mappedParams, Object message){
        if(mappedParams == null){
            __wrappedInstance.logError(mappedParams, message)
        }
        def nowrap = false
        if(mappedParams.containsKey("nowrap")){
            nowrap = mappedParams.nowrap
        }
        __wrappedInstance.logError(message, nowrap)
    }
    /**
     * Add an image to the run-log
     * 
     * @param image
     * The ImageRep for the log.
     * @param title
     * An optional title for the image.
     * @param dontcompactify
     * True to ensure that the image is not compactify.
     * @param report
     * True to log the image in the report (implies dontcompactify).
     */
    public void logImage(ImageRep image, String title=null, boolean dontcompactify=false, boolean report=false){
        __wrappedInstance.logImage(image, title, dontcompactify, report)
    }
    /**
     * Add an image to the run-log
     * 
     * @param image
     * The ImageRep for the log.
     * @param title
     * An optional title for the image.
     * @param dontcompactify
     * True to ensure that the image is not compactify.
     * @param report
     * True to log the image in the report (implies dontcompactify).
     */
    public void logImage(Map mappedParams, ImageRep image){
        def title = null
        if(mappedParams.containsKey("title")){
            title = mappedParams.title
        }
        def dontcompactify = false
        if(mappedParams.containsKey("dontcompactify")){
            dontcompactify = mappedParams.dontcompactify
        }
        def report = false
        if(mappedParams.containsKey("report")){
            report = mappedParams.report
        }
        __wrappedInstance.logImage(image, title, dontcompactify, report)
    }
    /**
     * Check or "assert" that a condition is true and log a message according to
     * the result.
     * 
     * @param condition
     * The condition to evaluate.
     * @param message
     * The message to log. It will be preceded by "Check OK: " or
     * "Check failed: " depending on the result. For the old-style
     * XML or HTML report the message will be treated like a 'Check'
     * node if it starts with an '!' character.
     * @param level
     * The error level in case of failure. The following constants
     * are defined in the run-context: rc.OK rc.WARNING rc.ERROR
     * rc.EXCEPTION If the level is rc.EXCEPTION, a UserException
     * will be thrown if the check fails.
     * @param report
     * If true, the check will appear in the report. Only applicable
     * if level <= 1.
     * @param nowrap
     * If true, lines of the message will not appear wrapped in the
     * report. Use for potentially long messages.
     * @return The result of the check.
     */
    public boolean check(boolean condition, Object message, int level=2, boolean report=true, boolean nowrap=false){
        return __wrappedInstance.check(condition, message, level, report, nowrap)
    }
    /**
     * Check or "assert" that a condition is true and log a message according to
     * the result.
     * 
     * @param condition
     * The condition to evaluate.
     * @param message
     * The message to log. It will be preceded by "Check OK: " or
     * "Check failed: " depending on the result. For the old-style
     * XML or HTML report the message will be treated like a 'Check'
     * node if it starts with an '!' character.
     * @param level
     * The error level in case of failure. The following constants
     * are defined in the run-context: rc.OK rc.WARNING rc.ERROR
     * rc.EXCEPTION If the level is rc.EXCEPTION, a UserException
     * will be thrown if the check fails.
     * @param report
     * If true, the check will appear in the report. Only applicable
     * if level <= 1.
     * @param nowrap
     * If true, lines of the message will not appear wrapped in the
     * report. Use for potentially long messages.
     * @return The result of the check.
     */
    public boolean check(Map mappedParams, boolean condition, Object message){
        def level = 2
        if(mappedParams.containsKey("level")){
            level = mappedParams.level
        }
        def report = true
        if(mappedParams.containsKey("report")){
            report = mappedParams.report
        }
        def nowrap = false
        if(mappedParams.containsKey("nowrap")){
            nowrap = mappedParams.nowrap
        }
        return __wrappedInstance.check(condition, message, level, report, nowrap)
    }
    /**
     * Check or "assert" that an object matches a given value and log a message
     * according to the result. Comparison is done using the == operator.
     * 
     * @param actual
     * The actual value.
     * @param expected
     * The expected value.
     * @param message
     * The message to log. It will be preceded by "Check OK: " or
     * "Check failed: " depending on the result. In case of failure,
     * the expected and actual values will also be logged. For the
     * old-style XML or HTML report the message will be treated like
     * a 'Check' node if it starts with an '!' character.
     * @param level
     * The error level in case of failure. The following constants
     * are defined in the run-context: rc.OK rc.WARNING rc.ERROR
     * rc.EXCEPTION If the level is rc.EXCEPTION, a UserException
     * will be thrown if the check fails.
     * @param report
     * If true, the check will appear in the report. Only applicable
     * if level <= 1.
     * @param nowrap
     * If true, lines of the message will not appear wrapped in the
     * report. Use for potentially long messages.
     * @return The result of the check.
     */
    public boolean checkEqual(Object actual, Object expected, Object message, Integer level=2, boolean report=true, boolean nowrap=false){
        return __wrappedInstance.checkEqual(actual, expected, message, level, report, nowrap)
    }
    /**
     * Check or "assert" that an object matches a given value and log a message
     * according to the result. Comparison is done using the == operator.
     * 
     * @param actual
     * The actual value.
     * @param expected
     * The expected value.
     * @param message
     * The message to log. It will be preceded by "Check OK: " or
     * "Check failed: " depending on the result. In case of failure,
     * the expected and actual values will also be logged. For the
     * old-style XML or HTML report the message will be treated like
     * a 'Check' node if it starts with an '!' character.
     * @param level
     * The error level in case of failure. The following constants
     * are defined in the run-context: rc.OK rc.WARNING rc.ERROR
     * rc.EXCEPTION If the level is rc.EXCEPTION, a UserException
     * will be thrown if the check fails.
     * @param report
     * If true, the check will appear in the report. Only applicable
     * if level <= 1.
     * @param nowrap
     * If true, lines of the message will not appear wrapped in the
     * report. Use for potentially long messages.
     * @return The result of the check.
     */
    public boolean checkEqual(Map mappedParams, Object actual, Object expected, Object message){
        def level = 2
        if(mappedParams.containsKey("level")){
            level = mappedParams.level
        }
        def report = true
        if(mappedParams.containsKey("report")){
            report = mappedParams.report
        }
        def nowrap = false
        if(mappedParams.containsKey("nowrap")){
            nowrap = mappedParams.nowrap
        }
        return __wrappedInstance.checkEqual(actual, expected, message, level, report, nowrap)
    }
    /**
     * Compare two ImageRep objects.
     * 
     * @param actual
     * The actual image for comparison.
     * @param expected
     * The expected image for comparison.
     * @param message
     * Error message for the run-log.
     * @param level
     * The error level in case of failure. The following constants
     * are defined in the run-context: rc.OK rc.WARNING rc.ERROR
     * rc.EXCEPTION If the level is rc.EXCEPTION, a UserException
     * will be thrown if the check fails.
     * @param report
     * If true, the check will appear in the report. Only applicable
     * if level <= 1.
     * @param nowrap
     * If true, lines of the message will not appear wrapped in the
     * report. Use for potentially long messages.
     * 
     * @return The result of the check
     */
    public boolean checkImage(ImageRep actual, ImageRep expected, String message, Integer level=2, boolean report=true, boolean nowrap=false){
        return __wrappedInstance.checkImage(actual, expected, message, level, report, nowrap)
    }
    /**
     * Compare two ImageRep objects.
     * 
     * @param actual
     * The actual image for comparison.
     * @param expected
     * The expected image for comparison.
     * @param message
     * Error message for the run-log.
     * @param level
     * The error level in case of failure. The following constants
     * are defined in the run-context: rc.OK rc.WARNING rc.ERROR
     * rc.EXCEPTION If the level is rc.EXCEPTION, a UserException
     * will be thrown if the check fails.
     * @param report
     * If true, the check will appear in the report. Only applicable
     * if level <= 1.
     * @param nowrap
     * If true, lines of the message will not appear wrapped in the
     * report. Use for potentially long messages.
     * 
     * @return The result of the check
     */
    public boolean checkImage(Map mappedParams, ImageRep actual, ImageRep expected, String message){
        def level = 2
        if(mappedParams.containsKey("level")){
            level = mappedParams.level
        }
        def report = true
        if(mappedParams.containsKey("report")){
            report = mappedParams.report
        }
        def nowrap = false
        if(mappedParams.containsKey("nowrap")){
            nowrap = mappedParams.nowrap
        }
        return __wrappedInstance.checkImage(actual, expected, message, level, report, nowrap)
    }
    /**
     * Compare two ImageRep objects by using an algorithm.
     * 
     * @param actual
     * The actual image for comparison.
     * @param expected
     * The expected image for comparison.
     * @param message
     * Error message for the run-log.
     * @param algorithm
     * The algorithm to use for this check.
     * @param level
     * The error level in case of failure. The following constants
     * are defined in the run-context: rc.OK rc.WARNING rc.ERROR
     * rc.EXCEPTION If the level is rc.EXCEPTION, a UserException
     * will be thrown if the check fails.
     * @param report
     * If true, the check will appear in the report. Only applicable
     * if level <= 1.
     * @param nowrap
     * If true, lines of the message will not appear wrapped in the
     * report. Use for potentially long messages.
     * @return An array with following content: Check result as Boolean. Check
     * result as probability. Transformation of expected image if
     * available. Transformation of actual image if available.
     */
    public Object[] checkImageAdvanced(ImageRep actual, ImageRep expected, String message, String algorithm, Integer level=2, boolean report=true, boolean nowrap=false){
        return __wrappedInstance.checkImageAdvanced(actual, expected, message, algorithm, level, report, nowrap)
    }
    /**
     * Compare two ImageRep objects by using an algorithm.
     * 
     * @param actual
     * The actual image for comparison.
     * @param expected
     * The expected image for comparison.
     * @param message
     * Error message for the run-log.
     * @param algorithm
     * The algorithm to use for this check.
     * @param level
     * The error level in case of failure. The following constants
     * are defined in the run-context: rc.OK rc.WARNING rc.ERROR
     * rc.EXCEPTION If the level is rc.EXCEPTION, a UserException
     * will be thrown if the check fails.
     * @param report
     * If true, the check will appear in the report. Only applicable
     * if level <= 1.
     * @param nowrap
     * If true, lines of the message will not appear wrapped in the
     * report. Use for potentially long messages.
     * @return An array with following content: Check result as Boolean. Check
     * result as probability. Transformation of expected image if
     * available. Transformation of actual image if available.
     */
    public Object[] checkImageAdvanced(Map mappedParams, ImageRep actual, ImageRep expected, String message, String algorithm){
        def level = 2
        if(mappedParams.containsKey("level")){
            level = mappedParams.level
        }
        def report = true
        if(mappedParams.containsKey("report")){
            report = mappedParams.report
        }
        def nowrap = false
        if(mappedParams.containsKey("nowrap")){
            nowrap = mappedParams.nowrap
        }
        return __wrappedInstance.checkImageAdvanced(actual, expected, message, algorithm, level, report, nowrap)
    }
    /**
     * Return the value of a QF-Test variable as String.
     * 
     * @param varname
     * The name of the variable.
     * @param expand
     * Whether to expand the value of the variable recursively.
     * @return The value of the variable.
     */
    public String getStr(String varname, boolean expand=true){
        return __wrappedInstance.getStr(varname, expand)
    }
    /**
     * Return the value of a QF-Test variable as String.
     * 
     * @param varname
     * The name of the variable.
     * @param expand
     * Whether to expand the value of the variable recursively.
     * @return The value of the variable.
     */
    public String getStr(Map mappedParams, String varname){
        if(mappedParams == null){
            return __wrappedInstance.getStr(mappedParams, varname)
        }
        def expand = true
        if(mappedParams.containsKey("expand")){
            expand = mappedParams.expand
        }
        return __wrappedInstance.getStr(varname, expand)
    }
    public String getStr(String var1, String var2, boolean expand=true){
        return __wrappedInstance.getStr(var1, var2, expand)
    }
    public String getStr(Map mappedParams, String var1, String var2){
        if(mappedParams == null){
            return __wrappedInstance.getStr(mappedParams, var1)
        }
        def expand = true
        if(mappedParams.containsKey("expand")){
            expand = mappedParams.expand
        }
        return __wrappedInstance.getStr(var1, var2, expand)
    }
    /**
     * Return a Pattern using the value of a QF-Test variable as regular expression.
     * 
     * @param varname
     * The name of the variable.
     * @param expand
     * Whether to expand the value of the variable recursively.
     * @return The value of the variable.
     */
    public Pattern getPattern(String varname, boolean expand=true){
        return __wrappedInstance.getPattern(varname, expand)
    }
    /**
     * Return a Pattern using the value of a QF-Test variable as regular expression.
     * 
     * @param varname
     * The name of the variable.
     * @param expand
     * Whether to expand the value of the variable recursively.
     * @return The value of the variable.
     */
    public Pattern getPattern(Map mappedParams, String varname){
        if(mappedParams == null){
            return __wrappedInstance.getPattern(mappedParams, varname)
        }
        def expand = true
        if(mappedParams.containsKey("expand")){
            expand = mappedParams.expand
        }
        return __wrappedInstance.getPattern(varname, expand)
    }
    public Pattern getPattern(String var1, String var2, boolean expand=true){
        return __wrappedInstance.getPattern(var1, var2, expand)
    }
    public Pattern getPattern(Map mappedParams, String var1, String var2){
        if(mappedParams == null){
            return __wrappedInstance.getPattern(mappedParams, var1)
        }
        def expand = true
        if(mappedParams.containsKey("expand")){
            expand = mappedParams.expand
        }
        return __wrappedInstance.getPattern(var1, var2, expand)
    }
    /**
     * Return the value of a QF-Test variable as Integer.
     * 
     * @param var1
     * The name of the variable or group.
     * @param var2
     * The name of the resource or property for the given group.
     * @return The value of the variable.
     */
    public Number getInt(String var1, String var2, boolean expand=true){
        return __wrappedInstance.getInt(var1, var2, expand)
    }
    /**
     * Return the value of a QF-Test variable as Integer.
     * 
     * @param var1
     * The name of the variable or group.
     * @param var2
     * The name of the resource or property for the given group.
     * @return The value of the variable.
     */
    public Number getInt(Map mappedParams, String var1, String var2){
        if(mappedParams == null){
            return __wrappedInstance.getInt(mappedParams, var1)
        }
        def expand = true
        if(mappedParams.containsKey("expand")){
            expand = mappedParams.expand
        }
        return __wrappedInstance.getInt(var1, var2, expand)
    }
    public Number getInt(String varname, boolean expand=true){
        return __wrappedInstance.getInt(varname, expand)
    }
    public Number getInt(Map mappedParams, String varname){
        if(mappedParams == null){
            return __wrappedInstance.getInt(mappedParams, varname)
        }
        def expand = true
        if(mappedParams.containsKey("expand")){
            expand = mappedParams.expand
        }
        return __wrappedInstance.getInt(varname, expand)
    }
    /**
     * Look up the value of a QF-Test variable, similar to lookup(), but treat
     * it as a number, i.e. an integer or a float, depending on its format.
     * 
     * @param var1
     * The name of the variable or group.
     * @param var2
     * The name of the resource or property for the given group.
     * @param expand
     * Whether to expand the value of the variable recursively. If,
     * for example, the value of $(varname) is the literal string
     * "$(othervar)", this method will return the expanded value of
     * $(othervar) if expand is true and "$(othervar)" itself if
     * expand is false. Note that if you want to set this parameter,
     * you must use Python keyword syntax to avoid conflicts with
     * lookup(String group, String name), i.e. rc.lookup("var",
     * expand=False) instead of rc.lookup("var", 0).
     * @return The value of the variable as int.
     */
    public Number getNum(String varname, boolean expand=true){
        return __wrappedInstance.getNum(varname, expand)
    }
    /**
     * Look up the value of a QF-Test variable, similar to lookup(), but treat
     * it as a number, i.e. an integer or a float, depending on its format.
     * 
     * @param var1
     * The name of the variable or group.
     * @param var2
     * The name of the resource or property for the given group.
     * @param expand
     * Whether to expand the value of the variable recursively. If,
     * for example, the value of $(varname) is the literal string
     * "$(othervar)", this method will return the expanded value of
     * $(othervar) if expand is true and "$(othervar)" itself if
     * expand is false. Note that if you want to set this parameter,
     * you must use Python keyword syntax to avoid conflicts with
     * lookup(String group, String name), i.e. rc.lookup("var",
     * expand=False) instead of rc.lookup("var", 0).
     * @return The value of the variable as int.
     */
    public Number getNum(Map mappedParams, String varname){
        if(mappedParams == null){
            return __wrappedInstance.getNum(mappedParams, varname)
        }
        def expand = true
        if(mappedParams.containsKey("expand")){
            expand = mappedParams.expand
        }
        return __wrappedInstance.getNum(varname, expand)
    }
    public Object getNum(String var1, String var2, boolean expand=true){
        return __wrappedInstance.getNum(var1, var2, expand)
    }
    public Object getNum(Map mappedParams, String var1, String var2){
        if(mappedParams == null){
            return __wrappedInstance.getNum(mappedParams, var1)
        }
        def expand = true
        if(mappedParams.containsKey("expand")){
            expand = mappedParams.expand
        }
        return __wrappedInstance.getNum(var1, var2, expand)
    }
    /**
     * Return the value of a QF-Test variable as Boolean.
     * 
     * @param varname
     * The name of the variable.
     * @param expand
     * Whether to expand the value of the variable recursively.
     * @return The value of the variable.
     */
    public Boolean getBool(String varname, boolean expand=true){
        return __wrappedInstance.getBoolGroovy(varname, expand)
    }
    /**
     * Return the value of a QF-Test variable as Boolean.
     * 
     * @param varname
     * The name of the variable.
     * @param expand
     * Whether to expand the value of the variable recursively.
     * @return The value of the variable.
     */
    public Boolean getBool(Map mappedParams, String varname){
        if(mappedParams == null){
            return __wrappedInstance.getBoolGroovy(mappedParams, varname)
        }
        def expand = true
        if(mappedParams.containsKey("expand")){
            expand = mappedParams.expand
        }
        return __wrappedInstance.getBoolGroovy(varname, expand)
    }
    /**
     * Look up the value of a QF-Test variable, similar to lookup(), but treat
     * it as a boolean.
     * 
     * @param var1
     * The name of the variable or group.
     * @param var2
     * The name of the resource or property for the given group.
     * @return The value of the variable as boolean (1 = true, 0 = false).
     */
    public Boolean getBool(String group, String varname, boolean expand=true){
        return __wrappedInstance.getBoolGroovy(group, varname, expand)
    }
    /**
     * Look up the value of a QF-Test variable, similar to lookup(), but treat
     * it as a boolean.
     * 
     * @param var1
     * The name of the variable or group.
     * @param var2
     * The name of the resource or property for the given group.
     * @return The value of the variable as boolean (1 = true, 0 = false).
     */
    public Boolean getBool(Map mappedParams, String group, String varname){
        if(mappedParams == null){
            return __wrappedInstance.getBoolGroovy(mappedParams, group)
        }
        def expand = true
        if(mappedParams.containsKey("expand")){
            expand = mappedParams.expand
        }
        return __wrappedInstance.getBoolGroovy(group, varname, expand)
    }
    public String lookup(String varname, boolean expand=true){
        return __wrappedInstance.lookup(varname, expand)
    }
    public String lookup(Map mappedParams, String varname){
        if(mappedParams == null){
            return __wrappedInstance.lookup(mappedParams, varname)
        }
        def expand = true
        if(mappedParams.containsKey("expand")){
            expand = mappedParams.expand
        }
        return __wrappedInstance.lookup(varname, expand)
    }
    public String lookup(String var1, String var2, boolean expand=true){
        return __wrappedInstance.lookup(var1, var2, expand)
    }
    public String lookup(Map mappedParams, String var1, String var2){
        if(mappedParams == null){
            return __wrappedInstance.lookup(mappedParams, var1)
        }
        def expand = true
        if(mappedParams.containsKey("expand")){
            expand = mappedParams.expand
        }
        return __wrappedInstance.lookup(var1, var2, expand)
    }
    /**
     * Define a global QF-Test variable.
     * 
     * @param name
     * The name of the variable.
     * @param value
     * An arbitrary value for the variable. It is automatically
     * converted to a string. A value of None unsets the variable.
     */
    public void setGlobal(String name, Object value){
        __wrappedInstance.setGlobal(name, value)
    }
    /**
     * Define a local QF-Test variable.
     * 
     * @param name
     * The name of the variable.
     * @param value
     * An arbitrary value for the variable. It is automatically
     * converted to a string. A value of None unsets the variable.
     */
    public void setLocal(String name, Object value){
        __wrappedInstance.setLocal(name, value)
    }
    /**
     * Set the value of a resource or property in a group. Note: This method
     * also works for the special groups 'system' and 'env' and can be used as a
     * means to set environment variables and system properties. Values in the
     * special group 'qftest' cannot be set or changed that way.
     * 
     * @param group
     * The name of the group. A new group is created automatically if
     * necessary.
     * 
     * @param name
     * The name of the resource or property.
     * @param value
     * An arbitrary value for the property. It is automatically
     * converted to a string. A value of None or null unsets the
     * property.
     */
    public void setProperty(String group, String name, Object value){
        __wrappedInstance.setProperty(group, name, value)
    }
    /**
     * Get the global bindings of the context.
     * 
     * @return The global bindings of the context.
     */
    public Properties getGlobals(){
        return __wrappedInstance.getGlobals()
    }
    /**
     * Get the innermost local bindings of the context.
     * 
     * @param nonEmpty
     * True to get the first non-empty set of bindings, false to get
     * the innermost bindings even when empty.
     * @return The context's innermost local bindings.
     */
    public Properties getLocals(boolean nonEmpty=false){
        return __wrappedInstance.getLocals(nonEmpty)
    }
    /**
     * Get the innermost local bindings of the context.
     * 
     * @param nonEmpty
     * True to get the first non-empty set of bindings, false to get
     * the innermost bindings even when empty.
     * @return The context's innermost local bindings.
     */
    public Properties getLocals(Map mappedParams){
        if(mappedParams == null){
            return __wrappedInstance.getLocals(mappedParams, nonEmpty)
        }
        def nonEmpty = false
        if(mappedParams.containsKey("nonEmpty")){
            nonEmpty = mappedParams.nonEmpty
        }
        return __wrappedInstance.getLocals(nonEmpty)
    }
    /**
     * Get a set of loaded properties or resources.
     * 
     * @param group
     * The group name of the properties or resources.
     * @return The properties bound for the given group or None if no such group
     * exists.
     */
    public Properties getProperties(String group){
        return __wrappedInstance.getProperties(group)
    }
    /** Stop the current test-run by raising a StopException. */
    public void stopTest(){
        __wrappedInstance.stopTest()
    }
    /**
     * Stop the execution of the current test-case.
     * 
     * @param expectedFail
     * If true, mark possible errors in this test-case as expected
     * failures.
     */
    public void stopTestCase(boolean expectedFail=false){
        __wrappedInstance.stopTestCase(expectedFail)
    }
    /**
     * Stop the execution of the current test-case.
     * 
     * @param expectedFail
     * If true, mark possible errors in this test-case as expected
     * failures.
     */
    public void stopTestCase(Map mappedParams){
        if(mappedParams == null){
            __wrappedInstance.stopTestCase(mappedParams, expectedFail)
        }
        def expectedFail = false
        if(mappedParams.containsKey("expectedFail")){
            expectedFail = mappedParams.expectedFail
        }
        __wrappedInstance.stopTestCase(expectedFail)
    }
    /** Stop the current test-set by raising a TestCaseStoppedException. */
    public void stopTestSet(){
        __wrappedInstance.stopTestSet()
    }
    /** Skip the current test-case by raising a TestCaseSkippedException. */
    public void skipTestCase(){
        __wrappedInstance.skipTestCase()
    }
    /** Skip the current test-set by raising a TestCaseSkippedException. */
    public void skipTestSet(){
        __wrappedInstance.skipTestSet()
    }
    /**
     * Get an option value.
     * 
     * @param name
     * The name of the option to get as defined in the 'Options'
     * class.
     */
    public Object getOption(String name){
        return __wrappedInstance.getOption(name)
    }
    /**
     * Set an option value. An option defined in a script has higher precedence
     * than the options defined in the Option dialog.
     * 
     * @param name
     * The name of the option to set as defined in the 'Options'
     * class.
     * @param value
     * The new value for the option.
     */
    public void setOption(String name, Object value){
        __wrappedInstance.setOption(name, value)
    }
    /**
     * Unset an option value by removing the option from those defined at script
     * level so that the original option defined in the Option dialog is used
     * again.
     * 
     * @param name
     * The name of the option to unset as defined in the 'Options'
     * class.
     */
    public void unsetOption(String name, Object... ignored){
        __wrappedInstance.unsetOption(name, ignored)
    }
    /**
     * Test whether an option has been set at script level.
     * 
     * @param name
     * The name of the option to get as defined in the 'Options'
     * class.
     * @return True if the option has been set, false otherwise.
     */
    public boolean isOptionSet(String name){
        return __wrappedInstance.isOptionSet(name)
    }
    /**
     * Return the 'QF-Test ID' of a given ${id:QF-Test ID} expression. You
     * should use this command to update the script in case of 'QF-Test ID'
     * changes.
     * 
     * @param id
     * The ${id:QF-Test ID} expression.
     * @return The 'QF-Test ID' of the searched component.
     */
    public String id(String id){
        return __wrappedInstance.id(id)
    }
    public Boolean valueToBoolean(Object value){
        return __wrappedInstance.valueToBoolean(value)
    }
    /**
     * Add a generic node created from the parameters to the current run-log.
     * 
     * @param text
     * The name of the node.
     * @param kw
     * Optional text content for the node. Additional keyword
     * arguments are attributes to set for the node.
     */
    public void logData(String name=null, Map kw=null){
        __wrappedInstance.logData(name, kw)
    }
    /**
     * Add a generic node created from the parameters to the current run-log.
     * 
     * @param text
     * The name of the node.
     * @param kw
     * Optional text content for the node. Additional keyword
     * arguments are attributes to set for the node.
     */
    public void logData(Map mappedParams){
        __wrappedInstance.logData(mappedParams)
    }
    /**
     * Add a generic node to the current run-log.
     * 
     * @param node
     * The node to add.
     */
    public void logNode(Node node){
        __wrappedInstance.logNode(node)
    }
    public boolean execHTTPRequest(String url, String method, String query, boolean logresponse, String responsevar=null, boolean islocal=false, Integer timeout=null, String statusCodeVar=null, Object timeoutRet=null, String responseHeaders=null, HashMap headerMap=null, int statusCodeErrorLevel=3){
        return __wrappedInstance.execHTTPRequest(url, method, query, logresponse, responsevar, islocal, timeout, statusCodeVar, timeoutRet, responseHeaders, headerMap, statusCodeErrorLevel)
    }
    public boolean execHTTPRequest(Map mappedParams, String url, String method, String query, boolean logresponse){
        def responsevar = null
        if(mappedParams.containsKey("responsevar")){
            responsevar = mappedParams.responsevar
        }
        def islocal = false
        if(mappedParams.containsKey("islocal")){
            islocal = mappedParams.islocal
        }
        def timeout = null
        if(mappedParams.containsKey("timeout")){
            timeout = mappedParams.timeout
        }
        def statusCodeVar = null
        if(mappedParams.containsKey("statusCodeVar")){
            statusCodeVar = mappedParams.statusCodeVar
        }
        def timeoutRet = null
        if(mappedParams.containsKey("timeoutRet")){
            timeoutRet = mappedParams.timeoutRet
        }
        def responseHeaders = null
        if(mappedParams.containsKey("responseHeaders")){
            responseHeaders = mappedParams.responseHeaders
        }
        def headerMap = null
        if(mappedParams.containsKey("headerMap")){
            headerMap = mappedParams.headerMap
        }
        def statusCodeErrorLevel = 3
        if(mappedParams.containsKey("statusCodeErrorLevel")){
            statusCodeErrorLevel = mappedParams.statusCodeErrorLevel
        }
        return __wrappedInstance.execHTTPRequest(url, method, query, logresponse, responsevar, islocal, timeout, statusCodeVar, timeoutRet, responseHeaders, headerMap, statusCodeErrorLevel)
    }
    public String getLanguageName(){
        return __wrappedInstance.languageName
    }
}
