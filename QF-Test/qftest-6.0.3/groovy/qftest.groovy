import de.qfs.ServerContext
import de.qfs.DataBinder
import de.qfs.UserNotifications

qf = de.qfs.QF
Options = de.qfs.apps.qftest.shared.extensions.Options
rc = new ServerContext("groovy")
qf.setRCProvider({new ServerContext("groovy")})
databinder = DataBinder.instance()
notifications = UserNotifications.instance()
