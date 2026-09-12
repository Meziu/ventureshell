import QtQuick
import QtQuick.Layouts
import Quickshell

import "../widgets"
import "../../../controls"
import "../../../services"

Menu {
    id: root
    implicitWidth: 220
    implicitHeight: list.implicitHeight

    ColumnLayout {
        id: list

        anchors.fill: parent
        spacing: 2

        Item {
            implicitHeight: 32
            Layout.fillWidth: true
            Layout.leftMargin: 18
            Layout.rightMargin: 18

            TextWidget {
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    left: parent.left
                }

                text: "Wifi"
                fontSize: 18
                clickable: false
            }

            Switch {
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    right: parent.right
                    margins: 2
                }

                checked: NetworkService.wifiEnabled

                onCheckedChanged: NetworkService.setWifi(checked)
            }
        }

        Item {
            implicitHeight: 8
        }

        TextWidget {
            text: NetworkService.activeNetwork? NetworkService.activeNetwork.name : "No connection"
            clickable: false
            Layout.fillWidth: true
        }

        Item {
            implicitHeight: 8
        }

        Item {
            implicitHeight: 32
            Layout.fillWidth: true
            Layout.leftMargin: 18
            Layout.rightMargin: 18

            TextWidget {
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    left: parent.left
                }

                text: "WireguardVPN"
                fontSize: 14
                clickable: false
            }

            Switch {
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    right: parent.right
                    margins: 2
                }

                checked: NetworkService.vpnActive

                onCheckedChanged: NetworkService.setVpn(checked)
            }
        }

        Item {
            implicitHeight: 16
        }

        Rectangle {
            Layout.fillWidth: true

            color: "#FFFFFF"
            opacity: 0.2
            height: 1
        }

        TextWidget {
            text: "Open NetworkManager"
            Layout.fillWidth: true

            onClicked: Quickshell.execDetached("nm-connection-editor")
        }
    }
}
