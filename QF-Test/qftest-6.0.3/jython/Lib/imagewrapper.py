from de.qfs.apps.qftest.shared.script.modules import ImageWrapper as _WrappedImageWrapper
class ImageWrapper(object):
    """ A QF-Test ImageWrapper object."""
    #  redirected constants
    #  redirected methods
    def __init__(self, rc):
        """
        Constructor.
        
        @param rc
        The current Run context object.
        """
        self.__wrappedInstance = _WrappedImageWrapper.instance(rc)
    
    def grabScreenshot(self, x=None, y=None, width=None, height=None):
        """
        Take screenshot of the whole screen. If you use the parameters x, y,
        width and height, you can take a screenshot of a specific region of the
        screen.
        
        @param x
        The x co-ordinate of the left upper corner of the sub-region.
        @param y
        The y co-ordinate of the left upper corner of the sub-region.
        @param width
        The width the sub-region.
        @param height
        The height height of the sub-region.
        @return The ImageRep object of the actual screenshot.
        """
        return self.__wrappedInstance.grabScreenshot(x, y, width, height)
    
    def grabImage(self, com, x=None, y=None, width=None, height=None):
        """
        Take screenshot of a given component. If you use the parameters x, y,
        width and height, you can take a screenshot of a specific region of the
        component.
        
        @param com
        The component.
        @param x
        The x co-ordinate of the left upper corner of the sub-region.
        @param y
        The y co-ordinate of the left upper corner of the sub-region.
        @param width
        The width the sub-region.
        @param height
        The height height of the sub-region.
        @return The ImageRep object of the actual screenshot.
        """
        return self.__wrappedInstance.grabImage(com, x, y, width, height)
    
    def grabScreenshotOfAllScreens(self):
        """
        Take a single screenshot of all available screens.
        
        @return An ImageRep object with a screenshot of all available screens.
        """
        return self.__wrappedInstance.grabScreenshotOfAllScreens()
    
    def grabScreenshots(self, monitor=None):
        """
        Take screenshots of all available screens.
        
        @param monitor
        Index of the monitor to take the screenshot from.
        @return An array of ImageRep objects of all screenshots or the specific
        ImageRep object, if the monitor parameter has been used.
        """
        return self.__wrappedInstance.grabScreenshots(monitor)
    
    def getMonitorCount(self):
        """
        Return the total number of monitors.
        
        @Returns The total numer of monitors.
        """
        return self.__wrappedInstance.getMonitorCount()
    
    def savePng(self, filename, image):
        """
        Save a given ImageRep object to a given file. The file will be in PNG
        format.
        
        @param filename
        The name of the file to save the image.
        @param image
        The image to save.
        """
        self.__wrappedInstance.savePng(filename, image)
    
    def loadPng(self, filename):
        """
        Load an ImageRep object of a given file.
        
        @param filename
        The file to load the image. The file must be in PNG format.
        @return The loaded ImageRep object.
        """
        return self.__wrappedInstance.loadPng(filename)
    
    def isComponentShownOnVisibleMonitors(self, com):
        """
        Check whether a given component is really visible on all connected
        monitors.
        
        @param com
        The component.
        @return True, if component is visible.
        """
        return self.__wrappedInstance.isComponentShownOnVisibleMonitors(com)
    

