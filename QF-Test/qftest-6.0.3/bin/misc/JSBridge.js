// {{{ copyright

/********************************************************************
 *
 * Copyright (C) 2013 Quality First Software
 * All rights reserved
 *
 *******************************************************************/

// }}}

const I_NSIJSBRIDGE = Components.interfaces.nsIJSBridge;

const CLASS_ID = Components.ID("{B22C8488-E7CA-11DD-B1E0-F97255D89593}");

const CLASS_NAME = "Javascript bridge between meex2 and DOM";

const CONTRACT_ID = "@qftest.web.client_cid/jsbridge;1";

const LOGGER_CID = "@qftest.web.logger_cid/jscallback;1";

const nsISupports = Components.interfaces.nsISupports;

var aCS = Components.classes["@mozilla.org/consoleservice;1"].
                        getService(Components.interfaces.nsIConsoleService);

var _xpcom_utils_ = null;
try						
{
  Components.utils.import("resource://gre/modules/XPCOMUtils.jsm");  // Introduced in Gecko 1.9 (Firefox 3)
  _xpcom_utils_ = XPCOMUtils
  aCS.logStringMessage("XPCOMUtils.jsm was successful imported.");
}
catch(e) {
  aCS.logStringMessage("can't import XPCOMUtils.jsm ...");
}

try {
    var version = Components.classes["@mozilla.org/xre/app-info;1"]
            .getService(Components.interfaces.nsIXULAppInfo).version;
    aCS.logStringMessage("version: " + version);
    version = version.replace(/(\d+\.?\d*).*/, "$1");
    if (version >= 26) {
        const kTransferCid = Components.ID("{1b4c85df-cbdd-4bb6-b04e-613caece083c}");
        const kTransferContractId = "@mozilla.org/transfer;1";
        Components.manager.QueryInterface(Components.interfaces.nsIComponentRegistrar)
                .registerFactory(kTransferCid, "", kTransferContractId, null);
    }

    var _downloadListener = {
        dlListener: Components.classes["@qftest.web/downloadlistener;1"].getService(Components.interfaces.IDownloadListener),
        onDownloadChanged: function(download) {
            var status = 0;
            status = download.succeeded ? 1 : status;
            status = download.canceled ? 2 : status;
            status = download.error ? 3 : status;
            this.dlListener.onDownloadChanged(download.source.url, download.target.path,
                download.progress, status);
        },
        onDownloadAdded: function(download) {
            this.dlListener.onDownloadAdded(download.source.url, download.target.path);
        },
        onDownloadRemoved: function(download) {
            this.dlListener.onDownloadRemoved(download.source.url, download.target.path);
        },
	};
   
    Components.utils.import("resource://gre/modules/Downloads.jsm");
    Downloads.getList(Downloads.ALL).then(function onFulfill(list) {
            list.addView(_downloadListener);
        }, Components.utils.reportError);
}
catch(e) {
    aCS.logStringMessage("DownloadListener initialization failed: " + e);
}

const MEEX2_JS_HELPER_ID = "__meex2_js_helper__";
const MEEX2_JSEVENT = "Meex2JSEvent";


const MEEX2_JS_EVENT_HANDLER = "\
function __meex2_log(message)\
{\
    event = document.createEvent(\"Events\");\
    event.initEvent(\"logevent\",true,false); \
    target = document.getElementById(\"__meex2_js_helper__\");\
    target._message = message;\
    target.dispatchEvent(event);\
}\
function __meex2_evaluate(element,jscode)\
{\
 try\
 {\
   window.__meex2_retval = window.eval(jscode);\
 }\
 catch(e)\
 {\
   window.__meex2_error = e;\
 }\
}\
var __meex2_js_handler = \
{\
    init: function()\
    {\
        element = document.getElementById(\"__meex2_js_helper__\");\
        if (!element)\
        {\
         throw new exception(\"cant find meex2 hellper element\");\
        }\
        element.addEventListener(\"Meex2JSEvent\",function __meex2_EventHandler(event)\
        {\
          var jscode = null;\
          try { jscode = element.getAttribute(\"jscode\"); } catch(ex) {}\
          if (!jscode)\
          {\
             jscode = window.__meex2_jscode__;\
          }\
          __meex2_evaluate(element,jscode);\
        },true);\
    }\
};\
__meex2_js_handler.init();\
";

/****************************************************
class definition
****************************************************/

var logger;

function event_handler(event)
{
  if (logger)
  {
    try
    {
        target = event.target.wrappedJSObject ? event.target.wrappedJSObject : event.target ;
        logger.callback(target.ownerDocument.defaultView,target._message);
    }
    catch(e)
    {
        aCS.logStringMessage("exception:" + e);
    }
  }
  else
  {
    aCS.logStringMessage("logger is not accessible.");
  }
}

function JSBridge()
{
};

JSBridge.prototype =
{
        mRetval: "",
        mRettype: "",
        mError: "",
        mNode: null,
        mNodes: null,
        mWindow: null,
        get retval() {return this.mRetval;},
        get rettype() { return this.mRettype;},
        get error() { return this.mError;},
        get node() { return this.mNode;},
        get nodes() { return this.mNodes;},
        get window() { return this.mWindow;},

    getHelperElement: function(win)
    {
        var element = null;
        if (win && win.document && win.document.body)
        {
           element = win.document.getElementById(MEEX2_JS_HELPER_ID);
           if (!element)
           {
                element = win.document.createElement("div");
                element.setAttribute("id",MEEX2_JS_HELPER_ID );
                element.setAttribute("style", "display:none");

                var body = win.document.getElementsByTagName('body');
                if (body && body[0])
                {
                    body[0].appendChild(element);
                }
                else
                {
                    win.document.documentElement.appendChild(element);
                }

                element = win.document.createElement("script");
                element.setAttribute("type", "text/javascript");
                textNode = win.document.createTextNode(MEEX2_JS_EVENT_HANDLER);
                element.appendChild(textNode);

                var head = win.document.getElementsByTagName('head');
                if (head && head[0])
                {
                    head[0].appendChild(element);
                }
                else
                {
                    win.document.documentElement.appendChild(element);
                }

                win.document.addEventListener("logevent",event_handler,true);
                logger = Components.classes["@qftest.web.logger_cid/jscallback;1"].getService(Components.interfaces.IJSCallback);
                aCS.logStringMessage("js helper created. logger:" + logger);
           }
        }
        return element;
    },
    init: function(win)
    {
      if (this.getHelperElement(win))
      {
        return true;
      }
      return false;
    },
    eval: function(win,code)
    {
        this.mRetval = "";
        this.mRettype = "";
        this.mError = "";
        this.mNode = null;
        this.mNodes = null;
        this.mWindow = null;

        win = win.wrappedJSObject ? win.wrappedJSObject : win;

        element = this.getHelperElement(win);
        if (!element)
        {
            aCS.logStringMessage("helper element not found");
            this.mError = "helper element not found";
            return I_NSIJSBRIDGE.JSB_ERROR;
        }

        event = win.document.createEvent("Events");
        event.initEvent(MEEX2_JSEVENT,true,false);
        element.setAttribute("jscode",code);

        win.__meex2_retval = null;
        win.__meex2_error = null;
        win.__meex2_jscode__ = code;

        var res = element.dispatchEvent(event);
        win.__meex2_jscode__ = null;

        aCS.logStringMessage("event dispatched:" + res + ", value=" + win.__meex2_retval+ ", error=" + win.__meex2_error);


        if ( win.__meex2_error)
        {
            this.mError = win.__meex2_error;
            return I_NSIJSBRIDGE.JSB_ERROR;
        }
        this.mRetval = win.__meex2_retval;

        if (this.mRetval && this.mRetval.wrappedJSObject)
        {
            this.mRettype = typeof(this.mRetval.wrappedJSObject);
        }
        else
        {
            this.mRettype = typeof(this.mRetval);
        }
        //for backward compatibility of FF lower than 4.0
        if(!Array.isArray) {
            Array.isArray = function (vArg) {
               return Object.prototype.toString.call(vArg) === "[object Array]";
           };
        }
        if (Array.isArray(this.mRetval)) 
        {
            this.mNodes = Components.classes["@mozilla.org/array;1"].createInstance(Components.interfaces.nsIMutableArray);
            for (var i = 0; i < this.mRetval.length; ++i)
            {
                this.mNodes.appendElement(this.mRetval[i],false);
            }
            aCS.logStringMessage("length: " +  this.mNodes.length);
            return I_NSIJSBRIDGE.JSB_IS_ARRAY;
        }

        if (this.mRetval && this.mRetval.nodeType)
        {
           this.mNode = this.mRetval;
           return I_NSIJSBRIDGE.JSB_IS_DOM_NODE;
        }
        if (this.mRetval && this.mRetval.document && this.mRetval.document.defaultView == this.mRetval)
        {
           this.mWindow = this.mRetval;
           return I_NSIJSBRIDGE.JSB_IS_DOM_WINDOW;
        }

        return I_NSIJSBRIDGE.JSB_NO_ERROR;
    },
    defineVariableFor: function(win,node,varname)
    {
        try
        {
            win = win.wrappedJSObject ? win.wrappedJSObject : win;
            win[varname]=node.wrappedJSObject;
        }
        catch(error)
        {
          this.mError = error;
          return I_NSIJSBRIDGE.JSB_ERROR;
        }
        return I_NSIJSBRIDGE.JSB_NO_ERROR;
    },
	classID: Components.ID("{B22C8488-E7CA-11DD-B1E0-F97255D89593}"),
	//QueryInterface: XPCOMUtils.generateQI([Components.interfaces.nsIJSBridge])
    QueryInterface: function(aIID)
    {
		/*
		if (_xpcom_utils_ && _xpcom_utils_.generateQI)
		{
			return XPCOMUtils.generateQI([Components.interfaces.nsIJSBridge])
		}
		*/
        if (!aIID.equals(I_NSIJSBRIDGE) && !aIID.equals(nsISupports))
        {
            throw Components.results.NS_ERROR_NO_INTERFACE;
        }
     return this;
    }
};

/***********************************************************
class factory
***********************************************************/
var JSBridgeFactory =
{
    createInstance: function(aOuter, aIID)
    {
        if (aOuter != null)
        {
            throw Components.results.NS_ERROR_NO_AGGREGATION;
        }
        return (new JSBridge()).QueryInterface(aIID);
    }
};

/***********************************************************
module definition (xpcom registration)
***********************************************************/
var JSBridgeModule = {
  registerSelf: function(aCompMgr, aFileSpec, aLocation, aType)
  {
    aCompMgr = aCompMgr.QueryInterface(Components.interfaces.nsIComponentRegistrar);
    aCompMgr.registerFactoryLocation(CLASS_ID, CLASS_NAME,CONTRACT_ID, aFileSpec, aLocation, aType);
  },

  unregisterSelf: function(aCompMgr, aLocation, aType)
  {
    aCompMgr = aCompMgr.QueryInterface(Components.interfaces.nsIComponentRegistrar);
    aCompMgr.unregisterFactoryLocation(CLASS_ID, aLocation);
  },

  getClassObject: function(aCompMgr, aCID, aIID)
  {
    if (!aIID.equals(Components.interfaces.nsIFactory))
      throw Components.results.NS_ERROR_NOT_IMPLEMENTED;

    if (aCID.equals(CLASS_ID))
      return JSBridgeFactory;

    throw Components.results.NS_ERROR_NO_INTERFACE;
  },

  canUnload: function(aCompMgr) { return true; }
};

/***********************************************************
module initialization

When the application registers the component, this function
is called.
***********************************************************/
function NSGetModule(aCompMgr, aFileSpec) { return JSBridgeModule; } // module initialization for gecko  < 2.0
if (_xpcom_utils_ && _xpcom_utils_.generateNSGetFactory) // module initialization for gecko >= 2.0b6
{
	var NSGetFactory = XPCOMUtils.generateNSGetFactory([JSBridge]);
}
