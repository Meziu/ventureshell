import QtQuick
import QtQuick.Controls

import "../effects"
import "../theme"

Switch {
    id: root

    width: height * widthToHeightRatio

    property real transitionTime: 150
    property real widthToHeightRatio: 2

    indicator: Rectangle {
        id: track
        anchors.fill: parent
        radius: height / 2

        color: root.checked ? Theme.controls.flipswitch.track.checkedColor : Theme.controls.flipswitch.track.uncheckedColor
        border.color: root.checked ? Theme.controls.flipswitch.track.borderCheckedColor : Theme.controls.flipswitch.track.borderUncheckedColor
        border.width: 1

        Behavior on color { ColorAnimation { duration: root.transitionTime } }
        Behavior on border.color { ColorAnimation { duration: root.transitionTime } }

        Rectangle {
            anchors.fill: parent
            anchors.margins: 3
            radius: height / 2
            color: Theme.controls.flipswitch.track.backgroundColor
            border.color: Theme.controls.flipswitch.track.backgroundBorderColor
            border.width: 1
        }

        // Moving Ball
        Item {
            id: handle
            width: track.height - 4
            height: width
            y: 2
            x: root.checked ? track.width - width - 2 : 2

            Behavior on x {
                NumberAnimation { duration: root.transitionTime; easing.type: Easing.InOutQuad }
            }

            // Base Glass Sphere
            Rectangle {
                id: sphere
                anchors.fill: parent
                radius: width / 2

                color: root.checked ? Theme.controls.flipswitch.handle.checkedColor : Theme.controls.flipswitch.handle.uncheckedColor
                border.color: root.checked ? Theme.controls.flipswitch.handle.borderCheckedColor : Theme.controls.flipswitch.handle.borderUncheckedColor
                border.width: 1

                Behavior on color { ColorAnimation { duration: root.transitionTime } }
                Behavior on border.color { ColorAnimation { duration: root.transitionTime } }

                Item {
                    anchors.fill: parent
                    opacity: root.checked ? 1.0 : 0.0

                    Behavior on opacity {
                        NumberAnimation { duration: root.transitionTime; easing.type: Easing.InOutQuad }
                    }

                    Rectangle {
                        id: glowSource
                        anchors.fill: parent
                        radius: width / 2
                        color: Theme.controls.flipswitch.handle.glowSourceBaseColor
                    }

                    layer.enabled: true
                    layer.effect: NomaiEyeGlow {}
                }
            }
        }
    }
}
