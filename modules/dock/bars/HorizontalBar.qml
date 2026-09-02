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
            item: topLeftIsland
        }

        Region {
            item: topCenterIsland
        }

        Region {
            item: topRightIsland
        }
    }

    property real barSize: 40
    property real barCornerRadius: 16

    anchors {
        left: true
        right: true
        top: true
    }

    exclusiveZone: barSize
    exclusionMode: ExclusionMode.Normal

    color: "#00000000"

    // The center island has size priority
    readonly property real distanceFromCenterIsland: (width - topCenterIsland.width) / 2

    TopLeftIsland {
        id: topLeftIsland
        cornerRadius: barCornerRadius
        thickness: barSize
        maxLength: distanceFromCenterIsland
    }

    TopCenterIsland {
        id: topCenterIsland
        cornerRadius: barCornerRadius
        thickness: barSize
        z: 1
    }

    TopRightIsland {
        id: topRightIsland
        cornerRadius: barCornerRadius
        thickness: barSize
        maxLength: distanceFromCenterIsland
    }
}
