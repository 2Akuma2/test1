
# {{{ imports

from java.lang import Boolean, Class, Object, String
from java.lang.reflect import Array
from de.qfs.lib.log import Log, Logger
from de.qfs.lib.util import Reflector, Pair
from de.qfs.apps.qftest.client import Engine
from de.qfs.apps.qftest.extensions.items import ItemRegistry, ItemResolver
from de.qfs.apps.qftest.extensions.checks import CheckerRegistry, Checker, \
    CheckDataType, CheckType
from de.qfs.apps.qftest.shared.data import SubItemIndex
from de.qfs.apps.qftest.shared.data.check import BooleanCheckData, ImageCheckData, \
    StringCheckData, StringItemsCheckData, SelectableItemsCheckData
from de.qfs.apps.qftest.shared.extensions.image import BaseImageHandler
import jarray, sys, types
import qf

# }}}
# {{{ variables

logger = Logger("de.qfs.apps.qftest.extensions.items.NebulaNatTableResolver")

# }}}

# ItemResolver for the Nebula NatTable
#
class NebulaNatTableResolver(ItemResolver, Checker):
    # {{{ __init__

    def __init__(self):
        if logger.level >= Log.MTD:
            lb = logger.build("__init__")
            lb.log(Log.MTD)
        self.Point = None
        self.GridColumn = None
        self.GridItem = None

    # }}}

    # --------------------------------------------------------------------------------------------
    # ItemResolver interface
    # --------------------------------------------------------------------------------------------
    # {{{ getItem

    def getItem(self, table, x, y = None):
        if logger.level >= Log.MTD:
            lb = logger.build("getItem(table,x,y)")
            if logger.level >= Log.MTDDETAIL:
                lb.add("table: ").add(table).add(", x: ").add(x).add(", y: ").add(y)
            lb.log(Log.MTD)

        if y is None:
            return self.getItemForIndex(table, x)

        col, row = (-1, -1)
        sp = self._getScrollPos(table)
        ho = self._getHeaderOffset(table)
        layer = self._getBodyLayer(table)
        try:
            col = layer.getColumnPositionByX(x - sp[0] - ho[0])
            row = layer.getRowPositionByY(y - sp[1] - ho[1])
            if col >= 0 and row >= 0:
                col = layer.getColumnIndexByPosition(col)
                row = layer.getRowIndexByPosition(row)
        except Exception, ex:
            if logger.level >= Log.ERR:
                logger.build("getItem(table,x,y)").add("layer: ").add(layer).add("\n").add(ex).log(Log.ERR)
        if col < 0 or row < 0:
            return
        chlayer = self._getColumnHideShowLayer(table)
        if chlayer:
            pos = chlayer.getColumnPositionByIndex(col)
            if logger.level >= Log.MSG:
                logger.build("getItem(table,x,y)") \
                .add(chlayer).add(", pos: ").add(pos).log(Log.MSG)
            if pos >= 0:
                col = pos
        item = intarray(col, row)
        if logger.level >= Log.DBG:
            logger.build("getItem(table,x,y)").add("item: ").addAll(item).log(Log.DBG)
        return item

    # }}}
    # {{{ getItemValue

    def getItemValue(self, table, item):
        if logger.level >= Log.MTD:
            lb = logger.build("getItemValue(table,item)")
            if logger.level >= Log.MTDDETAIL:
                 lb.add("table: ").add(table).add(", item: ").addAll(item)
            lb.log(Log.MTD)
        return self._getDefaultCellName(table, item[0], item[1])

    # }}}
    # {{{ getItemForIndex

    def getItemForIndex(self, table, index):
        if logger.level >= Log.MTD:
            lb = logger.build("getItemForIndex(table,index)")
            if logger.level >= Log.MTDDETAIL:
                 lb.add("table: ").add(table).add(", index: ").addAll(index)
            lb.log(Log.MTD)
        col = -1
        colIdx = index[0]
        cols = self._getColumnCount(table)
        rows = self._getRowCount(table)
        if logger.level >= Log.DBG:
            logger.build("getItemForIndex(table,index)") \
                .add("cols: ").add(cols).add(", rows: ").add(rows).log(Log.DBG)
        if cols <= 0 or rows <= 0:
            return None
        if colIdx.getType() == SubItemIndex.NUMBER:
            col = colIdx.asNumber()
            if col < 0:
                col += cols
        else:
            for i in range(cols):
                tmp = self._getCellName(table, i, -1)
                if colIdx.matches(tmp):
                    col = i
                    break
        if logger.level >= Log.DBG:
            logger.build("getItemForIndex(table,index)") \
                .add("col: ").add(col).log(Log.DBG)
        if col == -1 or col >= cols:
            return None
        if len(index) == 1:
            return col

        row = -1
        rowIdx = index[1]
        if rowIdx.getType() == SubItemIndex.NUMBER:
            row = rowIdx.asNumber()
            if row < 0:
                row += rows
        else:
            for i in range(rows):
                tmp = self._getCellName(table, col, i)
                if rowIdx.matches(tmp):
                    row = i
                    break
        if logger.level >= Log.DBG:
            logger.build("getItemForIndex(table,index)") \
                .add("row: ").add(row).log(Log.DBG)
        if row == -1 or row >= rows:
            # Special case: Might be looking for a sub-node with :Class syntax
            if rowIdx.getType() == SubItemIndex.STRING and \
               rowIdx.getIndex() is not None and \
               rowIdx.getIndex().startswith(":"):
                return col
            return None
        ItemRegistry.instance("swt").setIndexesResolved(2)
        return intarray(col, row)

    # }}}
    # {{{ getItemIndex

    def getItemIndex(self, table, item, type):
        if logger.level >= Log.MTD:
            lb = logger.build("getItemIndex(table,item,type)")
            if logger.level >= Log.MTDDETAIL:
                 lb.add("table: ").add(table).add(", item: ").addAll(item).add(", type: ").add(type)
            lb.log(Log.MTD)
        col = item[0]
        row = item[1]
        ctype = type
        if ctype == SubItemIndex.INTELLIGENT:
            if self._getRowCount(table) == 0 or self._getColumnCount(table) == 0:
                ctype = SubItemIndex.AS_NUMBER
            else:
                name = self._getCellName(table, col, -1)
                if name:
                    for i in range(self._getColumnCount(table)):
                        if i != col:
                            cname = self._getCellName(table, i, -1)
                            if name == cname:
                                ctype = SubItemIndex.AS_NUMBER
                                break;
                    else:
                        ctype = SubItemIndex.AS_STRING

        if ctype == SubItemIndex.AS_STRING:
            name = self._getCellName(table, col, -1)
            if not name is None:
                colIdx = SubItemIndex(name)
            else:
                colIdx = SubItemIndex(col)
        else:
            colIdx = SubItemIndex(col)
        if logger.level >= Log.DBG:
            logger.build("getItemIndex(table,item,type)") \
                .add("colIdx: ").add(colIdx).log(Log.DBG)

        if type == SubItemIndex.AS_STRING:
            name = self._getCellName(table, col, row)
            rowIdx = SubItemIndex(name)
        else:
            rowIdx = SubItemIndex(row)

        if logger.level >= Log.DBG:
            logger.build("getItemIndex(table,item,type)") \
                .add("rowIdx: ").add(rowIdx).log(Log.DBG)
        return jarray.array([colIdx, rowIdx], SubItemIndex)

    # }}}
    # {{{ getItemLocation

    def getItemLocation(self, table, item):
        if logger.level >= Log.MTD:
            lb = logger.build("getItemLocation(table,item)")
            if logger.level >= Log.MTDDETAIL:
                 lb.add("table: ").add(table).add(", item: ").addAll(item)
            lb.log(Log.MTD)
        bnds = self._getItemBounds(table, item)
        return intarray(bnds[0], bnds[1])

    # }}}
    # {{{ getItemSize

    def getItemSize(self, table, item):
        if logger.level >= Log.MTD:
            lb = logger.build("getItemSize(table,item)")
            if logger.level >= Log.MTDDETAIL:
                 lb.add("table: ").add(table).add(", item: ").addAll(item)
            lb.log(Log.MTD)
        bnds = self._getItemBounds(table, item)
        return intarray(bnds[2], bnds[3])

    # }}}
    # {{{ repositionMouseEvent

    def repositionMouseEvent(self, table, item, pos):
        if logger.level >= Log.MTD:
            lb = logger.build("repositionMouseEvent(table,item,pos)")
            if logger.level >= Log.MTDDETAIL:
                 lb.add("table: ").add(table).add(", item: ").addAll(item).add(", pos: ").add(pos)
            lb.log(Log.MTD)
        return False

    # }}}
    # {{{ scrollItemVisible

    def scrollItemVisible(self, table, item, x, y):
        if logger.level >= Log.MTD:
            lb = logger.build("scrollItemVisible(table,item,x,y)")
            if logger.level >= Log.MTDDETAIL:
                 lb.add("table: ").add(table).add(", item: ").addAll(item) \
                 .add(", x: ").add(x).add(", y: ").add(y)
            lb.log(Log.MTD)
        res = None
        col, row = (item[0], item[1])
        col = self._getVisibleColumnPosition(table, col)
        vlayer = self._getViewportLayer(table)
        if vlayer:
            vlayer.moveCellPositionIntoViewport(col, row)
        res = Boolean.FALSE
        return res

    # }}}
    # {{{ getItemCount

    def getItemCount(self, table, item):
        return 0
    #

    # }}}

    # -------------------------------------------------------------------------
    # Helper methods
    # -------------------------------------------------------------------------
    # {{{ _getBodyLayer

    def _getBodyLayer(self, table):
        layer = table.getLayer()
        clayer = None
        # GridLayer
        try:
            clayer = layer.getBodyLayer()
        except:
            pass
        # CompositeLayer
        if not clayer \
        and qf.isInstance(layer, "org.eclipse.nebula.widgets.nattable.layer.CompositeLayer"):
            clayer = layer.getChildLayerByLayoutCoordinate(1, 1)
            if not clayer:
                clayer = layer.getChildLayerByLayoutCoordinate(0, 1)
            if not clayer:
                clayer = layer.getChildLayerByLayoutCoordinate(0, 0)
        # Maybe DataLayer
        if not clayer:
            clayer = layer
        if logger.level >= Log.DBG:
            logger.build("_getBodyLayer(table)").add("body: ").add(clayer).log(Log.DBG)
        return clayer

    # }}}
    # {{{ _getHeaderLayer

    def _getHeaderLayer(self, table):
        layer = table.getLayer()
        clayer = None
        # GridLayer
        try:
            clayer = layer.getColumnHeaderLayer()
        except:
            pass
        # CompositeLayer
        if not clayer \
        and qf.isInstance(layer, "org.eclipse.nebula.widgets.nattable.layer.CompositeLayer"):
            clayer = layer.getChildLayerByLayoutCoordinate(1, 0)
            if not clayer:
                clayer = layer.getChildLayerByLayoutCoordinate(0, 0)
        if logger.level >= Log.DBG:
            logger.build("_getHeaderLayer(table)").add("header: ").add(clayer).log(Log.DBG)
        return clayer

    # }}}
    # {{{ _getRowHeaderLayer

    def _getRowHeaderLayer(self, table):
        layer = table.getLayer()
        clayer = None
        # GridLayer
        try:
            clayer = layer.getRowHeaderLayer()
        except:
            pass
        # CompositeLayer
        if not clayer \
        and qf.isInstance(layer, "org.eclipse.nebula.widgets.nattable.layer.CompositeLayer"):
            if layer.getChildLayerByLayoutCoordinate(1, 1):
                clayer = layer.getChildLayerByLayoutCoordinate(0, 1)
            if not clayer:
                if layer.getChildLayerByLayoutCoordinate(1, 0):
                    clayer = layer.getChildLayerByLayoutCoordinate(0, 0)
        if logger.level >= Log.DBG:
            logger.build("_getRowHeaderLayer(table)").add("header: ").add(clayer).log(Log.DBG)
        return clayer

    # }}}
    # {{{ _getLayerByClassName

    def _getLayerByClassName(self, layer, className):
        cn = className
        if not cn.startswith("org."):
            cn = "org.eclipse.nebula.widgets.nattable." + cn
        if qf.isInstance(layer, cn):
            return layer
        layer = layer.getUnderlyingLayerByPosition(0, 0)
        if layer:
            return self._getLayerByClassName(layer, className)

    # }}}
    # {{{ _getBottomLayer

    def _getBottomLayer(self, layer):
        if logger.level >= Log.MTD:
            lb = logger.build("_getBottomLayer(layer)")
            if logger.level >= Log.MTDDETAIL:
                 lb.add("layer: ").add(layer)
            lb.log(Log.MTD)
        layer1 = layer.getUnderlyingLayerByPosition(0, 0)
        if not layer1 \
        and qf.isInstance(layer, "org.eclipse.nebula.widgets.nattable.summaryrow.SummaryRowLayer"):
            try:
                # Needed for FixedSummaryRowLayer in NatTable 1.5.0
                layer1 = Reflector.get(layer, "underlyingLayer", True)
            except:
                pass
        if logger.level >= Log.DBG:
            logger.build("_getBottomLayer(layer)").add("layer1: ").add(layer1).log(Log.DBG)
        if not layer1:
            return layer
        return self._getBottomLayer(layer1)

    # }}}
    # {{{ _getSelectionLayer

    def _getSelectionLayer(self, table):
        if logger.level >= Log.MTD:
            logger.build("_getSelectionLayer(table)").add("table: ").add(table).log(Log.MTD)
        blayer = self._getBodyLayer(table)
        layer = self._getLayerByClassName(blayer, "selection.SelectionLayer")
        if logger.level >= Log.DBG:
            logger.build("_getSelectionLayer(table)").add("layer: ").add(layer).log(Log.DBG)
        return layer

    # }}}
    # {{{ _getViewportLayer

    def _getViewportLayer(self, table):
        blayer = self._getBodyLayer(table)
        layer = self._getLayerByClassName(blayer, "viewport.ViewportLayer")
        if logger.level >= Log.DBG:
            logger.build("_getViewportLayer(table)").add("layer: ").add(layer).log(Log.DBG)
        return layer

    # }}}
    # {{{ _getColumnHideShowLayer

    def _getColumnHideShowLayer(self, table):
        if logger.level >= Log.MTD:
            logger.build("_getColumnHideShowLayer(table)").add("table: ").add(table).log(Log.MTD)
        blayer = self._getBodyLayer(table)
        layer = self._getLayerByClassName(blayer, "hideshow.ColumnHideShowLayer")
        if logger.level >= Log.DBG:
            logger.build("_getColumnHideShowLayer(table)").add("layer: ").add(layer).log(Log.DBG)
        return layer

    # }}}
    # {{{ _getColumnCount

    def _getColumnCount(self, table):
        count = 0
        chlayer = self._getColumnHideShowLayer(table)
        if chlayer:
            # Include additional columns, if any
            count = chlayer.getColumnCount()
        else:
            # Ask the data layer
            blayer = self._getBodyLayer(table)
            layer = self._getBottomLayer(blayer)
            count = layer.getColumnCount()
        if logger.level >= Log.DBG:
            logger.build("_getColumnCount(table)").add("count: ").add(count).log(Log.DBG)
        return count

    # }}}
    # {{{ _getRowCount

    def _getRowCount(self, table):
        count = 0
        chlayer = self._getColumnHideShowLayer(table)
        if chlayer:
            # Include additional rows (e.g. a summary row)
            count = chlayer.getRowCount()
        else:
            # Ask the data layer
            blayer = self._getBodyLayer(table)
            layer = self._getBottomLayer(blayer)
            count = layer.getRowCount()
        if logger.level >= Log.DBG:
            logger.build("_getRowCount(table)").add("count: ").add(count).log(Log.DBG)
        return count

    # }}}
    # {{{ _getDefaultCellName

    def _getDefaultCellName(self, table, col, row):
        if logger.level >= Log.MTD:
            logger.build("_getDefaultCellName(table,col,row)") \
            .add("table: ").add(table).add(", col: ").add(col) \
            .add(", row: ").add(row).log(Log.MTD)
        try:
            if row < 0:
                layer = self._getHeaderLayer(table)
                if not layer:
                    if logger.level >= Log.DBG:
                        logger.build("_getDefaultCellName(table,col,row)") \
                            .add("No header").log(Log.DBG)
                    return None
                row = 0
            else:
                layer = self._getBodyLayer(table)
            if logger.level >= Log.DBG:
                logger.build("_getDefaultCellName(table,col,row)") \
                .add("layer: ").add(layer).log(Log.DBG)
            layer = self._getBottomLayer(layer)
            if logger.level >= Log.DBG:
                logger.build("_getDefaultCellName(table,col,row)") \
                .add("data: ").add(layer).log(Log.DBG)
            chlayer = self._getColumnHideShowLayer(table)
            if chlayer:
                colidx = chlayer.getColumnIndexByPosition(col)
                if logger.level >= Log.MSG:
                    logger.build("_getDefaultCellName(table,col,row)") \
                    .add(chlayer).add(", colidx: ").add(colidx).log(Log.MSG)
                if colidx >= 0:
                    col = colidx
            name = layer.getDataValueByPosition(col, row)
            if logger.level >= Log.DBG:
                logger.build("_getDefaultCellName(table,col,row)") \
                    .add("name: ").add(name).log(Log.DBG)
        except Exception, ex:
            if logger.level >= Log.WRN:
                logger.build("_getDefaultCellName(table,col,row)") \
                    .add(ex).log(Log.WRN)
            pass
        if not type(name) in types.StringTypes:
            name = str(name)
        return name

    # }}}
    # {{{ _getCellName

    def _getCellName(self, table, col, row):
        name = self._getDefaultCellName(table, col, row)
        item = [col, row]
        return ItemRegistry.instance("swt").getItemName(table, item, name)

    # }}}
    # {{{ _getCellValue

    def _getCellValue(self, table, col, row):
        return ItemRegistry.instance("swt").getItemValue(table, [col, row])

    # }}}
    # {{{ _getHeaderName

    def _getHeaderName(self, table, col):
        return self._getCellName(table, col, -1)

    # }}}
    # {{{ _isCellSelected

    def _isCellSelected(self, table, col, row):
        if logger.level >= Log.MTD:
            logger.build("_isCellSelected(table,col,row)") \
            .add("table: ").add(table).add(", col: ").add(col) \
            .add(", row: ").add(row).log(Log.MTD)
        selLayer = self._getSelectionLayer(table)
        sel = selLayer.isCellPositionSelected(col, row)
        if logger.level >= Log.DBG:
            logger.build("_isCellSelected(table,col,row)").add("sel: ").add(sel).log(Log.DBG)
        return sel

    # }}}
    # {{{ _getScrollPos

    def _getScrollPos(self, table):
        layer = self._getViewportLayer(table)
        if layer:
            p = layer.getOrigin()
            pos = [p.getX(), p.getY()]
        else:
            pos = [0, 0]
        if logger.level >= Log.DBG:
            logger.build("_getScrollPos(table)").add("pos: ").addAll(pos).log(Log.DBG)
        return pos

    # }}}
    # {{{ _getPositionFromIndex

    def _getPositionFromIndex(self, table, col, row):
        if logger.level >= Log.MTD:
            logger.build("_getPositionFromIndex(table,col,row)") \
            .add("table: ").add(table).add(", col: ").add(col) \
            .add(", row: ").add(row).log(Log.MTD)
        pos = [col, row]
        exc = False
        try:
            layer = self._getBodyLayer(table)
            pos[0] = layer.getColumnPositionByIndex(col)
            pos[1] = layer.getRowPositionByIndex(row)
        except:
            exc = True
        if exc:
            try:
                layer = self._getViewportLayer(table)
                pos[0] = layer.getColumnPositionByIndex(col)
                pos[1] = layer.getRowPositionByIndex(row)
            except:
                pass
        if logger.level >= Log.DBG:
            logger.build("_getPositionFromIndex(table,col,row)") \
            .add("pos: ").addAll(pos).log(Log.DBG)
        return pos

    # }}}
    # {{{ _getItemBounds

    def _getItemBounds(self, table, item):
        col, row = (item[0], item[1])
        chlayer = self._getColumnHideShowLayer(table)
        if chlayer:
            colidx = chlayer.getColumnIndexByPosition(col)
            if logger.level >= Log.MSG:
                logger.build("_getItemBounds(table,item)") \
                .add(chlayer).add(", colidx: ").add(colidx).log(Log.MSG)
            if colidx >= 0:
                col = colidx
        res = [0, 0, 0, 0]
        col, row = self._getPositionFromIndex(table, col, row)
        layer = self._getBodyLayer(table)
        cell = layer.getCellByPosition(col, row)
        if not cell:
            layer = self._getViewportLayer(table)
            cell = layer.getCellByPosition(col, row)
        bnds = cell.getBounds()
        x, y = (bnds.x, bnds.y)
        p = self._getScrollPos(table)
        x += p[0]
        y += p[1]
        off = self._getHeaderOffset(table)
        x += off[0]
        y += off[1]
        res = [x, y, bnds.width, bnds.height]
        return res

    # }}}
    # {{{ _getHeaderOffset

    def _getHeaderOffset(self, table):
        offset = [0, 0]
        rhlayer = self._getRowHeaderLayer(table)
        if rhlayer:
            offset[0] = rhlayer.getWidth()
        chlayer = self._getHeaderLayer(table)
        if chlayer:
            offset[1] = chlayer.getHeight()
        if logger.level >= Log.DBG:
            logger.build("_getHeaderOffset(table)").add("offset: ").addAll(offset).log(Log.DBG)
        return offset

    # }}}
    # {{{ _getVisibleCellPosition

    def _getVisibleColumnPosition(self, table, col):
        if logger.level >= Log.MTD:
            logger.build("_getVisibleColumnPosition(table,col)") \
            .add("table: ").add(table).add(", col: ").add(col).log(Log.MTD)
        try:
            gelayer = table.getLayer().getBodyLayer().getColumnGroupExpandCollapseLayer()
            hidden = gelayer.getHiddenColumnIndexes()
            if col in hidden:
                if logger.level >= Log.WRN:
                    logger.build("_getVisibleColumnPosition(table,col)") \
                    .add("The columun is hidden").log(Log.WRN)
                # TODO: IndexNotFoundException in getItemForIndex
                raise UserException("Idx not found")
            offset = 0
            for hc in hidden:
                if hc < col:
                    offset -= 1;
            col += offset
            if logger.level >= Log.DBG:
                logger.build("_getVisibleColumnPosition(table,col)") \
                .add("col: ").add(col).log(Log.MTD)
        except:
            pass
        return col

    # }}}

    # --------------------------------------------------------------------------------------------
    # Checker interface
    # --------------------------------------------------------------------------------------------
    # {{{ supported check types

    # The supported check types for a cell item.
    cellTypes = jarray.array(
        [CheckType.CELL, CheckType.CELL_SELECTED, CheckType.HEADER_FOR_TABLE, CheckType.COLUMN,
            CheckType.COLUMN_WITH_SELECTION, CheckType.ROW, CheckType.CELL_IMAGE], CheckType)

    # }}}
    # {{{ getSupportedCheckTypes

    def getSupportedCheckTypes(self, table, item):
        if logger.level >= Log.MTD:
            lb = logger.build("getSupportedCheckTypes(table,item)")
            if logger.level >= Log.MTDDETAIL:
                 lb.add("table: ").add(table).add(", item: ").addAll(item)
            lb.log(Log.MTD)
        if item:
            return self.cellTypes
        return None

    # }}}
    # {{{ getCheckData

    def getCheckData(self, table, item, checkType):
        if logger.level >= Log.MTD:
            lb = logger.build("getCheckData(table,item,checkType)")
            if logger.level >= Log.MTDDETAIL:
                 lb.add("table: ").add(table).add(", item: ").addAll(item) \
                 .add(", checkType: ").add(checkType)
            lb.log(Log.MTD)
        if item is None:
            return None
        try:
            col, row = (item[0], item[1])
        except:
            col = item
            row = -1
        if checkType.getDataType() == CheckDataType.STRING \
                and (CheckType.ID_DEFAULT == checkType.getIdentifier()
                     or "cell" == checkType.getIdentifier()
                     or CheckType.CELL.getIdentifier() == checkType.getIdentifier()):
            return StringCheckData(CheckType.ID_DEFAULT, self._getCellValue(table, col, row))
        elif checkType.getDataType() == CheckDataType.BOOLEAN \
                and ("cell_selected" == checkType.getIdentifier()
                     or CheckType.CELL_SELECTED.getIdentifier() == checkType.getIdentifier()):
            sel = self._isCellSelected(table, col, row)
            return BooleanCheckData (CheckType.CELL_SELECTED.getIdentifier(), sel)
        elif checkType.getDataType() == CheckDataType.STRING \
                and ("header" == checkType.getIdentifier()
                     or CheckType.HEADER_FOR_TABLE.getIdentifier() == checkType.getIdentifier()):
            title = self._getHeaderName(table, col)
            return StringCheckData(CheckType.HEADER_FOR_TABLE.getIdentifier(), title)
        elif checkType.getDataType() == CheckDataType.STRING_LIST \
                and CheckType.COLUMN.getIdentifier() == checkType.getIdentifier():
            count = self._getRowCount(table)
            values = jarray.zeros(count, String)
            for i in range(count):
                values[i] = self._getCellValue(table, col, i)
            return StringItemsCheckData(CheckType.COLUMN.getIdentifier(), values)
        elif checkType.getDataType() == CheckDataType.SELECTABLE_STRING_LIST \
               and (CheckType.COLUMN_WITH_SELECTION.getIdentifier() == checkType.getIdentifier()
                   or CheckType.ID_DEFAULT == checkType.getIdentifier()):
            count = self._getRowCount(table)
            values = Array.newInstance(Object, [count, 3])
            for i in range(count):
                values[i][0] = self._getCellValue(table, col, i)
                values[i][1] = Boolean(0)
                values[i][2] = Boolean(self._isCellSelected(table, col, i))
            return SelectableItemsCheckData(CheckType.ID_DEFAULT, values)
        elif checkType.getDataType() == CheckDataType.STRING_LIST \
                and CheckType.ROW.getIdentifier() == checkType.getIdentifier():
            count = self._getColumnCount(table)
            values = jarray.zeros(count, String)
            for i in range(count):
                values[i] = self._getCellValue(table, i, row)
            return StringItemsCheckData(CheckType.ROW.getIdentifier(), values)
        elif checkType.getDataType() == CheckDataType.IMAGE \
                and ("cell_image" == checkType.getIdentifier()
                     or CheckType.CELL_IMAGE.getIdentifier() == checkType.getIdentifier()):
            self.scrollItemVisible(table, item, 0, 0)
            ih = BaseImageHandler.instance(Engine.instance("swt"))
            image = ih.grabImage(table, item)
            icd = ImageCheckData(CheckType.CELL_IMAGE.getIdentifier(), image, -1, -1, -1, -1, -1, -1, 0)
            icd.setAlgorithm("algorithm=identity;expected=0.99")
            return icd
        return None

    # }}}
    # {{{ getCheckDataAndItem

    def getCheckDataAndItem(self, table, item, checkType):
        if logger.level >= Log.MTD:
            lb = logger.build("getCheckDataAndItem(table,item,checkType)")
            if logger.level >= Log.MTDDETAIL:
                 lb.add("table: ").add(table).add(", item: ").addAll(item) \
                 .add(", checkType: ").add(checkType)
            lb.log(Log.MTD)
        data = self.getCheckData(table, item, checkType)
        if data is None:
            return None
        return Pair(data, item)

    # }}}

def intarray(*args):
    return jarray.array(args, 'i')

global natTableResolver

try:
    ItemRegistry.instance("swt").unregisterItemResolver("org.eclipse.nebula.widgets.nattable.NatTable", natTableResolver)
    CheckerRegistry.instance("swt").unregisterChecker("org.eclipse.nebula.widgets.nattable.NatTable", natTableResolver)
except:
    pass
natTableResolver = NebulaNatTableResolver()
ItemRegistry.instance("swt").registerItemResolver("org.eclipse.nebula.widgets.nattable.NatTable", natTableResolver)
CheckerRegistry.instance("swt").registerChecker("org.eclipse.nebula.widgets.nattable.NatTable", natTableResolver)
