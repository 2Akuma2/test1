// http://alvinalexander.com/java/jwarehouse/openjdk-8/nashorn/src/jdk/nashorn/api/scripting/resources/engine.js.shtml
Object.defineProperty(this, "printf", {
    configurable: true,
    enumerable: false,
    writable: true,
    value: function (format, args/*, more args*/) {
        print(sprintf.apply(this, arguments));
    }
});

Object.defineProperty(this, "sprintf", {
    configurable: true,
    enumerable: false,
    writable: true,
    value: function (format, args/*, more args*/) {
        if (format === null || format === void 0) { return format;}
        var len = arguments.length - 1;
        var array = [];

        if (len < 0) {
            return "";
        }

        for (var i = 0; i < len; i++) {
            if (arguments[i+1] instanceof Date) {
                array[i] = arguments[i+1].getTime();
            } else {
                array[i] = arguments[i+1];
            }
        }

        array = Java.to(array);
        if (! console._qf_nashorn15) {
            try {
                return Packages.jdk.nashorn.api.scripting.ScriptUtils.format(format, array)
            } catch (e) {}
        }
        console._qf_nashorn15 = true;
        return Packages.org.openjdk.nashorn.api.scripting.ScriptUtils.format(format, array);
    }
});


var console = {
    log: printf,
    info: printf,
    warn: printf,
    error: printf,
    dir: function(o,options){print(require('util').inspect(o,options))},
    _qf_nashorn15: false
};

console.assert = function assert(condition, message) {
    if (!condition) {
        message = message || "Assertion failed";
        if (typeof Error !== "undefined") {
            throw new Error(message);
        }
        throw message; // Fallback
    }
}