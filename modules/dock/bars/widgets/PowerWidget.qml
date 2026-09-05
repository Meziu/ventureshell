import QtQuick

TextWidget {
    property string pluggedIcon: ""
    property list<string> batteryChargeIcons: ["", "", "", "", ""]
    property var powerProfilesIcons: {
        "default": "",
        "performance": "",
        "balanced": "",
        "power-saver": ""
    }

    text: batteryChargeIcons[2]
}
