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

    property real barHeight: 40
    property real barCornerRadius: 16

    anchors {
        left: true
        right: true
        top: true
    }

    exclusiveZone: Math.max(topLeftIsland.implicitHeight, topCenterIsland.implicitHeight, topRightIsland.implicitHeight) - barCornerRadius
    exclusionMode: ExclusionMode.Normal

    color: "#00000000"

    TopLeftIsland {
        id: topLeftIsland
        cornerRadius: barCornerRadius
        thickness: barHeight
        centerIslandWidth: topCenterIsland.width
    }

    TopCenterIsland {
        id: topCenterIsland
        cornerRadius: barCornerRadius
        thickness: barHeight
    }

    TopRightIsland {
        id: topRightIsland
        cornerRadius: barCornerRadius
        thickness: barHeight
    }
}
