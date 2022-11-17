package de.qfs
import java.util.List
import javax.swing.KeyStroke
/**
 * Collection of simple methods for Mac test automation based on axjlib.
 * 
 * @author Pascal Bihler
 */
class Automac{
    //  redirected constants
    static final public int NSApplicationDirectory = de.qfs.apps.qftest.shared.script.modules.Automac.NSApplicationDirectory
    static final public int NSDemoApplicationDirectory = de.qfs.apps.qftest.shared.script.modules.Automac.NSDemoApplicationDirectory
    static final public int NSDeveloperApplicationDirectory = de.qfs.apps.qftest.shared.script.modules.Automac.NSDeveloperApplicationDirectory
    static final public int NSAdminApplicationDirectory = de.qfs.apps.qftest.shared.script.modules.Automac.NSAdminApplicationDirectory
    static final public int NSLibraryDirectory = de.qfs.apps.qftest.shared.script.modules.Automac.NSLibraryDirectory
    static final public int NSDeveloperDirectory = de.qfs.apps.qftest.shared.script.modules.Automac.NSDeveloperDirectory
    static final public int NSUserDirectory = de.qfs.apps.qftest.shared.script.modules.Automac.NSUserDirectory
    static final public int NSDocumentationDirectory = de.qfs.apps.qftest.shared.script.modules.Automac.NSDocumentationDirectory
    static final public int NSDocumentDirectory = de.qfs.apps.qftest.shared.script.modules.Automac.NSDocumentDirectory
    static final public int NSCoreServiceDirectory = de.qfs.apps.qftest.shared.script.modules.Automac.NSCoreServiceDirectory
    static final public int NSAutosavedInformationDirectory = de.qfs.apps.qftest.shared.script.modules.Automac.NSAutosavedInformationDirectory
    static final public int NSDesktopDirectory = de.qfs.apps.qftest.shared.script.modules.Automac.NSDesktopDirectory
    static final public int NSCachesDirectory = de.qfs.apps.qftest.shared.script.modules.Automac.NSCachesDirectory
    static final public int NSApplicationSupportDirectory = de.qfs.apps.qftest.shared.script.modules.Automac.NSApplicationSupportDirectory
    static final public int NSDownloadsDirectory = de.qfs.apps.qftest.shared.script.modules.Automac.NSDownloadsDirectory
    static final public int NSInputMethodsDirectory = de.qfs.apps.qftest.shared.script.modules.Automac.NSInputMethodsDirectory
    static final public int NSMoviesDirectory = de.qfs.apps.qftest.shared.script.modules.Automac.NSMoviesDirectory
    static final public int NSMusicDirectory = de.qfs.apps.qftest.shared.script.modules.Automac.NSMusicDirectory
    static final public int NSPicturesDirectory = de.qfs.apps.qftest.shared.script.modules.Automac.NSPicturesDirectory
    static final public int NSPrinterDescriptionDirectory = de.qfs.apps.qftest.shared.script.modules.Automac.NSPrinterDescriptionDirectory
    static final public int NSSharedPublicDirectory = de.qfs.apps.qftest.shared.script.modules.Automac.NSSharedPublicDirectory
    static final public int NSPreferencePanesDirectory = de.qfs.apps.qftest.shared.script.modules.Automac.NSPreferencePanesDirectory
    static final public int NSApplicationScriptsDirectory = de.qfs.apps.qftest.shared.script.modules.Automac.NSApplicationScriptsDirectory
    static final public int NSItemReplacementDirectory = de.qfs.apps.qftest.shared.script.modules.Automac.NSItemReplacementDirectory
    static final public int NSAllApplicationsDirectory = de.qfs.apps.qftest.shared.script.modules.Automac.NSAllApplicationsDirectory
    static final public int NSAllLibrariesDirectory = de.qfs.apps.qftest.shared.script.modules.Automac.NSAllLibrariesDirectory
    static final public int NSTrashDirectory = de.qfs.apps.qftest.shared.script.modules.Automac.NSTrashDirectory
    static final public int NSUserDomainMask = de.qfs.apps.qftest.shared.script.modules.Automac.NSUserDomainMask
    static final public int NSLocalDomainMask = de.qfs.apps.qftest.shared.script.modules.Automac.NSLocalDomainMask
    static final public int NSNetworkDomainMask = de.qfs.apps.qftest.shared.script.modules.Automac.NSNetworkDomainMask
    static final public int NSSystemDomainMask = de.qfs.apps.qftest.shared.script.modules.Automac.NSSystemDomainMask
    static final public int NSAllDomainsMask = de.qfs.apps.qftest.shared.script.modules.Automac.NSAllDomainsMask
    /** Specifies a mouse down event with the left button. */
    static final public int kCGEventLeftMouseDown = de.qfs.apps.qftest.shared.script.modules.Automac.kCGEventLeftMouseDown
    /** Specifies a mouse up event with the left button. */
    static final public int kCGEventLeftMouseUp = de.qfs.apps.qftest.shared.script.modules.Automac.kCGEventLeftMouseUp
    /** Specifies a mouse down event with the right button. */
    static final public int kCGEventRightMouseDown = de.qfs.apps.qftest.shared.script.modules.Automac.kCGEventRightMouseDown
    /** Specifies a mouse up event with the right button. */
    static final public int kCGEventRightMouseUp = de.qfs.apps.qftest.shared.script.modules.Automac.kCGEventRightMouseUp
    /** Specifies a mouse moved event. */
    static final public int kCGEventMouseMoved = de.qfs.apps.qftest.shared.script.modules.Automac.kCGEventMouseMoved
    /** Specifies a mouse drag event with the left button down. */
    static final public int kCGEventLeftMouseDragged = de.qfs.apps.qftest.shared.script.modules.Automac.kCGEventLeftMouseDragged
    /** Specifies a mouse drag event with the right button down. */
    static final public int kCGEventRightMouseDragged = de.qfs.apps.qftest.shared.script.modules.Automac.kCGEventRightMouseDragged
    /** Specifies a mouse down event with one of buttons 2-31. */
    static final public int kCGEventOtherMouseDown = de.qfs.apps.qftest.shared.script.modules.Automac.kCGEventOtherMouseDown
    /** Specifies a mouse up event with one of buttons 2-31. */
    static final public int kCGEventOtherMouseUp = de.qfs.apps.qftest.shared.script.modules.Automac.kCGEventOtherMouseUp
    /** Specifies a mouse drag event with one of buttons 2-31 down. */
    static final public int kCGEventOtherMouseDragged = de.qfs.apps.qftest.shared.script.modules.Automac.kCGEventOtherMouseDragged
    //  redirected methods
    private final de.qfs.apps.qftest.shared.script.modules.Automac __wrappedInstance
    private static Automac __instance = new Automac()
    /** @return the Singleton instance */
    static Automac instance(){
        return __instance
    }
    /** @return the Singleton instance */
    private Automac(){
        __wrappedInstance = de.qfs.apps.qftest.shared.script.modules.Automac.instance()
    }
    /**
     * Returns whether the current process is a trusted accessibility client.
     * @param informUser indicating whether the user will be informed if the current process is untrusted.
     * This could be used, for example, on application startup to always warn a user if accessibility is not enabled for the current process.
     * Prompting occurs asynchronously and does not affect the return value.
     * 
     * @return true if the current process is a trusted accessibility client, false if it is not.
     */
    public boolean isProcessTrusted(boolean informUser){
        return __wrappedInstance.isProcessTrusted(informUser)
    }
    /**
     * Returns the accessibility object at the specified position in top-left relative screen coordinates,
     * unrestricted to the application
     * 
     * @param x The horizontal position.
     * @param y The vertical position.
     * @return the accessibility object at the position specified by x and y.
     * 
     * @throws AXException on error
     */
    public Object elementAtPosition(float x, float y){
        return __wrappedInstance.elementAtPosition(x, y)
    }
    /**
     * Creates and returns the top-level accessibility object for the application with the specified process ID.
     * 
     * @param pid The process ID of an application.
     * @return The AXUIElement representing the top-level accessibility object for the application with the specified process ID.
     */
    public Object getApplicationAccessibilityObject(int pid){
        return __wrappedInstance.getApplicationAccessibilityObject(pid)
    }
    /**
     * Returns an accessibility object that provides access to system attributes.
     * <br>
     * This is useful for things like finding the focused accessibility object regardless of which application is currently active.
     * @return The AXUIElement representing the system-wide accessibility object.
     */
    public Object getSystemWideAccessibilityObject(){
        return __wrappedInstance.getSystemWideAccessibilityObject()
    }
    public void setGlobalMessagingTimeout(int timeoutInMs){
        __wrappedInstance.setGlobalMessagingTimeout(timeoutInMs)
    }
    /**
     * Get the title of a window (or any other AXUIElement).
     * 
     * @param window The window.
     * @return The title of the window.
     */
    public String getWindowText(Object window){
        return __wrappedInstance.getWindowText(window)
    }
    /**
     * Set the position of a window.
     * 
     * @param window
     * The window object.
     * @param x
     * The x co-ordinate.
     * @param y
     * The y co-ordinate.
     */
    public void setWindowPosition(Object window, float x, float y){
        __wrappedInstance.setWindowPosition(window, x, y)
    }
    /**
     * Set the size of a window.
     * 
     * @param window
     * The window object.
     * @param width
     * The width.
     * @param height
     * The height.
     */
    public void setWindowSize(Object window, float width, float height){
        __wrappedInstance.setWindowSize(window, width, height)
    }
    /**
     * Iterates over all windows of all applications on the current desktop and matches the parameter
     * against the window title.
     * 
     * @param nameOrPattern The window title or a pattern to match
     * @param regexp If true, the title string will be transformed to a pattern
     * @return the window or null, if not found.
     */
    public Object findWindow(Object nameOrPattern, boolean regexp=false){
        return __wrappedInstance.findWindow(nameOrPattern, regexp)
    }
    /**
     * Iterates over all windows of all applications on the current desktop and matches the parameter
     * against the window title.
     * 
     * @param nameOrPattern The window title or a pattern to match
     * @param regexp If true, the title string will be transformed to a pattern
     * @return the window or null, if not found.
     */
    public Object findWindow(Map mappedParams, Object nameOrPattern){
        if(mappedParams == null){
            return __wrappedInstance.findWindow(mappedParams, nameOrPattern)
        }
        def regexp = false
        if(mappedParams.containsKey("regexp")){
            regexp = mappedParams.regexp
        }
        return __wrappedInstance.findWindow(nameOrPattern, regexp)
    }
    /**
     * Wait for a window on the current desktop identified by its title.
     * 
     * @param timeout
     * The maximum time to wait (in ms).
     * @param nameOrPattern
     * TThe window title or a pattern to match
     * @return the window object or null, if not found.
     * @throws Exception
     */
    public Object waitForWindow(long timeout, Object nameOrPattern){
        return __wrappedInstance.waitForWindow(timeout, nameOrPattern)
    }
    /**
     * Close a window by pressing its close button.
     * 
     * @param window The Window to close
     */
    public void closeWindow(Object window){
        __wrappedInstance.closeWindow(window)
    }
    /**
     * Maximizes a window by pressing its zoom button. Depending on the user config,
     * The window size is optimized or the fullscreen mode is entered.
     * 
     * @param window The Window to maximize
     */
    public void maximizeWindow(Object window){
        __wrappedInstance.maximizeWindow(window)
    }
    /**
     * Puts a window in Full Screen mode
     * 
     * @param window The Window to put in Full screen mode
     */
    public void fullScreenWindow(Object window){
        __wrappedInstance.fullScreenWindow(window)
    }
    /**
     * Minimizes a window by setting it AXMinimized value
     * 
     * @param window The Window to minimize
     */
    public void minimizeWindow(Object window){
        __wrappedInstance.minimizeWindow(window)
    }
    /**
     * Restores a window by unsetting its AXMinimized and AXFullScreen value
     * 
     * @param window The Window to restore
     */
    public void restoreWindow(Object window){
        __wrappedInstance.restoreWindow(window)
    }
    /**
     * Puts a window to the foreground
     * 
     * @param window The Window to put to front
     */
    public void setForeground(Object window){
        __wrappedInstance.setForeground(window)
    }
    /**
     * Dumps identification data of the given control and all children to the terminal
     * 
     * @param parent
     * the control to dump. Defaults to the desktop, i.e. all applications
     * @param maxDepth
     * the maximal depth of children to dump. Defaults to 3
     * @throws AutomationException
     * if something goes wrong
     * @throws PatternNotFoundException
     * if the desktop could not be found
     */
    public String dumpControls(Object parent=null, int maxDepth=3){
        return __wrappedInstance.dumpControls(parent, maxDepth)
    }
    /**
     * Dumps identification data of the given control and all children to the terminal
     * 
     * @param parent
     * the control to dump. Defaults to the desktop, i.e. all applications
     * @param maxDepth
     * the maximal depth of children to dump. Defaults to 3
     * @throws AutomationException
     * if something goes wrong
     * @throws PatternNotFoundException
     * if the desktop could not be found
     */
    public String dumpControls(Map mappedParams){
        def parent = null
        if(mappedParams.containsKey("parent")){
            parent = mappedParams.parent
        }
        def maxDepth = 3
        if(mappedParams.containsKey("maxDepth")){
            maxDepth = mappedParams.maxDepth
        }
        return __wrappedInstance.dumpControls(parent, maxDepth)
    }
    /**
     * Dumps identification data of the given control and all children to a file
     * 
     * @param filename
     * the name of the file to dump data to
     * @param parent
     * the Control object to dump. Defaults to the desktop, i.e. all applications
     * @param maxDepth
     * the maximal depth of children to dump. Defaults to 3
     * @param charset
     * the charset to use for the dump. Defaults to "UTF-8", other options include "US-ASCII", "ISO-8859-1", and "UTF-16"
     * @throws AutomationException
     * if something goes wrong
     * @throws PatternNotFoundException
     * if the desktop could not be found
     */
    public void dumpControlsToFile(String filename, Object parent=null, int maxDepth=3, String charset="UTF-8"){
        __wrappedInstance.dumpControlsToFile(filename, parent, maxDepth, charset)
    }
    /**
     * Dumps identification data of the given control and all children to a file
     * 
     * @param filename
     * the name of the file to dump data to
     * @param parent
     * the Control object to dump. Defaults to the desktop, i.e. all applications
     * @param maxDepth
     * the maximal depth of children to dump. Defaults to 3
     * @param charset
     * the charset to use for the dump. Defaults to "UTF-8", other options include "US-ASCII", "ISO-8859-1", and "UTF-16"
     * @throws AutomationException
     * if something goes wrong
     * @throws PatternNotFoundException
     * if the desktop could not be found
     */
    public void dumpControlsToFile(Map mappedParams, String filename){
        def parent = null
        if(mappedParams.containsKey("parent")){
            parent = mappedParams.parent
        }
        def maxDepth = 3
        if(mappedParams.containsKey("maxDepth")){
            maxDepth = mappedParams.maxDepth
        }
        def charset = "UTF-8"
        if(mappedParams.containsKey("charset")){
            charset = mappedParams.charset
        }
        __wrappedInstance.dumpControlsToFile(filename, parent, maxDepth, charset)
    }
    /** Returns an array of running applications, as seen by the Cocoa Core framework */
    public Object[] runningApplications(){
        return __wrappedInstance.runningApplications()
    }
    /** Returns the running application with the given process identifier, or null if no application has that pid */
    public Object runningApplicationWithProcessIdentifier(int processIdentifier){
        return __wrappedInstance.runningApplicationWithProcessIdentifier(processIdentifier)
    }
    /** Returns an array of currently running applications with the specified bundle identifier. */
    public Object[] runningApplicationsWithBundleIdentifier(String bundleIdentifier){
        return __wrappedInstance.runningApplicationsWithBundleIdentifier(bundleIdentifier)
    }
    /** Returns an NSRunningApplication representing this application. */
    public Object currentApplication(){
        return __wrappedInstance.currentApplication()
    }
    /**
     * Creates a list of path strings for the specified directories in the specified domains.
     * The list is in the order in which you should search the directories.
     * 
     * @param directory An NSSearchPathDirectory constant
     * @param domainMask AN NSSearchPathDomainMask constant
     * @param expandTilde If expandTilde is true, tildes are expanded
     * 
     * @return a list of directory search paths
     */
    public List<String> getSearchPathForDirectoriesInDomains(int directory, int domainMask, boolean expandTilde){
        return __wrappedInstance.getSearchPathForDirectoriesInDomains(directory, domainMask, expandTilde)
    }
    /**
     * Creates and posts a Quartz keyboard event into the event stream.
     * 
     * @param keyCode The AWT key code for the event.
     * @param modifiers Explicit modifiers like java.awt.Event.CTRL_MASK.
     * @param keyDown Pass true to specify that the key position is down. To specify that the key position is up, pass false. This value is used to determine the type of the keyboard event.
     * @return <code>true</code> if the event could be created, false otherwise.
     */
    public boolean postKeyboardEvent(int keyCode, int modifiers, boolean keyDown){
        return __wrappedInstance.postKeyboardEvent(keyCode, modifiers, keyDown)
    }
    /**
     * Posts a Quartz event into the event stream for a specific application.
     * 
     * @param pid The process ID of an application.
     * @param keyCode The AWT key code for the event.
     * @param modifiers Explicit modifiers like java.awt.Event.CTRL_MASK.
     * @param keyDown Pass true to specify that the key position is down. To specify that the key position is up, pass false. This value is used to determine the type of the keyboard event.
     * @return <code>true</code> if the event could be created, false otherwise.
     * 
     * @since macOs 10.11
     */
    public boolean postKeyboardEventToProcess(int pid, int keyCode, int modifiers, boolean keyDown){
        return __wrappedInstance.postKeyboardEventToProcess(pid, keyCode, modifiers, keyDown)
    }
    /**
     * Converts a given sequence of KeyStrokes into the corresponding characters using the current keyboard layout.
     * 
     * @param keyStrokes the keyStrokes. The keyCode is expected to be a KeyEvent constant
     * @return the string containing the corresponding characters
     */
    public String stringForKeyStrokes(KeyStroke... keyStrokes){
        return __wrappedInstance.stringForKeyStrokes(keyStrokes)
    }
    /**
     * Converts a given input String into sequence of KeyStrokes using the current keyboard layout.
     * 
     * @param input the String to convert to keystrokes
     * @return the keyStrokes required to output the string, using KeyEvent constants for the keyCodes
     */
    public KeyStroke[] keyStrokesForString(String input){
        return __wrappedInstance.keyStrokesForString(input)
    }
    /**
     * Sends appropriate key events to input text to the control currently in focus
     * 
     * @param textToInput the text to input
     * 
     * @since 5.1.1
     */
    public void sendText(String textToInput){
        __wrappedInstance.sendText(textToInput)
    }
    /**
     * Creates and posts a Quartz mouse event into the event stream.
     * 
     * @param mouseType A mouse event type. Pass one of the constants listed in CGEventType.
     * @param mouseCursorPositionX The x position where the event should be posted.
     * @param mouseCursorPositionY The y position where the event should be posted.
     * @param mouseButton The button that's changing state.
     * @param clickState The mouse button click state. A click state of 1 represents a single click. A click state of 2 represents a double-click. A click state of 3 represents a triple-click.
     * @param modifiers Explicit modifiers like java.awt.InputEvent.CTRL_DOWN_MASK.
     * @return <code>true</code> if the event could be created, false otherwise.
     */
    public boolean postMouseEvent(int mouseType, float mouseCursorPositionX, float mouseCursorPositionY, int mouseButton, int clickState, int modifiers){
        return __wrappedInstance.postMouseEvent(mouseType, mouseCursorPositionX, mouseCursorPositionY, mouseButton, clickState, modifiers)
    }
    public Map getVirtualKeyToKeyCode(){
        return __wrappedInstance.virtualKeyToKeyCode
    }
    public Map getKeyCodeToVirtualKey(){
        return __wrappedInstance.keyCodeToVirtualKey
    }
    /**
     * Set to true if axjlib libraries are willingly on the main classpath and should
     * not reported as a warning.
     */
    public void setExpectLibsInClasspath(boolean expectLibsInClasspath){
        __wrappedInstance.expectLibsInClasspath = expectLibsInClasspath
    }
}
