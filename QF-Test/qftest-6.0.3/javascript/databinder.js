exports.__esModule = true;
var module$input = exports;
DataBinder = function() {
  _WrappedDataBinder = Java.type("de.qfs.apps.qftest.script.modules.DataBinder");
  var __wrappedInstance;
  function DataBinder() {
    __wrappedInstance = _WrappedDataBinder.instance();
  }
  DataBinder.prototype.bindList = parameterfy(function(rc, loopname, varname, values, separator, counter, intervals) {
    if (separator === undefined) {
      separator = null;
    }
    if (counter === undefined) {
      counter = null;
    }
    if (intervals === undefined) {
      intervals = null;
    }
    __wrappedInstance.bindList(rc, loopname, varname, values, separator, counter, intervals);
  });
  DataBinder.prototype.bindSets = parameterfy(function(rc, loopname, varnames, values, separator, counter, intervals) {
    if (separator === undefined) {
      separator = null;
    }
    if (counter === undefined) {
      counter = null;
    }
    if (intervals === undefined) {
      intervals = null;
    }
    __wrappedInstance.bindSets(rc, loopname, varnames, values, separator, counter, intervals);
  });
  DataBinder.prototype.bindDict = parameterfy(function(rc, loopname, dict, counter, intervals) {
    if (counter === undefined) {
      counter = null;
    }
    if (intervals === undefined) {
      intervals = null;
    }
    __wrappedInstance.bindDict(rc, loopname, dict, counter, intervals);
  });
  return DataBinder;
}();
var DataBinder_export = new DataBinder;
var $jscompDefaultExport = DataBinder_export;
module$input.DataBinder = DataBinder_export;
module$input["default"] = $jscompDefaultExport;
