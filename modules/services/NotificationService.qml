pragma Singleton

import Quickshell
import Quickshell.Services.Notifications

Singleton {
    id: root

    property alias trackedNotifications: server.trackedNotifications

    signal notification(notification: Notification)

    NotificationServer {
        id: server

        bodySupported: true
        inlineReplySupported: false // TODO
        bodyImagesSupported: true
        imageSupported: true
        bodyMarkupSupported: false // TODO
        persistenceSupported: false // TODO
        actionsSupported: false // TODO
        actionIconsSupported: false // TODO
        bodyHyperlinksSupported: false // TODO

        onNotification: notification => {
            notification.tracked = true

            root.notification(notification)
        }
    }
}
