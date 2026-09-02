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

    TopLeft {
        id: topLeftIsland
        cornerRadius: barCornerRadius
        implicitHeight: barHeight
    }

    TopCenter {
        id: topCenterIsland
        cornerRadius: barCornerRadius
        implicitHeight: barHeight
    }

    TopRight {
        id: topRightIsland
        cornerRadius: barCornerRadius
        implicitHeight: barHeight
    }
}
