import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

import "../../../config"
import "../../../shapes"
import "../widgets"

Island {
    id: root

    horizontal: false
    widgetsFillIsland: false

    //widgetContainer.anchors.bottomMargin: root.cornerRadius

    attached: Attach {
        top: false
        left: true
        right: false
        bottom: true
    }

    anchors {
        bottom: parent.bottom
        left: parent.left
    }

    CPUWidget {
        horizontal: root.horizontal
    }
    RAMWidget {
        horizontal: root.horizontal
    }
    StorageWidget {
        horizontal: root.horizontal
    }

    AudioWidget {
        horizontal: root.horizontal
    }
}
