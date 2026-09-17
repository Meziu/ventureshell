pragma Singleton

import Quickshell
import Quickshell.Services.Notifications

Singleton {
    id: root

    signal notification(notification: Notification)

    NotificationServer {
        onNotification: notification => {
            notification.tracked = true

            root.notification(notification)
        }
    }
}
