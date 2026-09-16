import Quickshell
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts

import "../../../services"
import "../menus"

TextWidget {
    id: root

    property string notificationIcon: ""
    property string dndIcon: ""

    property Notification currentNotification: null

    text: notificationIcon

    Component.onCompleted: {
        NotificationService.notification.connect(root.notification)
    }

    Component {
        id: menuComponent

        NotificationMenu {
            id: notificationMenu

            notification: root.currentNotification
        }
    }

    function notification(notification: Notification) {
        root.currentNotification = notification

        root.menuRequested(menuComponent)
    }
}
