import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Notifications

import "../../../config"
import "../widgets"

// Not to be confused with the NotificationsWidget
ClickableWidget {
    requestedLength: 400
    implicitWidth: 400
    implicitHeight: 100

    required property Notification notification

    ColumnLayout {
        id: layout

        anchors.fill: parent
        anchors.margins: 2

        RowLayout {
            Layout.preferredHeight: 14

            IconWidget {
                Layout.fillHeight: true
                visible: notification.appIcon !== ""

                clickable: false
                iconSize: height
                source: notification.appIcon
            }

            TextWidget {
                id: title

                Layout.fillHeight: true
                Layout.fillWidth: true

                clickable: false
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignLeft

                text: notification.summary
                fontSize: 12
            }
        }

        RowLayout {
            Layout.fillHeight: true
            Layout.fillWidth: true

            TextWidget {
                id: body

                Layout.fillHeight: true
                Layout.fillWidth: true

                clickable: false
                verticalAlignment: Text.AlignTop
                horizontalAlignment: Text.AlignLeft
                wrapMode: Text.WordWrap
                elide: false

                text: notification.body
                fontSize: 10
            }

            IconWidget {
                id: image

                Layout.fillHeight: true
                Layout.preferredWidth: height

                visible: notification.image !== ""
                clickable: false

                source: notification.image
                iconSize: 128
            }
        }
    }

    onClicked: {
        notification.dismiss()
    }
}
