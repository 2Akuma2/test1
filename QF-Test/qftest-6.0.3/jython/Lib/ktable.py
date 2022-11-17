from java.lang import Class, Object, Boolean, Integer, String
from java.lang.reflect import Array

from de.qfs.lib.log import Log, Logger
from de.qfs.lib.util import Pair, Reflector

from de.qfs.apps.qftest.client import Client
from de.qfs.apps.qftest.extensions import ResolverRegistry, ScrollOffsetResolver
from de.qfs.apps.qftest.extensions.items import ItemRegistry, ItemResolver
from de.qfs.apps.qftest.extensions.checks import CheckerRegistry, Checker, CheckDataType, CheckType
from de.qfs.apps.qftest.shared.data import SubItemIndex
from de.qfs.apps.qftest.shared.data.check import BooleanCheckData, SelectableItemsCheckData
from de.qfs.apps.qftest.shared.data.check import StringCheckData, StringItemsCheckData

import jarray, sys, types

logger = Logger("de.qfs.apps.qftest.extensions.items.KTableItemResolver")

# ItemResolver for the KTable class
#
# Internal Item representation is int for column or int[col,row] for cell where row is
# the KTable index, i.e. for a KTable with a column header, row 0 is never used. For the
# external representation, row index 0 represents KTable row 1 if there is a column header.
class KTableResolver(ScrollOffsetResolver, ItemResolver, Checker):
    # {{{ __init__

    def __init__(self):
        if logger.level >= Log.MTD:
            lb = logger.build("__init__()")
            lb.log(Log.MTD)
    #

    # }}}

    # --------------------------------------------------------------------------------------------
    # ScrollOffsetResolver interface
    # --------------------------------------------------------------------------------------------
    # {{{ fromScrolledLocation

    def fromScrolledLocation(self, table, pos):
        if logger.level >= Log.MTD:
            lb = logger.build("fromScrolledLocation(table,pos)")
            if logger.level >= Log.MTDDETAIL:
                 lb.add("table: ").add(table).add(", pos: ").add(pos)
            lb.log(Log.MTD)
        m = table.getModel()
        fc = m.getFixedHeaderColumnCount() + m.getFixedSelectableColumnCount()
        fcw = self._getColumnX(table, fc)
        fr = m.getFixedHeaderRowCount() + m.getFixedSelectableRowCount()
        frh = self._getRowY(table, fr)

        if pos[0] > fcw or pos[1] > frh:
            sx, sy = self._getScrollPos(table, fcw, frh)
            if logger.level >= Log.DBG:
                logger.build("fromScrolledLocation(table,pos)") \
                    .add("sx: ").add(sx).add(", sy: ").add(sy).log(Log.DBG)
            if pos[0] > fcw:
                pos[0] += sx
            if pos[1] > frh:
                pos[1] += sy
        return pos
    #

    # }}}
    # {{{ toScrolledLocation

    def toScrolledLocation(self, table, pos):
        if logger.level >= Log.MTD:
            lb = logger.build("toScrolledLocation(table,pos)")
            if logger.level >= Log.MTDDETAIL:
                 lb.add("table: ").add(table).add(", pos: ").addAll(pos)
            lb.log(Log.MTD)
        m = table.getModel()
        fc = m.getFixedHeaderColumnCount() + m.getFixedSelectableColumnCount()
        fcw = self._getColumnX(table, fc)
        fr = m.getFixedHeaderRowCount() + m.getFixedSelectableRowCount()
        frh = self._getRowY(table, fr)

        if pos[0] > fcw or pos[1] > frh:
            sx, sy = self._getScrollPos(table, fcw, frh)
            if logger.level >= Log.DBG:
                logger.build("toScrolledLocation(table,pos)") \
                    .add("sx: ").add(sx).add(", sy: ").add(sy).log(Log.DBG)
            if pos[0] > fcw:
                pos[0] -= sx
            if pos[1] > frh:
                pos[1] -= sy
        return pos
    #

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
        if y is None:
            return self.getItemForIndex(table, x)
        col = self._getColumn(table, x)
        if logger.level >= Log.DBG:
            logger.build("getItem(x,y)") \
                .add("col: ").add(col).log(Log.DBG)
        if col < 0:
            return None
        row = self._getRow(table, y)
        if logger.level >= Log.DBG:
            logger.build("getItem(x,y)") \
                .add("row: ").add(row).log(Log.DBG)
        if row < 0:
            # Column
            return col
        if row == 0 and table.getModel().getFixedHeaderRowCount() + \
            table.getModel().getFixedSelectableRowCount() > 0:
            # Column header -> Column
            return col
        return intarray(col, row)
    #

    # }}}
    # {{{ getItemValue

    def getItemValue(self, table, item):
        if logger.level >= Log.MTD:
            lb = logger.build("getItemValue(table,item)")
            if logger.level >= Log.MTDDETAIL:
                 lb.add("table: ").add(table).add(", item: ").addAll(item)
            lb.log(Log.MTD)
        try:
            return self._getCellValue(table, item[0], item[1])
        except TypeError:
            # Column
            return self._getCellValue(table, item, 0)
    #

    # }}}
    # {{{ getItemForIndex

    def getItemForIndex(self, table, index):
        if logger.level >= Log.MTD:
            lb = logger.build("getItemForIndex(table,index)")
            if logger.level >= Log.MTDDETAIL:
                 lb.add("table: ").add(table).add(", index: ").add(index)
            lb.log(Log.MTD)
        col = -1
        colIdx = index[0]
        cols = table.getModel().getColumnCount()
        rows = table.getModel().getRowCount()
        if cols <= 0 or rows <= 0:
            return None
        if colIdx.getType() == SubItemIndex.NUMBER:
            col = colIdx.asNumber()
        else:
            for i in range(cols):
                tmp = self._getCellName(table, i, 0)
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
        rowOffset = 0
        # 0 is considered column header
        if table.getModel().getFixedHeaderRowCount() + \
               table.getModel().getFixedSelectableRowCount() > 0:
            rowOffset = 1
        if rowIdx.getType() == SubItemIndex.NUMBER:
            row = rowIdx.asNumber() + rowOffset
        else:
            for i in range(rows):
                if i >= rowOffset:
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
    #

    # }}}
    # {{{ getItemIndex

    def getItemIndex(self, table, item, type):
        if logger.level >= Log.MTD:
            lb = logger.build("getItemIndex(table,item,type)")
            if logger.level >= Log.MTDDETAIL:
                 lb.add("table: ").add(table).add(", item: ").addAll(item).add(", type: ").add(type)
            lb.log(Log.MTD)
        try:
            col = item[0]
            row = item[1]
        except TypeError:
            col = item
            row = -1
        ctype = type
        if ctype == 1:
            # Intelligent, check for uniqueness
            if table.getModel().getRowCount() == 0 or table.getModel().getColumnCount() == 0:
                ctype = 3
            else:
                name = self._getCellName(table, col, 0)
                if name:
                    for i in range(table.getModel().getColumnCount()):
                        if i != col:
                            cname = self._getCellName(table, i, 0)
                            if name == cname:
                                ctype = 3
                                break;
                    else:
                        ctype = 2

        if ctype == 2:
            name = self._getCellName(table, col, 0)
            colIdx = SubItemIndex(name)
        else:
            colIdx = SubItemIndex(col)
        if logger.level >= Log.DBG:
            logger.build("getItemIndex(table,item,type)") \
                .add("colIdx: ").add(colIdx).log(Log.DBG)

        if row < 0:
            return jarray.array([colIdx], SubItemIndex)

        if type == 2:
            name = self._getCellName(table, col, row)
            rowIdx = SubItemIndex(name)
        else:
            if table.getModel().getFixedHeaderRowCount() + \
               table.getModel().getFixedSelectableRowCount() > 0:
                # 0 is considered column header
                rowIdx = SubItemIndex(row - 1)
            else:
                rowIdx = SubItemIndex(row)

        if logger.level >= Log.DBG:
            logger.build("getItemIndex(table,item,type)") \
                .add("rowIdx: ").add(rowIdx).log(Log.DBG)
        return jarray.array([colIdx, rowIdx], SubItemIndex)
    #

    # }}}
    # {{{ getItemLocation

    def getItemLocation(self, table, item):
        if logger.level >= Log.MTD:
            lb = logger.build("getItemLocation(table,item)")
            if logger.level >= Log.MTDDETAIL:
                 lb.add("table: ").add(table).add(", item: ").addAll(item)
            lb.log(Log.MTD)
        try:
            return intarray(self._getColumnX(table, item[0]), self._getRowY(table, item[1]))
        except TypeError:
            # Column
            return intarray(self._getColumnX(table, item), 0)
    #

    # }}}
    # {{{ getItemSize

    def getItemSize(self, table, item):
        if logger.level >= Log.MTD:
            lb = logger.build("getItemSize(table,item)")
            if logger.level >= Log.MTDDETAIL:
                 lb.add("table: ").add(table).add(", item: ").addAll(item)
            lb.log(Log.MTD)
        try:
            if item[1] == 0:
                height = self._getHeaderHeight(table)
            else:
                height = self._getRowHeight(table)
            return intarray(table.getModel().getColumnWidth(item[0]), height)
        except TypeError:
            m = table.getModel()
            if m.getRowCount() == 0:
                height = 0
            else:
                height = self._getHeaderHeight(table) + \
                     self._getRowHeight(table) * (m.getRowCount() - 1)
            return intarray(m.getColumnWidth(item), height)
    #

    # }}}
    # {{{ repositionMouseEvent

    def repositionMouseEvent(self, table, item, pos):
        if logger.level >= Log.MTD:
            lb = logger.build("repositionMouseEvent(table,item,pos)")
            if logger.level >= Log.MTDDETAIL:
                 lb.add("table: ").add(table).add(", item: ").addAll(item).add(", pos: ").add(pos)
            lb.log(Log.MTD)
        try:
            if type(table.getModel().getContentAt(item[0], item[1])) in types.StringTypes:
                if Client.instance().getOptions().getBoolean("RepositionMiddle", True):
                    pos[0] = Integer.MAX_VALUE;
                    pos[1] = Integer.MAX_VALUE;
                else:
                    pos[0] = min(pos[0], 1 )
                    pos[1] = min(pos[1], 1 )
                return Boolean(True)
        except TypeError:
            # Column
            if type(table.getModel().getContentAt(item, 0)) in types.StringTypes:
                if Client.instance().getOptions().getBoolean("RepositionMiddle", True):
                    pos[0] = Integer.MAX_VALUE;
                    pos[1] = Integer.MAX_VALUE;
                else:
                    pos[0] = min(pos[0], 1 )
                    pos[1] = min(pos[1], 1 )
                return Boolean(True)
        return Boolean(False)
    #

    # }}}
    # {{{ scrollItemVisible

    def scrollItemVisible(self, table, item, x, y):
        if logger.level >= Log.MTD:
            lb = logger.build("scrollItemVisible(table,item,x,y)")
            if logger.level >= Log.MTDDETAIL:
                 lb.add("table: ").add(table).add(", item: ").addAll(item) \
                 .add(", x: ").add(x).add(", y: ").add(y)
            lb.log(Log.MTD)

        m = table.getModel()

        rowVis = Reflector.get(table, "m_RowsFullyVisible", 1)
        if rowVis == 0:
            Reflector.call(table, "doCalculations", 1)
            if logger.level >= Log.DBG:
                logger.build("scrollItemVisible(table,item,x,y)") \
                    .add("doCalculations").log(Log.DBG)
            rowVis = Reflector.get(table, "m_RowsFullyVisible", 1)

        fixedCols = m.getFixedHeaderColumnCount() + m.getFixedSelectableColumnCount()
        leftCol = Reflector.get(table, "m_LeftColumn", 1)
        colVis = Reflector.get(table, "m_ColumnsFullyVisible", 1)
        if logger.level >= Log.DBG:
            logger.build("scrollItemVisible(table,item,x,y)") \
                .add("fixedCols: ").add(fixedCols) \
                .add(", leftCol: ").add(leftCol) \
                .add(", colVis: ").add(colVis).log(Log.DBG)

        fixedRows = m.getFixedHeaderRowCount() + m.getFixedSelectableRowCount()
        topRow = Reflector.get(table, "m_TopRow", 1)
        if logger.level >= Log.DBG:
            logger.build("scrollItemVisible(table,item,x,y)") \
                .add("fixedRows: ").add(fixedRows) \
                .add(", topRow: ").add(topRow) \
                .add(", rowVis: ").add(rowVis).log(Log.DBG)

        try:
            col = item[0]
            row = item[1]
        except TypeError:
            # Column only
            col = item
            row = 0
        if logger.level >= Log.DBG:
            logger.build("scrollItemVisible(table,item,x,y)") \
                .add("col: ").add(col) \
                .add(", row: ").add(row).log(Log.DBG)

        changed = 0
        # vertical scroll allowed?
        if table.getVerticalBar() is not None:
            if row < topRow and row >= fixedRows:
                topRow = 1
                changed = 1

            if row >= topRow + rowVis:
                topRow = row - rowVis + 1
                changed = 1

        # horizontal scroll allowed?
        if table.getHorizontalBar() is not None:
            if col < leftCol and col >= fixedCols:
                leftCol = col
                changed = 1

            if col >= leftCol + colVis:
                rect = table.getClientArea()
                m = table.getModel()
                xright = self._getColumnX(table, col + 1)
                while leftCol < col and xright > rect.x + rect.width:
                    xright -= m.getColumnWidth(leftCol)
                    leftCol += 1
                    changed = 1

        if not changed:
            if logger.level >= Log.DBG:
                logger.build("scrollItemVisible(table,item,x,y)") \
                    .add("all OK").log(Log.DBG)
            return Boolean.FALSE

        if table.getHorizontalBar() is not None:
            table.getHorizontalBar().setSelection(leftCol)
        if table.getVerticalBar() is not None:
            table.getVerticalBar().setSelection(topRow)
        Reflector.set(table, "m_LeftColumn", leftCol, 1)
        Reflector.set(table, "m_TopRow", topRow, 1)
        table.redraw()
        table.update()
        return Boolean.TRUE
    #

    # }}}
    # {{{ getItemCount

    def getItemCount(self, table, item):
        return 0
    #

    # }}}

    # --------------------------------------------------------------------------------------------
    # Checker interface
    # --------------------------------------------------------------------------------------------
    # {{{ supported check types

    # The supported check types with no item.
    stdTypes = jarray.array([CheckType.ENABLED,
                             CheckType.GEOMETRY], CheckType)

    # The supported check types for column item.
    columnTypes = jarray.array([CheckType.HEADER_FOR_TABLE,
                                CheckType.COLUMN,
                                CheckType.COLUMN_WITH_SELECTION,
                                CheckType.ENABLED,
                                CheckType.GEOMETRY], CheckType)

    # The supported check types for a cell item.
    cellTypes = jarray.array([CheckType.CELL,
                              CheckType.CELL_SELECTED,
                              CheckType.ROW,
                              CheckType.HEADER_FOR_TABLE,
                              CheckType.COLUMN,
                              CheckType.COLUMN_WITH_SELECTION,
                              CheckType.ENABLED,
                              CheckType.GEOMETRY], CheckType)

    # }}}
    # {{{ getSupportedCheckTypes

    def getSupportedCheckTypes(self, table, item):
        if logger.level >= Log.MTD:
            lb = logger.build("getSupportedCheckTypes(table,item)")
            if logger.level >= Log.MTDDETAIL:
                 lb.add("table: ").add(table).add(", item: ").addAll(item)
            lb.log(Log.MTD)

        if item is None:
            return self.stdTypes

        try:
            item[0]
            return self.cellTypes
        except TypeError:
            # Column
            return self.columnTypes

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
            # All checks on the whole table are handled by ControlChecker
            return None

        try:
            col = item[0]
            row = item[1]
        except TypeError:
            # Column
            col = item
            row = -1

        rowCount = table.getModel().getRowCount()

        if checkType.getDataType() == CheckDataType.STRING \
               and ((row < 0 and CheckType.ID_DEFAULT == checkType.getIdentifier())
                    or CheckType.HEADER_FOR_TABLE.getIdentifier() == checkType.getIdentifier()
                    or "header" == checkType.getIdentifier()):
            return StringCheckData(CheckType.ID_DEFAULT, self._getCellValue(table, col, 0))

        if checkType.getDataType() == CheckDataType.STRING_LIST \
               and ((row < 0 and CheckType.ID_DEFAULT == checkType.getIdentifier())
                    or CheckType.COLUMN.getIdentifier() == checkType.getIdentifier()):
            values = jarray.zeros(rowCount - 1, String)
            for i in range(rowCount - 1):
                values[i] = self._getCellValue(table, col, i + 1)
            return StringItemsCheckData(CheckType.ID_DEFAULT, values)

        if checkType.getDataType() == CheckDataType.SELECTABLE_STRING_LIST \
               and ((row < 0 and CheckType.ID_DEFAULT == checkType.getIdentifier())
                    or CheckType.COLUMN_WITH_SELECTION.getIdentifier()
                           == checkType.getIdentifier()):
            # Object[][] values = new Object[table.getItemCount()][];
            values = Array.newInstance(Object, [rowCount - 1, 3])
            for i in range(rowCount - 1):
                values[i][0] = self._getCellValue(table, col, i + 1)
                values[i][1] = Boolean(0)
                values[i][2] = Boolean(table.isCellSelected(col, i + 1))
            if logger.level >= Log.DBG:
                logger.build("getCheckData(table,item,checkType)") \
                    .add("values: ").addAll(values).log(Log.DBG)
            return SelectableItemsCheckData(CheckType.ID_DEFAULT, values)

        if row >= 0:
            if checkType.getDataType() == CheckDataType.STRING \
                   and (CheckType.ID_DEFAULT == checkType.getIdentifier()
                        or CheckType.CELL.getIdentifier() == checkType.getIdentifier()):
                return StringCheckData(CheckType.ID_DEFAULT, self._getCellValue(table, col, row))

            if checkType.getDataType() == CheckDataType.BOOLEAN \
                   and (CheckType.SELECTED.getIdentifier() == checkType.getIdentifier()
                        or CheckType.CELL_SELECTED.getIdentifier() == checkType.getIdentifier()
                        or "cell_selected" == checkType.getIdentifier()):
                return BooleanCheckData(CheckType.SELECTED.getIdentifier(),
                                        table.isCellSelected(col, row))

            if checkType.getDataType() == CheckDataType.STRING_LIST \
                    and CheckType.ROW.getIdentifier() == checkType.getIdentifier():
                count = table.getModel().getColumnCount()
                values = jarray.zeros(count, String)
                for i in range(count):
                    values[i] = self._getCellValue(table, i, row)
                return StringItemsCheckData(CheckType.ROW.getIdentifier(), values)

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

        try:
            col = item[0]
            row = item[1]
        except TypeError:
            # Column
            col = item
            row = -1

        if CheckType.HEADER_FOR_TABLE.getIdentifier() == checkType.getIdentifier() \
            or CheckType.COLUMN.getIdentifier() == checkType.getIdentifier() \
            or CheckType.COLUMN_WITH_SELECTION.getIdentifier() == checkType.getIdentifier():
            return Pair(data, col)

        if row >= 0:
            if CheckType.CELL.getIdentifier() == checkType.getIdentifier() \
                or CheckType.CELL_SELECTED.getIdentifier() == checkType.getIdentifier() \
                or CheckType.ROW.getIdentifier() == checkType.getIdentifier():
                return Pair(data, item)
        return Pair(data, None)

    # }}}

    # --------------------------------------------------------------------------------------------
    # Helper methods
    # --------------------------------------------------------------------------------------------
    # {{{ _getScrollPos

    def _getScrollPos(self, table, fcw, frh):
        m = table.getModel()
        hbar = table.getHorizontalBar()
        if hbar:
            fc = m.getFixedHeaderColumnCount() + m.getFixedSelectableColumnCount()
            if hbar.getSelection() == fc:
                x = 0
            else:
                x = self._getColumnX(table, hbar.getSelection()) - fcw
        else:
            x = 0
        vbar = table.getVerticalBar()
        if vbar:
            fr = m.getFixedHeaderRowCount() + m.getFixedSelectableRowCount()
            y = self._getRowY(table, vbar.getSelection()) - frh
        else:
            y = 0
        return (x,y)
    #

    # }}}
    # {{{ _getHeaderHeight

    def _getHeaderHeightOld(self, table):
        return table.getModel().getFirstRowHeight()

    def _getHeaderHeightNew(self, table):
        return table.getModel().getRowHeight(0)

    def _getHeaderHeight(self, table):
        try:
            height = self._getHeaderHeightOld(table)
            self._getHeaderHeight = self._getHeaderHeightOld
        except:
            height = self._getHeaderHeightNew(table)
            self._getHeaderHeight = self._getHeaderHeightNew
        return height

    # }}}
    # {{{ _getRowHeight

    def _getRowHeightOld(self, table):
        return table.getModel().getRowHeight()

    def _getRowHeightNew(self, table):
        return table.getModel().getRowHeight(1)

    def _getRowHeight(self, table):
        try:
            height = self._getRowHeightOld(table)
            self._getRowHeight = self._getRowHeightOld
        except:
            height = self._getRowHeightNew(table)
            self._getRowHeight = self._getRowHeightNew
        return height

    # }}}
    # {{{ _getColumn

    def _getColumn(self, table, x):
        w = 1
        m = table.getModel()
        for i in range(m.getColumnCount()):
            w += m.getColumnWidth(i)
            if (w > x):
                return i
        return -1
    #

    # }}}
    # {{{ _getColumnX

    def _getColumnX(self, table, column):
        w = 1
        m = table.getModel()
        for i in range(m.getColumnCount()):
            if column == i:
                return w
            w += m.getColumnWidth(i)
        return w
    #

    # }}}
    # {{{ _getRow

    def _getRow(self, table, y):
        h = self._getHeaderHeight(table)
        if y <= h:
            return 0
        row = 1 + (y - h - 1) / self._getRowHeight(table)
        if row >= table.getModel().getRowCount():
            return -1
        return row
    #

    # }}}
    # {{{ _getRowY

    def _getRowY(self, table, row):
        if row == 0:
            return 1
        return 1 + self._getHeaderHeight(table) + (row - 1) * self._getRowHeight(table)
    #

    # }}}
    # {{{ _getCellName

    # Get the name for addressing a cell in the table
    def _getCellName(self, table, column, row):
        val = str(table.getModel().getContentAt(column, row))
        ret = ItemRegistry.instance("swt").getItemName(table, intarray(column, row), val)
        if ret is None:
            return ""
        return str(ret)
    #

    # }}}
    # {{{ _getCellValue

    # Get the value of a cell in the table
    def _getCellValue(self, table, column, row):
        val = table.getModel().getContentAt(column, row)
        ret = ItemRegistry.instance("swt").resolveItemValue(table, intarray(column, row), str(val))
        if ret is None:
            return ""
        return str(ret)
    #

    # }}}
#

def intarray(*args):
    return jarray.array(args, 'i')

global ktir

try:
    ResolverRegistry.instance("swt").unregisterScrollOffsetResolver("de.kupzog.ktable.KTable", ktir)
    ItemRegistry.instance("swt").unregisterItemResolver("de.kupzog.ktable.KTable", ktir)
    CheckerRegistry.instance("swt").unregisterChecker("de.kupzog.ktable.KTable", ktir)
except:
    pass
ktir = KTableResolver()
ResolverRegistry.instance("swt").registerScrollOffsetResolver("de.kupzog.ktable.KTable", ktir)
ItemRegistry.instance("swt").registerItemResolver("de.kupzog.ktable.KTable", ktir)
CheckerRegistry.instance("swt").registerChecker("de.kupzog.ktable.KTable", ktir)
