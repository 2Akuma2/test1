package de.qfs
import java.util.List
import de.qfs.apps.qftest.shared.script.modules.helper.Wnd
/** Collection of simple methods for Windows test automation. */
class Autowin{
    //  redirected constants
    static final public int VK_RETURN = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_RETURN
    static final public int VK_ENTER = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_ENTER
    static final public int VK_BACKSPACE = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_BACKSPACE
    static final public int VK_TAB = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_TAB
    static final public int VK_SHIFT = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_SHIFT
    static final public int VK_CONTROL = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_CONTROL
    static final public int VK_CTRL = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_CTRL
    static final public int VK_MENU = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_MENU
    static final public int VK_ALT = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_ALT
    static final public int VK_ESCAPE = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_ESCAPE
    static final public int VK_ESC = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_ESC
    static final public int VK_SPACE = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_SPACE
    static final public int VK_PRIOR = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_PRIOR
    static final public int VK_PGUP = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_PGUP
    static final public int VK_NEXT = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_NEXT
    static final public int VK_PGDOWN = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_PGDOWN
    static final public int VK_END = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_END
    static final public int VK_HOME = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_HOME
    static final public int VK_LEFT = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_LEFT
    static final public int VK_UP = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_UP
    static final public int VK_RIGHT = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_RIGHT
    static final public int VK_DOWN = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_DOWN
    static final public int VK_INSERT = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_INSERT
    static final public int VK_DELETE = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_DELETE
    static final public int VK_WINDOWS = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_WINDOWS
    static final public int VK_F1 = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_F1
    static final public int VK_F2 = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_F2
    static final public int VK_F3 = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_F3
    static final public int VK_F4 = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_F4
    static final public int VK_F5 = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_F5
    static final public int VK_F6 = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_F6
    static final public int VK_F7 = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_F7
    static final public int VK_F8 = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_F8
    static final public int VK_F9 = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_F9
    static final public int VK_F10 = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_F10
    static final public int VK_F11 = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_F11
    static final public int VK_F12 = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_F12
    static final public int VK_F13 = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_F13
    static final public int VK_F14 = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_F14
    static final public int VK_F15 = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_F15
    static final public int VK_F16 = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_F16
    static final public int VK_F17 = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_F17
    static final public int VK_F18 = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_F18
    static final public int VK_F19 = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_F19
    static final public int VK_F20 = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_F20
    static final public int VK_F21 = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_F21
    static final public int VK_F22 = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_F22
    static final public int VK_F23 = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_F23
    static final public int VK_F24 = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_F24
    static final public int VK_0 = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_0
    static final public int VK_1 = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_1
    static final public int VK_2 = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_2
    static final public int VK_3 = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_3
    static final public int VK_4 = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_4
    static final public int VK_5 = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_5
    static final public int VK_6 = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_6
    static final public int VK_7 = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_7
    static final public int VK_8 = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_8
    static final public int VK_9 = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_9
    static final public int VK_A = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_A
    static final public int VK_B = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_B
    static final public int VK_C = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_C
    static final public int VK_D = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_D
    static final public int VK_E = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_E
    static final public int VK_F = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_F
    static final public int VK_G = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_G
    static final public int VK_H = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_H
    static final public int VK_I = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_I
    static final public int VK_J = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_J
    static final public int VK_K = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_K
    static final public int VK_L = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_L
    static final public int VK_M = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_M
    static final public int VK_N = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_N
    static final public int VK_O = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_O
    static final public int VK_P = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_P
    static final public int VK_Q = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_Q
    static final public int VK_R = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_R
    static final public int VK_S = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_S
    static final public int VK_T = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_T
    static final public int VK_U = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_U
    static final public int VK_V = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_V
    static final public int VK_W = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_W
    static final public int VK_X = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_X
    static final public int VK_Y = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_Y
    static final public int VK_Z = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_Z
    static final public int VK_NUMPAD0 = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_NUMPAD0
    static final public int VK_NUMPAD1 = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_NUMPAD1
    static final public int VK_NUMPAD2 = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_NUMPAD2
    static final public int VK_NUMPAD3 = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_NUMPAD3
    static final public int VK_NUMPAD4 = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_NUMPAD4
    static final public int VK_NUMPAD5 = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_NUMPAD5
    static final public int VK_NUMPAD6 = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_NUMPAD6
    static final public int VK_NUMPAD7 = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_NUMPAD7
    static final public int VK_NUMPAD8 = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_NUMPAD8
    static final public int VK_NUMPAD9 = de.qfs.apps.qftest.shared.script.modules.Autowin.VK_NUMPAD9
    static final public int KEYEVENTF_EXTENDEDKEY = de.qfs.apps.qftest.shared.script.modules.Autowin.KEYEVENTF_EXTENDEDKEY
    static final public int KEYEVENTF_KEYUP = de.qfs.apps.qftest.shared.script.modules.Autowin.KEYEVENTF_KEYUP
    static final public int MOUSEEVENTF_MOVE = de.qfs.apps.qftest.shared.script.modules.Autowin.MOUSEEVENTF_MOVE
    static final public int MOUSEEVENTF_LEFTDOWN = de.qfs.apps.qftest.shared.script.modules.Autowin.MOUSEEVENTF_LEFTDOWN
    static final public int MOUSEEVENTF_LEFTUP = de.qfs.apps.qftest.shared.script.modules.Autowin.MOUSEEVENTF_LEFTUP
    static final public int MOUSEEVENTF_RIGHTDOWN = de.qfs.apps.qftest.shared.script.modules.Autowin.MOUSEEVENTF_RIGHTDOWN
    static final public int MOUSEEVENTF_RIGHTUP = de.qfs.apps.qftest.shared.script.modules.Autowin.MOUSEEVENTF_RIGHTUP
    static final public int MOUSEEVENTF_MIDDLEDOWN = de.qfs.apps.qftest.shared.script.modules.Autowin.MOUSEEVENTF_MIDDLEDOWN
    static final public int MOUSEEVENTF_MIDDLEUP = de.qfs.apps.qftest.shared.script.modules.Autowin.MOUSEEVENTF_MIDDLEUP
    static final public int MOUSEEVENTF_WHEEL = de.qfs.apps.qftest.shared.script.modules.Autowin.MOUSEEVENTF_WHEEL
    static final public int MOUSEEVENTF_ABSOLUTE = de.qfs.apps.qftest.shared.script.modules.Autowin.MOUSEEVENTF_ABSOLUTE
    static final public int WHEEL_DELTA = de.qfs.apps.qftest.shared.script.modules.Autowin.WHEEL_DELTA
    static final public int SM_CXSCREEN = de.qfs.apps.qftest.shared.script.modules.Autowin.SM_CXSCREEN
    static final public int SM_CYSCREEN = de.qfs.apps.qftest.shared.script.modules.Autowin.SM_CYSCREEN
    static final public int SC_CLOSE = de.qfs.apps.qftest.shared.script.modules.Autowin.SC_CLOSE
    static final public int SC_MINIMIZE = de.qfs.apps.qftest.shared.script.modules.Autowin.SC_MINIMIZE
    static final public int SC_MAXIMIZE = de.qfs.apps.qftest.shared.script.modules.Autowin.SC_MAXIMIZE
    static final public int SC_RESTORE = de.qfs.apps.qftest.shared.script.modules.Autowin.SC_RESTORE
    static final public int WM_COMMAND = de.qfs.apps.qftest.shared.script.modules.Autowin.WM_COMMAND
    //  redirected methods
    private final de.qfs.apps.qftest.shared.script.modules.Autowin __wrappedInstance
    private static Autowin __instance = new Autowin()
    /** @return the Singleton instance */
    static Autowin instance(){
        return __instance
    }
    /** @return the Singleton instance */
    private Autowin(){
        __wrappedInstance = de.qfs.apps.qftest.shared.script.modules.Autowin.instance()
    }
    /**
     * Get all top-level windows on the screen.
     * 
     * @return A list with the top-level windows.
     */
    public List<Wnd> getAllWindows(){
        return __wrappedInstance.getAllWindows()
    }
    /**
     * Get the text of a window (does work not only for titles).
     * 
     * @param win
     * The window handle.
     * @return The text of the window.
     */
    public String getWindowText(Wnd win){
        return __wrappedInstance.getWindowText(win)
    }
    /**
     * Set the text of a window.
     * 
     * @param win
     * The window handle.
     * @param text
     * The text to set.
     * @return True, if the text is set.
     */
    public boolean setWindowText(Wnd win, String text){
        return __wrappedInstance.setWindowText(win, text)
    }
    /**
     * Get the classname of a window.
     * 
     * @param win
     * The window handle.
     * @return The classname of the window.
     */
    public String getWindowClassName(Wnd win){
        return __wrappedInstance.getWindowClassName(win)
    }
    /**
     * Set the position of a window.
     * 
     * @param win
     * The window handle.
     * @param x
     * The x co-ordinate.
     * @param y
     * The y co-ordinate.
     */
    public void setWindowPosition(Wnd win, long x, long y){
        __wrappedInstance.setWindowPosition(win, x, y)
    }
    /**
     * Set the size of a window.
     * 
     * @param win
     * The window handle.
     * @param width
     * The width.
     * @param height
     * The height.
     */
    public void setWindowSize(Wnd win, long width, long height){
        __wrappedInstance.setWindowSize(win, width, height)
    }
    /**
     * Find a window on the desktop indentified by its title.
     * 
     * @param name
     * The window title
     * @param regexp
     * True if the given title is a regular expression.
     * @return A handle for the window or null if not found.
     * @throws Exception
     */
    public Wnd findWindow(String name, boolean regexp=false){
        return __wrappedInstance.findWindow(name, regexp)
    }
    /**
     * Find a window on the desktop indentified by its title.
     * 
     * @param name
     * The window title
     * @param regexp
     * True if the given title is a regular expression.
     * @return A handle for the window or null if not found.
     * @throws Exception
     */
    public Wnd findWindow(Map mappedParams, String name){
        if(mappedParams == null){
            return __wrappedInstance.findWindow(mappedParams, name)
        }
        def regexp = false
        if(mappedParams.containsKey("regexp")){
            regexp = mappedParams.regexp
        }
        return __wrappedInstance.findWindow(name, regexp)
    }
    /**
     * Wait for a window on the desktop identified by its title.
     * 
     * @param timeout
     * The maximum time to wait (in ms).
     * @param name
     * The window title
     * @param regexp
     * True if the given title is a regular expression.
     * @return A handle for the window or null if the timeout is exceeded.
     * @throws Exception
     */
    public Wnd waitForWindow(long timeout, String name, boolean regexp=false){
        return __wrappedInstance.waitForWindow(timeout, name, regexp)
    }
    /**
     * Wait for a window on the desktop identified by its title.
     * 
     * @param timeout
     * The maximum time to wait (in ms).
     * @param name
     * The window title
     * @param regexp
     * True if the given title is a regular expression.
     * @return A handle for the window or null if the timeout is exceeded.
     * @throws Exception
     */
    public Wnd waitForWindow(Map mappedParams, long timeout, String name){
        if(mappedParams == null){
            return __wrappedInstance.waitForWindow(mappedParams, timeout)
        }
        def regexp = false
        if(mappedParams.containsKey("regexp")){
            regexp = mappedParams.regexp
        }
        return __wrappedInstance.waitForWindow(timeout, name, regexp)
    }
    /**
     * Find a dialog on the desktop with the given parent.
     * 
     * @param parent
     * The parent window.
     * @param titleRe
     * An optional regexp for the window title.
     * @return A handle for the dialog or null if the timeout is exceeded.
     * @throws Exception
     */
    public Wnd findDialog(Wnd parent, String titleRe=null){
        return __wrappedInstance.findDialog(parent, titleRe)
    }
    /**
     * Find a dialog on the desktop with the given parent.
     * 
     * @param parent
     * The parent window.
     * @param titleRe
     * An optional regexp for the window title.
     * @return A handle for the dialog or null if the timeout is exceeded.
     * @throws Exception
     */
    public Wnd findDialog(Map mappedParams, Wnd parent){
        if(mappedParams == null){
            return __wrappedInstance.findDialog(mappedParams, parent)
        }
        def titleRe = null
        if(mappedParams.containsKey("titleRe")){
            titleRe = mappedParams.titleRe
        }
        return __wrappedInstance.findDialog(parent, titleRe)
    }
    /**
     * Wait for a dialog on the desktop with the given parent.
     * 
     * @param timeout
     * The maximum time to wait (in ms).
     * 
     * @param parent
     * The parent window.
     * 
     * @param titleRe
     * An optional regexp for the window title.
     * 
     * @return A handle for the dialog or null if the timeout is exceeded.
     * @throws Exception
     */
    public Wnd waitForDialog(long timeout, Wnd parent, String titleRe=null){
        return __wrappedInstance.waitForDialog(timeout, parent, titleRe)
    }
    /**
     * Wait for a dialog on the desktop with the given parent.
     * 
     * @param timeout
     * The maximum time to wait (in ms).
     * 
     * @param parent
     * The parent window.
     * 
     * @param titleRe
     * An optional regexp for the window title.
     * 
     * @return A handle for the dialog or null if the timeout is exceeded.
     * @throws Exception
     */
    public Wnd waitForDialog(Map mappedParams, long timeout, Wnd parent){
        if(mappedParams == null){
            return __wrappedInstance.waitForDialog(mappedParams, timeout)
        }
        def titleRe = null
        if(mappedParams.containsKey("titleRe")){
            titleRe = mappedParams.titleRe
        }
        return __wrappedInstance.waitForDialog(timeout, parent, titleRe)
    }
    /**
     * Find a child window of a given window, indentified by some text.
     * 
     * @param parent
     * A handle for the parent window.
     * @param name
     * The identifying text.
     * @param regexp
     * True if the given text is a regular expression.
     * @return A handle for the child window or null if not found.
     * @throws Exception
     */
    public Wnd findChildWindow(Wnd parent, String name, boolean regexp=false){
        return __wrappedInstance.findChildWindow(parent, name, regexp)
    }
    /**
     * Find a child window of a given window, indentified by some text.
     * 
     * @param parent
     * A handle for the parent window.
     * @param name
     * The identifying text.
     * @param regexp
     * True if the given text is a regular expression.
     * @return A handle for the child window or null if not found.
     * @throws Exception
     */
    public Wnd findChildWindow(Map mappedParams, Wnd parent, String name){
        if(mappedParams == null){
            return __wrappedInstance.findChildWindow(mappedParams, parent)
        }
        def regexp = false
        if(mappedParams.containsKey("regexp")){
            regexp = mappedParams.regexp
        }
        return __wrappedInstance.findChildWindow(parent, name, regexp)
    }
    /**
     * Find child windows of a given window, identified by text and class name.
     * 
     * @param parent
     * A handle for the parent window.
     * @param name
     * The identifying text.
     * @param regexp
     * True if the given text is a regular expression.
     * @param clazz
     * The name of the child window's class.
     * @return A list of child window handles.
     */
    public List<Wnd> findChildWindows(Wnd parent, String name=null, boolean regexp=false, String clazz=null){
        return __wrappedInstance.findChildWindows(parent, name, regexp, clazz)
    }
    /**
     * Find child windows of a given window, identified by text and class name.
     * 
     * @param parent
     * A handle for the parent window.
     * @param name
     * The identifying text.
     * @param regexp
     * True if the given text is a regular expression.
     * @param clazz
     * The name of the child window's class.
     * @return A list of child window handles.
     */
    public List<Wnd> findChildWindows(Map mappedParams, Wnd parent){
        def name = null
        if(mappedParams.containsKey("name")){
            name = mappedParams.name
        }
        def regexp = false
        if(mappedParams.containsKey("regexp")){
            regexp = mappedParams.regexp
        }
        def clazz = null
        if(mappedParams.containsKey("clazz")){
            clazz = mappedParams.clazz
        }
        return __wrappedInstance.findChildWindows(parent, name, regexp, clazz)
    }
    /**
     * Wait for a child window of a given window, indentified by some text.
     * 
     * @param timeout
     * The maximum time to wait (in ms).
     * @param parent
     * A handle for the parent window.
     * @param name
     * The identifying text.
     * @param regexp
     * True if the given text is a regular expression.
     * @return A handle for the child window or null if not found.
     * @throws Exception
     */
    public Wnd waitForChildWindow(long timeout, Wnd parent, String name, boolean regexp=false){
        return __wrappedInstance.waitForChildWindow(timeout, parent, name, regexp)
    }
    /**
     * Wait for a child window of a given window, indentified by some text.
     * 
     * @param timeout
     * The maximum time to wait (in ms).
     * @param parent
     * A handle for the parent window.
     * @param name
     * The identifying text.
     * @param regexp
     * True if the given text is a regular expression.
     * @return A handle for the child window or null if not found.
     * @throws Exception
     */
    public Wnd waitForChildWindow(Map mappedParams, long timeout, Wnd parent, String name){
        if(mappedParams == null){
            return __wrappedInstance.waitForChildWindow(mappedParams, timeout)
        }
        def regexp = false
        if(mappedParams.containsKey("regexp")){
            regexp = mappedParams.regexp
        }
        return __wrappedInstance.waitForChildWindow(timeout, parent, name, regexp)
    }
    /**
     * Find a child window of a given window, indentified by the window's class name
     * 
     * @param parent
     * A handle for the parent window.
     * @param classname
     * The identifying classname.
     * @param regexp
     * True if the given classname is a regular expression.
     * @return A handle for the child window or null if not found.
     * @throws Exception
     */
    public Wnd findChildWindowByClassName(Wnd parent, String classname, boolean regexp=false){
        return __wrappedInstance.findChildWindowByClassName(parent, classname, regexp)
    }
    /**
     * Find a child window of a given window, indentified by the window's class name
     * 
     * @param parent
     * A handle for the parent window.
     * @param classname
     * The identifying classname.
     * @param regexp
     * True if the given classname is a regular expression.
     * @return A handle for the child window or null if not found.
     * @throws Exception
     */
    public Wnd findChildWindowByClassName(Map mappedParams, Wnd parent, String classname){
        if(mappedParams == null){
            return __wrappedInstance.findChildWindowByClassName(mappedParams, parent)
        }
        def regexp = false
        if(mappedParams.containsKey("regexp")){
            regexp = mappedParams.regexp
        }
        return __wrappedInstance.findChildWindowByClassName(parent, classname, regexp)
    }
    /** Synthesize a mouse event at the given coordinates. */
    public void mouse_event(long flags, long dx, long dy, long dwData=0){
        __wrappedInstance.mouse_event(flags, dx, dy, dwData)
    }
    /** Synthesize a mouse event at the given coordinates. */
    public void mouse_event(Map mappedParams, long flags, long dx, long dy){
        if(mappedParams == null){
            __wrappedInstance.mouse_event(mappedParams, flags)
        }
        def dwData = 0
        if(mappedParams.containsKey("dwData")){
            dwData = mappedParams.dwData
        }
        __wrappedInstance.mouse_event(flags, dx, dy, dwData)
    }
    /**
     * Synthesize a key event.
     * 
     * @param code
     * The virtual key code.
     * @param flags
     * KEYEVENTF flags.
     */
    public void keybd_event(long code, long flags){
        __wrappedInstance.keybd_event(code, flags)
    }
    /** Synthesize a mouse click at the given screen position. */
    public void doClickHard(long x, long y, boolean right=false){
        __wrappedInstance.doClickHard(x, y, right)
    }
    /** Synthesize a mouse click at the given screen position. */
    public void doClickHard(Map mappedParams, long x, long y){
        if(mappedParams == null){
            __wrappedInstance.doClickHard(mappedParams, x)
        }
        def right = false
        if(mappedParams.containsKey("right")){
            right = mappedParams.right
        }
        __wrappedInstance.doClickHard(x, y, right)
    }
    /**
     * Simulate a mouse click on a window.
     * 
     * @param win
     * A handle for the window.
     * @param x
     * Target X coordinate.
     * @param y
     * Target Y coordinate.
     */
    public void doClick(Wnd win, long x, long y){
        __wrappedInstance.doClick(win, x, y)
    }
    /**
     * Close a window by sending it the WM_CLOSE message.
     * 
     * @param win
     * A handle for the window.
     */
    public void closeWindow(Wnd win, boolean async=false){
        __wrappedInstance.closeWindow(win, async)
    }
    /**
     * Close a window by sending it the WM_CLOSE message.
     * 
     * @param win
     * A handle for the window.
     */
    public void closeWindow(Map mappedParams, Wnd win){
        if(mappedParams == null){
            __wrappedInstance.closeWindow(mappedParams, win)
        }
        def async = false
        if(mappedParams.containsKey("async")){
            async = mappedParams.async
        }
        __wrappedInstance.closeWindow(win, async)
    }
    /**
     * Maximize a window.
     * 
     * @param win
     * A handle for the window.
     */
    public void maximizeWindow(Wnd win){
        __wrappedInstance.maximizeWindow(win)
    }
    /**
     * Minimize a window.
     * 
     * @param win
     * A handle for the window.
     */
    public void minimizeWindow(Wnd win){
        __wrappedInstance.minimizeWindow(win)
    }
    /**
     * Restore a window.
     * 
     * @param win
     * A handle for the window.
     */
    public void restoreWindow(Wnd win){
        __wrappedInstance.restoreWindow(win)
    }
    /**
     * Puts a window to the foreground
     * 
     * @param win
     * A handle for the window.
     */
    public void setForeground(Wnd win){
        __wrappedInstance.setForeground(win)
    }
    /**
     * Simulate a key press on a window.
     * 
     * @param win
     * A handle for the window.
     * @param keycode
     * The keycode for the key.
     */
    public void typeKey(Wnd win, long keycode){
        __wrappedInstance.typeKey(win, keycode)
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
}
