import Quickshell
import QtQuick
import QtQuick.Layouts

import "islands"
import "../../shapes"

Bar {
    id: root

    position: Position.Top
    implicitHeight: 1000

    // The center island has size priority
    readonly property real distanceFromCenterIsland: (width - topCenterIsland.length) / 2 - cornerRadius * 2

    HLeftIsland {
        id: topLeftIsland

        screen: root.screen
        cornerRadius: root.cornerRadius
        size: root.size
        maxLength: distanceFromCenterIsland
        position: root.position | Position.Left
        horizontal: true
    }

    HCenterIsland {
        id: topCenterIsland

        screen: root.screen
        cornerRadius: root.cornerRadius
        size: root.size
        position: root.position
        horizontal: true

        z: 1
    }

    HRightIsland {
        id: topRightIsland

        screen: root.screen
        cornerRadius: root.cornerRadius
        size: root.size
        maxLength: distanceFromCenterIsland
        position: root.position | Position.Right
        horizontal: true
    }
}
