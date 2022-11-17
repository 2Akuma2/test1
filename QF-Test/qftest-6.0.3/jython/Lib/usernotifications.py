from de.qfs.apps.qftest.shared.script.modules import UserNotifications as _WrappedUserNotifications
#  redirected constants
NOTIFICATION_PREFIX = _WrappedUserNotifications.NOTIFICATION_PREFIX
RECORDING_STARTED = _WrappedUserNotifications.RECORDING_STARTED
RECORDING_STOPPED = _WrappedUserNotifications.RECORDING_STOPPED
RECORDING_PAUSED = _WrappedUserNotifications.RECORDING_PAUSED
RECORDING_RESUMED = _WrappedUserNotifications.RECORDING_RESUMED
CHECK_RECORDING_STARTED = _WrappedUserNotifications.CHECK_RECORDING_STARTED
CHECK_RECORDING_STOPPED = _WrappedUserNotifications.CHECK_RECORDING_STOPPED
REQUEST_RECORDING_STARTED = _WrappedUserNotifications.REQUEST_RECORDING_STARTED
REQUEST_RECORDING_STOPPED = _WrappedUserNotifications.REQUEST_RECORDING_STOPPED
COMPONENT_RECORDING_STARTED = _WrappedUserNotifications.COMPONENT_RECORDING_STARTED
COMPONENT_RECORDING_STOPPED = _WrappedUserNotifications.COMPONENT_RECORDING_STOPPED
PROCBUILDER_STARTED = _WrappedUserNotifications.PROCBUILDER_STARTED
PROCBUILDER_STOPPED = _WrappedUserNotifications.PROCBUILDER_STOPPED
INSPECTOR_MODE_STARTED = _WrappedUserNotifications.INSPECTOR_MODE_STARTED
INSPECTOR_MODE_STOPPED = _WrappedUserNotifications.INSPECTOR_MODE_STOPPED
RUN_STARTED = _WrappedUserNotifications.RUN_STARTED
RUN_STOPPED = _WrappedUserNotifications.RUN_STOPPED
NODE_ENTERED = _WrappedUserNotifications.NODE_ENTERED
NODE_EXITED = _WrappedUserNotifications.NODE_EXITED
RUN_ERROR_OCCURED = _WrappedUserNotifications.RUN_ERROR_OCCURED
"""
Used to trigger a script execution in QF-Test.

User-Info members:
* code: The code to execute
* interpreter: Interpreter name, defaults to the standard scripting language
* async: true/false, to execute the script asynchronously
* client: Client name, if the script should be executed as a SUT-Script.
* engine: If executed as SUT-script can specify the engine to execute the script in
"""
EXECUTE = _WrappedUserNotifications.EXECUTE
"""
Sent when a window is about to be raised. Put a member <code>didRaise</code> into the userInfo
to prevent QF-Test raising the window.
"""
WINDOW_RAISE = _WrappedUserNotifications.WINDOW_RAISE
"""
Called as soon as the application tries to open an external webbrowser to display a website.
The userInfo contains the members "url" - a String pointing to the URL to open (read only) - and
"open" - a Boolean which can be set to "FALSE" to prohibit the actual browser opening.
"""
BROWSER_OPEN = _WrappedUserNotifications.BROWSER_OPEN
"""
Called as soon as the application is about to start an external process.

The userInfo contains the following entries:
* command - A List of Strings of the command to start (modifiable/replaceable)
* directory - A File with the process working directory (or null) (replaceable)
* environment - A Map of String-String entries representing the environment passed to the process (modifiable/replaceable)

These entries can be added to the userInfo:
* stdout - If set, a mock process is started which returns the given String on STDOUT
* stderr - If set, a mock process is started which returns the given String on STDERR
* exitcode - If set, a mock process is started which returns with the given exit code
* runtime - If set, a mock process is started which returns after the given runtime (in milliseconds)
* ioexception - If set, instead of starting the process the given exception is thrown (can be a String)
"""
PROCESS_START = _WrappedUserNotifications.PROCESS_START
"""
Called as soon as a request is about to be sent from the browser.

The userInfo contains the following entries:
* url - The url called by the browser - (replaceable)
* method - The method used to request (replaceable)
* postData - A String containing the post data, if available (replaceable)
* resourceType - the requested resource - one of Document, Stylesheet, Image, Media, Font, Script, TextTrack, XHR, Fetch, EventSource, WebSocket, Manifest, SignedExchange, Ping, CSPViolationReport, Preflight, Other
* requestHeaders - A Map of String-String entries representing the headers sent with the request (modifiable/replaceable)

These entries can be added to the userInfo:
* errorReason - If set, the request fails with the given reason. Allowed values: Failed, Aborted, TimedOut, AccessDenied, ConnectionClosed, ConnectionReset, ConnectionRefused, ConnectionAborted, ConnectionFailed, NameNotResolved, InternetDisconnected, AddressUnreachable, BlockedByClient, BlockedByResponse
* responseCode - If set, the request will be fulfilled with the given response status code, e.g. "404"
* responseHeaders - If set, the request will be fulfilled with the given response headers (Should be a String or a Map of String-String entries)
* responseBody (String or byte[]) - If set, the request will be fulfilled with the given body.

Only available when CDP-Driver is used to connect the browser.
"""
WEB_REQUEST_RECEIVED = _WrappedUserNotifications.WEB_REQUEST_RECEIVED
"""
Simple variation of WEB_RESPONSE_RECEIVED, called upon CDPs Fetch.requestPaused event, only contains
the parsed event data as "value" entry, and the request is continued without modification.
"""
WEB_REQUEST_RECEIVED_TRACKONLY = _WrappedUserNotifications.WEB_REQUEST_RECEIVED_TRACKONLY
"""
Called as soon as a request is responded from the server to the browser.

The userInfo contains all information as described for WEB_REQUEST_RECEIVED.

In addition, the following entries are prefilled:
* errorReason - Only in case of error (replaceable)
* responseCode - If available (replaceable)
* responseHeaders - The headers returned from the server (replaceable)
* responseBodyAccessor - An object who's "get()"-Method returns the body of the response (String or byte[])

Information: Only modify the response headers or request the responseBody if the request content is
about to be small to avoid OutOfMemeory errors, since the complete body will go through QF-Test
for technical reasons.

Only available when CDP-Driver is used to connect the browser.
"""
WEB_RESPONSE_RECEIVED = _WrappedUserNotifications.WEB_RESPONSE_RECEIVED
"""
Simple variation of WEB_RESPONSE_RECEIVED, called upon CDPs Fetch.requestPaused event, only contains
the parsed event data as "value" entry, and the request is continued without modification.
"""
WEB_RESPONSE_RECEIVED_TRACKONLY = _WrappedUserNotifications.WEB_RESPONSE_RECEIVED_TRACKONLY
CREATING_WEBDRIVER = _WrappedUserNotifications.CREATING_WEBDRIVER
""" The ExceptionHandler logs to run log and catches any exception"""
LOGGING_EXCEPTION_HANDLER = _WrappedUserNotifications.LOGGING_EXCEPTION_HANDLER
#  redirected methods
__wrappedInstance = _WrappedUserNotifications.instance()
def post(notificationName, userInfo=None):
    """
    Posts a new notification.
    
    @param notficationName the name of the notification. If it does not start with "user.",
    it is prefixed with this string.
    @param userInfo An optional map of data to attach to the notification
    """
    __wrappedInstance.post(notificationName, userInfo)

def addObserver(observerName, method, *notificationNames):
    """
    Adds a notification observer with the given name for the given notificationNames
    
    @param observerName the name of the observer
    @param observer the method to call when a notification is posted. The method receives the name of the
    posted notification as first argument and the userInfo map as second argument. If the observer
    specifies only one argument, the userInfo map is provided as first parameter.
    @param notificationNames the names of the notifications to be informed when posted. If a name does not
    start with "user.", it is prefixed with this string. If no notification names are provided, the observerName
    is used as notification name.
    """
    __wrappedInstance.addObserver(observerName, method, notificationNames)

def removeObserver(observerName):
    """
    Removes the notification observer added before with the given name
    
    @param observerName the name of the observer to remove
    """
    __wrappedInstance.removeObserver(observerName)

def removeAllObserver():
    """ Remove all previously registered observers"""
    __wrappedInstance.removeAllObserver()

def listObserverNames():
    """ List the names of all registered observers"""
    return __wrappedInstance.listObserverNames()

