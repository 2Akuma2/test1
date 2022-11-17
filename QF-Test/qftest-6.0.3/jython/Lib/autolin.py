from de.qfs.apps.qftest.shared.script.modules import Autolin as _WrappedAutolin
#  redirected constants
#  redirected methods
__wrappedInstance = _WrappedAutolin.instance()
def getWindowText(win):
    """
    Get the text of a window.
    
    @param win
    The window handle.
    @return The text of the window.
    """
    return __wrappedInstance.getWindowText(win)

def getAllWindows():
    """
    Get all open windows.
    
    @return An array with the window handles.
    """
    return __wrappedInstance.getAllWindows()

def closeWindow(win):
    """
    Close a window.
    
    @param win
    A handle for the window.
    """
    __wrappedInstance.closeWindow(win)

def setForeground(win):
    """
    Bring a window into the foreground.
    
    @param win
    A handle for the window.
    """
    __wrappedInstance.setForeground(win)

def getParent(win):
    """
    Get the parent's handle.
    
    @param win
    A handle for the window.
    @return The Parent.
    """
    return __wrappedInstance.getParent(win)

def findWindow(name, regexp=False):
    """
    Find a window on the desktop identified by its title.
    
    @param name
    The window title
    @param regext
    True if the given title is a regular expression.
    @return A handle for the window or 0 if not found.
    @throws Exception
    """
    if regexp:
        regexp = True
    
    else:
        regexp = False
    
    return __wrappedInstance.findWindow(name, regexp)

def waitForWindow(timeout, name, regexp=False):
    """
    Find for a window on the desktop identified by its title.
    
    @param timeout
    The maximum time to wait (in ms).
    @param name
    The window title
    @param regext
    True if the given title is a regular expression.
    @return A handle for the window or 0 if the timeout is exceeded.
    """
    if regexp:
        regexp = True
    
    else:
        regexp = False
    
    return __wrappedInstance.waitForWindow(timeout, name, regexp)

def sendText(textToInput):
    """
    Sends appropriate key events to input text to the control currently in focus
    
    @param textToInput the text to input
    
    @since 5.1.1
    """
    __wrappedInstance.sendText(textToInput)

