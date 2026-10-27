import QtQuick
import QtQuick.Layouts
import Quickshell

import "../../../controls"
import "../../../services"
import "../../../shapes"
import "../widgets"

Menu {
    id: root
    implicitWidth: 260
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

        TextWidget {
            text: NetworkService.activeNetwork? NetworkService.activeNetwork.name : "No connection"
            clickable: false
            Layout.fillWidth: true
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

        MenuSeparator {
            Layout.fillWidth: true
        }

        TextWidget {
            text: "Open NetworkManager"
            Layout.fillWidth: true

            onClicked: Quickshell.execDetached("nm-connection-editor")
        }
    }
}
