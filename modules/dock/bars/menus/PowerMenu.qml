import QtQuick
import QtQuick.Layouts
import Quickshell

import "../../../services"
import "../widgets"

Menu {
    id: root
    implicitWidth: Math.max(list.implicitWidth, 160)
    implicitHeight: list.implicitHeight

    ColumnLayout {
        id: list

        anchors.fill: parent
        spacing: 2

        RowLayout {
            Layout.fillWidth: true

            TextWidget {
                Layout.fillWidth: true

                text: ""

                onClicked: PowerService.setProfilePowerSaver()
            }

            TextWidget {
                Layout.fillWidth: true

                text: ""

                onClicked: PowerService.setProfileBalanced()
            }

            TextWidget {
                Layout.fillWidth: true
                visible: PowerService.hasPerformanceProfile

                text: ""

                onClicked: PowerService.setProfilePerformance()
            }
        }

        TextWidget {
            Layout.fillWidth: true

            clickable: false
            text: "Power: " + (Math.round(PowerService.powerRate * 100) / 100).toFixed(2) + "W"
        }

        /*TextWidget {
            Layout.fillWidth: true

            visible: !PowerService.isCharging
            clickable: false
            text: "Time to empty: " + PowerService.timeToEmptyString
        }*/
    }
}
