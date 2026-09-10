import QtQuick

import "../menus"

TextWidget {
    property string ethernetIcon: "󰈀"
    property list<string> wifiStrengthIcons: ["󰤯", "󰤟", "󰤢", "󰤥", "󰤨"]

    text: wifiStrengthIcons[2]

    Component {
        id: menuComponent
        NetworkMenu {}
    }

    onClicked: {
        menuRequested(menuComponent)
    }
}
