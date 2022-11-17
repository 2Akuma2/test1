exports.__esModule = true;
var module$input = exports;
Autolin = function() {
  _WrappedAutolin = Java.type("de.qfs.apps.qftest.shared.script.modules.Autolin");
  var __wrappedInstance;
  function Autolin() {
    __wrappedInstance = _WrappedAutolin.instance();
  }
  Autolin.prototype.getWindowText = parameterfy(function(win) {
    return __wrappedInstance.getWindowText(win);
  });
  Autolin.prototype.getAllWindows = parameterfy(function() {
    return __wrappedInstance.getAllWindows();
  });
  Autolin.prototype.closeWindow = parameterfy(function(win) {
    __wrappedInstance.closeWindow(win);
  });
  Autolin.prototype.setForeground = parameterfy(function(win) {
    __wrappedInstance.setForeground(win);
  });
  Autolin.prototype.getParent = parameterfy(function(win) {
    return __wrappedInstance.getParent(win);
  });
  Autolin.prototype.findWindow = parameterfy(function(name, regexp) {
    if (regexp === undefined) {
      regexp = false;
    }
    return __wrappedInstance.findWindow(name, regexp);
  });
  Autolin.prototype.waitForWindow = parameterfy(function(timeout, name, regexp) {
    if (regexp === undefined) {
      regexp = false;
    }
    return __wrappedInstance.waitForWindow(timeout, name, regexp);
  });
  Autolin.prototype.sendText = parameterfy(function(textToInput) {
    __wrappedInstance.sendText(textToInput);
  });
  return Autolin;
}();
var Autolin_export = new Autolin;
var $jscompDefaultExport = Autolin_export;
module$input.Autolin = Autolin_export;
module$input["default"] = $jscompDefaultExport;
