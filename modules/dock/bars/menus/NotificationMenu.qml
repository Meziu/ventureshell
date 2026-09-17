import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Notifications

import "../../../config"
import "../widgets"

Menu {
    id: root
    implicitWidth: 400
    implicitHeight: 120

    required property Notification notification

    NotificationView {
        notification: root.notification
    }
}
