(function(){
var util = exports;

var Reflector = Java.type("de.qfs.lib.util.Reflector");
var javaInspect = function(o, options) {
    var showHidden = options.showHidden,
        maxArrayLength = options.maxArrayLength,
        depth = options.depth,
        breakLength = options.breakLength,
        _strLength = options._strLength,
        _seen = options._seen,
        fName, clazz = o.class, mods, key, value, field, method, isType = false,
        isArray = false;

    if (! (clazz && clazz.name)) {
        return '' + o;
    }

    if (Java.isType(o)) {
        fName = '[JavaClass ' + clazz.name + ']';
        isType = true;
    } else {
        isArray = (clazz.name.indexOf('[') === 0);
        if (isArray) {
            fName = '[JavaArray ' + clazz.name.substring(1) + ']';
        } else {
            fName = '[JavaObject ' + clazz.name + ']';
        }
    }
    
    if (isArray) {
      result = "[ " + fName;
      if (o.length > 0) {
        breakLines = o.length > breakLength;
        if (depth < 0) {
          result += 'Object';
        } else {
          for (var i = 0; i < o.length; i++) {
            result += " ";
            if (i >= maxArrayLength) {
              var remaining = (o.length - i);
              result += "... " + remaining + " more item" + (remaining > 1 ? "s" : "");
              break;
            }
            value = o[i];
            if (value !== void 0) {
              result += util.inspect(value,{depth:depth-1, maxArrayLength:maxArrayLength, showHidden:showHidden, breakLength: breakLength, _strLength: _strLength + 3 + fName.length, _seen: _seen});
            }
            if (i < o.length - 1) {
              result += ",";
              if (breakLines) {
                result += "\n";
                for (var j = 0; j < _strLength + 2 + fName.length; j++) {
                  result += " ";
                }
              }
            }
          }
          result += " ";
        }
      }
      result += "]";
      return result;
    }

    var filteredFields = {};
    var filteredMethods = {};

    while(clazz) {
        var fields = clazz.getDeclaredFields()
        for (var i=0;i<fields.length;i++) {
            field = fields[i];
            key = field.name;
            mods = field.getModifiers()
            var isPublic = mods & 0x00000001 != 0;
            var isStatic = mods & 0x00000008 != 0;
            if ((showHidden || isPublic) && (isStatic || ! isType)) {
                if (! filteredFields[key]) {
                    filteredFields[key] = field;
                }
            }
        }
        var methods = clazz.getDeclaredMethods()
        for (var i=0;i<methods.length;i++) {
            method = methods[i];
            key = method.name + Reflector.getMethodDescriptor(method, false);
            mods = method.getModifiers()
            var isPublic = mods & 0x00000001 != 0;
            var isStatic = mods & 0x00000008 != 0;
            if ((showHidden || isPublic) && (isStatic || ! isType)) {
                if (! filteredMethods[key]) {
                    filteredMethods[key] = method;
                }
            }
        }
        clazz = clazz.getSuperclass()
    }

    var fieldKeys = Object.keys(filteredFields);
    fieldKeys.sort();
    var methodKeys = Object.keys(filteredMethods);
    methodKeys.sort();

    var totalLength = fieldKeys.length + methodKeys.length;
    if (totalLength == 0 || depth < 0) {
        return fName;
    }
    var breakLines = totalLength > breakLength;
    
    result = "{ " + fName;

    result += " '" + o + "'";

    if (breakLines) {
      result += "\n";
      for (var j = 0; j < _strLength + fName.length + 2; j++) {
        result += " ";
      }
    }

    for (var i = 0; i < fieldKeys.length; i++) {
        key = fieldKeys[i];
        field = filteredFields[key];

        result += " " + key + ": ";

        value = Reflector.safeGet(isType ? o.class : o, key, true);

        result += util.inspect(value,{depth:depth-1, maxArrayLength:maxArrayLength, showHidden:showHidden, breakLength: breakLength, _strLength: _strLength + 3 + fName.length, _seen: _seen});

        if (i < totalLength - 1) {
          result += ",";
          if (breakLines) {
            result += "\n";
            for (var j = 0; j < _strLength + fName.length + 2; j++) {
              result += " ";
            }
          }
        }
    }

    for (var i = 0; i < methodKeys.length; i++) {
        key = methodKeys[i];
        method = filteredMethods[key];

        result += " " + method.name + ": ";

        result += "[JavaMethod "+ method.name + Reflector.getMethodDescriptor(method, true) +"]";

        if (i < methodKeys.length - 1) {
          result += ",";
          if (breakLines) {
            result += "\n";
            for (var j = 0; j < _strLength + fName.length + 2; j++) {
              result += " ";
            }
          }
        }
    }

    result += " }";
    return result;
}

util.inspect = function inspect(o, options) {
  options = options || {};
  var defaultOptions = util.inspect.defaultOptions,
      type = typeof o,
      maxArrayLength = options.maxArrayLength,
      showHidden = options.showHidden === void 0 ? defaultOptions.showHidden : !!options.showHidden,
      depth = options.depth,
      breakLength = options.breakLength,
      _strLength = options._strLength | 0,
      _seen = options._seen || [];

  if (maxArrayLength === void 0) {
    maxArrayLength = defaultOptions.maxArrayLength;
  } else if (maxArrayLength === null) {
    maxArrayLength = Number.MAX_VALUE; // quasi infinity
  }
  if (depth === void 0) {
    depth = defaultOptions.depth;
  } else if (depth === null) {
    depth = Number.MAX_VALUE; // quasi infinity
  }
  if (breakLength === void 0) {
    breakLength = defaultOptions.breakLength;
  }

  _seen.push(o);

  if (type == "undefined") {
    return "undefined";
  } else if (o === null) {
    return "null";
  } else if (type == "boolean") {
    return o ? "true" : "false";
  } else if (type == "string") {
    return "'" + o + "'";
  } else if (type == "number") {
    return "" +o;
  } else if (type == "symbol") {
    return o.toString();
  } else { // type == object or function
    var objString = Object.prototype.toString.call(o);
    if (objString === '[object RegExp]') {
      return '' + o;
    } else if (objString === '[object Date]') {
      return o.toUTCString();
    } else if (objString === '[object Error]' || o instanceof Error) {
      return '[' + o + ']';
    } else if (Java.isJavaMethod(o)) {
        return '[JavaMethod]';
    } else if (objString.indexOf(".") > objString.indexOf(" ")) { // java object...
        return o.toString()
    }

    if (_seen.indexOf(o) < _seen.length - 1) {
      return '[Circular]';
    }

    var isArray = Array.isArray(o),
        result = "",
        key,desc,value,
        breakLines = false;

    if (isArray) {
      result += "[";
      if (o.length > 0) {
        breakLines = o.length > breakLength;
        if (depth < 0) {
          result += 'Object';
        } else {
          for (var i = 0; i < o.length; i++) {
            result += " ";
            if (i >= maxArrayLength) {
              var remaining = (o.length - i);
              result += "... " + remaining + " more item" + (remaining > 1 ? "s" : "");
              break;
            }
            value = o[i];
            if (value !== void 0) {
              result += util.inspect(value,{depth:depth-1, maxArrayLength:maxArrayLength, showHidden:showHidden, breakLength: breakLength, _strLength: _strLength + 2, _seen: _seen});
            }
            if (i < o.length - 1) {
              result += ",";
              if (breakLines) {
                result += "\n";
                for (var j = 0; j < _strLength + 1; j++) {
                  result += " ";
                }
              }
            }
          }
          result += " ";
        }
      }
      result += "]";
    } else {
      var ownProperties = showHidden ? Object.getOwnPropertyNames(o) : Object.keys(o);
      var fName = "";

      if (type == "function") {
        fName = "[Function" + (o.name ? ': ' + o.name : '') + "]";
        if (ownProperties.length == 0 || depth < 0) {
            return fName;
        }
        else fName = " " + fName;
      }

      if (depth < 0) {
        if (ownProperties.length == 0) {
          return "{}";
        } else {
          return "[Object]";
        }
      }
      result += "{" + fName;
      if (ownProperties.length > 0) {
        breakLines = ownProperties.length > breakLength;
        for (var i = 0; i < ownProperties.length; i++) {
          result += " ";
          key = ownProperties[i];
          result += key + ": ";
          desc = Object.getOwnPropertyDescriptor(o, key) || {};
          if (desc.get) {
            if (desc.set) {
              result += '[Getter/Setter]';
            } else {
              result += '[Getter]';
            }
          } else if (desc.set) {
            result += '[Setter]';
          } else {
            value = o[key];
            result += util.inspect(value, {depth:depth-1, maxArrayLength:maxArrayLength, showHidden:showHidden, breakLength: breakLength, _strLength: _strLength + 2 + fName.length, _seen: _seen});
          }
          if (i < ownProperties.length - 1) {
            result += ",";
            if (breakLines) {
              result += "\n";
              for (var j = 0; j < _strLength + fName.length + 1; j++) {
                result += " ";
              }
            }
          }
        }
        result += " ";
      }
      result += "}";
    }
    return result;
  }
}

util.inspect.defaultOptions = {
  maxArrayLength: 100,
  showHidden: false,
  depth: 2,
  breakLength: 60
}

util.default = util.inspect;
})()