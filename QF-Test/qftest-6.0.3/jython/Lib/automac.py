from de.qfs.apps.qftest.shared.script.modules import Automac as _WrappedAutomac
#  redirected constants
NSApplicationDirectory = _WrappedAutomac.NSApplicationDirectory
NSDemoApplicationDirectory = _WrappedAutomac.NSDemoApplicationDirectory
NSDeveloperApplicationDirectory = _WrappedAutomac.NSDeveloperApplicationDirectory
NSAdminApplicationDirectory = _WrappedAutomac.NSAdminApplicationDirectory
NSLibraryDirectory = _WrappedAutomac.NSLibraryDirectory
NSDeveloperDirectory = _WrappedAutomac.NSDeveloperDirectory
NSUserDirectory = _WrappedAutomac.NSUserDirectory
NSDocumentationDirectory = _WrappedAutomac.NSDocumentationDirectory
NSDocumentDirectory = _WrappedAutomac.NSDocumentDirectory
NSCoreServiceDirectory = _WrappedAutomac.NSCoreServiceDirectory
NSAutosavedInformationDirectory = _WrappedAutomac.NSAutosavedInformationDirectory
NSDesktopDirectory = _WrappedAutomac.NSDesktopDirectory
NSCachesDirectory = _WrappedAutomac.NSCachesDirectory
NSApplicationSupportDirectory = _WrappedAutomac.NSApplicationSupportDirectory
NSDownloadsDirectory = _WrappedAutomac.NSDownloadsDirectory
NSInputMethodsDirectory = _WrappedAutomac.NSInputMethodsDirectory
NSMoviesDirectory = _WrappedAutomac.NSMoviesDirectory
NSMusicDirectory = _WrappedAutomac.NSMusicDirectory
NSPicturesDirectory = _WrappedAutomac.NSPicturesDirectory
NSPrinterDescriptionDirectory = _WrappedAutomac.NSPrinterDescriptionDirectory
NSSharedPublicDirectory = _WrappedAutomac.NSSharedPublicDirectory
NSPreferencePanesDirectory = _WrappedAutomac.NSPreferencePanesDirectory
NSApplicationScriptsDirectory = _WrappedAutomac.NSApplicationScriptsDirectory
NSItemReplacementDirectory = _WrappedAutomac.NSItemReplacementDirectory
NSAllApplicationsDirectory = _WrappedAutomac.NSAllApplicationsDirectory
NSAllLibrariesDirectory = _WrappedAutomac.NSAllLibrariesDirectory
NSTrashDirectory = _WrappedAutomac.NSTrashDirectory
NSUserDomainMask = _WrappedAutomac.NSUserDomainMask
NSLocalDomainMask = _WrappedAutomac.NSLocalDomainMask
NSNetworkDomainMask = _WrappedAutomac.NSNetworkDomainMask
NSSystemDomainMask = _WrappedAutomac.NSSystemDomainMask
NSAllDomainsMask = _WrappedAutomac.NSAllDomainsMask
""" Specifies a mouse down event with the left button."""
kCGEventLeftMouseDown = _WrappedAutomac.kCGEventLeftMouseDown
""" Specifies a mouse up event with the left button."""
kCGEventLeftMouseUp = _WrappedAutomac.kCGEventLeftMouseUp
""" Specifies a mouse down event with the right button."""
kCGEventRightMouseDown = _WrappedAutomac.kCGEventRightMouseDown
""" Specifies a mouse up event with the right button."""
kCGEventRightMouseUp = _WrappedAutomac.kCGEventRightMouseUp
""" Specifies a mouse moved event."""
kCGEventMouseMoved = _WrappedAutomac.kCGEventMouseMoved
""" Specifies a mouse drag event with the left button down."""
kCGEventLeftMouseDragged = _WrappedAutomac.kCGEventLeftMouseDragged
""" Specifies a mouse drag event with the right button down."""
kCGEventRightMouseDragged = _WrappedAutomac.kCGEventRightMouseDragged
""" Specifies a mouse down event with one of buttons 2-31."""
kCGEventOtherMouseDown = _WrappedAutomac.kCGEventOtherMouseDown
""" Specifies a mouse up event with one of buttons 2-31."""
kCGEventOtherMouseUp = _WrappedAutomac.kCGEventOtherMouseUp
""" Specifies a mouse drag event with one of buttons 2-31 down."""
kCGEventOtherMouseDragged = _WrappedAutomac.kCGEventOtherMouseDragged
#  redirected methods
__wrappedInstance = _WrappedAutomac.instance()
def isProcessTrusted(informUser):
    """
    Returns whether the current process is a trusted accessibility client.
    @param informUser indicating whether the user will be informed if the current process is untrusted.
    This could be used, for example, on application startup to always warn a user if accessibility is not enabled for the current process.
    Prompting occurs asynchronously and does not affect the return value.
    
    @return true if the current process is a trusted accessibility client, false if it is not.
    """
    if informUser:
        informUser = True
    
    else:
        informUser = False
    
    return __wrappedInstance.isProcessTrusted(informUser)

def elementAtPosition(x, y):
    """
    Returns the accessibility object at the specified position in top-left relative screen coordinates,
    unrestricted to the application
    
    @param x The horizontal position.
    @param y The vertical position.
    @return the accessibility object at the position specified by x and y.
    
    @throws AXException on error
    """
    return __wrappedInstance.elementAtPosition(x, y)

def getApplicationAccessibilityObject(pid):
    """
    Creates and returns the top-level accessibility object for the application with the specified process ID.
    
    @param pid The process ID of an application.
    @return The AXUIElement representing the top-level accessibility object for the application with the specified process ID.
    """
    return __wrappedInstance.getApplicationAccessibilityObject(pid)

def getSystemWideAccessibilityObject():
    """
    Returns an accessibility object that provides access to system attributes.
    <br>
    This is useful for things like finding the focused accessibility object regardless of which application is currently active.
    @return The AXUIElement representing the system-wide accessibility object.
    """
    return __wrappedInstance.getSystemWideAccessibilityObject()

def setGlobalMessagingTimeout(timeoutInMs):
    __wrappedInstance.setGlobalMessagingTimeout(timeoutInMs)

def getWindowText(window):
    """
    Get the title of a window (or any other AXUIElement).
    
    @param window The window.
    @return The title of the window.
    """
    return __wrappedInstance.getWindowText(window)

def setWindowPosition(window, x, y):
    """
    Set the position of a window.
    
    @param window
    The window object.
    @param x
    The x co-ordinate.
    @param y
    The y co-ordinate.
    """
    __wrappedInstance.setWindowPosition(window, x, y)

def setWindowSize(window, width, height):
    """
    Set the size of a window.
    
    @param window
    The window object.
    @param width
    The width.
    @param height
    The height.
    """
    __wrappedInstance.setWindowSize(window, width, height)

def findWindow(nameOrPattern, regexp=False):
    """
    Iterates over all windows of all applications on the current desktop and matches the parameter
    against the window title.
    
    @param nameOrPattern The window title or a pattern to match
    @param regexp If true, the title string will be transformed to a pattern
    @return the window or null, if not found.
    """
    if regexp:
        regexp = True
    
    else:
        regexp = False
    
    return __wrappedInstance.findWindow(nameOrPattern, regexp)

def waitForWindow(timeout, nameOrPattern):
    """
    Wait for a window on the current desktop identified by its title.
    
    @param timeout
    The maximum time to wait (in ms).
    @param nameOrPattern
    TThe window title or a pattern to match
    @return the window object or null, if not found.
    @throws Exception
    """
    return __wrappedInstance.waitForWindow(timeout, nameOrPattern)

def closeWindow(window):
    """
    Close a window by pressing its close button.
    
    @param window The Window to close
    """
    __wrappedInstance.closeWindow(window)

def maximizeWindow(window):
    """
    Maximizes a window by pressing its zoom button. Depending on the user config,
    The window size is optimized or the fullscreen mode is entered.
    
    @param window The Window to maximize
    """
    __wrappedInstance.maximizeWindow(window)

def fullScreenWindow(window):
    """
    Puts a window in Full Screen mode
    
    @param window The Window to put in Full screen mode
    """
    __wrappedInstance.fullScreenWindow(window)

def minimizeWindow(window):
    """
    Minimizes a window by setting it AXMinimized value
    
    @param window The Window to minimize
    """
    __wrappedInstance.minimizeWindow(window)

def restoreWindow(window):
    """
    Restores a window by unsetting its AXMinimized and AXFullScreen value
    
    @param window The Window to restore
    """
    __wrappedInstance.restoreWindow(window)

def setForeground(window):
    """
    Puts a window to the foreground
    
    @param window The Window to put to front
    """
    __wrappedInstance.setForeground(window)

def dumpControls(parent=None, maxDepth=3):
    """
    Dumps identification data of the given control and all children to the terminal
    
    @param parent
    the control to dump. Defaults to the desktop, i.e. all applications
    @param maxDepth
    the maximal depth of children to dump. Defaults to 3
    @throws AutomationException
    if something goes wrong
    @throws PatternNotFoundException
    if the desktop could not be found
    """
    return __wrappedInstance.dumpControls(parent, maxDepth)

def dumpControlsToFile(filename, parent=None, maxDepth=3, charset="UTF-8"):
    """
    Dumps identification data of the given control and all children to a file
    
    @param filename
    the name of the file to dump data to
    @param parent
    the Control object to dump. Defaults to the desktop, i.e. all applications
    @param maxDepth
    the maximal depth of children to dump. Defaults to 3
    @param charset
    the charset to use for the dump. Defaults to "UTF-8", other options include "US-ASCII", "ISO-8859-1", and "UTF-16"
    @throws AutomationException
    if something goes wrong
    @throws PatternNotFoundException
    if the desktop could not be found
    """
    __wrappedInstance.dumpControlsToFile(filename, parent, maxDepth, charset)

def runningApplications():
    """ Returns an array of running applications, as seen by the Cocoa Core framework"""
    return __wrappedInstance.runningApplications()

def runningApplicationWithProcessIdentifier(processIdentifier):
    """ Returns the running application with the given process identifier, or null if no application has that pid"""
    return __wrappedInstance.runningApplicationWithProcessIdentifier(processIdentifier)

def runningApplicationsWithBundleIdentifier(bundleIdentifier):
    """ Returns an array of currently running applications with the specified bundle identifier."""
    return __wrappedInstance.runningApplicationsWithBundleIdentifier(bundleIdentifier)

def currentApplication():
    """ Returns an NSRunningApplication representing this application."""
    return __wrappedInstance.currentApplication()

def getSearchPathForDirectoriesInDomains(directory, domainMask, expandTilde):
    """
    Creates a list of path strings for the specified directories in the specified domains.
    The list is in the order in which you should search the directories.
    
    @param directory An NSSearchPathDirectory constant
    @param domainMask AN NSSearchPathDomainMask constant
    @param expandTilde If expandTilde is true, tildes are expanded
    
    @return a list of directory search paths
    """
    if expandTilde:
        expandTilde = True
    
    else:
        expandTilde = False
    
    return __wrappedInstance.getSearchPathForDirectoriesInDomains(directory, domainMask, expandTilde)

def postKeyboardEvent(keyCode, modifiers, keyDown):
    """
    Creates and posts a Quartz keyboard event into the event stream.
    
    @param keyCode The AWT key code for the event.
    @param modifiers Explicit modifiers like java.awt.Event.CTRL_MASK.
    @param keyDown Pass true to specify that the key position is down. To specify that the key position is up, pass false. This value is used to determine the type of the keyboard event.
    @return <code>true</code> if the event could be created, false otherwise.
    """
    if keyDown:
        keyDown = True
    
    else:
        keyDown = False
    
    return __wrappedInstance.postKeyboardEvent(keyCode, modifiers, keyDown)

def postKeyboardEventToProcess(pid, keyCode, modifiers, keyDown):
    """
    Posts a Quartz event into the event stream for a specific application.
    
    @param pid The process ID of an application.
    @param keyCode The AWT key code for the event.
    @param modifiers Explicit modifiers like java.awt.Event.CTRL_MASK.
    @param keyDown Pass true to specify that the key position is down. To specify that the key position is up, pass false. This value is used to determine the type of the keyboard event.
    @return <code>true</code> if the event could be created, false otherwise.
    
    @since macOs 10.11
    """
    if keyDown:
        keyDown = True
    
    else:
        keyDown = False
    
    return __wrappedInstance.postKeyboardEventToProcess(pid, keyCode, modifiers, keyDown)

def stringForKeyStrokes(*keyStrokes):
    """
    Converts a given sequence of KeyStrokes into the corresponding characters using the current keyboard layout.
    
    @param keyStrokes the keyStrokes. The keyCode is expected to be a KeyEvent constant
    @return the string containing the corresponding characters
    """
    return __wrappedInstance.stringForKeyStrokes(keyStrokes)

def keyStrokesForString(input):
    """
    Converts a given input String into sequence of KeyStrokes using the current keyboard layout.
    
    @param input the String to convert to keystrokes
    @return the keyStrokes required to output the string, using KeyEvent constants for the keyCodes
    """
    return __wrappedInstance.keyStrokesForString(input)

def sendText(textToInput):
    """
    Sends appropriate key events to input text to the control currently in focus
    
    @param textToInput the text to input
    
    @since 5.1.1
    """
    __wrappedInstance.sendText(textToInput)

def postMouseEvent(mouseType, mouseCursorPositionX, mouseCursorPositionY, mouseButton, clickState, modifiers):
    """
    Creates and posts a Quartz mouse event into the event stream.
    
    @param mouseType A mouse event type. Pass one of the constants listed in CGEventType.
    @param mouseCursorPositionX The x position where the event should be posted.
    @param mouseCursorPositionY The y position where the event should be posted.
    @param mouseButton The button that's changing state.
    @param clickState The mouse button click state. A click state of 1 represents a single click. A click state of 2 represents a double-click. A click state of 3 represents a triple-click.
    @param modifiers Explicit modifiers like java.awt.InputEvent.CTRL_DOWN_MASK.
    @return <code>true</code> if the event could be created, false otherwise.
    """
    return __wrappedInstance.postMouseEvent(mouseType, mouseCursorPositionX, mouseCursorPositionY, mouseButton, clickState, modifiers)

def getVirtualKeyToKeyCode():
    return __wrappedInstance.virtualKeyToKeyCode

def getKeyCodeToVirtualKey():
    return __wrappedInstance.keyCodeToVirtualKey

def setExpectLibsInClasspath(self, expectLibsInClasspath):
    """
    Set to true if axjlib libraries are willingly on the main classpath and should
    not reported as a warning.
    """
    __wrappedInstance.expectLibsInClasspath = expectLibsInClasspath

virtualKeyToKeyCode = property(getVirtualKeyToKeyCode, None)
keyCodeToVirtualKey = property(getKeyCodeToVirtualKey, None)
expectLibsInClasspath = property(None, setExpectLibsInClasspath)
