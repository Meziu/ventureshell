import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

import "../../../services"
import "../../../effects"
import "../../../paths"

IconWidget {
    id: shutdownWidget
    source: Paths.assets + "/images/outerwilds/symbols/MinimalEye.svg"

    effect: NomaiEyeGlow {}

    onClicked: SessionControlService.show()
}
