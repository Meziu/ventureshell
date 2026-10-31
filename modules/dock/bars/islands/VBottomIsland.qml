import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

import "../../../config"
import "../../../shapes"
import "../../../effects"
import "../widgets"

Island {
    id: root

    horizontal: false
    widgetsFillIsland: false

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

    AudioWidget {
        horizontal: root.horizontal
    }
}
