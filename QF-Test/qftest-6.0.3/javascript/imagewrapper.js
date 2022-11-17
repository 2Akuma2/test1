exports.__esModule = true;
var module$input = exports;
ImageWrapper = function() {
  _WrappedImageWrapper = Java.type("de.qfs.apps.qftest.shared.script.modules.ImageWrapper");
  var __wrappedInstance;
  function ImageWrapper(rc) {
    __wrappedInstance = _WrappedImageWrapper.instance(rc);
  }
  ImageWrapper.prototype.grabScreenshot = parameterfy(function(x, y, width, height) {
    if (x === undefined) {
      x = null;
    }
    if (y === undefined) {
      y = null;
    }
    if (width === undefined) {
      width = null;
    }
    if (height === undefined) {
      height = null;
    }
    return __wrappedInstance.grabScreenshot(x, y, width, height);
  });
  ImageWrapper.prototype.grabImage = parameterfy(function(com, x, y, width, height) {
    if (x === undefined) {
      x = null;
    }
    if (y === undefined) {
      y = null;
    }
    if (width === undefined) {
      width = null;
    }
    if (height === undefined) {
      height = null;
    }
    return __wrappedInstance.grabImage(com, x, y, width, height);
  });
  ImageWrapper.prototype.grabScreenshotOfAllScreens = parameterfy(function() {
    return __wrappedInstance.grabScreenshotOfAllScreens();
  });
  ImageWrapper.prototype.grabScreenshots = parameterfy(function(monitor) {
    if (monitor === undefined) {
      monitor = null;
    }
    return __wrappedInstance.grabScreenshots(monitor);
  });
  ImageWrapper.prototype.getMonitorCount = parameterfy(function() {
    return __wrappedInstance.getMonitorCount();
  });
  ImageWrapper.prototype.savePng = parameterfy(function(filename, image) {
    __wrappedInstance.savePng(filename, image);
  });
  ImageWrapper.prototype.loadPng = parameterfy(function(filename) {
    return __wrappedInstance.loadPng(filename);
  });
  ImageWrapper.prototype.isComponentShownOnVisibleMonitors = parameterfy(function(com) {
    return __wrappedInstance.isComponentShownOnVisibleMonitors(com);
  });
  return ImageWrapper;
}();
var $jscompDefaultExport = ImageWrapper;
module$input.ImageWrapper = ImageWrapper;
module$input["default"] = $jscompDefaultExport;
