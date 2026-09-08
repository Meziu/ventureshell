import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

import "../../../sessioncontrol"
import "../../../effects"

IconWidget {
    id: shutdownWidget
    source: "file:assets/images/outerwilds/symbols/MinimalEye.svg"

    effect: NomaiEyeGlow {}

    onClicked: SessionControlService.show()
}
