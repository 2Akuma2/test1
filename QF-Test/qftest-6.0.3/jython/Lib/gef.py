
# {{{ imports

import jarray
import re
import traceback
from java.lang import Boolean, Class
from de.qfs.lib.util import Reflector, Misc, Pair
from de.qfs.apps.qftest.client import Engine
from de.qfs.apps.qftest.shared.data import SubItemIndex
from de.qfs.apps.qftest.shared.data.check import StringCheckData, BooleanCheckData, GeometryCheckData, ImageCheckData
from de.qfs.apps.qftest.shared.exceptions import IndexNotFoundException
from de.qfs.apps.qftest.shared.extensions.image import BaseImageHandler
from de.qfs.apps.qftest.extensions import ResolverRegistry
from de.qfs.apps.qftest.extensions.items import ItemRegistry, ItemResolver
from de.qfs.apps.qftest.extensions.checks import CheckerRegistry, Checker, CheckDataType, CheckType, DefaultCheckType
import qf

# }}}
# {{{ constants

STRING = 0
NUMBER = 1
REGEXP = 2
INTELLIGENT = 1
AS_STRING = 2
AS_NUMBER = 3
PATHSEP = "/"
QUOTE_STD = "\\#@&%"
QUOTE_SEP = QUOTE_STD + PATHSEP

SELECTED = 1
SELECTED_PRIMARY = 2

BUILD = "131106"

# }}}
# {{{ getGefEditor

def getGefEditor(shell):
    wbw = shell.getData()
    pages = wbw.getPages()
    for i in range(len(pages)):
        wbp = pages[i]
        editor = wbp.getActiveEditor()
        if editor != None:
            if ResolverRegistry.isInstance(editor, "org.eclipse.ui.part.MultiPageEditorPart"):
                editor = Reflector.call(editor, "getActiveEditor", 1)
            return editor
    return None

# }}}
# {{{ getShell

def getShell(com):
    while com != None:
        if ResolverRegistry.isInstance(com, "org.eclipse.swt.widgets.Shell"):
            break
        com = com.getParent()
    return com

# }}}
# {{{ intarray

def intarray(*args):
    return jarray.array(args, 'i')

# }}}

# {{{ CheckTypes

ObjectValueCheckType = DefaultCheckType("object_value", CheckDataType.STRING, "Object value")
ObjectSelectedCheckType = DefaultCheckType("object_selected", CheckDataType.BOOLEAN, "Object selected")
ObjectGeometryCheckType = DefaultCheckType("object_geometry", CheckDataType.GEOMETRY, "Object geometry")
ObjectImageCheckType = DefaultCheckType("object_image", CheckDataType.IMAGE, "Object image")

# }}}

class GefResolver(ItemResolver, Checker):
    # {{{ __init__

    def __init__(self):
        self.__graphicalViewer = None
        self.__paletteViewer = None
        self.__Point = None
        self.__LayerManager = None
        self.__paletteViewerInView = 0
        self.__predefinedViewer = None
        self.__editorNotFoundPrinted = False

    # }}}
    # {{{ setViewer

    def setViewer(self, viewer):
        self.__predefinedViewer = viewer
        self.__graphicalViewer = viewer

    # }}}
    # --------------------------------------------------------------------------------------------
    # ItemResolver interface
    # --------------------------------------------------------------------------------------------
    # {{{ getItem

    # y=None is a fallback for the old ItemResolver interface where getItemForIndex was
    # also named getItem
    def getItem(self, figureCanvas, x, y=None):
        if not qf.getClassName(figureCanvas).endswith("FigureCanvas"):
            # Do not handle a derived canvas here (like zest's Graph)
            return None
        if y is None:
            return self.getItemForIndex(figureCanvas, x)
        viewer = self._getViewer(figureCanvas)
        if not viewer:
            return None
        try:
            layerManager = viewer.getEditPartRegistry().get(self.__LayerManager.ID)
            scalableLayer = layerManager.getLayer("Scalable Layers")
            p = self.__Point(x, y)
            scalableLayer.translateToAbsolute(p)
        except:
            # Just another means to get the same result
            viewport = figureCanvas.getViewport()
            xoff = viewport.getHorizontalRangeModel().getValue()
            yoff = viewport.getVerticalRangeModel().getValue()
            p = self.__Point(x - xoff, y - yoff)
        editPart = viewer.findObjectAt(p)
        root = self._getRootEditPart(figureCanvas)
        if editPart == root or editPart == root.getParent():
            return None
        return editPart

    # }}}
    # {{{ getItemValue

    def getItemValue(self, figureCanvas, item):
        value = self._getDefaultItemName(item)
        return value

    # }}}
    # {{{ getItemForIndex

    def getItemForIndex(self, figureCanvas, idx):
        if not qf.getClassName(figureCanvas).endswith("FigureCanvas"):
            # Do not handle a derived canvas here (like zest's Graph)
            return None
        path = []
        tPath = idx[0].getIndex()

        isConnection = not tPath.startswith(PATHSEP)
        if isConnection:
            tPath = PATHSEP + tPath

        pos = 0
        while pos >= 0:
            pos2 = Misc.unquotedIndexOf(tPath, PATHSEP, pos + 1)
            if pos2 > pos:
                index = Misc.unquote(tPath[pos + 1:pos2], QUOTE_SEP)
            else:
                index = Misc.unquote(tPath[pos + 1:], QUOTE_SEP)
            pos = pos2
            path.append(SubItemIndex(index, idx[0].getType()))

        item = None
        start = 0
        if isConnection:
            if path[0].getType() == STRING:
                try:
                    value = int(path[0].getIndex())
                    newPath = []
                    for i in range(len(path)):
                        newPath.append(SubItemIndex(path[i].getIndex(), NUMBER))
                    path = newPath
                except ValueError:
                    pass
            item = self._getConnectionItemForIndex(figureCanvas,
                    jarray.array([SubItemIndex(path[0].getIndex(), path[0].getType())], SubItemIndex))
            start = 1

        for i in range(start, len(path)):
            item = self._getSubItem(figureCanvas, item, path[i])
        return item

    # }}}
    # {{{ getItemIndex

    def getItemIndex(self, figureCanvas, item, type):
        try:
            path = self._getItemPath(figureCanvas, item, type)
            if type == INTELLIGENT:
                for i in range(len(path)):
                    if path[i].getType() == NUMBER:
                        path = self._getItemPath(figureCanvas, item, AS_NUMBER)
                        break
            sb = ""
            quote = path[0].getType() == STRING
            for i in range(len(path)):
                sb += PATHSEP
                if (quote):
                    sb += Misc.quote(path[i].getIndex(), QUOTE_SEP)
                else:
                    sb += path[i].getIndex()

            idxType = path[0].getType()
            if self._isConnectionChild(item):
                sb = sb[len(PATHSEP):]
                if idxType == NUMBER and len(path) > 1:
                    # The player does not allow of non-numerical values with the '&' separator.
                    idxType = STRING

            return jarray.array([SubItemIndex(sb, idxType)], SubItemIndex)
        except:
            return None

    # }}}
    # {{{ getItemLocation

    def getItemLocation(self, figureCanvas, item):
        figure = item.getFigure()
        bounds = figure.getBounds().getCopy()
        figure.translateToAbsolute(bounds)
        try:
            scalableLayer = Reflector.call(item, "getLayer", Class.forName("java.lang.Object"), "Scalable Layers", 1)
            scalableLayer.translateToRelative(bounds)
            try:
                loc = intarray(bounds.x(), bounds.y())
            except:
                loc = intarray(bounds.x, bounds.y)
        except:
            try:
                primaryLayer = Reflector.call(item, "getLayer", Class.forName("java.lang.Object"), "Primary Layer", 1)
                primaryLayer.translateToRelative(bounds)
                try:
                    loc = intarray(bounds.x(), bounds.y())
                except:
                    loc = intarray(bounds.x, bounds.y)
            except:
                viewport = figureCanvas.getViewport()
                xoff = viewport.getHorizontalRangeModel().getValue()
                yoff = viewport.getVerticalRangeModel().getValue()
                try:
                    loc = intarray(bounds.x() + xoff, bounds.y() + yoff)
                except:
                    loc = intarray(bounds.x + xoff, bounds.y + yoff)
        return loc

    # }}}
    # {{{ getItemSize

    def getItemSize(self, figureCanvas, item):
        fig = item.getFigure()
        bounds = fig.getBounds().getCopy()
        try:
            scalableLayer = Reflector.call(item, "getLayer", Class.forName("java.lang.Object"), "Scalable Layers", 1)
            scalableLayer.translateToParent(bounds)
        except:
            pass
        try:
            size = intarray(bounds.width(), bounds.height())
        except:
            size = intarray(bounds.width, bounds.height)
        return size

    # }}}
    # {{{ repositionMouseEvent

    def repositionMouseEvent(self, figureCanvas, item, pos):
        return Boolean(False)

    # }}}
    # {{{ scrollItemVisible

    def scrollItemVisible(self, figureCanvas, item, x, y):
        try:
            self._getViewer(figureCanvas).reveal(item)
        except:
            pass
        return None

    # }}}
    # {{{ getItemCount

    def getItemCount(self, figureCanvas, item):
        """Currently unused."""
        return 0

    # }}}

    # --------------------------------------------------------------------------------------------
    # Checker interface
    # --------------------------------------------------------------------------------------------
    # {{{ supported check types

    # The supported check types for an item.
    itemTypes = jarray.array([ObjectValueCheckType, ObjectSelectedCheckType, ObjectGeometryCheckType, ObjectImageCheckType], CheckType)

    # }}}
    # {{{ getSupportedCheckTypes

    def getSupportedCheckTypes(self, figureCanvas, item):
        if item is not None:
            return self.itemTypes
        return None

    # }}}
    # {{{ getCheckData

    def getCheckData(self, figureCanvas, item, checkType):
        if item is None:
            return None
        if checkType.getDataType() == CheckDataType.STRING \
               and (CheckType.ID_DEFAULT == checkType.getIdentifier()
                    or ObjectValueCheckType.getIdentifier() == checkType.getIdentifier()):
            return StringCheckData(ObjectValueCheckType.getIdentifier(),
                                   ItemRegistry.instance("swt").getItemValue(figureCanvas, item))
        if checkType.getDataType() == CheckDataType.GEOMETRY \
               and (CheckType.ID_DEFAULT == checkType.getIdentifier()
                    or ObjectGeometryCheckType.getIdentifier() == checkType.getIdentifier()):
            pos = self.getItemLocation(figureCanvas, item)
            size = self.getItemSize(figureCanvas, item)
            return GeometryCheckData(ObjectGeometryCheckType.getIdentifier(),
                                     pos[0], pos[1], size[0], size[1])
        if checkType.getDataType() == CheckDataType.BOOLEAN \
               and (CheckType.SELECTED.getIdentifier() == checkType.getIdentifier()
                    or ObjectSelectedCheckType.getIdentifier() == checkType.getIdentifier()):
            selected = (item.getSelected() == SELECTED or item.getSelected() == SELECTED_PRIMARY)
            return BooleanCheckData(ObjectSelectedCheckType.getIdentifier(), selected)
        if checkType.getDataType() == CheckDataType.IMAGE \
               and (CheckType.ID_DEFAULT == checkType.getIdentifier()
                    or ObjectImageCheckType.getIdentifier() == checkType.getIdentifier()):
            self.scrollItemVisible(figureCanvas, item, 0, 0)
            ih = BaseImageHandler.instance(Engine.instance("swt"))
            image = ih.grabImage(figureCanvas, item)
            return ImageCheckData(ObjectImageCheckType.getIdentifier(),
                                  image, -1, -1, -1, -1, -1, -1, 0)
        else:
            return None

    #}}}
    # {{{ getCheckDataAndItem

    def getCheckDataAndItem(self, figureCanvas, item, checkType):
        data = self.getCheckData(figureCanvas, item, checkType)
        if data is None:
            return None
        return Pair(data, item)

    #}}}

    # --------------------------------------------------------------------------------------------
    # Helper
    # --------------------------------------------------------------------------------------------
    # {{{ _getGraphicalViewer

    def _getGraphicalViewer(self, figureCanvas, editorPart=None):
        graphicalViewer = None
        try:
            if not editorPart:
                shell = getShell(figureCanvas)
                editorPart = getGefEditor(shell)
            try:
                processWidget = Reflector.call(editorPart, "getProcessWidget", 1)
                editorPart = processWidget
            except:
                pass
            graphicalViewer = Reflector.call(editorPart, "getGraphicalViewer", 1)
        except:
            pass
        return graphicalViewer

    # }}}
    # {{{ _getFlyoutPaletteComposite

    def _getFlyoutPaletteComposite(self, figureCanvas):
        fpc = None
        parent = figureCanvas.getParent()
        while (parent != None):
            if ResolverRegistry.isInstance(parent, "org.eclipse.gef.ui.palette.FlyoutPaletteComposite"):
                fpc = parent
                break
            parent = parent.getParent()
        return fpc

    # }}}
    # {{{ _getPaletteViewer

    def _getPaletteViewer(self, figureCanvas, editorPart=None):
        paletteViewer = None
        try:
            fpc = self._getFlyoutPaletteComposite(figureCanvas)
            if (fpc != None):
                paletteViewer = Reflector.get(fpc, "pViewer", 1)
                if paletteViewer == None:
                    paletteViewer = Reflector.get(fpc, "externalViewer", 1)
            else:
                if not editorPart:
                    shell = getShell(figureCanvas)
                    editorPart = getGefEditor(shell)
                editDomain = Reflector.get(editorPart, "editDomain", 1)
                paletteViewer = editDomain.getPaletteViewer()
        except:
            pass
        if paletteViewer == None:
            paletteViewer = self._getPaletteViewerInView(figureCanvas)
            self.__paletteViewerInView = 1
        return paletteViewer

    # }}}
    # {{{ _getPaletteViewerInView

    def _getPaletteViewerInView(self, figureCanvas):
        shell = getShell(figureCanvas)
        wbw = shell.getData()
        pages = wbw.getPages()
        pvClass = None
        for i in range(len(pages)):
            wbp = pages[i]
            for v in wbp.getViews():
                try:
                    if not pvClass:
                        pvClass = v.getClass().getClassLoader().loadClass("org.eclipse.gef.ui.palette.PaletteViewer")
                except:
                    continue
                flds = v.getClass().getDeclaredFields()
                for f in flds:
                    if pvClass.isAssignableFrom(f.getType()):
                        return Reflector.get(v, f.getName(), True)
        return None

    # }}}
    # {{{ _getViewer

    def _getViewer(self, figureCanvas):
        viewer = self.__predefinedViewer
        if not viewer:
            shell = getShell(figureCanvas)
            editorPart = getGefEditor(shell)
            if not editorPart and not self.__editorNotFoundPrinted:
                self.__editorNotFoundPrinted = True
            self.__paletteViewer = self._getPaletteViewer(figureCanvas, editorPart)
            self.__graphicalViewer = self._getGraphicalViewer(figureCanvas, editorPart)
            if self.__paletteViewer != None and figureCanvas == self.__paletteViewer.getControl():
                viewer = self.__paletteViewer
            else:
                viewer = self.__graphicalViewer

        if viewer and (self.__Point == None or self.__LayerManager == None):
            clazz = self._findSuperclass(viewer, "org.eclipse.gef")
            self.__Point = clazz.getClassLoader().loadClass("org.eclipse.draw2d.geometry.Point")
            self.__LayerManager = clazz.getClassLoader().loadClass("org.eclipse.gef.editparts.LayerManager")
        return viewer

    # }}}
    # {{{ _findSuperclass

    def _findSuperclass(self, obj, package):
        c = obj.getClass()
        while c != None:
            if c.getName().startswith(package):
                break
            c = c.getSuperclass()
        return c

    # }}}
    # {{{ _getRootEditPart

    def _getRootEditPart(self, figureCanvas):
        viewer = self._getViewer(figureCanvas)
        if viewer and viewer == self.__graphicalViewer:
            return viewer.getContents()
        elif viewer and viewer == self.__paletteViewer:
            viewer = self.__paletteViewer
            paletteRoot = viewer.getPaletteRoot()
            return viewer.getEditPartRegistry().get(paletteRoot)
        else:
            return None

    # }}}
    # {{{ _getItemName

    def _getItemName(self, figureCanvas, item):
        name = self._getDefaultItemName(item)
        return ItemRegistry.instance("swt").getItemName(figureCanvas, item, name)

    # }}}
    # {{{ _getItemPath

    def _getItemPath(self, figureCanvas, item, type):
        items = []
        pIdx = None
        rootEditPart = self._getRootEditPart(figureCanvas)
        parent = item.getParent()
        if item == rootEditPart:
            items = rootEditPart.getParent().getChildren()
        elif parent:
            if self._isConnection(item):
                    #parent == rootEditPart.getParent()
                pIdx = self._getConnectionItemIndex(figureCanvas, item, type)
                ret = jarray.array(list(pIdx), SubItemIndex)
                return ret
            else:
                items = parent.getChildren()
                pIdx = self._getItemPath(figureCanvas, parent, type)
        name = self._getItemName(figureCanvas, item)
        if type == INTELLIGENT:
            unique = 1
        else:
            unique = 0
        idx = -1
        for i in range(len(items)):
            if (items[i] == item):
                idx = i;
                if not unique:
                    break
            elif (not ((name == None) or (len(name) == 0))) \
                    and name == self._getItemName(figureCanvas, items[i]):
                unique = 0
                if idx >= 0:
                    break
        itemType = type;
        if type == INTELLIGENT:
            if unique:
                itemType = AS_STRING
            else:
                itemType = AS_NUMBER
        if itemType == AS_STRING:
            tIdx = SubItemIndex(name)
        else:
            tIdx = SubItemIndex(idx)
        if pIdx == None:
            ret = [tIdx]
        else:
            ret = list(pIdx)
            ret.append(tIdx)
        return jarray.array(ret, SubItemIndex)

    # }}}
    # {{{ _getConnections

    def _getConnections(self, figureCanvas):
        rootEditPart = self._getRootEditPart(figureCanvas)
        connections = []
        self._findEditPartConnections(rootEditPart, connections)
        return connections

    # }}}
    # {{{ _findEditPartConnections

    def _findEditPartConnections(self, node, connections):
        if not node:
            return
        conns = node.getSourceConnections()
        for conn in conns:
            if not (conn in connections):
                connections.append(conn)
        conns = node.getTargetConnections()
        for conn in conns:
            if not (conn in connections):
                connections.append(conn)
        children = node.getChildren()
        for c in children:
            self._findEditPartConnections(c, connections)
    # }}}
    # {{{ _getSubItem

    def _getSubItem(self, figureCanvas, parent, idx):
        num = -1
        if parent == None:
            root = self._getRootEditPart(figureCanvas)
            if not root:
                return None
            parent = root.getParent()
        items = parent.getChildren()
        if idx.getType() == NUMBER:
            num = idx.asNumber()
        else:
            for i in range(len(items)):
                index = Misc.unquote(idx.getIndex(), QUOTE_SEP)
                idx = SubItemIndex(index, idx.getType())
                if idx.matches(self._getItemName(figureCanvas, items[i])):
                    num = i
                    break
        if (num < 0) or (num >= len(items)):
            raise IndexNotFoundException(idx)
        return items[num]

    # }}}
    # {{{ _getConnectionItemIndex

    def _getConnectionItemIndex(self, figureCanvas, item, type):
        connections = self._getConnections(figureCanvas)
        for i in range(len(connections)):
            if item == connections[i]:
                if type == INTELLIGENT:
                    name = self._getItemName(figureCanvas, item)
                    return jarray.array([SubItemIndex(name)], SubItemIndex)
                else:
                    return jarray.array([SubItemIndex(i)], SubItemIndex)
        return None

    # }}}
    # {{{ _getConnectionItemForIndex

    def _getConnectionItemForIndex(self, figureCanvas, idx):
        connections = self._getConnections(figureCanvas)
        num = -1
        idx = idx[0]
        if idx.getType() == NUMBER:
            try:
                num = idx.asNumber()
            except:
                return None
        else:
            for i in range(len(connections)):
                if idx.matches(self._getItemName(figureCanvas, connections[i])):
                    num = i
                    break
        if (num < 0) or (num >= len(connections)):
            return None
        return connections[num]

    # }}}
    # {{{ _isConnection

    def _isConnection(self, item):
        return ResolverRegistry.isInstance(item, "org.eclipse.gef.editparts.AbstractConnectionEditPart")

    # }}}
    # {{{ _isConnectionChild

    def _isConnectionChild(self, item):
        parent = item
        while parent:
            if self._isConnection(parent):
                return True
            parent = parent.getParent()
        return False

    # }}}
    # {{{ _getDefaultItemName

    def _getDefaultItemName(self, item):
        name = item.getModel().toString()
        # Do nothing when there's no hash value in it.
        if not re.match(".*\\w+@[a-z0-9]+", name):
            return name
        # Check whether it's the diagram
        if item == item.getRoot().getContents():
            return "Diagram"
        # Try to get a name
        name = self._getName(item)
        if name:
            return name
        # Classname with text
        clazz = self._getClassName(item)
        text = None
        try:
            texts = self._getFiguresTexts(item.getFigure())
            text = " ".join(texts)
        except:
            pass
        if text:
            return "%s (%s)" %(clazz, text)
        # Classname with index
        idx = self._getIndex(item)
        if idx > 0:
            return "%s-%d" %(clazz, idx)
        # Pure classname
        return clazz

    # }}}
    # {{{ _getName

    def _getName(self, item):
        name = None
        model = item.getModel()
        try:
            name = model.getName()
        except:
            pass
        if name:
            return name
        # GMF
        try:
            if model.isSetElement():
                name = model.getElement().getName()
        except:
            pass
        return name

    # }}}
    # {{{ _getClassName

    def _getClassName(self, item):
        clazz = Class.getName(item.getClass())
        parts = clazz.split(".")
        clazz = parts[-1]
        clazz = clazz.replace("EditPart", "")
        return clazz

    # }}}
    # {{{ _getFiguresTexts

    def _getFiguresTexts(self, figure, texts=None):
        if texts is None:
            texts = []
        isLabel = ResolverRegistry.isInstance(figure, "org.eclipse.draw2d.Label") \
            or ResolverRegistry.isInstance(figure, "org.eclipse.draw2d.text.TextFlow")
        if figure.isShowing() and isLabel:
            text = figure.getText()
            texts.append(text)
        children = figure.getChildren()
        for c in children:
            self._getFiguresTexts(c, texts)
        return texts

    # }}}
    # {{{ _getConnectionIndex

    def _getConnectionIndex(self, item):
        idx = -1
        clazz = Class.getName(item.getClass())
        fc = item.getViewer().getControl()
        for c in self._getConnections(fc):
            if Class.getName(c.getClass()) == clazz:
                idx += 1
            if c == item:
                break
        return idx

    # }}}
    # {{{ _getIndex

    def _getIndex(self, item):
        if self._isConnection(item):
            return self._getConnectionIndex(item)
        idx = -1
        clazz = Class.getName(item.getClass())
        p = item.getParent()
        if not p:
            return idx
        for c in p.getChildren():
            if Class.getName(c.getClass()) == clazz:
                idx += 1
            if c == item:
                break
        return idx

    # }}}

global gefResolver

try:
    ItemRegistry.instance("swt").unregisterItemResolvers("org.eclipse.draw2d.FigureCanvas")
    CheckerRegistry.instance("swt").unregisterCheckers("org.eclipse.draw2d.FigureCanvas")
except:
    pass

gefResolver = GefResolver()
ItemRegistry.instance("swt").registerItemResolver("org.eclipse.draw2d.FigureCanvas", gefResolver)
CheckerRegistry.instance("swt").registerChecker("org.eclipse.draw2d.FigureCanvas", gefResolver)
