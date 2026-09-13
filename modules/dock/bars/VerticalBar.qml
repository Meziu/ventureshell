import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

import "islands"

import "../../shapes"

Bar {
    id: root

    position: Position.Left

    VCenterIsland {
        id: leftCenterIsland

        screen: root.screen
        cornerRadius: root.cornerRadius
        position: root.position
        size: root.size
    }
}
