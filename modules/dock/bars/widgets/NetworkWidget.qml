import QtQuick

TextWidget {
    property string ethernetIcon: "󰈀"
    property list<string> wifiStrengthIcons: ["󰤯", "󰤟", "󰤢", "󰤥", "󰤨"]

    text: wifiStrengthIcons[2]
}
