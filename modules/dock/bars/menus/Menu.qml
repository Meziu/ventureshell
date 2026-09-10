import QtQuick
import QtQuick.Layouts

import "../widgets"

Item {
    anchors.fill: parent
    implicitWidth: 240
    implicitHeight: 80

    signal exited()

    ColumnLayout {
        anchors.fill: parent
        spacing: 10

        TextWidget {
            text: "Option 1"
            Layout.fillWidth: true
        }
        TextWidget {
            text: "Option 2"
            Layout.fillWidth: true
        }
    }

    Rectangle {
        anchors.fill: parent

        opacity: 0.1
    }
}
