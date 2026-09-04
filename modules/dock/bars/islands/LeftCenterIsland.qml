import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

import "../../../config"
import "../../../shapes"
import "../../../effects"
import "../widgets"

Island {
    id: root

    attached: Attach {
        top: false
        left: true
        right: false
        bottom: false
    }

    anchors {
        verticalCenter: parent.verticalCenter
        left: parent.left
    }

    WorkspaceWidget {
        id: workspaceWidget

        horizontal: false
    }
}
