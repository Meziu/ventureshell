import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Notifications

import "../../../config"
import "../../../shapes"
import "../widgets"

// Not to be confused with the NotificationWidget
ClickableWidget {
    id: root

    implicitWidth: 400
    implicitHeight: layout.implicitHeight + layout.anchors.margins * 2
    baseOpacity: 0.1
    hoverOpacity: 0.2

    required property Notification notification
    property real defaultTimeout: 5000

    function dismiss() {
        notification.dismiss()
    }

    function expire() {
        notification.expire()
    }

    ColumnLayout {
        id: layout

        anchors.fill: parent
        anchors.margins: 2

        Layout.minimumWidth: 300

        RowLayout {
            Layout.minimumHeight: 32

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

            CompletionCircle {
                Layout.fillHeight: true
                Layout.preferredWidth: height

                NumberAnimation on completion {
                    // By the spec, the notification should stay permanently if 0
                    running: notification.expireTimeout !== 0
                    from: 1.0
                    to: 0.0
                    duration: notification.expireTimeout < 0 ? root.defaultTimeout : notification.expireTimeout

                    onFinished: root.expire()
                }
            }
        }

        RowLayout {
            Layout.minimumHeight: 32
            Layout.preferredHeight: 60
            Layout.fillWidth: true

            TextWidget {
                id: body

                Layout.fillHeight: true
                Layout.fillWidth: true

                clickable: false
                verticalAlignment: Text.AlignTop
                horizontalAlignment: Text.AlignLeft
                wrapMode: Text.Wrap
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
        root.dismiss();
    }
}
