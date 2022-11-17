exports.__esModule = true;
var module$input = exports;
WebResolvers = function() {
  _WrappedWebResolvers = Java.type("de.qfs.apps.qftest.client.script.modules.WebResolvers");
  var __wrappedInstance;
  function WebResolvers() {
    __wrappedInstance = _WrappedWebResolvers.instance();
  }
  WebResolvers.prototype.addClassNameResolver = parameterfy(function(name, jsFunction, targets) {
    var $jscomp$restParams = [];
    for (var $jscomp$restIndex = 2;$jscomp$restIndex < arguments.length;++$jscomp$restIndex) {
      $jscomp$restParams[$jscomp$restIndex - 2] = arguments[$jscomp$restIndex];
    }
    var targets$0 = $jscomp$restParams;
    if (targets$0) {
      __wrappedInstance.addClassNameResolver(name, jsFunction, targets$0);
    } else {
      __wrappedInstance.addClassNameResolver(name, jsFunction);
    }
  });
  WebResolvers.prototype.addComponentRecordingFilter = parameterfy(function(name, jsFunction, targets) {
    var $jscomp$restParams = [];
    for (var $jscomp$restIndex = 2;$jscomp$restIndex < arguments.length;++$jscomp$restIndex) {
      $jscomp$restParams[$jscomp$restIndex - 2] = arguments[$jscomp$restIndex];
    }
    var targets$1 = $jscomp$restParams;
    if (targets$1) {
      __wrappedInstance.addComponentRecordingFilter(name, jsFunction, targets$1);
    } else {
      __wrappedInstance.addComponentRecordingFilter(name, jsFunction);
    }
  });
  WebResolvers.prototype.addEnabledResolver = parameterfy(function(name, jsFunction, targets) {
    var $jscomp$restParams = [];
    for (var $jscomp$restIndex = 2;$jscomp$restIndex < arguments.length;++$jscomp$restIndex) {
      $jscomp$restParams[$jscomp$restIndex - 2] = arguments[$jscomp$restIndex];
    }
    var targets$2 = $jscomp$restParams;
    if (targets$2) {
      __wrappedInstance.addEnabledResolver(name, jsFunction, targets$2);
    } else {
      __wrappedInstance.addEnabledResolver(name, jsFunction);
    }
  });
  WebResolvers.prototype.addBusyApplicationDetector = parameterfy(function(name, jsFunction, engines) {
    var $jscomp$restParams = [];
    for (var $jscomp$restIndex = 2;$jscomp$restIndex < arguments.length;++$jscomp$restIndex) {
      $jscomp$restParams[$jscomp$restIndex - 2] = arguments[$jscomp$restIndex];
    }
    var engines$3 = $jscomp$restParams;
    if (engines$3) {
      __wrappedInstance.addBusyApplicationDetector(name, jsFunction, engines$3);
    } else {
      __wrappedInstance.addBusyApplicationDetector(name, jsFunction);
    }
  });
  WebResolvers.prototype.addExtraFeatureMatcher = parameterfy(function(name, jsFunction, targets) {
    var $jscomp$restParams = [];
    for (var $jscomp$restIndex = 2;$jscomp$restIndex < arguments.length;++$jscomp$restIndex) {
      $jscomp$restParams[$jscomp$restIndex - 2] = arguments[$jscomp$restIndex];
    }
    var targets$4 = $jscomp$restParams;
    if (targets$4) {
      __wrappedInstance.addExtraFeatureMatcher(name, jsFunction, targets$4);
    } else {
      __wrappedInstance.addExtraFeatureMatcher(name, jsFunction);
    }
  });
  WebResolvers.prototype.addSpecificExtraFeatureMatcher = parameterfy(function(name, jsFunction, featureName, targets) {
    var $jscomp$restParams = [];
    for (var $jscomp$restIndex = 3;$jscomp$restIndex < arguments.length;++$jscomp$restIndex) {
      $jscomp$restParams[$jscomp$restIndex - 3] = arguments[$jscomp$restIndex];
    }
    var targets$5 = $jscomp$restParams;
    if (targets$5) {
      __wrappedInstance.addSpecificExtraFeatureMatcher(name, jsFunction, featureName, targets$5);
    } else {
      __wrappedInstance.addSpecificExtraFeatureMatcher(name, jsFunction, featureName);
    }
  });
  WebResolvers.prototype.addExtraFeatureResolver = parameterfy(function(name, jsFunction, targets) {
    var $jscomp$restParams = [];
    for (var $jscomp$restIndex = 2;$jscomp$restIndex < arguments.length;++$jscomp$restIndex) {
      $jscomp$restParams[$jscomp$restIndex - 2] = arguments[$jscomp$restIndex];
    }
    var targets$6 = $jscomp$restParams;
    if (targets$6) {
      __wrappedInstance.addExtraFeatureResolver(name, jsFunction, targets$6);
    } else {
      __wrappedInstance.addExtraFeatureResolver(name, jsFunction);
    }
  });
  WebResolvers.prototype.addFallbackClassNameResolver = parameterfy(function(name, jsFunction, targets) {
    var $jscomp$restParams = [];
    for (var $jscomp$restIndex = 2;$jscomp$restIndex < arguments.length;++$jscomp$restIndex) {
      $jscomp$restParams[$jscomp$restIndex - 2] = arguments[$jscomp$restIndex];
    }
    var targets$7 = $jscomp$restParams;
    if (targets$7) {
      __wrappedInstance.addFallbackClassNameResolver(name, jsFunction, targets$7);
    } else {
      __wrappedInstance.addFallbackClassNameResolver(name, jsFunction);
    }
  });
  WebResolvers.prototype.addFeatureResolver = parameterfy(function(name, jsFunction, targets) {
    var $jscomp$restParams = [];
    for (var $jscomp$restIndex = 2;$jscomp$restIndex < arguments.length;++$jscomp$restIndex) {
      $jscomp$restParams[$jscomp$restIndex - 2] = arguments[$jscomp$restIndex];
    }
    var targets$8 = $jscomp$restParams;
    if (targets$8) {
      __wrappedInstance.addFeatureResolver(name, jsFunction, targets$8);
    } else {
      __wrappedInstance.addFeatureResolver(name, jsFunction);
    }
  });
  WebResolvers.prototype.addGenericClassNameResolver = parameterfy(function(name, jsFunction, targets) {
    var $jscomp$restParams = [];
    for (var $jscomp$restIndex = 2;$jscomp$restIndex < arguments.length;++$jscomp$restIndex) {
      $jscomp$restParams[$jscomp$restIndex - 2] = arguments[$jscomp$restIndex];
    }
    var targets$9 = $jscomp$restParams;
    if (targets$9) {
      __wrappedInstance.addGenericClassNameResolver(name, jsFunction, targets$9);
    } else {
      __wrappedInstance.addGenericClassNameResolver(name, jsFunction);
    }
  });
  WebResolvers.prototype.addElementResolver = parameterfy(function(name, jsFunction, targets) {
    var $jscomp$restParams = [];
    for (var $jscomp$restIndex = 2;$jscomp$restIndex < arguments.length;++$jscomp$restIndex) {
      $jscomp$restParams[$jscomp$restIndex - 2] = arguments[$jscomp$restIndex];
    }
    var targets$10 = $jscomp$restParams;
    if (targets$10) {
      __wrappedInstance.addElementResolver(name, jsFunction, targets$10);
    } else {
      __wrappedInstance.addElementResolver(name, jsFunction);
    }
  });
  WebResolvers.prototype.addIdResolver = parameterfy(function(name, jsFunction, targets) {
    var $jscomp$restParams = [];
    for (var $jscomp$restIndex = 2;$jscomp$restIndex < arguments.length;++$jscomp$restIndex) {
      $jscomp$restParams[$jscomp$restIndex - 2] = arguments[$jscomp$restIndex];
    }
    var targets$11 = $jscomp$restParams;
    if (targets$11) {
      __wrappedInstance.addIdResolver(name, jsFunction, targets$11);
    } else {
      __wrappedInstance.addIdResolver(name, jsFunction);
    }
  });
  WebResolvers.prototype.addInterestingParentResolver = parameterfy(function(name, jsFunction, targets) {
    var $jscomp$restParams = [];
    for (var $jscomp$restIndex = 2;$jscomp$restIndex < arguments.length;++$jscomp$restIndex) {
      $jscomp$restParams[$jscomp$restIndex - 2] = arguments[$jscomp$restIndex];
    }
    var targets$12 = $jscomp$restParams;
    if (targets$12) {
      __wrappedInstance.addInterestingParentResolver(name, jsFunction, targets$12);
    } else {
      __wrappedInstance.addInterestingParentResolver(name, jsFunction);
    }
  });
  WebResolvers.prototype.addIndexBasedItemNameResolver = parameterfy(function(name, jsFunction, targets) {
    var $jscomp$restParams = [];
    for (var $jscomp$restIndex = 2;$jscomp$restIndex < arguments.length;++$jscomp$restIndex) {
      $jscomp$restParams[$jscomp$restIndex - 2] = arguments[$jscomp$restIndex];
    }
    var targets$13 = $jscomp$restParams;
    if (targets$13) {
      __wrappedInstance.addIndexBasedItemNameResolver(name, jsFunction, targets$13);
    } else {
      __wrappedInstance.addIndexBasedItemNameResolver(name, jsFunction);
    }
  });
  WebResolvers.prototype.addMainTextResolver = parameterfy(function(name, jsFunction, targets) {
    var $jscomp$restParams = [];
    for (var $jscomp$restIndex = 2;$jscomp$restIndex < arguments.length;++$jscomp$restIndex) {
      $jscomp$restParams[$jscomp$restIndex - 2] = arguments[$jscomp$restIndex];
    }
    var targets$14 = $jscomp$restParams;
    if (targets$14) {
      __wrappedInstance.addMainTextResolver(name, jsFunction, targets$14);
    } else {
      __wrappedInstance.addMainTextResolver(name, jsFunction);
    }
  });
  WebResolvers.prototype.addNameResolver = parameterfy(function(name, jsFunction, targets) {
    var $jscomp$restParams = [];
    for (var $jscomp$restIndex = 2;$jscomp$restIndex < arguments.length;++$jscomp$restIndex) {
      $jscomp$restParams[$jscomp$restIndex - 2] = arguments[$jscomp$restIndex];
    }
    var targets$15 = $jscomp$restParams;
    if (targets$15) {
      __wrappedInstance.addNameResolver(name, jsFunction, targets$15);
    } else {
      __wrappedInstance.addNameResolver(name, jsFunction);
    }
  });
  WebResolvers.prototype.addRedirectResolver = parameterfy(function(name, jsFunction, targets) {
    var $jscomp$restParams = [];
    for (var $jscomp$restIndex = 2;$jscomp$restIndex < arguments.length;++$jscomp$restIndex) {
      $jscomp$restParams[$jscomp$restIndex - 2] = arguments[$jscomp$restIndex];
    }
    var targets$16 = $jscomp$restParams;
    if (targets$16) {
      __wrappedInstance.addRedirectResolver(name, jsFunction, targets$16);
    } else {
      __wrappedInstance.addRedirectResolver(name, jsFunction);
    }
  });
  WebResolvers.prototype.addScrollOffsetResolver = parameterfy(function(name, fromScrolledLocationFunction, toScrolledLocationFunction, targets) {
    var $jscomp$restParams = [];
    for (var $jscomp$restIndex = 3;$jscomp$restIndex < arguments.length;++$jscomp$restIndex) {
      $jscomp$restParams[$jscomp$restIndex - 3] = arguments[$jscomp$restIndex];
    }
    var targets$17 = $jscomp$restParams;
    if (targets$17) {
      __wrappedInstance.addScrollOffsetResolver(name, fromScrolledLocationFunction, toScrolledLocationFunction, targets$17);
    } else {
      __wrappedInstance.addScrollOffsetResolver(name, fromScrolledLocationFunction, toScrolledLocationFunction);
    }
  });
  WebResolvers.prototype.addTableWithItemsResolver = parameterfy(function(name, jsFunction, targets) {
    var $jscomp$restParams = [];
    for (var $jscomp$restIndex = 2;$jscomp$restIndex < arguments.length;++$jscomp$restIndex) {
      $jscomp$restParams[$jscomp$restIndex - 2] = arguments[$jscomp$restIndex];
    }
    var targets$18 = $jscomp$restParams;
    if (targets$18) {
      __wrappedInstance.addTableWithItemsResolver(name, jsFunction, targets$18);
    } else {
      __wrappedInstance.addTableWithItemsResolver(name, jsFunction);
    }
  });
  WebResolvers.prototype.addTooltipResolver = parameterfy(function(name, jsFunction, targets) {
    var $jscomp$restParams = [];
    for (var $jscomp$restIndex = 2;$jscomp$restIndex < arguments.length;++$jscomp$restIndex) {
      $jscomp$restParams[$jscomp$restIndex - 2] = arguments[$jscomp$restIndex];
    }
    var targets$19 = $jscomp$restParams;
    if (targets$19) {
      __wrappedInstance.addTooltipResolver(name, jsFunction, targets$19);
    } else {
      __wrappedInstance.addTooltipResolver(name, jsFunction);
    }
  });
  WebResolvers.prototype.addVisibilityResolver = parameterfy(function(name, jsFunction, targets) {
    var $jscomp$restParams = [];
    for (var $jscomp$restIndex = 2;$jscomp$restIndex < arguments.length;++$jscomp$restIndex) {
      $jscomp$restParams[$jscomp$restIndex - 2] = arguments[$jscomp$restIndex];
    }
    var targets$20 = $jscomp$restParams;
    if (targets$20) {
      __wrappedInstance.addVisibilityResolver(name, jsFunction, targets$20);
    } else {
      __wrappedInstance.addVisibilityResolver(name, jsFunction);
    }
  });
  WebResolvers.prototype.addWholeTextResolver = parameterfy(function(name, jsFunction, targets) {
    var $jscomp$restParams = [];
    for (var $jscomp$restIndex = 2;$jscomp$restIndex < arguments.length;++$jscomp$restIndex) {
      $jscomp$restParams[$jscomp$restIndex - 2] = arguments[$jscomp$restIndex];
    }
    var targets$21 = $jscomp$restParams;
    if (targets$21) {
      __wrappedInstance.addWholeTextResolver(name, jsFunction, targets$21);
    } else {
      __wrappedInstance.addWholeTextResolver(name, jsFunction);
    }
  });
  WebResolvers.prototype.addItemNameMatcher = parameterfy(function(name, jsFunction, targets) {
    var $jscomp$restParams = [];
    for (var $jscomp$restIndex = 2;$jscomp$restIndex < arguments.length;++$jscomp$restIndex) {
      $jscomp$restParams[$jscomp$restIndex - 2] = arguments[$jscomp$restIndex];
    }
    var targets$22 = $jscomp$restParams;
    if (targets$22) {
      __wrappedInstance.addItemNameMatcher(name, jsFunction, targets$22);
    } else {
      __wrappedInstance.addItemNameMatcher(name, jsFunction);
    }
  });
  WebResolvers.prototype.addItemNameResolver = parameterfy(function(name, jsFunction, targets) {
    var $jscomp$restParams = [];
    for (var $jscomp$restIndex = 2;$jscomp$restIndex < arguments.length;++$jscomp$restIndex) {
      $jscomp$restParams[$jscomp$restIndex - 2] = arguments[$jscomp$restIndex];
    }
    var targets$23 = $jscomp$restParams;
    if (targets$23) {
      __wrappedInstance.addItemNameResolver(name, jsFunction, targets$23);
    } else {
      __wrappedInstance.addItemNameResolver(name, jsFunction);
    }
  });
  WebResolvers.prototype.addItemParentResolver = parameterfy(function(name, getElementFunction, getItemForIndexFunction, getItemIndexFunction, getParentAndItemFunction, targets) {
    var $jscomp$restParams = [];
    for (var $jscomp$restIndex = 5;$jscomp$restIndex < arguments.length;++$jscomp$restIndex) {
      $jscomp$restParams[$jscomp$restIndex - 5] = arguments[$jscomp$restIndex];
    }
    var targets$24 = $jscomp$restParams;
    if (targets$24) {
      __wrappedInstance.addItemParentResolver(name, getElementFunction, getItemForIndexFunction, getItemIndexFunction, getParentAndItemFunction, targets$24);
    } else {
      __wrappedInstance.addItemParentResolver(name, getElementFunction, getItemForIndexFunction, getItemIndexFunction, getParentAndItemFunction);
    }
  });
  WebResolvers.prototype.addItemResolver = parameterfy(function(name, getItemFunction, getItemCountFunction, getItemForIndexFunction, getItemLocationFunction, getItemSizeFunction, getItemValueFunction, repositionMouseEventFunction, scrollItemVisibleFunction, targets) {
    var $jscomp$restParams = [];
    for (var $jscomp$restIndex = 9;$jscomp$restIndex < arguments.length;++$jscomp$restIndex) {
      $jscomp$restParams[$jscomp$restIndex - 9] = arguments[$jscomp$restIndex];
    }
    var targets$25 = $jscomp$restParams;
    if (targets$25) {
      __wrappedInstance.addItemResolver(name, getItemFunction, getItemCountFunction, getItemForIndexFunction, getItemLocationFunction, getItemSizeFunction, getItemValueFunction, repositionMouseEventFunction, scrollItemVisibleFunction, targets$25);
    } else {
      __wrappedInstance.addItemResolver(name, getItemFunction, getItemCountFunction, getItemForIndexFunction, getItemLocationFunction, getItemSizeFunction, getItemValueFunction, repositionMouseEventFunction, scrollItemVisibleFunction);
    }
  });
  WebResolvers.prototype.addItemValueResolver = parameterfy(function(name, jsFunction, targets) {
    var $jscomp$restParams = [];
    for (var $jscomp$restIndex = 2;$jscomp$restIndex < arguments.length;++$jscomp$restIndex) {
      $jscomp$restParams[$jscomp$restIndex - 2] = arguments[$jscomp$restIndex];
    }
    var targets$26 = $jscomp$restParams;
    if (targets$26) {
      __wrappedInstance.addItemValueResolver(name, jsFunction, targets$26);
    } else {
      __wrappedInstance.addItemValueResolver(name, jsFunction);
    }
  });
  WebResolvers.prototype.addResolver = parameterfy(function(name, resolver, targets) {
    var $jscomp$restParams = [];
    for (var $jscomp$restIndex = 2;$jscomp$restIndex < arguments.length;++$jscomp$restIndex) {
      $jscomp$restParams[$jscomp$restIndex - 2] = arguments[$jscomp$restIndex];
    }
    var targets$27 = $jscomp$restParams;
    if (targets$27) {
      __wrappedInstance.addResolver(name, resolver, targets$27);
    } else {
      __wrappedInstance.addResolver(name, resolver);
    }
  });
  WebResolvers.prototype.removeResolver = parameterfy(function(name) {
    __wrappedInstance.removeResolver(name);
  });
  WebResolvers.prototype.removeAll = parameterfy(function() {
    __wrappedInstance.removeAll();
  });
  WebResolvers.prototype.listNames = parameterfy(function() {
    return __wrappedInstance.listNames();
  });
  return WebResolvers;
}();
var WebResolvers_export = new WebResolvers;
var $jscompDefaultExport = WebResolvers_export;
module$input.WebResolvers = WebResolvers_export;
module$input["default"] = $jscompDefaultExport;
