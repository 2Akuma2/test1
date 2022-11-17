exports.__esModule = true;
var module$input = exports;
Resolvers = function() {
  _WrappedResolvers = Java.type("de.qfs.apps.qftest.client.script.modules.Resolvers");
  Resolvers.STATE_IGNORE = Resolvers.prototype.STATE_IGNORE = _WrappedResolvers.STATE_IGNORE;
  Resolvers.STATE_SHOULD_MATCH = Resolvers.prototype.STATE_SHOULD_MATCH = _WrappedResolvers.STATE_SHOULD_MATCH;
  Resolvers.STATE_MUST_MATCH = Resolvers.prototype.STATE_MUST_MATCH = _WrappedResolvers.STATE_MUST_MATCH;
  var __wrappedInstance;
  function Resolvers() {
    __wrappedInstance = _WrappedResolvers.instance();
  }
  Resolvers.prototype.addResolver = parameterfy(function(name, resolver, targets) {
    var $jscomp$restParams = [];
    for (var $jscomp$restIndex = 2;$jscomp$restIndex < arguments.length;++$jscomp$restIndex) {
      $jscomp$restParams[$jscomp$restIndex - 2] = arguments[$jscomp$restIndex];
    }
    var targets$0 = $jscomp$restParams;
    if (targets$0) {
      __wrappedInstance.addResolver(name, resolver, targets$0);
    } else {
      __wrappedInstance.addResolver(name, resolver);
    }
  });
  Resolvers.prototype.addBusyPaneResolver = parameterfy(function(name, method, targets) {
    var $jscomp$restParams = [];
    for (var $jscomp$restIndex = 2;$jscomp$restIndex < arguments.length;++$jscomp$restIndex) {
      $jscomp$restParams[$jscomp$restIndex - 2] = arguments[$jscomp$restIndex];
    }
    var targets$1 = $jscomp$restParams;
    if (targets$1) {
      __wrappedInstance.addBusyPaneResolver(name, method, targets$1);
    } else {
      __wrappedInstance.addBusyPaneResolver(name, method);
    }
  });
  Resolvers.prototype.addClassNameResolver = parameterfy(function(name, method, targets) {
    var $jscomp$restParams = [];
    for (var $jscomp$restIndex = 2;$jscomp$restIndex < arguments.length;++$jscomp$restIndex) {
      $jscomp$restParams[$jscomp$restIndex - 2] = arguments[$jscomp$restIndex];
    }
    var targets$2 = $jscomp$restParams;
    if (targets$2) {
      __wrappedInstance.addClassNameResolver(name, method, targets$2);
    } else {
      __wrappedInstance.addClassNameResolver(name, method);
    }
  });
  Resolvers.prototype.addComponentRecordingFilter = parameterfy(function(name, method, targets) {
    var $jscomp$restParams = [];
    for (var $jscomp$restIndex = 2;$jscomp$restIndex < arguments.length;++$jscomp$restIndex) {
      $jscomp$restParams[$jscomp$restIndex - 2] = arguments[$jscomp$restIndex];
    }
    var targets$3 = $jscomp$restParams;
    if (targets$3) {
      __wrappedInstance.addComponentRecordingFilter(name, method, targets$3);
    } else {
      __wrappedInstance.addComponentRecordingFilter(name, method);
    }
  });
  Resolvers.prototype.addElementInfoResolver = parameterfy(function(name, method, targets) {
    var $jscomp$restParams = [];
    for (var $jscomp$restIndex = 2;$jscomp$restIndex < arguments.length;++$jscomp$restIndex) {
      $jscomp$restParams[$jscomp$restIndex - 2] = arguments[$jscomp$restIndex];
    }
    var targets$4 = $jscomp$restParams;
    if (targets$4) {
      __wrappedInstance.addElementInfoResolver(name, method, targets$4);
    } else {
      __wrappedInstance.addElementInfoResolver(name, method);
    }
  });
  Resolvers.prototype.addEnabledResolver = parameterfy(function(name, method, targets) {
    var $jscomp$restParams = [];
    for (var $jscomp$restIndex = 2;$jscomp$restIndex < arguments.length;++$jscomp$restIndex) {
      $jscomp$restParams[$jscomp$restIndex - 2] = arguments[$jscomp$restIndex];
    }
    var targets$5 = $jscomp$restParams;
    if (targets$5) {
      __wrappedInstance.addEnabledResolver(name, method, targets$5);
    } else {
      __wrappedInstance.addEnabledResolver(name, method);
    }
  });
  Resolvers.prototype.addEventSynchronizer = parameterfy(function(name, method, engines) {
    var $jscomp$restParams = [];
    for (var $jscomp$restIndex = 2;$jscomp$restIndex < arguments.length;++$jscomp$restIndex) {
      $jscomp$restParams[$jscomp$restIndex - 2] = arguments[$jscomp$restIndex];
    }
    var engines$6 = $jscomp$restParams;
    if (engines$6) {
      __wrappedInstance.addEventSynchronizer(name, method, engines$6);
    } else {
      __wrappedInstance.addEventSynchronizer(name, method);
    }
  });
  Resolvers.prototype.addBusyApplicationDetector = parameterfy(function(name, method, engines) {
    var $jscomp$restParams = [];
    for (var $jscomp$restIndex = 2;$jscomp$restIndex < arguments.length;++$jscomp$restIndex) {
      $jscomp$restParams[$jscomp$restIndex - 2] = arguments[$jscomp$restIndex];
    }
    var engines$7 = $jscomp$restParams;
    if (engines$7) {
      __wrappedInstance.addBusyApplicationDetector(name, method, engines$7);
    } else {
      __wrappedInstance.addBusyApplicationDetector(name, method);
    }
  });
  Resolvers.prototype.addExtraFeatureMatcher = parameterfy(function(name, method, targets) {
    var $jscomp$restParams = [];
    for (var $jscomp$restIndex = 2;$jscomp$restIndex < arguments.length;++$jscomp$restIndex) {
      $jscomp$restParams[$jscomp$restIndex - 2] = arguments[$jscomp$restIndex];
    }
    var targets$8 = $jscomp$restParams;
    if (targets$8) {
      __wrappedInstance.addExtraFeatureMatcher(name, method, targets$8);
    } else {
      __wrappedInstance.addExtraFeatureMatcher(name, method);
    }
  });
  Resolvers.prototype.addSpecificExtraFeatureMatcher = parameterfy(function(name, method, featureName, targets) {
    var $jscomp$restParams = [];
    for (var $jscomp$restIndex = 3;$jscomp$restIndex < arguments.length;++$jscomp$restIndex) {
      $jscomp$restParams[$jscomp$restIndex - 3] = arguments[$jscomp$restIndex];
    }
    var targets$9 = $jscomp$restParams;
    if (targets$9) {
      __wrappedInstance.addSpecificExtraFeatureMatcher(name, method, featureName, targets$9);
    } else {
      __wrappedInstance.addSpecificExtraFeatureMatcher(name, method, featureName);
    }
  });
  Resolvers.prototype.addExtraFeatureResolver = parameterfy(function(name, method, targets) {
    var $jscomp$restParams = [];
    for (var $jscomp$restIndex = 2;$jscomp$restIndex < arguments.length;++$jscomp$restIndex) {
      $jscomp$restParams[$jscomp$restIndex - 2] = arguments[$jscomp$restIndex];
    }
    var targets$10 = $jscomp$restParams;
    if (targets$10) {
      __wrappedInstance.addExtraFeatureResolver(name, method, targets$10);
    } else {
      __wrappedInstance.addExtraFeatureResolver(name, method);
    }
  });
  Resolvers.prototype.addFallbackClassNameResolver = parameterfy(function(name, method, targets) {
    var $jscomp$restParams = [];
    for (var $jscomp$restIndex = 2;$jscomp$restIndex < arguments.length;++$jscomp$restIndex) {
      $jscomp$restParams[$jscomp$restIndex - 2] = arguments[$jscomp$restIndex];
    }
    var targets$11 = $jscomp$restParams;
    if (targets$11) {
      __wrappedInstance.addFallbackClassNameResolver(name, method, targets$11);
    } else {
      __wrappedInstance.addFallbackClassNameResolver(name, method);
    }
  });
  Resolvers.prototype.addFeatureResolver = parameterfy(function(name, method, targets) {
    var $jscomp$restParams = [];
    for (var $jscomp$restIndex = 2;$jscomp$restIndex < arguments.length;++$jscomp$restIndex) {
      $jscomp$restParams[$jscomp$restIndex - 2] = arguments[$jscomp$restIndex];
    }
    var targets$12 = $jscomp$restParams;
    if (targets$12) {
      __wrappedInstance.addFeatureResolver(name, method, targets$12);
    } else {
      __wrappedInstance.addFeatureResolver(name, method);
    }
  });
  Resolvers.prototype.addFeatureResolver2 = parameterfy(function(name, method, targets) {
    var $jscomp$restParams = [];
    for (var $jscomp$restIndex = 2;$jscomp$restIndex < arguments.length;++$jscomp$restIndex) {
      $jscomp$restParams[$jscomp$restIndex - 2] = arguments[$jscomp$restIndex];
    }
    var targets$13 = $jscomp$restParams;
    if (targets$13) {
      __wrappedInstance.addFeatureResolver2(name, method, targets$13);
    } else {
      __wrappedInstance.addFeatureResolver2(name, method);
    }
  });
  Resolvers.prototype.addGenericClassNameResolver = parameterfy(function(name, method, targets) {
    var $jscomp$restParams = [];
    for (var $jscomp$restIndex = 2;$jscomp$restIndex < arguments.length;++$jscomp$restIndex) {
      $jscomp$restParams[$jscomp$restIndex - 2] = arguments[$jscomp$restIndex];
    }
    var targets$14 = $jscomp$restParams;
    if (targets$14) {
      __wrappedInstance.addGenericClassNameResolver(name, method, targets$14);
    } else {
      __wrappedInstance.addGenericClassNameResolver(name, method);
    }
  });
  Resolvers.prototype.addElementResolver = parameterfy(function(name, method, targets) {
    var $jscomp$restParams = [];
    for (var $jscomp$restIndex = 2;$jscomp$restIndex < arguments.length;++$jscomp$restIndex) {
      $jscomp$restParams[$jscomp$restIndex - 2] = arguments[$jscomp$restIndex];
    }
    var targets$15 = $jscomp$restParams;
    if (targets$15) {
      __wrappedInstance.addElementResolver(name, method, targets$15);
    } else {
      __wrappedInstance.addElementResolver(name, method);
    }
  });
  Resolvers.prototype.addGlassPaneResolver = parameterfy(function(name, method, targets) {
    var $jscomp$restParams = [];
    for (var $jscomp$restIndex = 2;$jscomp$restIndex < arguments.length;++$jscomp$restIndex) {
      $jscomp$restParams[$jscomp$restIndex - 2] = arguments[$jscomp$restIndex];
    }
    var targets$16 = $jscomp$restParams;
    if (targets$16) {
      __wrappedInstance.addGlassPaneResolver(name, method, targets$16);
    } else {
      __wrappedInstance.addGlassPaneResolver(name, method);
    }
  });
  Resolvers.prototype.addIdResolver = parameterfy(function(name, method, targets) {
    var $jscomp$restParams = [];
    for (var $jscomp$restIndex = 2;$jscomp$restIndex < arguments.length;++$jscomp$restIndex) {
      $jscomp$restParams[$jscomp$restIndex - 2] = arguments[$jscomp$restIndex];
    }
    var targets$17 = $jscomp$restParams;
    if (targets$17) {
      __wrappedInstance.addIdResolver(name, method, targets$17);
    } else {
      __wrappedInstance.addIdResolver(name, method);
    }
  });
  Resolvers.prototype.addInterestingParentResolver = parameterfy(function(name, method, targets) {
    var $jscomp$restParams = [];
    for (var $jscomp$restIndex = 2;$jscomp$restIndex < arguments.length;++$jscomp$restIndex) {
      $jscomp$restParams[$jscomp$restIndex - 2] = arguments[$jscomp$restIndex];
    }
    var targets$18 = $jscomp$restParams;
    if (targets$18) {
      __wrappedInstance.addInterestingParentResolver(name, method, targets$18);
    } else {
      __wrappedInstance.addInterestingParentResolver(name, method);
    }
  });
  Resolvers.prototype.addIndexBasedItemNameResolver = parameterfy(function(name, method, targets) {
    var $jscomp$restParams = [];
    for (var $jscomp$restIndex = 2;$jscomp$restIndex < arguments.length;++$jscomp$restIndex) {
      $jscomp$restParams[$jscomp$restIndex - 2] = arguments[$jscomp$restIndex];
    }
    var targets$19 = $jscomp$restParams;
    if (targets$19) {
      __wrappedInstance.addIndexBasedItemNameResolver(name, method, targets$19);
    } else {
      __wrappedInstance.addIndexBasedItemNameResolver(name, method);
    }
  });
  Resolvers.prototype.addMainTextResolver = parameterfy(function(name, method, targets) {
    var $jscomp$restParams = [];
    for (var $jscomp$restIndex = 2;$jscomp$restIndex < arguments.length;++$jscomp$restIndex) {
      $jscomp$restParams[$jscomp$restIndex - 2] = arguments[$jscomp$restIndex];
    }
    var targets$20 = $jscomp$restParams;
    if (targets$20) {
      __wrappedInstance.addMainTextResolver(name, method, targets$20);
    } else {
      __wrappedInstance.addMainTextResolver(name, method);
    }
  });
  Resolvers.prototype.addNameResolver = parameterfy(function(name, method, targets) {
    var $jscomp$restParams = [];
    for (var $jscomp$restIndex = 2;$jscomp$restIndex < arguments.length;++$jscomp$restIndex) {
      $jscomp$restParams[$jscomp$restIndex - 2] = arguments[$jscomp$restIndex];
    }
    var targets$21 = $jscomp$restParams;
    if (targets$21) {
      __wrappedInstance.addNameResolver(name, method, targets$21);
    } else {
      __wrappedInstance.addNameResolver(name, method);
    }
  });
  Resolvers.prototype.addNameResolver2 = parameterfy(function(name, method, targets) {
    var $jscomp$restParams = [];
    for (var $jscomp$restIndex = 2;$jscomp$restIndex < arguments.length;++$jscomp$restIndex) {
      $jscomp$restParams[$jscomp$restIndex - 2] = arguments[$jscomp$restIndex];
    }
    var targets$22 = $jscomp$restParams;
    if (targets$22) {
      __wrappedInstance.addNameResolver2(name, method, targets$22);
    } else {
      __wrappedInstance.addNameResolver2(name, method);
    }
  });
  Resolvers.prototype.addOverrideClassesResolver = parameterfy(function(name, method, targets) {
    var $jscomp$restParams = [];
    for (var $jscomp$restIndex = 2;$jscomp$restIndex < arguments.length;++$jscomp$restIndex) {
      $jscomp$restParams[$jscomp$restIndex - 2] = arguments[$jscomp$restIndex];
    }
    var targets$23 = $jscomp$restParams;
    if (targets$23) {
      __wrappedInstance.addOverrideClassesResolver(name, method, targets$23);
    } else {
      __wrappedInstance.addOverrideClassesResolver(name, method);
    }
  });
  Resolvers.prototype.addRedirectResolver = parameterfy(function(name, method, targets) {
    var $jscomp$restParams = [];
    for (var $jscomp$restIndex = 2;$jscomp$restIndex < arguments.length;++$jscomp$restIndex) {
      $jscomp$restParams[$jscomp$restIndex - 2] = arguments[$jscomp$restIndex];
    }
    var targets$24 = $jscomp$restParams;
    if (targets$24) {
      __wrappedInstance.addRedirectResolver(name, method, targets$24);
    } else {
      __wrappedInstance.addRedirectResolver(name, method);
    }
  });
  Resolvers.prototype.addScrollOffsetResolver = parameterfy(function(name, fromScrolledLocationMethod, toScrolledLocationMethod, targets) {
    var $jscomp$restParams = [];
    for (var $jscomp$restIndex = 3;$jscomp$restIndex < arguments.length;++$jscomp$restIndex) {
      $jscomp$restParams[$jscomp$restIndex - 3] = arguments[$jscomp$restIndex];
    }
    var targets$25 = $jscomp$restParams;
    if (targets$25) {
      __wrappedInstance.addScrollOffsetResolver(name, fromScrolledLocationMethod, toScrolledLocationMethod, targets$25);
    } else {
      __wrappedInstance.addScrollOffsetResolver(name, fromScrolledLocationMethod, toScrolledLocationMethod);
    }
  });
  Resolvers.prototype.addTableWithItemsResolver = parameterfy(function(name, method, targets) {
    var $jscomp$restParams = [];
    for (var $jscomp$restIndex = 2;$jscomp$restIndex < arguments.length;++$jscomp$restIndex) {
      $jscomp$restParams[$jscomp$restIndex - 2] = arguments[$jscomp$restIndex];
    }
    var targets$26 = $jscomp$restParams;
    if (targets$26) {
      __wrappedInstance.addTableWithItemsResolver(name, method, targets$26);
    } else {
      __wrappedInstance.addTableWithItemsResolver(name, method);
    }
  });
  Resolvers.prototype.addTooltipResolver = parameterfy(function(name, method, targets) {
    var $jscomp$restParams = [];
    for (var $jscomp$restIndex = 2;$jscomp$restIndex < arguments.length;++$jscomp$restIndex) {
      $jscomp$restParams[$jscomp$restIndex - 2] = arguments[$jscomp$restIndex];
    }
    var targets$27 = $jscomp$restParams;
    if (targets$27) {
      __wrappedInstance.addTooltipResolver(name, method, targets$27);
    } else {
      __wrappedInstance.addTooltipResolver(name, method);
    }
  });
  Resolvers.prototype.addTreeTableResolver = parameterfy(function(name, getTreeMethod, getTreeColumnMethod, target) {
    if (getTreeColumnMethod === undefined) {
      getTreeColumnMethod = null;
    }
    if (target === undefined) {
      target = null;
    }
    __wrappedInstance.addTreeTableResolver(name, getTreeMethod, getTreeColumnMethod, target);
  });
  Resolvers.prototype.addVisibilityResolver = parameterfy(function(name, method, targets) {
    var $jscomp$restParams = [];
    for (var $jscomp$restIndex = 2;$jscomp$restIndex < arguments.length;++$jscomp$restIndex) {
      $jscomp$restParams[$jscomp$restIndex - 2] = arguments[$jscomp$restIndex];
    }
    var targets$28 = $jscomp$restParams;
    if (targets$28) {
      __wrappedInstance.addVisibilityResolver(name, method, targets$28);
    } else {
      __wrappedInstance.addVisibilityResolver(name, method);
    }
  });
  Resolvers.prototype.addWholeTextResolver = parameterfy(function(name, method, targets) {
    var $jscomp$restParams = [];
    for (var $jscomp$restIndex = 2;$jscomp$restIndex < arguments.length;++$jscomp$restIndex) {
      $jscomp$restParams[$jscomp$restIndex - 2] = arguments[$jscomp$restIndex];
    }
    var targets$29 = $jscomp$restParams;
    if (targets$29) {
      __wrappedInstance.addWholeTextResolver(name, method, targets$29);
    } else {
      __wrappedInstance.addWholeTextResolver(name, method);
    }
  });
  Resolvers.prototype.addItemNameMatcher = parameterfy(function(name, method, targets) {
    var $jscomp$restParams = [];
    for (var $jscomp$restIndex = 2;$jscomp$restIndex < arguments.length;++$jscomp$restIndex) {
      $jscomp$restParams[$jscomp$restIndex - 2] = arguments[$jscomp$restIndex];
    }
    var targets$30 = $jscomp$restParams;
    if (targets$30) {
      __wrappedInstance.addItemNameMatcher(name, method, targets$30);
    } else {
      __wrappedInstance.addItemNameMatcher(name, method);
    }
  });
  Resolvers.prototype.addItemNameResolver = parameterfy(function(name, method, targets) {
    var $jscomp$restParams = [];
    for (var $jscomp$restIndex = 2;$jscomp$restIndex < arguments.length;++$jscomp$restIndex) {
      $jscomp$restParams[$jscomp$restIndex - 2] = arguments[$jscomp$restIndex];
    }
    var targets$31 = $jscomp$restParams;
    if (targets$31) {
      __wrappedInstance.addItemNameResolver(name, method, targets$31);
    } else {
      __wrappedInstance.addItemNameResolver(name, method);
    }
  });
  Resolvers.prototype.addItemNameResolver2 = parameterfy(function(name, method, targets) {
    var $jscomp$restParams = [];
    for (var $jscomp$restIndex = 2;$jscomp$restIndex < arguments.length;++$jscomp$restIndex) {
      $jscomp$restParams[$jscomp$restIndex - 2] = arguments[$jscomp$restIndex];
    }
    var targets$32 = $jscomp$restParams;
    if (targets$32) {
      __wrappedInstance.addItemNameResolver2(name, method, targets$32);
    } else {
      __wrappedInstance.addItemNameResolver2(name, method);
    }
  });
  Resolvers.prototype.addItemParentResolver = parameterfy(function(name, getElementMethod, getItemForIndexMethod, getItemIndexMethod, getParentAndItemMethod, targets) {
    var $jscomp$restParams = [];
    for (var $jscomp$restIndex = 5;$jscomp$restIndex < arguments.length;++$jscomp$restIndex) {
      $jscomp$restParams[$jscomp$restIndex - 5] = arguments[$jscomp$restIndex];
    }
    var targets$33 = $jscomp$restParams;
    if (targets$33) {
      __wrappedInstance.addItemParentResolver(name, getElementMethod, getItemForIndexMethod, getItemIndexMethod, getParentAndItemMethod, targets$33);
    } else {
      __wrappedInstance.addItemParentResolver(name, getElementMethod, getItemForIndexMethod, getItemIndexMethod, getParentAndItemMethod);
    }
  });
  Resolvers.prototype.addItemResolver = parameterfy(function(name, getItemMethod, getItemCountMethod, getItemForIndexMethod, getItemLocationMethod, getItemSizeMethod, getItemValueMethod, repositionMouseEventMethod, scrollItemVisibleMethod, targets) {
    var $jscomp$restParams = [];
    for (var $jscomp$restIndex = 9;$jscomp$restIndex < arguments.length;++$jscomp$restIndex) {
      $jscomp$restParams[$jscomp$restIndex - 9] = arguments[$jscomp$restIndex];
    }
    var targets$34 = $jscomp$restParams;
    if (targets$34) {
      __wrappedInstance.addItemResolver(name, getItemMethod, getItemCountMethod, getItemForIndexMethod, getItemLocationMethod, getItemSizeMethod, getItemValueMethod, repositionMouseEventMethod, scrollItemVisibleMethod, targets$34);
    } else {
      __wrappedInstance.addItemResolver(name, getItemMethod, getItemCountMethod, getItemForIndexMethod, getItemLocationMethod, getItemSizeMethod, getItemValueMethod, repositionMouseEventMethod, scrollItemVisibleMethod);
    }
  });
  Resolvers.prototype.addItemValueResolver = parameterfy(function(name, method, targets) {
    var $jscomp$restParams = [];
    for (var $jscomp$restIndex = 2;$jscomp$restIndex < arguments.length;++$jscomp$restIndex) {
      $jscomp$restParams[$jscomp$restIndex - 2] = arguments[$jscomp$restIndex];
    }
    var targets$35 = $jscomp$restParams;
    if (targets$35) {
      __wrappedInstance.addItemValueResolver(name, method, targets$35);
    } else {
      __wrappedInstance.addItemValueResolver(name, method);
    }
  });
  Resolvers.prototype.addItemValueResolver2 = parameterfy(function(name, method, targets) {
    var $jscomp$restParams = [];
    for (var $jscomp$restIndex = 2;$jscomp$restIndex < arguments.length;++$jscomp$restIndex) {
      $jscomp$restParams[$jscomp$restIndex - 2] = arguments[$jscomp$restIndex];
    }
    var targets$36 = $jscomp$restParams;
    if (targets$36) {
      __wrappedInstance.addItemValueResolver2(name, method, targets$36);
    } else {
      __wrappedInstance.addItemValueResolver2(name, method);
    }
  });
  Resolvers.prototype.removeResolver = parameterfy(function(name) {
    __wrappedInstance.removeResolver(name);
  });
  Resolvers.prototype.removeAll = parameterfy(function() {
    __wrappedInstance.removeAll();
  });
  Resolvers.prototype.listNames = parameterfy(function() {
    return __wrappedInstance.listNames();
  });
  Resolvers.prototype.setApiLevel = parameterfy(function(level) {
    __wrappedInstance.setApiLevel(level);
  });
  return Resolvers;
}();
var Resolvers_export = new Resolvers;
var $jscompDefaultExport = Resolvers_export;
module$input.Resolvers = Resolvers_export;
module$input["default"] = $jscompDefaultExport;
