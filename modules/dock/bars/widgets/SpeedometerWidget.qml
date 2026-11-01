import QtQuick
import QtQuick.Layouts
import Quickshell

import "../../../theme"
import "../../../shapes"

ClickableWidget {
    id: root

    Layout.preferredHeight: !horizontal ? width : -1
    Layout.preferredWidth: horizontal ? height : -1

    required property string text
    required property real completion
    property color color: Theme.shapes.completionCircle.baseColor

    CompletionCircle {
        id: speedometer
        anchors.fill: parent

        completion: root.completion
        clockwise: true
        startAngle: -225
        maxSweep: 270

        strokeWidth: 4
        strokeColor: root.color
    }

    TextWidget {
        anchors.centerIn: speedometer

        clickable: false

        text: root.text
        fontSize: 6
    }
}
