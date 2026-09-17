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

    ColumnLayout {
        id: column
        anchors.fill: parent

        Repeater {
            model: NotificationService.trackedNotifications

            NotificationView {
                Layout.fillWidth: true

                required property Notification modelData

                notification: modelData
            }
        }
    }
}
