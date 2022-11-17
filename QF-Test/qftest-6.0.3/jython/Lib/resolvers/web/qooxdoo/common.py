"""Common utilities used by all versions of the qooxdoo resolvers except where overridden."""

from de.qfs.apps.qftest.extensions import ResolverRegistry

# {{{ getWidgetProperty

def getWidgetProperty(node, propName):
    node.toJS("_myNode")
    js = """
        function _getProperty(node)
        {
            try {
                var hash = node.getAttribute("$$widget");
                if (hash == null) {
                    hash = node.$$widget;
                }
                if (hash) {
                    widget = this.qx.core.ObjectRegistry.fromHashCode(hash);
                    if (widget) {
                        v = widget["%s"];
                        return v;
                    }
                }
            }
            catch(e) {
            }
            return "";
        }
        _getProperty(_myNode);""" %(propName)
    value = node.evalJS(js)
    return value

# }}}
# {{{ invokeWidgetMethod

def invokeWidgetMethod(node, methodName, *args):
    node.toJS("_myNode")
    jargs = "widget"
    for arg in args:
        jargs += ", " + str(arg)
    js = """
        function _invoke(node)
        {
            try {
                var hash = node.getAttribute("$$widget");
                if (hash == null) {
                    hash = node.$$widget;
                }
                if (hash) {
                    widget = this.qx.core.ObjectRegistry.fromHashCode(hash);
                    if (widget) {
                        v = widget["%s"];
                        if (typeof(v) == "function") {
                            return v.call(%s);
                        }
                        return v;
                    }
                }
            }
            catch(e) {
                alert(e);
            }
            return "";
        }
        _invoke(_myNode);""" %(methodName, jargs)
    value = node.evalJS(js)
    return value

# }}}
# {{{ getQxClass

def getQxClass(node):
    # clazz = node.getProperty("qxClass")
    # if clazz == "":
        # return None
    # if clazz:
        # return clazz

    clazz = node.getAttribute("qxClass")
    if not clazz:
        clazz = getWidgetProperty(node, "classname")
    if not clazz:
        node.toJS("_myNode")
        clazz = node.evalJS("""try { _myNode.qx_Widget.classname } catch(e) { null }""")

    if clazz:
        node.setProperty("qxClass", clazz)
    else:
        node.setProperty("qxClass", "")
    return clazz

# }}}
# {{{ _collect

def _collect(node, filterProc, l=[]):
    if apply(filterProc, [node]):
        l.append(node)
    for c in node.getChildren():
        _collect(c, filterProc, l)
    return l

# }}}
# {{{ getElementsByQxClass

def getElementsByQxClass(node, qxClass):
    l = _collect(node, lambda n: getQxClass(n) == qxClass)
    try:
        l.remove(node)
    except:
        pass
    return l

# }}}
# {{{ getNodeText

def getNodeText(node):
    try:
        lbl = node.getElementsByTagName("LABEL")[0]
        text = ResolverRegistry.instance().getFeature(lbl, ["LABEL"])
    except:
        text = node.getText()
    if text:
        return text.strip()

# }}}
# {{{ findQxLabels

def findQxLabels(node, labels=[]):
    qxClass = getQxClass(node)
    if qxClass == "qx.ui.basic.Label":
        labels.append(node)
    for c in node.getChildren():
        findQxLabels(c, labels)
    return labels

# }}}
# {{{ tree_getAllItems

def tree_getAllItems(tree):
    tree.toJS("_myTree")
    res = tree.evalJS("""
        function tree_getItems(node, result, indent)
        {
            result.push(indent + node.getLabel());
            var items = node.getChildren();
            for (var i = 0; i < items.length; i++) {
                tree_getItems(items[i], result, indent + "    ");
            }
            return result;
        }

        function tree_getAllItems(myTree)
        {
            var flat = false;
            var tree = this.qx.core.ObjectRegistry.fromHashCode(myTree.$$widget);
            var s = "";
            if (flat) {
                var items = tree.getItems();
                for (i = 0; i < items.length; i++) {
                    s += items[i].getLabel() + "\\n";
                }
            }
            else {
                var root = tree.getRoot();
                var items = tree_getItems(root, [], "");
                for (i = 0; i < items.length; i++) {
                    s += items[i] + "\\n";
                }
            }
            return s;
        }
        tree_getAllItems(_myTree);""")
    print res

# }}}
# {{{ tree_expandNode

def tree_expandNode(tree, path):
    tree.toJS("_myTree")
    tree.evalJS("""
        function tree_expandNode(myTree, path)
        {
            var nodeNames = path.split("/");
            var tree = this.qx.core.ObjectRegistry.fromHashCode(myTree.$$widget);
            var parent = tree.getRoot();
            for (var i = 0; i < nodeNames.length; i++) {
                var name = nodeNames[i];
                if (name.length > 0) {
                    var nodes = parent.getChildren();
                    for (var j = 0; j < nodes.length; j++) {
                        if (nodes[j].getLabel() == name) {
                            if (i == nodeNames.length - 1) {
                                tree.select(nodes[j]);
                                return;
                            }
                            nodes[j].setOpen(true);
                            parent = nodes[j];
                            break;
                        }
                    }
                }
            }
        }
        tree_expandNode(_myTree, "%s");""" %(path))

# }}}

# ----------------------
# ----------------------

from de.qfs.apps.qftest.extensions.items import ItemRegistry, ItemResolver, ItemParentResolver
import jarray

# {{{

class TreeItemResolver(ItemResolver, ItemParentResolver):
    def __init__(self):
        print "TreeItemResolver created"
        pass

    def getParentAndItem(self, element):
        print element.getName()
        #print element.getAttribute("qxClass")

    def getItem(self, tree, x, y):
        print "foo"
#        clazz = getQxClass(tree)
#        if clazz != "qx.ui.tree.Tree":
#            return None

    def getItemIndex(self, tree, item):
        return None

    def getItemForIndex(self, tree, idx):
        return None

    def getItemLocation(self, tree, item):
        return jarray.array([0, 0], i)

    def getItemSize(self, tree, item):
        return jarray.array([0, 0], i)

    def getItemValue(self, tree, item):
        return "foo"

    def repositionMouseEvent(self, tree, item, pos):
        pass

    def getItemCount(self, tree, item):
        return 0

    def scrollItemVisible(self, tree, item):
        return None

# }}}

global treeItemResolver

try:
    ItemRegistry.instance().unregisterItemParentResolver("P", treeItemResolver)
    ItemRegistry.instance().unregisterItemResolver("DIV", treeItemResolver)
except:
    pass

#treeItemResolver = TreeItemResolver()
#ItemRegistry.instance().registerItemParentResolver("P", treeItemResolver)
#ItemRegistry.instance().registerItemResolver("DIV", treeItemResolver)
