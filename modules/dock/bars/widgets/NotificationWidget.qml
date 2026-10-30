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

    text: notificationIcon

    Component {
        id: menuComponent

        NotificationMenu {}
    }

    Component.onCompleted: {
        // explicit open rather than toggle, it stays on with multiple notifications
        NotificationService.notification.connect(() => root.openPopup(menuComponent))
    }
}
