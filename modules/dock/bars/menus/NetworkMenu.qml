import QtQuick
import QtQuick.Layouts
import Quickshell.Networking

import "../widgets"
import "../../../controls"

Menu {
    id: root
    implicitHeight: list.implicitHeight

    function setWifi(enabled: bool) {
        Networking.wifiEnabled = enabled
    }

    ColumnLayout {
        id: list

        anchors.fill: parent
        spacing: 2

        Item {
            implicitHeight: 32
            Layout.fillWidth: true

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

                checked: Networking.wifiEnabled

                onCheckedChanged: root.setWifi(checked)
            }
        }

        Item {
            implicitHeight: 10
        }

        TextWidget {
            text: "Option 1"
            Layout.fillWidth: true
        }

        Rectangle {
            Layout.fillWidth: true

            color: "#FFFFFF"
            opacity: 0.2
            height: 1
        }

        TextWidget {
            text: "Option 2"
            Layout.fillWidth: true

            onClicked: exited()
        }
    }
}
