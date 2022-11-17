package de.qfs
/** Collection of simple methods for Linux test automation. */
class Autolin{
    //  redirected constants
    //  redirected methods
    private final de.qfs.apps.qftest.shared.script.modules.Autolin __wrappedInstance
    private static Autolin __instance = new Autolin()
    static Autolin instance(){
        return __instance
    }
    private Autolin(){
        __wrappedInstance = de.qfs.apps.qftest.shared.script.modules.Autolin.instance()
    }
    /**
     * Get the text of a window.
     * 
     * @param win
     * The window handle.
     * @return The text of the window.
     */
    public String getWindowText(int win){
        return __wrappedInstance.getWindowText(win)
    }
    /**
     * Get all open windows.
     * 
     * @return An array with the window handles.
     */
    public int[] getAllWindows(){
        return __wrappedInstance.getAllWindows()
    }
    /**
     * Close a window.
     * 
     * @param win
     * A handle for the window.
     */
    public void closeWindow(int win){
        __wrappedInstance.closeWindow(win)
    }
    /**
     * Bring a window into the foreground.
     * 
     * @param win
     * A handle for the window.
     */
    public void setForeground(int win){
        __wrappedInstance.setForeground(win)
    }
    /**
     * Get the parent's handle.
     * 
     * @param win
     * A handle for the window.
     * @return The Parent.
     */
    public int getParent(int win){
        return __wrappedInstance.getParent(win)
    }
    /**
     * Find a window on the desktop identified by its title.
     * 
     * @param name
     * The window title
     * @param regext
     * True if the given title is a regular expression.
     * @return A handle for the window or 0 if not found.
     * @throws Exception
     */
    public int findWindow(String name, boolean regexp=false){
        return __wrappedInstance.findWindow(name, regexp)
    }
    /**
     * Find a window on the desktop identified by its title.
     * 
     * @param name
     * The window title
     * @param regext
     * True if the given title is a regular expression.
     * @return A handle for the window or 0 if not found.
     * @throws Exception
     */
    public int findWindow(Map mappedParams, String name){
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
     * Find for a window on the desktop identified by its title.
     * 
     * @param timeout
     * The maximum time to wait (in ms).
     * @param name
     * The window title
     * @param regext
     * True if the given title is a regular expression.
     * @return A handle for the window or 0 if the timeout is exceeded.
     */
    public int waitForWindow(long timeout, String name, boolean regexp=false){
        return __wrappedInstance.waitForWindow(timeout, name, regexp)
    }
    /**
     * Find for a window on the desktop identified by its title.
     * 
     * @param timeout
     * The maximum time to wait (in ms).
     * @param name
     * The window title
     * @param regext
     * True if the given title is a regular expression.
     * @return A handle for the window or 0 if the timeout is exceeded.
     */
    public int waitForWindow(Map mappedParams, long timeout, String name){
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
