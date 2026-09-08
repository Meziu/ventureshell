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

    LauncherWidget {}

    IdleInhibitorWidget {}

    PowerWidget {}

    NetworkWidget {}

    NotificationsWidget {}

    property bool activeWidgetHasMenu: true
    protrusionActive: activeWidgetHasMenu
    protrusionEdge: "bottom"
    protrusionPosition: 60
    protrusionLength: 140
    protrusionDepth: activeWidgetHasMenu ? 60 : 0

    // Populate the protrusion slot
    protrusionContent: Column {
        anchors.fill: parent
        spacing: 8

        Text {
            text: "Menu Option 1"
            color: "white"
        }
        Text {
            text: "Menu Option 2"
            color: "white"
        }
    }
}
