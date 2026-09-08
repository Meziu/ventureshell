import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

import "islands"

import "../../shapes"

Bar {
    id: root

    position: Position.Left

    LeftCenterIsland {
        id: leftCenterIsland

        screen: root.screen
        cornerRadius: barCornerRadius
        position: root.position
        size: barSize
        horizontal: false
    }
}
