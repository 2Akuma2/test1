import atexit
import sys
import time

from jpype import JImplements, JOverride

from java.lang import Thread
from de.qfs.lib.log import Log
from de.qfs.lib.util import ThreadGroupTreeAdapter
from de.qfs.lib.tree import TreeUtil, TraversalCallback

_daemon = None

@JImplements(TraversalCallback)
class RMIReaperFinder(object):
    def __init__(self):
        self.thread = None

    @JOverride
    def nodeEntered(self, traversal):
        # print(time.strftime("%H:%M:%S", time.localtime(time.time())), "thread: %s" % traversal.getNode(), file=sys.stderr)
        if traversal.getNode().getName() == "RMI Reaper":
            self.thread = traversal.getNode()
        return True

    @JOverride
    def nodeExited(self, traversal):
        pass


def terminateThread():
    global _daemon
    try:
        # print(time.strftime("%H:%M:%S", time.localtime(time.time())), "_daemon:", _daemon, file=sys.stderr)
        if _daemon and _daemon.context:
            _daemon.context.stopTest()
    except:
        import traceback
        traceback.print_exc(file=sys.stderr)

    Log.setQueueing(False)
    Thread.sleep(1000)
    for i in range(20):
        tgta = ThreadGroupTreeAdapter()
        rootTG = TreeUtil.getRoot(tgta, Thread.currentThread())
        # print(time.strftime("%H:%M:%S", time.localtime(time.time())), "rootTG", rootTG, file=sys.stderr)
        rmrf = RMIReaperFinder()
        TreeUtil.traverse(tgta, rootTG, rmrf)
        rmiReaperThread = rmrf.thread
        # print(time.strftime("%H:%M:%S", time.localtime(time.time())), "rmiReaperThread: %s" % rmiReaperThread, file=sys.stderr)
        if rmiReaperThread is not None:
            # print("Terminating RMI Reaper", file=sys.stderr)
            rmiReaperThread.interrupt()
            break
    Thread.sleep(1000)

def setAtExit(daemon):
    # print(time.strftime("%H:%M:%S", time.localtime(time.time())), "daemon:", daemon, file=sys.stderr)
    global _daemon
    _daemon = daemon
    atexit.register(terminateThread)
