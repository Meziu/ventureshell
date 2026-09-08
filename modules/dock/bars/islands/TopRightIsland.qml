import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

import "../../../shapes"
import "../widgets"

Island {
    id: root

    widgetsFillIsland: false

    anchors {
        top: parent.top
        right: parent.right
    }

    widgetContainer.anchors.rightMargin: root.cornerRadius

    attached: Attach {
        top: true
        left: false
        right: true
        bottom: false
    }

    IdleInhibitorWidget {}

    PowerWidget {}

    NetworkWidget {}

    NotificationsWidget {}

    protrusionPosition: 30

    // Populate the protrusion slot
    protrusionContent: Item {
        anchors.fill: parent
        implicitWidth: 110
        implicitHeight: 60

        Column {
            spacing: 10
            Text {
                text: "Menu option 1"
            }
            Text {
                text: "Menu option 2"
            }
        }

        Rectangle {
            anchors.fill: parent

            opacity: 0.1
        }
    }
}
