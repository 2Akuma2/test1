package de.qfs
import de.qfs.apps.qftest.shared.extensions.image.ImageRep
/** A QF-Test ImageWrapper object. */
class ImageWrapper{
    //  redirected constants
    //  redirected methods
    private final de.qfs.apps.qftest.shared.script.modules.ImageWrapper __wrappedInstance
    /**
     * Constructor.
     * 
     * @param rc
     * The current Run context object.
     */
    public ImageWrapper(Object rc){
        __wrappedInstance = de.qfs.apps.qftest.shared.script.modules.ImageWrapper.instance(rc)
    }
    /**
     * Take screenshot of the whole screen. If you use the parameters x, y,
     * width and height, you can take a screenshot of a specific region of the
     * screen.
     * 
     * @param x
     * The x co-ordinate of the left upper corner of the sub-region.
     * @param y
     * The y co-ordinate of the left upper corner of the sub-region.
     * @param width
     * The width the sub-region.
     * @param height
     * The height height of the sub-region.
     * @return The ImageRep object of the actual screenshot.
     */
    public ImageRep grabScreenshot(Integer x=null, Integer y=null, Integer width=null, Integer height=null){
        return __wrappedInstance.grabScreenshot(x, y, width, height)
    }
    /**
     * Take screenshot of the whole screen. If you use the parameters x, y,
     * width and height, you can take a screenshot of a specific region of the
     * screen.
     * 
     * @param x
     * The x co-ordinate of the left upper corner of the sub-region.
     * @param y
     * The y co-ordinate of the left upper corner of the sub-region.
     * @param width
     * The width the sub-region.
     * @param height
     * The height height of the sub-region.
     * @return The ImageRep object of the actual screenshot.
     */
    public ImageRep grabScreenshot(Map mappedParams){
        def x = null
        if(mappedParams.containsKey("x")){
            x = mappedParams.x
        }
        def y = null
        if(mappedParams.containsKey("y")){
            y = mappedParams.y
        }
        def width = null
        if(mappedParams.containsKey("width")){
            width = mappedParams.width
        }
        def height = null
        if(mappedParams.containsKey("height")){
            height = mappedParams.height
        }
        return __wrappedInstance.grabScreenshot(x, y, width, height)
    }
    /**
     * Take screenshot of a given component. If you use the parameters x, y,
     * width and height, you can take a screenshot of a specific region of the
     * component.
     * 
     * @param com
     * The component.
     * @param x
     * The x co-ordinate of the left upper corner of the sub-region.
     * @param y
     * The y co-ordinate of the left upper corner of the sub-region.
     * @param width
     * The width the sub-region.
     * @param height
     * The height height of the sub-region.
     * @return The ImageRep object of the actual screenshot.
     */
    public ImageRep grabImage(Object com, Integer x=null, Integer y=null, Integer width=null, Integer height=null){
        return __wrappedInstance.grabImage(com, x, y, width, height)
    }
    /**
     * Take screenshot of a given component. If you use the parameters x, y,
     * width and height, you can take a screenshot of a specific region of the
     * component.
     * 
     * @param com
     * The component.
     * @param x
     * The x co-ordinate of the left upper corner of the sub-region.
     * @param y
     * The y co-ordinate of the left upper corner of the sub-region.
     * @param width
     * The width the sub-region.
     * @param height
     * The height height of the sub-region.
     * @return The ImageRep object of the actual screenshot.
     */
    public ImageRep grabImage(Map mappedParams, Object com){
        def x = null
        if(mappedParams.containsKey("x")){
            x = mappedParams.x
        }
        def y = null
        if(mappedParams.containsKey("y")){
            y = mappedParams.y
        }
        def width = null
        if(mappedParams.containsKey("width")){
            width = mappedParams.width
        }
        def height = null
        if(mappedParams.containsKey("height")){
            height = mappedParams.height
        }
        return __wrappedInstance.grabImage(com, x, y, width, height)
    }
    /**
     * Take a single screenshot of all available screens.
     * 
     * @return An ImageRep object with a screenshot of all available screens.
     */
    public ImageRep grabScreenshotOfAllScreens(){
        return __wrappedInstance.grabScreenshotOfAllScreens()
    }
    /**
     * Take screenshots of all available screens.
     * 
     * @param monitor
     * Index of the monitor to take the screenshot from.
     * @return An array of ImageRep objects of all screenshots or the specific
     * ImageRep object, if the monitor parameter has been used.
     */
    public Object grabScreenshots(Integer monitor=null){
        return __wrappedInstance.grabScreenshots(monitor)
    }
    /**
     * Take screenshots of all available screens.
     * 
     * @param monitor
     * Index of the monitor to take the screenshot from.
     * @return An array of ImageRep objects of all screenshots or the specific
     * ImageRep object, if the monitor parameter has been used.
     */
    public Object grabScreenshots(Map mappedParams){
        if(mappedParams == null){
            return __wrappedInstance.grabScreenshots(mappedParams, monitor)
        }
        def monitor = null
        if(mappedParams.containsKey("monitor")){
            monitor = mappedParams.monitor
        }
        return __wrappedInstance.grabScreenshots(monitor)
    }
    /**
     * Return the total number of monitors.
     * 
     * @Returns The total numer of monitors.
     */
    public int getMonitorCount(){
        return __wrappedInstance.getMonitorCount()
    }
    /**
     * Save a given ImageRep object to a given file. The file will be in PNG
     * format.
     * 
     * @param filename
     * The name of the file to save the image.
     * @param image
     * The image to save.
     */
    public void savePng(String filename, ImageRep image){
        __wrappedInstance.savePng(filename, image)
    }
    /**
     * Load an ImageRep object of a given file.
     * 
     * @param filename
     * The file to load the image. The file must be in PNG format.
     * @return The loaded ImageRep object.
     */
    public ImageRep loadPng(String filename){
        return __wrappedInstance.loadPng(filename)
    }
    /**
     * Check whether a given component is really visible on all connected
     * monitors.
     * 
     * @param com
     * The component.
     * @return True, if component is visible.
     */
    public boolean isComponentShownOnVisibleMonitors(Object com){
        return __wrappedInstance.isComponentShownOnVisibleMonitors(com)
    }
}
