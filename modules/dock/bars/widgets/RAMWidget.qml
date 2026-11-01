import QtQuick
import Quickshell

import "../../../theme"
import "../../../services"

SpeedometerWidget {
    text: "RAM"
    completion: SystemStatsService.ram
    color: Theme.widgets.speedometer.ramColor

    onClicked: SystemStatsService.viewSystemInfoRAM()
    onAltClicked: SystemStatsService.viewSystemInfoRAM()
}
