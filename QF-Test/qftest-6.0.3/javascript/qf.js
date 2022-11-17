exports.__esModule = true;
var module$input = exports;
var QF = function() {
};
var _WrappedQF = Java.type("de.qfs.apps.qftest.shared.script.modules.QF");
QF.getClassName = parameterfy(function(objectOrClass) {
  return _WrappedQF.getClassName(objectOrClass);
});
QF.isInstance = parameterfy(function(object, className) {
  return _WrappedQF.isInstance(object, className);
});
QF.toString = parameterfy(function(object, nullValue) {
  if (nullValue === undefined) {
    nullValue = "";
  }
  return _WrappedQF.toString(object, nullValue);
});
QF.setProperty = parameterfy(function(object, name, value) {
  _WrappedQF.setProperty(object, name, value);
});
QF.getProperty = parameterfy(function(object, name) {
  return _WrappedQF.getProperty(object, name);
});
QF.logMessage = parameterfy(function(msg, dontcompactify, report, nowrap) {
  if (dontcompactify === undefined) {
    dontcompactify = false;
  }
  if (report === undefined) {
    report = false;
  }
  if (nowrap === undefined) {
    nowrap = false;
  }
  _WrappedQF.logMessage(msg, dontcompactify, report, nowrap);
});
QF.logWarning = parameterfy(function(msg, report, nowrap) {
  if (report === undefined) {
    report = true;
  }
  if (nowrap === undefined) {
    nowrap = false;
  }
  _WrappedQF.logWarning(msg, report, nowrap);
});
QF.logError = parameterfy(function(msg, nowrap) {
  if (nowrap === undefined) {
    nowrap = false;
  }
  _WrappedQF.logError(msg, nowrap);
});
QF.getCleanText = parameterfy(function(text) {
  return _WrappedQF.getCleanText(text);
});
QF.asPattern = parameterfy(function(regexp) {
  return _WrappedQF.asPattern(regexp);
});
QF.getRC = parameterfy(function() {
  return _WrappedQF.getRC();
});
QF.setRCProvider = parameterfy(function(rcProviderMethod) {
  _WrappedQF.setRCProvider(rcProviderMethod);
});
QF.getCurrentInterpreterName = parameterfy(function() {
  return _WrappedQF.getCurrentInterpreterName();
});
QF.print = parameterfy(function(obj) {
  var $jscomp$restParams = [];
  for (var $jscomp$restIndex = 0;$jscomp$restIndex < arguments.length;++$jscomp$restIndex) {
    $jscomp$restParams[$jscomp$restIndex - 0] = arguments[$jscomp$restIndex];
  }
  var obj$0 = $jscomp$restParams;
  if (obj$0) {
    _WrappedQF.print(obj$0);
  } else {
    _WrappedQF.print();
  }
});
QF.println = parameterfy(function(obj) {
  var $jscomp$restParams = [];
  for (var $jscomp$restIndex = 0;$jscomp$restIndex < arguments.length;++$jscomp$restIndex) {
    $jscomp$restParams[$jscomp$restIndex - 0] = arguments[$jscomp$restIndex];
  }
  var obj$1 = $jscomp$restParams;
  if (obj$1) {
    _WrappedQF.println(obj$1);
  } else {
    _WrappedQF.println();
  }
});
var $jscompDefaultExport = QF;
module$input.QF = QF;
module$input["default"] = $jscompDefaultExport;
