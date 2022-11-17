
# Handle hyperlinks in org.eclipse.ui.forms.widgets.FormText.

# {{{ imports

from de.qfs.apps.qftest.extensions import ResolverRegistry
from de.qfs.apps.qftest.extensions.items import ItemRegistry, ItemResolver
from de.qfs.apps.qftest.shared.data import SubItemIndex
from de.qfs.apps.qftest.shared.exceptions import IndexNotFoundException
from de.qfs.lib.util import Misc, Reflector
from java.lang import Boolean, Class
import jarray

# }}}
# {{{ intarray

def intarray(*args):
    return jarray.array(args, 'i')

# }}}

class FormTextResolver(ItemResolver):
    # {{{ __init__

    def __init__(self):
        pass

    # }}}
    # --------------------------------------------------------------------------------------------
    # ItemResolver interface
    # --------------------------------------------------------------------------------------------
    # {{{ getItem

    def getItem(self, com, x, y):
        model = Reflector.get(com, "model", True)
        link = model.findHyperlinkAt(x, y)
        if link:
            return link
        return None

    # }}}
    # {{{ getItemIndex

    def getItemIndex(self, com, item, type):
        result = None
        if type == SubItemIndex.AS_NUMBER:
            model = Reflector.get(com, "model", True)
            count = model.getHyperlinkCount()
            for i in range(count):
                if item == model.getHyperlink(i):
                    result = jarray.array([SubItemIndex(i)], SubItemIndex)
        else:
            result = jarray.array([SubItemIndex(item.getText(), SubItemIndex.QUOTE_STD)], SubItemIndex)
        return result

    # }}}
    # {{{ getItemForIndex

    def getItemForIndex(self, com, idx):
        model = Reflector.get(com, "model", True)
        count = model.getHyperlinkCount()
        if idx[0].getType() == SubItemIndex.NUMBER:
            i = idx[0].asNumber()
            if i < 0:
                i = i + count
            if i >= 0 and i < count:
                return model.getHyperlink(i)
        else:
            for i in range(count):
                link = model.getHyperlink(i)
                if idx[0].matches(link.getText()):
                    return link
        return None

    # }}}
    # {{{ getItemValue

    def getItemValue(self, com, item):
        return item.getText()

    # }}}
    # {{{ getItemLocation

    def getItemLocation(self, com, item):
        b = item.getBounds()
        return intarray(b.x, b.y)

    # }}}
    # {{{ getItemSize

    def getItemSize(self, com, item):
        b = item.getBounds()
        return intarray(b.width, b.height)

    # }}}
    # {{{ repositionMouseEvent

    def repositionMouseEvent(self, com, item, pos):
        return Boolean.FALSE

    # }}}
    # {{{ scrollItemVisible

    def scrollItemVisible(self, com, item, x, y):
        return None

    # }}}
    # {{{ getItemCount

    def getItemCount(self, com, item):
        # Currently unused
        return 0

    # }}}

def unregister():
    try:
        ItemRegistry.instance("swt").unregisterItemResolver("org.eclipse.ui.forms.widgets.FormText", formTextResolver)
    except:
        pass

def register():
    unregister()
    global formTextResolver
    formTextResolver = FormTextResolver()
    ItemRegistry.instance("swt").registerItemResolver("org.eclipse.ui.forms.widgets.FormText", formTextResolver)

