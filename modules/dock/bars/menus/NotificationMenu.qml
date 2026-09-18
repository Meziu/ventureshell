import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Notifications

import "../../../config"
import "../../../services"
import "../widgets"

Menu {
    id: root
    implicitWidth: column.implicitWidth
    implicitHeight: column.implicitHeight + 16 // likely comes from cornerRadius margin

    persistent: true

    ColumnLayout {
        id: column
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }

        Repeater {
            model: NotificationService.trackedNotifications

            NotificationView {
                Layout.fillHeight: false
                Layout.fillWidth: true

                required property Notification modelData

                notification: modelData
            }
        }
    }
}
