package de.qfs
import java.util.Map
import java.util.List
import de.qfs.lib.notifications.DefaultNotification.ExceptionHandler
/**
 * User notifications provide a simple API for posting and handling notifications
 * from user scripts.
 * 
 * Notifications are identified by a name, e.g. "user.sut.login" and provide a
 * userInfo map, which can hold arbitrary key-value pairs.
 * 
 * To post notifications, use notification.post(notificationName, userInfo).
 * 
 * To observe notifications, add an observer method using
 * addObserver(nameOfObserver, observerMethod, notificationName)
 */
class UserNotifications{
    //  redirected constants
    static final public String NOTIFICATION_PREFIX = de.qfs.apps.qftest.shared.script.modules.UserNotifications.NOTIFICATION_PREFIX
    static final public String RECORDING_STARTED = de.qfs.apps.qftest.shared.script.modules.UserNotifications.RECORDING_STARTED
    static final public String RECORDING_STOPPED = de.qfs.apps.qftest.shared.script.modules.UserNotifications.RECORDING_STOPPED
    static final public String RECORDING_PAUSED = de.qfs.apps.qftest.shared.script.modules.UserNotifications.RECORDING_PAUSED
    static final public String RECORDING_RESUMED = de.qfs.apps.qftest.shared.script.modules.UserNotifications.RECORDING_RESUMED
    static final public String CHECK_RECORDING_STARTED = de.qfs.apps.qftest.shared.script.modules.UserNotifications.CHECK_RECORDING_STARTED
    static final public String CHECK_RECORDING_STOPPED = de.qfs.apps.qftest.shared.script.modules.UserNotifications.CHECK_RECORDING_STOPPED
    static final public String REQUEST_RECORDING_STARTED = de.qfs.apps.qftest.shared.script.modules.UserNotifications.REQUEST_RECORDING_STARTED
    static final public String REQUEST_RECORDING_STOPPED = de.qfs.apps.qftest.shared.script.modules.UserNotifications.REQUEST_RECORDING_STOPPED
    static final public String COMPONENT_RECORDING_STARTED = de.qfs.apps.qftest.shared.script.modules.UserNotifications.COMPONENT_RECORDING_STARTED
    static final public String COMPONENT_RECORDING_STOPPED = de.qfs.apps.qftest.shared.script.modules.UserNotifications.COMPONENT_RECORDING_STOPPED
    static final public String PROCBUILDER_STARTED = de.qfs.apps.qftest.shared.script.modules.UserNotifications.PROCBUILDER_STARTED
    static final public String PROCBUILDER_STOPPED = de.qfs.apps.qftest.shared.script.modules.UserNotifications.PROCBUILDER_STOPPED
    static final public String INSPECTOR_MODE_STARTED = de.qfs.apps.qftest.shared.script.modules.UserNotifications.INSPECTOR_MODE_STARTED
    static final public String INSPECTOR_MODE_STOPPED = de.qfs.apps.qftest.shared.script.modules.UserNotifications.INSPECTOR_MODE_STOPPED
    static final public String RUN_STARTED = de.qfs.apps.qftest.shared.script.modules.UserNotifications.RUN_STARTED
    static final public String RUN_STOPPED = de.qfs.apps.qftest.shared.script.modules.UserNotifications.RUN_STOPPED
    static final public String NODE_ENTERED = de.qfs.apps.qftest.shared.script.modules.UserNotifications.NODE_ENTERED
    static final public String NODE_EXITED = de.qfs.apps.qftest.shared.script.modules.UserNotifications.NODE_EXITED
    static final public String RUN_ERROR_OCCURED = de.qfs.apps.qftest.shared.script.modules.UserNotifications.RUN_ERROR_OCCURED
    /**
     * Used to trigger a script execution in QF-Test.
     * 
     * User-Info members:
     * * code: The code to execute
     * * interpreter: Interpreter name, defaults to the standard scripting language
     * * async: true/false, to execute the script asynchronously
     * * client: Client name, if the script should be executed as a SUT-Script.
     * * engine: If executed as SUT-script can specify the engine to execute the script in
     */
    static final public String EXECUTE = de.qfs.apps.qftest.shared.script.modules.UserNotifications.EXECUTE
    /**
     * Sent when a window is about to be raised. Put a member <code>didRaise</code> into the userInfo
     * to prevent QF-Test raising the window.
     */
    static final public String WINDOW_RAISE = de.qfs.apps.qftest.shared.script.modules.UserNotifications.WINDOW_RAISE
    /**
     * Called as soon as the application tries to open an external webbrowser to display a website.
     * The userInfo contains the members "url" - a String pointing to the URL to open (read only) - and
     * "open" - a Boolean which can be set to "FALSE" to prohibit the actual browser opening.
     */
    static final public String BROWSER_OPEN = de.qfs.apps.qftest.shared.script.modules.UserNotifications.BROWSER_OPEN
    /**
     * Called as soon as the application is about to start an external process.
     * 
     * The userInfo contains the following entries:
     * * command - A List of Strings of the command to start (modifiable/replaceable)
     * * directory - A File with the process working directory (or null) (replaceable)
     * * environment - A Map of String-String entries representing the environment passed to the process (modifiable/replaceable)
     * 
     * These entries can be added to the userInfo:
     * * stdout - If set, a mock process is started which returns the given String on STDOUT
     * * stderr - If set, a mock process is started which returns the given String on STDERR
     * * exitcode - If set, a mock process is started which returns with the given exit code
     * * runtime - If set, a mock process is started which returns after the given runtime (in milliseconds)
     * * ioexception - If set, instead of starting the process the given exception is thrown (can be a String)
     */
    static final public String PROCESS_START = de.qfs.apps.qftest.shared.script.modules.UserNotifications.PROCESS_START
    /**
     * Called as soon as a request is about to be sent from the browser.
     * 
     * The userInfo contains the following entries:
     * * url - The url called by the browser - (replaceable)
     * * method - The method used to request (replaceable)
     * * postData - A String containing the post data, if available (replaceable)
     * * resourceType - the requested resource - one of Document, Stylesheet, Image, Media, Font, Script, TextTrack, XHR, Fetch, EventSource, WebSocket, Manifest, SignedExchange, Ping, CSPViolationReport, Preflight, Other
     * * requestHeaders - A Map of String-String entries representing the headers sent with the request (modifiable/replaceable)
     * 
     * These entries can be added to the userInfo:
     * * errorReason - If set, the request fails with the given reason. Allowed values: Failed, Aborted, TimedOut, AccessDenied, ConnectionClosed, ConnectionReset, ConnectionRefused, ConnectionAborted, ConnectionFailed, NameNotResolved, InternetDisconnected, AddressUnreachable, BlockedByClient, BlockedByResponse
     * * responseCode - If set, the request will be fulfilled with the given response status code, e.g. "404"
     * * responseHeaders - If set, the request will be fulfilled with the given response headers (Should be a String or a Map of String-String entries)
     * * responseBody (String or byte[]) - If set, the request will be fulfilled with the given body.
     * 
     * Only available when CDP-Driver is used to connect the browser.
     */
    static final public String WEB_REQUEST_RECEIVED = de.qfs.apps.qftest.shared.script.modules.UserNotifications.WEB_REQUEST_RECEIVED
    /**
     * Simple variation of WEB_RESPONSE_RECEIVED, called upon CDPs Fetch.requestPaused event, only contains
     * the parsed event data as "value" entry, and the request is continued without modification.
     */
    static final public String WEB_REQUEST_RECEIVED_TRACKONLY = de.qfs.apps.qftest.shared.script.modules.UserNotifications.WEB_REQUEST_RECEIVED_TRACKONLY
    /**
     * Called as soon as a request is responded from the server to the browser.
     * 
     * The userInfo contains all information as described for WEB_REQUEST_RECEIVED.
     * 
     * In addition, the following entries are prefilled:
     * * errorReason - Only in case of error (replaceable)
     * * responseCode - If available (replaceable)
     * * responseHeaders - The headers returned from the server (replaceable)
     * * responseBodyAccessor - An object who's "get()"-Method returns the body of the response (String or byte[])
     * 
     * Information: Only modify the response headers or request the responseBody if the request content is
     * about to be small to avoid OutOfMemeory errors, since the complete body will go through QF-Test
     * for technical reasons.
     * 
     * Only available when CDP-Driver is used to connect the browser.
     */
    static final public String WEB_RESPONSE_RECEIVED = de.qfs.apps.qftest.shared.script.modules.UserNotifications.WEB_RESPONSE_RECEIVED
    /**
     * Simple variation of WEB_RESPONSE_RECEIVED, called upon CDPs Fetch.requestPaused event, only contains
     * the parsed event data as "value" entry, and the request is continued without modification.
     */
    static final public String WEB_RESPONSE_RECEIVED_TRACKONLY = de.qfs.apps.qftest.shared.script.modules.UserNotifications.WEB_RESPONSE_RECEIVED_TRACKONLY
    static final public String CREATING_WEBDRIVER = de.qfs.apps.qftest.shared.script.modules.UserNotifications.CREATING_WEBDRIVER
    /** The ExceptionHandler logs to run log and catches any exception */
    static final public ExceptionHandler LOGGING_EXCEPTION_HANDLER = de.qfs.apps.qftest.shared.script.modules.UserNotifications.LOGGING_EXCEPTION_HANDLER
    //  redirected methods
    private final de.qfs.apps.qftest.shared.script.modules.UserNotifications __wrappedInstance
    private static UserNotifications __instance = new UserNotifications()
    static UserNotifications instance(){
        return __instance
    }
    private UserNotifications(){
        __wrappedInstance = de.qfs.apps.qftest.shared.script.modules.UserNotifications.instance()
    }
    /**
     * Posts a new notification.
     * 
     * @param notficationName the name of the notification. If it does not start with "user.",
     * it is prefixed with this string.
     * @param userInfo An optional map of data to attach to the notification
     */
    public void post(String notificationName, Map userInfo=null){
        __wrappedInstance.post(notificationName, userInfo)
    }
    /**
     * Posts a new notification.
     * 
     * @param notficationName the name of the notification. If it does not start with "user.",
     * it is prefixed with this string.
     * @param userInfo An optional map of data to attach to the notification
     */
    public void post(Map mappedParams, String notificationName){
        __wrappedInstance.post(notificationName, mappedParams)
    }
    /**
     * Adds a notification observer with the given name for the given notificationNames
     * 
     * @param observerName the name of the observer
     * @param observer the method to call when a notification is posted. The method receives the name of the
     * posted notification as first argument and the userInfo map as second argument. If the observer
     * specifies only one argument, the userInfo map is provided as first parameter.
     * @param notificationNames the names of the notifications to be informed when posted. If a name does not
     * start with "user.", it is prefixed with this string. If no notification names are provided, the observerName
     * is used as notification name.
     */
    public void addObserver(String observerName, Object method, String... notificationNames){
        __wrappedInstance.addObserver(observerName, method, notificationNames)
    }
    /**
     * Removes the notification observer added before with the given name
     * 
     * @param observerName the name of the observer to remove
     */
    public void removeObserver(String observerName){
        __wrappedInstance.removeObserver(observerName)
    }
    /** Remove all previously registered observers */
    public void removeAllObserver(){
        __wrappedInstance.removeAllObserver()
    }
    /** List the names of all registered observers */
    public List<String> listObserverNames(){
        return __wrappedInstance.listObserverNames()
    }
}
