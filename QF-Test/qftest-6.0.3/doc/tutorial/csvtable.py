# Simple module for reading CSV files and
# for verifying tables
import string
from java.lang import Integer, Boolean, NumberFormatException

def loadTable(file, separator='|'):
    __doc__="""Load data from a CSV table
    @param      file      The name of the file
    @param      separator The separator character

    @return     The data as an array of tuples.
                Access with [row][column].
    """
    data = []
    fd = open(file, "r")
    line = fd.readline()
    while line:
        line = string.strip(line)
        if len(line) > 0:
            data.append(string.split(line,separator))
        line = fd.readline()
    return data

def verifyTable(rc, table, data):
    __doc__="""Load data from a CSV table
    @param      rc      The current run-context for Logging.
                        None means no logging.
    @param      table   The Java table
    @param      data    The data as an array of tuples

    @return     True (1) if everything is OK,
                false (0) if there are errors.
    """
    ret = 1
    # check the number of rows
    if table.getRowCount() != len(data):
        if rc:
            rc.logError("Row count mismatch")
        return 0
    # check each row
    for i in range(len(data)):
        row = data[i]
        # check the number of columns
        if table.getModel().getColumnCount() != len(row):
            if rc:
                rc.logError("Column count mismatch in row " +
                            `i`)
            ret = 0
        else:
            # check each cell
            for j in range(len(row)):
                val = table.getModel().getValueAt(i, j)
                if val is None:
                    val = ""
                cc = table.getModel().getColumnClass(j)
                if cc == Boolean:
                    test = Boolean(row[j]).equals(Boolean(val))
                elif cc == Integer:
                    try:
                        test = (row[j] == "" and val == "") \
                               or Integer(row[j]).equals(Integer(val))
                    except NumberFormatException:
                        test = 0
                else:
                    test = str(val) == row[j]
                if not test:
                    if rc:
                        rc.logError("Mismatch in row " + `i` +
                                    " column " + `j` + ":\ndata: " +
                                    row[j] + "\ntable: " + str(val))
                    ret = 0
    return ret
