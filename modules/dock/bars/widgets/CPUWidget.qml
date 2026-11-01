import QtQuick
import Quickshell

import "../../../theme"
import "../../../services"

SpeedometerWidget {
    text: "CPU"
    completion: SystemStatsService.cpu
    color: Theme.widgets.speedometer.cpuColor

    onClicked: SystemStatsService.viewSystemInfoCPU()
    onAltClicked: SystemStatsService.viewSystemInfoCPU()
}
