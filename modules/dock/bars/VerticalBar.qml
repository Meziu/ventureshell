import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

import "islands"

PanelWindow {
    id: root

    WlrLayershell.layer: WlrLayer.Top
    mask: Region {
        Region {
            item: leftCenterIsland
        }
    }

    property real barSize: 40
    property real barCornerRadius: 16

    anchors {
        left: true
        top: true
        bottom: true
    }

    exclusiveZone: barSize
    exclusionMode: ExclusionMode.Normal

    color: "#00000000"

    // The center island has size priority
    readonly property real distanceFromCenterIsland: (height - leftCenterIsland.height) / 2

    LeftCenterIsland {
        id: leftCenterIsland
        cornerRadius: barCornerRadius
        size: barSize
        horizontal: false
    }
}
