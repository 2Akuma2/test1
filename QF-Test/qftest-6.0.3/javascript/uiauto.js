exports.__esModule = true;
var module$input = exports;
UIAuto = function() {
  _WrappedUIAuto = Java.type("de.qfs.apps.qftest.shared.script.modules.UIAuto");
  var __wrappedInstance;
  function UIAuto() {
    __wrappedInstance = _WrappedUIAuto.instance();
  }
  UIAuto.prototype.launchWithDirectory = parameterfy(function(command) {
    var $jscomp$restParams = [];
    for (var $jscomp$restIndex = 0;$jscomp$restIndex < arguments.length;++$jscomp$restIndex) {
      $jscomp$restParams[$jscomp$restIndex - 0] = arguments[$jscomp$restIndex];
    }
    var command$0 = $jscomp$restParams;
    if (command$0) {
      return __wrappedInstance.launchWithDirectory(command$0);
    } else {
      return __wrappedInstance.launchWithDirectory();
    }
  });
  UIAuto.prototype.attach = parameterfy(function(process) {
    return __wrappedInstance.attach(process);
  });
  UIAuto.prototype.launchOrAttach = parameterfy(function(command) {
    var $jscomp$restParams = [];
    for (var $jscomp$restIndex = 0;$jscomp$restIndex < arguments.length;++$jscomp$restIndex) {
      $jscomp$restParams[$jscomp$restIndex - 0] = arguments[$jscomp$restIndex];
    }
    var command$1 = $jscomp$restParams;
    if (command$1) {
      return __wrappedInstance.launchOrAttach(command$1);
    } else {
      return __wrappedInstance.launchOrAttach();
    }
  });
  UIAuto.prototype.launchWithWorkingDirectoryOrAttach = parameterfy(function(command) {
    var $jscomp$restParams = [];
    for (var $jscomp$restIndex = 0;$jscomp$restIndex < arguments.length;++$jscomp$restIndex) {
      $jscomp$restParams[$jscomp$restIndex - 0] = arguments[$jscomp$restIndex];
    }
    var command$2 = $jscomp$restParams;
    if (command$2) {
      return __wrappedInstance.launchWithWorkingDirectoryOrAttach(command$2);
    } else {
      return __wrappedInstance.launchWithWorkingDirectoryOrAttach();
    }
  });
  UIAuto.prototype.launchWithDirectoryOrAttach = parameterfy(function(command) {
    var $jscomp$restParams = [];
    for (var $jscomp$restIndex = 0;$jscomp$restIndex < arguments.length;++$jscomp$restIndex) {
      $jscomp$restParams[$jscomp$restIndex - 0] = arguments[$jscomp$restIndex];
    }
    var command$3 = $jscomp$restParams;
    if (command$3) {
      return __wrappedInstance.launchWithDirectoryOrAttach(command$3);
    } else {
      return __wrappedInstance.launchWithDirectoryOrAttach();
    }
  });
  UIAuto.prototype.findProcess = parameterfy(function(commandOrPattern) {
    var $jscomp$restParams = [];
    for (var $jscomp$restIndex = 0;$jscomp$restIndex < arguments.length;++$jscomp$restIndex) {
      $jscomp$restParams[$jscomp$restIndex - 0] = arguments[$jscomp$restIndex];
    }
    var commandOrPattern$4 = $jscomp$restParams;
    if (commandOrPattern$4) {
      return __wrappedInstance.findProcess(commandOrPattern$4);
    } else {
      return __wrappedInstance.findProcess();
    }
  });
  UIAuto.prototype.getDesktopWindow = parameterfy(function(titleOrPattern, retries) {
    if (retries === undefined) {
      retries = 25;
    }
    return __wrappedInstance.getDesktopWindow(titleOrPattern, retries);
  });
  UIAuto.prototype.getWindow = parameterfy(function(titleOrPattern, retries) {
    if (retries === undefined) {
      retries = 25;
    }
    return __wrappedInstance.getWindow(titleOrPattern, retries);
  });
  UIAuto.prototype.getDesktop = parameterfy(function() {
    return __wrappedInstance.getDesktop();
  });
  UIAuto.prototype.getDesktopObject = parameterfy(function(titleOrPattern, retries) {
    if (retries === undefined) {
      retries = 25;
    }
    return __wrappedInstance.getDesktopObject(titleOrPattern, retries);
  });
  UIAuto.prototype.getDesktopMenu = parameterfy(function(title) {
    return __wrappedInstance.getDesktopMenu(title);
  });
  UIAuto.prototype.getDesktopWindows = parameterfy(function() {
    return __wrappedInstance.getDesktopWindows();
  });
  UIAuto.prototype.getDesktopObjects = parameterfy(function() {
    return __wrappedInstance.getDesktopObjects();
  });
  UIAuto.prototype.getControlTypeByName = parameterfy(function(controlTypeName) {
    return __wrappedInstance.getControlTypeByName(controlTypeName);
  });
  UIAuto.prototype.getControlTypeByValue = parameterfy(function(controlTypeValue) {
    return __wrappedInstance.getControlTypeByValue(controlTypeValue);
  });
  UIAuto.prototype.getControlByPointer = parameterfy(function(ptr) {
    return __wrappedInstance.getControlByPointer(ptr);
  });
  UIAuto.prototype.getSearch = parameterfy(function() {
    return __wrappedInstance.getSearch();
  });
  UIAuto.prototype.getAutomationPatternClass = parameterfy(function(patternClassName) {
    return __wrappedInstance.getAutomationPatternClass(patternClassName);
  });
  UIAuto.prototype.getAutomationExceptionClass = parameterfy(function() {
    return __wrappedInstance.getAutomationExceptionClass();
  });
  UIAuto.prototype.getControlViewWalker = parameterfy(function() {
    return __wrappedInstance.getControlViewWalker();
  });
  UIAuto.prototype.dumpControls = parameterfy(function(parent, maxDepth) {
    if (parent === undefined) {
      parent = null;
    }
    if (maxDepth === undefined) {
      maxDepth = 0;
    }
    return __wrappedInstance.dumpControls(parent, maxDepth);
  });
  UIAuto.prototype.dumpControlsToFile = parameterfy(function(filename, parent, maxDepth, charset) {
    if (parent === undefined) {
      parent = null;
    }
    if (maxDepth === undefined) {
      maxDepth = 0;
    }
    if (charset === undefined) {
      charset = "UTF-8";
    }
    __wrappedInstance.dumpControlsToFile(filename, parent, maxDepth, charset);
  });
  return UIAuto;
}();
var UIAuto_export = new UIAuto;
var $jscompDefaultExport = UIAuto_export;
module$input.UIAuto = UIAuto_export;
module$input["default"] = $jscompDefaultExport;
