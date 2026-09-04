import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

import "islands"

Bar {
    id: root

    position: Bar.Top

    // The center island has size priority
    readonly property real distanceFromCenterIsland: (width - topCenterIsland.width) / 2

    TopLeftIsland {
        id: topLeftIsland

        cornerRadius: barCornerRadius
        size: barSize
        maxLength: distanceFromCenterIsland
        position: root.position
    }

    TopCenterIsland {
        id: topCenterIsland

        cornerRadius: barCornerRadius
        size: barSize
        position: root.position
        z: 1
    }

    TopRightIsland {
        id: topRightIsland

        cornerRadius: barCornerRadius
        size: barSize
        maxLength: distanceFromCenterIsland
        position: root.position
    }
}
