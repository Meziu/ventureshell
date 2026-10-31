import QtQuick
import QtQuick.Controls

Slider {
    id: slider

    property color accentColor: "#6A2CA0"
    property color trackColor: "#bdbebf"
    property real trackThickness: 6
    property real trackThicknessActive: 8
    property real knobSize: 14
    property int animationDuration: 120

    property real barThickness: hovered ? trackThicknessActive : trackThickness
    Behavior on barThickness {
        NumberAnimation {
            duration: slider.animationDuration
            easing.type: Easing.OutCubic
        }
    }

    opacity: enabled ? 1.0 : 0.3

    leftPadding: horizontal ? knobSize / 2 : 0
    rightPadding: horizontal ? knobSize / 2 : 0
    topPadding: horizontal ? 0 : knobSize / 2
    bottomPadding: horizontal ? 0 : knobSize / 2

    implicitWidth: horizontal ? 200 : knobSize
    implicitHeight: horizontal ? knobSize : 200

    handle: Item {
        width: 0
        height: 0
        x: slider.horizontal ? slider.leftPadding + slider.visualPosition * slider.availableWidth : slider.leftPadding + slider.availableWidth / 2
        y: slider.horizontal ? slider.topPadding + slider.availableHeight / 2 : slider.topPadding + slider.visualPosition * slider.availableHeight

        Rectangle {
            anchors.centerIn: parent
            width: slider.knobSize
            height: slider.knobSize
            radius: width / 2
            color: slider.accentColor

            scale: slider.pressed ? 1.0 : 0.0
            visible: scale > 0
            Behavior on scale {
                NumberAnimation {
                    duration: slider.animationDuration
                    easing.type: Easing.OutCubic
                }
            }
        }
    }

    background: Item {
        id: bar

        x: slider.leftPadding + (slider.horizontal ? 0 : (slider.availableWidth - width) / 2)
        y: slider.topPadding + (slider.horizontal ? (slider.availableHeight - height) / 2 : 0)
        width: slider.horizontal ? slider.availableWidth : slider.barThickness
        height: slider.horizontal ? slider.barThickness : slider.availableHeight

        readonly property real radius: slider.barThickness / 2
        readonly property real total: slider.horizontal ? width : height
        readonly property real filled: slider.position * total
        readonly property real greyStart: Math.max(filled - radius, 0)
        readonly property real overscan: 2

        Item {
            clip: true
            visible: slider.position < 1
            x: slider.horizontal ? (slider.mirrored ? -bar.overscan : bar.greyStart) : -bar.overscan
            y: -bar.overscan
            width: slider.horizontal ? bar.total - bar.greyStart + bar.overscan : bar.width + 2 * bar.overscan
            height: slider.horizontal ? bar.height + 2 * bar.overscan : bar.total - bar.greyStart + bar.overscan

            Rectangle {
                x: -parent.x
                y: -parent.y
                width: bar.width
                height: bar.height
                radius: bar.radius
                color: slider.trackColor
            }
        }
        Rectangle {
            x: slider.horizontal && slider.mirrored ? bar.width - width : 0
            y: slider.horizontal ? 0 : bar.height - height
            width: slider.horizontal ? bar.filled : bar.width
            height: slider.horizontal ? bar.height : bar.filled
            radius: bar.radius
            color: slider.accentColor
        }
    }
}
