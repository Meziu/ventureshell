import QtQuick
import QtQuick.Layouts
import Quickshell

import "../../../assetloaders"
import "../../../services"
import "../widgets"

Menu {
    implicitWidth: 350
    implicitHeight: 300

    Rectangle {
        id: screen
        property real borderWidth: 10

        anchors {
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }

        implicitHeight: 120

        color: "#242E37"

        border {
            color: "#4E5065"
            width: borderWidth
        }

        radius: 16

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: screen.borderWidth + 4

            TextWidget {
                Layout.fillWidth: true

                clickable: false
                text: MediaPlayerService.trackArtist
                font: OuterWildsFont.signalscopeWithSize(10)
                color: "#ADE1E5"
                horizontalAlignment: Text.AlignHCenter
            }

            // Placeholder for cool line
            Item {
                Layout.fillHeight: true
                implicitHeight: 60
            }

            TextWidget {
                Layout.fillWidth: true

                clickable: false
                text: MediaPlayerService.trackTitle
                font: OuterWildsFont.signalscopeWithSize(12)
                color: OuterWildsFont.defaultColor
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }
}
