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

    anchors {
        left: true
        right: true
        top: true
    }

    exclusiveZone: Math.max(topLeftIsland.implicitHeight, topCenterIsland.implicitHeight, topRightIsland.implicitHeight)
    exclusionMode: ExclusionMode.Normal

    color: "#00000000"

    TopLeft {
        id: topLeftIsland
    }

    TopCenter {
        id: topCenterIsland
    }

    TopRight {
        id: topRightIsland
    }
}
