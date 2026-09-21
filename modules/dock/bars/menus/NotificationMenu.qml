import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Notifications

import "../../../config"
import "../../../services"
import "../widgets"

Menu {
    id: root
    implicitWidth: column.implicitWidth
    implicitHeight: column.implicitHeight

    persistent: true

    ColumnLayout {
        id: column

        Repeater {
            model: NotificationService.trackedNotifications

            NotificationView {
                Layout.fillHeight: true
                Layout.fillWidth: true

                required property Notification modelData

                notification: modelData
            }
        }
    }
}
