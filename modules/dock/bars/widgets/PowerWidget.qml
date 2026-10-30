import QtQuick

import "../../../services"
import "../menus"

TextWidget {
    property bool showPercentage: true

    text: {
        let percentageLabel = ""
        if (showPercentage && PowerService.battery) {
            percentageLabel = Math.round(PowerService.battery.percentage * 100) + "% "
        }

        return percentageLabel + PowerService.currentBatteryIcon + " " + PowerService.powerProfileIcon
    }

    Component {
        id: menuComponent

        PowerMenu {}
    }

    onClicked: togglePopup(menuComponent)
    onAltClicked: PowerService.cyclePowerProfile()
}
