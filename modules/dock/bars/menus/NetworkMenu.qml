import QtQuick
import QtQuick.Layouts

import "../widgets"

Menu {
    implicitHeight: list.implicitHeight

    ColumnLayout {
        id: list

        anchors.fill: parent
        spacing: 2

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
