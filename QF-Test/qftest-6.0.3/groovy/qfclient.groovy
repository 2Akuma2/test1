import javax.swing.SwingUtilities
import de.qfs.SutContext
import de.qfs.Resolvers
import de.qfs.WebResolvers
import de.qfs.UserNotifications
import de.qfs.apps.qftest.client.Engine
import de.qfs.apps.qftest.shared.script.groovy.GroovyHelper

import de.qfs.RunEngine
qf = de.qfs.QF
Options = de.qfs.apps.qftest.shared.extensions.Options
rc = new SutContext("groovy")
qf.setRCProvider({new SutContext("groovy")})
resolvers = Resolvers.instance()
try {
    webResolvers = WebResolvers.instance()
} catch (e) {
    // webResolvers not available
}
notifications = UserNotifications.instance()

runAndroid = { cmd, timeout= 5000 -> RunEngine.runAndroid("groovy", cmd, timeout)
}
runAWT = { cmd, timeout= 5000 -> RunEngine.runAWT("groovy", cmd, timeout)
}
runSWT = { cmd, timeout= 5000 -> RunEngine.runSWT("groovy", cmd, timeout)
}
runWeb = { cmd, timeout= 5000 -> RunEngine.runWeb("groovy", cmd, timeout)
}
runFX = { cmd, timeout= 5000 -> RunEngine.runFX("groovy", cmd, timeout)
}
runWin = { cmd, timeout= 5000 -> RunEngine.runWin("groovy", cmd, timeout)
}
