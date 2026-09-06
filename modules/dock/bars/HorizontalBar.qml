import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

import "islands"

Bar {
    id: root

    position: Bar.Top
    implicitHeight: 1000

    // The center island has size priority
    readonly property real distanceFromCenterIsland: (width - topCenterIsland.length) / 2

    TopLeftIsland {
        id: topLeftIsland

        screen: root.screen
        cornerRadius: barCornerRadius
        size: barSize
        maxLength: distanceFromCenterIsland
        position: root.position
    }

    TopCenterIsland {
        id: topCenterIsland

        screen: root.screen
        cornerRadius: barCornerRadius
        size: barSize
        position: root.position
        z: 1
    }

    TopRightIsland {
        id: topRightIsland

        screen: root.screen
        cornerRadius: barCornerRadius
        size: barSize
        maxLength: distanceFromCenterIsland
        position: root.position
    }
}
