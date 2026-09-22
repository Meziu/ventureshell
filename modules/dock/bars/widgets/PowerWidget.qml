import QtQuick

import "../../../services"

TextWidget {
    property bool showPercentage: true

    property string pluggedIcon: ""
    property list<string> batteryChargeIcons: ["", "", "", "", ""]
    property var powerProfilesIcons: {
        "Performance": "",
        "Balanced": "",
        "PowerSaver": ""
    }

    readonly property string batteryIcon: {
        if (PowerService.battery) {
            const percentage = Math.min(PowerService.battery.percentage, 0.99);
            return batteryChargeIcons[Math.floor(percentage * batteryChargeIcons.length)]
        }

        return batteryChargeIcons[0]
    }

    readonly property string powerProfileIcon: {
        return powerProfilesIcons[PowerService.powerProfileName]
    }

    text: {
        let percentageLabel = ""
        if (showPercentage && PowerService.battery) {
            percentageLabel = Math.round(PowerService.battery.percentage * 100) + "% "
        }

        return percentageLabel + batteryIcon + " " + powerProfileIcon
    }

    onAltClicked: PowerService.cyclePowerProfile()
}
