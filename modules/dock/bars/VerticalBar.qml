import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

import "islands"

Bar {
    id: root

    position: Bar.Left

    // The center island has size priority
    readonly property real distanceFromCenterIsland: (height - leftCenterIsland.height) / 2

    LeftCenterIsland {
        id: leftCenterIsland
        cornerRadius: barCornerRadius
        size: barSize
        horizontal: false
    }
}
