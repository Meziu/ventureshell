import QtQuick
import Quickshell

import "../../../theme"
import "../../../services"

SpeedometerWidget {
    text: "DSK"
    completion: SystemStatsService.storage
    color: Theme.widgets.speedometer.storageColor

    onClicked: SystemStatsService.viewSystemInfoStorage()
    onAltClicked: SystemStatsService.viewSystemInfoStorage()
}
