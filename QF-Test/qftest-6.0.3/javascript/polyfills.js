// from https://developer.mozilla.org/de/docs/Web/JavaScript/Reference/Global_Objects/Array/includes
if (!Array.prototype.includes) {
    Object.defineProperty(Array.prototype, "includes", {
        configurable: false,
        enumerable: false,
        writable: false,
        value: function(searchElement /*, fromIndex*/) {
    if (this == null) {
      throw new TypeError('Array.prototype.includes called on null or undefined');
    }

    var O = Object(this);
    var len = parseInt(O.length, 10) || 0;
    if (len === 0) {
      return false;
    }
    var n = parseInt(arguments[1], 10) || 0;
    var k;
    if (n >= 0) {
      k = n;
    } else {
      k = len + n;
      if (k < 0) {k = 0;}
    }
    var currentElement;
    while (k < len) {
      currentElement = O[k];
      if (searchElement === currentElement ||
         (searchElement !== searchElement && currentElement !== currentElement)) { // NaN !== NaN
        return true;
      }
      k++;
    }
    return false;
  }});
}

// from https://github.com/gearcase/pad-start/blob/master/index.js
if (!String.prototype.padStart) {
    Object.defineProperty(String.prototype, "padStart", {
        configurable: false,
        enumerable: false,
        writable: false,
        value: function (maxLength, fillString) {

      if (this == null || maxLength == null) {
        return this;
      }

      var result    = String(this);
      var targetLen = typeof maxLength === 'number'
        ? maxLength
        : parseInt(maxLength, 10);

      if (isNaN(targetLen) || !isFinite(targetLen)) {
        return result;
      }


      var length = result.length;
      if (length >= targetLen) {
        return result;
      }


      var fill = fillString == null ? '' : String(fillString);
      if (fill === '') {
        fill = ' ';
      }


      var fillLen = targetLen - length;

      while (fill.length < fillLen) {
        fill += fill;
      }

      var truncated = fill.length > fillLen ? fill.substr(0, fillLen) : fill;

      return truncated + result;
    }});
}

// from https://github.com/gearcase/pad-end/blob/master/index.js
if (! String.prototype.padEnd) {
    Object.defineProperty(String.prototype, "padEnd", {
        configurable: false,
        enumerable: false,
        writable: false,
        value: function (maxLength, fillString) {

      if (this == null || maxLength == null) {
        return this;
      }

      var result    = String(this);
      var targetLen = typeof maxLength === 'number'
        ? maxLength
        : parseInt(maxLength, 10);

      if (isNaN(targetLen) || !isFinite(targetLen)) {
        return result;
      }


      var length = result.length;
      if (length >= targetLen) {
        return result;
      }


      var filled = fillString == null ? '' : String(fillString);
      if (filled === '') {
        filled = ' ';
      }

      var fillLen = targetLen - length;

      while (filled.length < fillLen) {
        filled += filled;
      }

      var truncated = filled.length > fillLen ? filled.substr(0, fillLen) : filled;

      return result + truncated;
    }});
}

// from https://github.com/59naga/string-raw/blob/master/src/index.js
if (! String.raw) {
    Object.defineProperty(String, "raw", {
        configurable: false,
        enumerable: false,
        writable: false,
        value: (function() {
        "use strict";

        function e(e, n) {
            return n = {
                exports: {}
            }, e(n, n.exports), n.exports
        }
        var n = {};
        n["typeof"] = "function" == typeof Symbol && "symbol" == typeof Symbol.iterator ? function(e) {
            return typeof e
        } : function(e) {
            return e && "function" == typeof Symbol && e.constructor === Symbol ? "symbol" : typeof e
        };
        var r = e(function(e) {
                e.exports = function() {
                    var e = function(e) {
                            return "function" == typeof e
                        },
                        r = function(e) {
                            var n = Number(e);
                            return isNaN(n) ? 0 : 0 !== n && isFinite(n) ? (n > 0 ? 1 : -1) * Math.floor(Math.abs(n)) : n
                        },
                        t = Math.pow(2, 53) - 1,
                        o = function(e) {
                            var n = r(e);
                            return Math.min(Math.max(n, 0), t)
                        },
                        i = function(e) {
                            if (null != e) {
                                if (["string", "number", "boolean", "symbol"].indexOf("undefined" == typeof e ? "undefined" : n["typeof"](e)) > -1) return Symbol.iterator;
                                if ("undefined" != typeof Symbol && "iterator" in Symbol && Symbol.iterator in e) return Symbol.iterator;
                                if ("@@iterator" in e) return "@@iterator"
                            }
                        },
                        f = function(n, r) {
                            if (null != n && null != r) {
                                var t = n[r];
                                if (null == t) return;
                                if (!e(t)) throw new TypeError(t + " is not a function");
                                return t
                            }
                        },
                        u = function(e) {
                            var n = e.next(),
                                r = Boolean(n.done);
                            return r ? !1 : n
                        };
                    return function(n) {
                        var r, t = this,
                            a = arguments.length > 1 ? arguments[1] : void 0;
                        if ("undefined" != typeof a) {
                            if (!e(a)) throw new TypeError("Array.from: when provided, the second argument must be a function");
                            arguments.length > 2 && (r = arguments[2])
                        }
                        var l, y, c = f(n, i(n));
                        if (void 0 !== c) {
                            l = e(t) ? Object(new t) : [];
                            var d = c.call(n);
                            if (null == d) throw new TypeError("Array.from requires an array-like or iterable object");
                            y = 0;
                            for (var p, b;;) {
                                if (p = u(d), !p) return l.length = y, l;
                                b = p.value, a ? l[y] = a.call(r, b, y) : l[y] = b, y++
                            }
                        } else {
                            var m = Object(n);
                            if (null == n) throw new TypeError("Array.from requires an array-like object - not null or undefined");
                            var s = o(m.length);
                            l = e(t) ? Object(new t(s)) : new Array(s), y = 0;
                            for (var h; s > y;) h = m[y], a ? l[y] = a.call(r, h, y) : l[y] = h, y++;
                            l.length = s
                        }
                        return l
                    }
                }()
            }),
            t = r && "object" === ("undefined" == typeof r ? "undefined" : n["typeof"](r)) && "default" in r ? r["default"] : r,
            o = e(function(e) {
                e.exports = "function" == typeof Array.from ? Array.from : t
            }),
            i = o && "object" === ("undefined" == typeof o ? "undefined" : n["typeof"](o)) && "default" in o ? o["default"] : o,
            f = function() {
                for (var e = arguments.length, n = Array(e > 1 ? e - 1 : 0), r = 1; e > r; r++) n[r - 1] = arguments[r];
                var t = arguments.length <= 0 || void 0 === arguments[0] ? {} : arguments[0],
                    o = void 0;
                try {
                    o = i(t.raw)
                } catch (f) {
                    throw new TypeError("Cannot convert undefined or null to object")
                }
                return o.map(function(e, r) {
                    return t.raw.length <= r ? e : n[r - 1] ? n[r - 1] + e : e
                }).join("")
            };
        return f
    })()});
}

// Object values/entries
(function(){
    var reduce = Function.bind.call(Function.call, Array.prototype.reduce);
    var isEnumerable = Function.bind.call(Function.call, Object.prototype.propertyIsEnumerable);
    var concat = Function.bind.call(Function.call, Array.prototype.concat);

    if (!Object.values) {
        Object.defineProperty(Object, "values", {
            configurable: false,
            enumerable: false,
            writable: false,
            value: function values(O) {
            return reduce(Object.keys(O), function(v, k) {
              return concat(v, typeof k === "string" && isEnumerable(O, k) ? [O[k]] : []);
            }, []);
          }
      });
    }

    if (!Object.entries) {
        Object.defineProperty(Object, "entries", {
            configurable: false,
            enumerable: false,
            writable: false,
            value: function entries(O) {
            return reduce(Object.keys(O), function(e, k) {
              return concat(e, typeof k === "string" && isEnumerable(O, k) ? [[k, O[k]]] : []);
            }, []);
          }
      });
    }
})()
