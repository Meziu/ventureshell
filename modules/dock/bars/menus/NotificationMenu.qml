import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts

import "../../../config"
import "../widgets"

Menu {
    id: root
    implicitWidth: 400
    implicitHeight: 120

    required property Notification notification

    ColumnLayout {
        id: layout

        anchors.fill: parent

        RowLayout {
            Layout.margins: 4

            TextWidget {
                id: title

                Layout.fillHeight: true
                Layout.fillWidth: true

                clickable: true
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignLeft

                text: notification.summary
                fontSize: 16
            }
        }

        RowLayout {
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.margins: 4

            TextWidget {
                id: body

                Layout.fillHeight: true
                Layout.fillWidth: true

                clickable: true
                verticalAlignment: Text.AlignTop
                horizontalAlignment: Text.AlignLeft

                text: notification.body
                fontSize: 14
            }

            Image {
                id: image

                Layout.fillHeight: true
                Layout.preferredWidth: height

                source: "file:assets/images/outerwilds/backgrounds/SolarSystem.jpg"
                sourceSize.width: 128
                sourceSize.height: 128

                fillMode: Image.PreserveAspectCrop
                verticalAlignment: Image.AlignTop
                horizontalAlignment: Image.AlignLeft
            }
        }
    }

    Rectangle {
        anchors.fill: layout

        opacity: 0.1
        radius: Config.options.bar.cornerRadius
    }
}
