exports.__esModule = true;
var module$input = exports;
Automac = function() {
  _WrappedAutomac = Java.type("de.qfs.apps.qftest.shared.script.modules.Automac");
  Automac.NSApplicationDirectory = Automac.prototype.NSApplicationDirectory = _WrappedAutomac.NSApplicationDirectory;
  Automac.NSDemoApplicationDirectory = Automac.prototype.NSDemoApplicationDirectory = _WrappedAutomac.NSDemoApplicationDirectory;
  Automac.NSDeveloperApplicationDirectory = Automac.prototype.NSDeveloperApplicationDirectory = _WrappedAutomac.NSDeveloperApplicationDirectory;
  Automac.NSAdminApplicationDirectory = Automac.prototype.NSAdminApplicationDirectory = _WrappedAutomac.NSAdminApplicationDirectory;
  Automac.NSLibraryDirectory = Automac.prototype.NSLibraryDirectory = _WrappedAutomac.NSLibraryDirectory;
  Automac.NSDeveloperDirectory = Automac.prototype.NSDeveloperDirectory = _WrappedAutomac.NSDeveloperDirectory;
  Automac.NSUserDirectory = Automac.prototype.NSUserDirectory = _WrappedAutomac.NSUserDirectory;
  Automac.NSDocumentationDirectory = Automac.prototype.NSDocumentationDirectory = _WrappedAutomac.NSDocumentationDirectory;
  Automac.NSDocumentDirectory = Automac.prototype.NSDocumentDirectory = _WrappedAutomac.NSDocumentDirectory;
  Automac.NSCoreServiceDirectory = Automac.prototype.NSCoreServiceDirectory = _WrappedAutomac.NSCoreServiceDirectory;
  Automac.NSAutosavedInformationDirectory = Automac.prototype.NSAutosavedInformationDirectory = _WrappedAutomac.NSAutosavedInformationDirectory;
  Automac.NSDesktopDirectory = Automac.prototype.NSDesktopDirectory = _WrappedAutomac.NSDesktopDirectory;
  Automac.NSCachesDirectory = Automac.prototype.NSCachesDirectory = _WrappedAutomac.NSCachesDirectory;
  Automac.NSApplicationSupportDirectory = Automac.prototype.NSApplicationSupportDirectory = _WrappedAutomac.NSApplicationSupportDirectory;
  Automac.NSDownloadsDirectory = Automac.prototype.NSDownloadsDirectory = _WrappedAutomac.NSDownloadsDirectory;
  Automac.NSInputMethodsDirectory = Automac.prototype.NSInputMethodsDirectory = _WrappedAutomac.NSInputMethodsDirectory;
  Automac.NSMoviesDirectory = Automac.prototype.NSMoviesDirectory = _WrappedAutomac.NSMoviesDirectory;
  Automac.NSMusicDirectory = Automac.prototype.NSMusicDirectory = _WrappedAutomac.NSMusicDirectory;
  Automac.NSPicturesDirectory = Automac.prototype.NSPicturesDirectory = _WrappedAutomac.NSPicturesDirectory;
  Automac.NSPrinterDescriptionDirectory = Automac.prototype.NSPrinterDescriptionDirectory = _WrappedAutomac.NSPrinterDescriptionDirectory;
  Automac.NSSharedPublicDirectory = Automac.prototype.NSSharedPublicDirectory = _WrappedAutomac.NSSharedPublicDirectory;
  Automac.NSPreferencePanesDirectory = Automac.prototype.NSPreferencePanesDirectory = _WrappedAutomac.NSPreferencePanesDirectory;
  Automac.NSApplicationScriptsDirectory = Automac.prototype.NSApplicationScriptsDirectory = _WrappedAutomac.NSApplicationScriptsDirectory;
  Automac.NSItemReplacementDirectory = Automac.prototype.NSItemReplacementDirectory = _WrappedAutomac.NSItemReplacementDirectory;
  Automac.NSAllApplicationsDirectory = Automac.prototype.NSAllApplicationsDirectory = _WrappedAutomac.NSAllApplicationsDirectory;
  Automac.NSAllLibrariesDirectory = Automac.prototype.NSAllLibrariesDirectory = _WrappedAutomac.NSAllLibrariesDirectory;
  Automac.NSTrashDirectory = Automac.prototype.NSTrashDirectory = _WrappedAutomac.NSTrashDirectory;
  Automac.NSUserDomainMask = Automac.prototype.NSUserDomainMask = _WrappedAutomac.NSUserDomainMask;
  Automac.NSLocalDomainMask = Automac.prototype.NSLocalDomainMask = _WrappedAutomac.NSLocalDomainMask;
  Automac.NSNetworkDomainMask = Automac.prototype.NSNetworkDomainMask = _WrappedAutomac.NSNetworkDomainMask;
  Automac.NSSystemDomainMask = Automac.prototype.NSSystemDomainMask = _WrappedAutomac.NSSystemDomainMask;
  Automac.NSAllDomainsMask = Automac.prototype.NSAllDomainsMask = _WrappedAutomac.NSAllDomainsMask;
  Automac.kCGEventLeftMouseDown = Automac.prototype.kCGEventLeftMouseDown = _WrappedAutomac.kCGEventLeftMouseDown;
  Automac.kCGEventLeftMouseUp = Automac.prototype.kCGEventLeftMouseUp = _WrappedAutomac.kCGEventLeftMouseUp;
  Automac.kCGEventRightMouseDown = Automac.prototype.kCGEventRightMouseDown = _WrappedAutomac.kCGEventRightMouseDown;
  Automac.kCGEventRightMouseUp = Automac.prototype.kCGEventRightMouseUp = _WrappedAutomac.kCGEventRightMouseUp;
  Automac.kCGEventMouseMoved = Automac.prototype.kCGEventMouseMoved = _WrappedAutomac.kCGEventMouseMoved;
  Automac.kCGEventLeftMouseDragged = Automac.prototype.kCGEventLeftMouseDragged = _WrappedAutomac.kCGEventLeftMouseDragged;
  Automac.kCGEventRightMouseDragged = Automac.prototype.kCGEventRightMouseDragged = _WrappedAutomac.kCGEventRightMouseDragged;
  Automac.kCGEventOtherMouseDown = Automac.prototype.kCGEventOtherMouseDown = _WrappedAutomac.kCGEventOtherMouseDown;
  Automac.kCGEventOtherMouseUp = Automac.prototype.kCGEventOtherMouseUp = _WrappedAutomac.kCGEventOtherMouseUp;
  Automac.kCGEventOtherMouseDragged = Automac.prototype.kCGEventOtherMouseDragged = _WrappedAutomac.kCGEventOtherMouseDragged;
  var __wrappedInstance;
  function Automac() {
    __wrappedInstance = _WrappedAutomac.instance();
  }
  Automac.prototype.isProcessTrusted = parameterfy(function(informUser) {
    return __wrappedInstance.isProcessTrusted(informUser);
  });
  Automac.prototype.elementAtPosition = parameterfy(function(x, y) {
    return __wrappedInstance.elementAtPosition(x, y);
  });
  Automac.prototype.getApplicationAccessibilityObject = parameterfy(function(pid) {
    return __wrappedInstance.getApplicationAccessibilityObject(pid);
  });
  Automac.prototype.getSystemWideAccessibilityObject = parameterfy(function() {
    return __wrappedInstance.getSystemWideAccessibilityObject();
  });
  Automac.prototype.setGlobalMessagingTimeout = parameterfy(function(timeoutInMs) {
    __wrappedInstance.setGlobalMessagingTimeout(timeoutInMs);
  });
  Automac.prototype.getWindowText = parameterfy(function(window) {
    return __wrappedInstance.getWindowText(window);
  });
  Automac.prototype.setWindowPosition = parameterfy(function(window, x, y) {
    __wrappedInstance.setWindowPosition(window, x, y);
  });
  Automac.prototype.setWindowSize = parameterfy(function(window, width, height) {
    __wrappedInstance.setWindowSize(window, width, height);
  });
  Automac.prototype.findWindow = parameterfy(function(nameOrPattern, regexp) {
    if (regexp === undefined) {
      regexp = false;
    }
    return __wrappedInstance.findWindow(nameOrPattern, regexp);
  });
  Automac.prototype.waitForWindow = parameterfy(function(timeout, nameOrPattern) {
    return __wrappedInstance.waitForWindow(timeout, nameOrPattern);
  });
  Automac.prototype.closeWindow = parameterfy(function(window) {
    __wrappedInstance.closeWindow(window);
  });
  Automac.prototype.maximizeWindow = parameterfy(function(window) {
    __wrappedInstance.maximizeWindow(window);
  });
  Automac.prototype.fullScreenWindow = parameterfy(function(window) {
    __wrappedInstance.fullScreenWindow(window);
  });
  Automac.prototype.minimizeWindow = parameterfy(function(window) {
    __wrappedInstance.minimizeWindow(window);
  });
  Automac.prototype.restoreWindow = parameterfy(function(window) {
    __wrappedInstance.restoreWindow(window);
  });
  Automac.prototype.setForeground = parameterfy(function(window) {
    __wrappedInstance.setForeground(window);
  });
  Automac.prototype.dumpControls = parameterfy(function(parent, maxDepth) {
    if (parent === undefined) {
      parent = null;
    }
    if (maxDepth === undefined) {
      maxDepth = 3;
    }
    return __wrappedInstance.dumpControls(parent, maxDepth);
  });
  Automac.prototype.dumpControlsToFile = parameterfy(function(filename, parent, maxDepth, charset) {
    if (parent === undefined) {
      parent = null;
    }
    if (maxDepth === undefined) {
      maxDepth = 3;
    }
    if (charset === undefined) {
      charset = "UTF-8";
    }
    __wrappedInstance.dumpControlsToFile(filename, parent, maxDepth, charset);
  });
  Automac.prototype.runningApplications = parameterfy(function() {
    return __wrappedInstance.runningApplications();
  });
  Automac.prototype.runningApplicationWithProcessIdentifier = parameterfy(function(processIdentifier) {
    return __wrappedInstance.runningApplicationWithProcessIdentifier(processIdentifier);
  });
  Automac.prototype.runningApplicationsWithBundleIdentifier = parameterfy(function(bundleIdentifier) {
    return __wrappedInstance.runningApplicationsWithBundleIdentifier(bundleIdentifier);
  });
  Automac.prototype.currentApplication = parameterfy(function() {
    return __wrappedInstance.currentApplication();
  });
  Automac.prototype.getSearchPathForDirectoriesInDomains = parameterfy(function(directory, domainMask, expandTilde) {
    return __wrappedInstance.getSearchPathForDirectoriesInDomains(directory, domainMask, expandTilde);
  });
  Automac.prototype.postKeyboardEvent = parameterfy(function(keyCode, modifiers, keyDown) {
    return __wrappedInstance.postKeyboardEvent(keyCode, modifiers, keyDown);
  });
  Automac.prototype.postKeyboardEventToProcess = parameterfy(function(pid, keyCode, modifiers, keyDown) {
    return __wrappedInstance.postKeyboardEventToProcess(pid, keyCode, modifiers, keyDown);
  });
  Automac.prototype.stringForKeyStrokes = parameterfy(function(keyStrokes) {
    var $jscomp$restParams = [];
    for (var $jscomp$restIndex = 0;$jscomp$restIndex < arguments.length;++$jscomp$restIndex) {
      $jscomp$restParams[$jscomp$restIndex - 0] = arguments[$jscomp$restIndex];
    }
    var keyStrokes$0 = $jscomp$restParams;
    if (keyStrokes$0) {
      return __wrappedInstance.stringForKeyStrokes(keyStrokes$0);
    } else {
      return __wrappedInstance.stringForKeyStrokes();
    }
  });
  Automac.prototype.keyStrokesForString = parameterfy(function(input) {
    return __wrappedInstance.keyStrokesForString(input);
  });
  Automac.prototype.sendText = parameterfy(function(textToInput) {
    __wrappedInstance.sendText(textToInput);
  });
  Automac.prototype.postMouseEvent = parameterfy(function(mouseType, mouseCursorPositionX, mouseCursorPositionY, mouseButton, clickState, modifiers) {
    return __wrappedInstance.postMouseEvent(mouseType, mouseCursorPositionX, mouseCursorPositionY, mouseButton, clickState, modifiers);
  });
  return Automac;
}();
var Automac_export = new Automac;
var $jscompDefaultExport = Automac_export;
module$input.Automac = Automac_export;
module$input["default"] = $jscompDefaultExport;
