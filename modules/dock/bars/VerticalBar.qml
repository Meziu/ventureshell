import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

import "islands"

Bar {
    id: root

    position: Bar.Left

    LeftCenterIsland {
        id: leftCenterIsland

        screen: root.screen
        cornerRadius: barCornerRadius
        position: root.position
        size: barSize
    }
}
