from java.lang import Class, Object, Boolean, Integer, String
from de.qfs.lib.log import Log, Logger
from de.qfs.lib.util import Reflector, Pair
from de.qfs.apps.qftest.extensions import ResolverRegistry
from de.qfs.apps.qftest.extensions.items import ItemRegistry, ItemResolver
from de.qfs.apps.qftest.extensions.checks import CheckerRegistry, Checker, CheckDataType, CheckType
from de.qfs.apps.qftest.shared.data import SubItemIndex
from de.qfs.apps.qftest.shared.data.check import BooleanCheckData, SelectableItemsCheckData
from de.qfs.apps.qftest.shared.data.check import StringCheckData, StringItemsCheckData
import jarray, sys, types

logger = Logger("de.qfs.apps.qftest.extensions.items.NebulaGridResolver")

# ItemResolver for the Nebula Grid
#
class NebulaGridResolver(ItemResolver, Checker):
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

    # y=None is a fallback for the old ItemResolver interface where getItemForIndex was
    # also named getItem
    def getItem(self, table, x, y = None):
        if logger.level >= Log.MTD:
            lb = logger.build("getItem(x,y)")
            if logger.level >= Log.MTDDETAIL:
                lb.add("x: ").add(x).add(", y: ").add(y)
            lb.log(Log.MTD)

        self._loadClasses(table)

        if y is None:
            return self.getItemForIndex(table, x)

        # Handle scrolling
        hbar = table.getHorizontalBar()
        x = x - hbar.getSelection()
        # The vertical bar gives the current top row which qftest wrongly
        # adds to the current location. Seems we don't need a to implement
        # a ScrollOffsetResolver, just substracting works fine.
        vbar = table.getVerticalBar()
        y = y - vbar.getSelection()

        p = self.Point(x, y)
        cell = table.getCell(p)
        if logger.level >= Log.DBG:
            lb = logger.build("getItem(x,y)")
            if logger.level >= Log.DBGDETAIL:
                lb.add("x: ").add(x).add(", y: ").add(y).add(", cell: ").add(cell)
            lb.log(Log.DBG)
        try:
            return intarray(cell.x, cell.y)
        except:
            return None

    # }}}
    # {{{ getItemValue

    def getItemValue(self, table, item):
        if logger.level >= Log.MTD:
            lb = logger.build("getItemValue(table,item)")
            if logger.level >= Log.MTDDETAIL:
                 lb.add("table: ").add(table).add(", item: ").addAll(item)
            lb.log(Log.MTD)
        return table.getItems()[item[1]].getText(item[0])

    # }}}
    # {{{ getItemForIndex

    def getItemForIndex(self, table, index):
        if logger.level >= Log.MTD:
            lb = logger.build("getItemForIndex(table,index)")
            if logger.level >= Log.MTDDETAIL:
                 lb.add("table: ").add(table).add(", index: ").add(index)
            lb.log(Log.MTD)

        self._loadClasses(table)

        col = -1
        colIdx = index[0]
        cols = table.getColumnCount()
        rows = table.getItemCount()
        if cols <= 0 or rows <= 0:
            return None
        if colIdx.getType() == SubItemIndex.NUMBER:
            col = colIdx.asNumber()
            if col < 0:
                col = col + cols
        else:
            for i in range(cols):
                tmp = table.getColumn(i).getText()
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
                row = row + rows
        else:
            for i in range(rows):
                tmp = table.getItems()[i].getText(col)
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
            if table.getItemCount() == 0 or table.getColumnCount() == 0:
                ctype = SubItemIndex.AS_NUMBER
            else:
                name = table.getColumn(col).getText()
                if name:
                    for i in range(table.getColumnCount()):
                        if i != col:
                            cname = table.getColumn(i).getText()
                            if name == cname:
                                ctype = SubItemIndex.AS_NUMBER
                                break;
                    else:
                        ctype = SubItemIndex.AS_STRING

        if ctype == SubItemIndex.AS_STRING:
            name = table.getColumn(col).getText()
            colIdx = SubItemIndex(name)
        else:
            colIdx = SubItemIndex(col)
        if logger.level >= Log.DBG:
            logger.build("getItemIndex(table,item,type)") \
                .add("colIdx: ").add(colIdx).log(Log.DBG)

        if type == SubItemIndex.AS_STRING:
            name = table.getItems()[row].getText(col)
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

        p = self._getItemOrigin(table, item)

        hbar = table.getHorizontalBar()
        if hbar is not None:
            p.x += hbar.getSelection()
        vbar = table.getVerticalBar()
        if vbar is not None:
            p.y += vbar.getSelection()
        p.x += 1
        p.y += 1

        return intarray(p.x, p.y)

    # }}}
    # {{{ getItemSize

    def getItemSize(self, table, item):
        if logger.level >= Log.MTD:
            lb = logger.build("getItemSize(table,item)")
            if logger.level >= Log.MTDDETAIL:
                 lb.add("table: ").add(table).add(", item: ").addAll(item)
            lb.log(Log.MTD)
        rect = table.getItems()[item[1]].getBounds(item[0])
        return intarray(rect.width, rect.height)

    # }}}
    # {{{ repositionMouseEvent

    def repositionMouseEvent(self, table, item, pos):
        if logger.level >= Log.MTD:
            lb = logger.build("repositionMouseEvent(table,item,pos)")
            if logger.level >= Log.MTDDETAIL:
                 lb.add("table: ").add(table).add(", item: ").addAll(item).add(", pos: ").add(pos)
            lb.log(Log.MTD)
        return Boolean(False)

    # }}}
    # {{{ scrollItemVisible

    def scrollItemVisible(self, table, item, x, y):
        if logger.level >= Log.MTD:
            lb = logger.build("scrollItemVisible(table,item,x,y)")
            if logger.level >= Log.MTDDETAIL:
                 lb.add("table: ").add(table).add(", item: ").addAll(item) \
                 .add(", x: ").add(x).add(", y: ").add(y)
            lb.log(Log.MTD)

        col = item[0]
        row = item[1]
        table.setTopIndex(row)
        table.showColumn(table.getColumn(col))
        return Boolean.FALSE

    # }}}
    # {{{ getItemCount

    def getItemCount(self, table, item):
        return 0
    #

    # }}}
    # {{{ _getItemOrigin

    def _getItemOrigin(self, table, item):
        col = item[0]
        row = item[1]
        classes = jarray.array([self.GridColumn, self.GridItem], Class)
        args = jarray.array([table.getColumn(col), table.getItems()[row]], Object)
        p = Reflector.call(table, "getOrigin", classes, args, True)
        return p

    # }}}
    # {{{ _loadClasses

    def _loadClasses(self, table):
        if not self.Point:
            self.Point = \
                table.getClass().getClassLoader().loadClass("org.eclipse.swt.graphics.Point")
            self.GridColumn = \
                table.getClass().getClassLoader().loadClass("org.eclipse.nebula.widgets.grid.GridColumn")
            self.GridItem = \
                table.getClass().getClassLoader().loadClass("org.eclipse.nebula.widgets.grid.GridItem")

    # }}}

    # --------------------------------------------------------------------------------------------
    # Checker interface
    # --------------------------------------------------------------------------------------------
    # {{{ supported check types

    # The supported check types for a cell item.
    cellTypes = jarray.array([CheckType.CELL,
                              CheckType.CELL_SELECTED], CheckType)

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
        col = item[0]
        row = item[1]
        if checkType.getDataType() == CheckDataType.STRING \
               and (CheckType.ID_DEFAULT == checkType.getIdentifier()
                    or CheckType.CELL.getIdentifier() == checkType.getIdentifier()):
            return StringCheckData(CheckType.ID_DEFAULT, table.getItems()[row].getText(col))
        if checkType.getDataType() == CheckDataType.BOOLEAN \
               and (CheckType.SELECTED.getIdentifier() == checkType.getIdentifier()
                    or CheckType.CELL_SELECTED.getIdentifier() == checkType.getIdentifier()):
            if table.getCellSelectionEnabled():
                cells = table.getCellSelection()
                for c in cells:
                    if c.x == row and c.y == col:
                        return BooleanCheckData(CheckType.SELECTED.getIdentifier(), 1)
                return BooleanCheckData(CheckType.SELECTED.getIdentifier(), 0)
            elif table.getSelectionEnabled():
                items = table.getSelection()
                for i in items:
                    if row == i.getParent().indexOf(i):
                        return BooleanCheckData(CheckType.SELECTED.getIdentifier(), 1)
                return BooleanCheckData(CheckType.SELECTED.getIdentifier(), 0)
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
        if CheckType.CELL.getIdentifier() == checkType.getIdentifier() \
                or CheckType.CELL_SELECTED.getIdentifier() == checkType.getIdentifier():
            return Pair(data, item)
        return Pair(data, None)

    # }}}

def intarray(*args):
    return jarray.array(args, 'i')

global ngir

try:
    ItemRegistry.instance("swt").unregisterItemResolver("org.eclipse.nebula.widgets.grid.Grid", ngir)
    CheckerRegistry.instance("swt").unregisterChecker("org.eclipse.nebula.widgets.grid.Grid", ngir)
except:
    pass
ngir = NebulaGridResolver()
ItemRegistry.instance("swt").registerItemResolver("org.eclipse.nebula.widgets.grid.Grid", ngir)
CheckerRegistry.instance("swt").registerChecker("org.eclipse.nebula.widgets.grid.Grid", ngir)
