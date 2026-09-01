import QtQuick
import QtQuick.Shapes

Rectangle {
    id: box

    required property Attach attached
    property real cornerRadius: 18
    property bool showFeet: true // haha, feet

    readonly property color gradStart: Qt.rgba(250/255, 179/255, 135/255, 0.16)
    readonly property color gradEnd:   Qt.rgba(250/255, 179/255, 135/255, 0.05)
    readonly property color borderCol: Qt.rgba(250/255, 179/255, 135/255, 0.28)

    color: "transparent"
    gradient: Gradient {
        orientation: Gradient.Horizontal // closest built-in approximation of the 135deg diagonal
        GradientStop {
            position: 0.0
            color: gradStart
        }
        GradientStop {
            position: 1.0
            color: gradEnd
        }
    }
    border.color: borderCol
    border.width: 1


    // There can be 8 different feet, of which only a max of 4
    // may be visible at once depending on how the box is attached.
    // Here they are categorised by the side they stick and the direction they look from.

    readonly property real leftBothX: -cornerRadius
    readonly property real rightBothX: box.width
    readonly property real bothLeftX: 0
    readonly property real bothRightX: box.width - cornerRadius

    readonly property real topBothY: -cornerRadius
    readonly property real bottomBothY: box.height
    readonly property real bothTopY: 0
    readonly property real bothBottomY: box.height - cornerRadius

    topLeftRadius: attached.top || attached.left ? 0 : cornerRadius
    bottomLeftRadius: attached.bottom || attached.left ? 0 : cornerRadius
    topRightRadius: attached.top || attached.right ? 0 : cornerRadius
    bottomRightRadius: attached.bottom || attached.right ? 0 : cornerRadius

    CurvyFoot {
        id: leftBottom

        x: box.leftBothX
        y: box.bothBottomY
        rotation: 90

        gradientStart: box.gradStart
        gradientEnd: box.gradEnd
        borderColor: box.borderCol

        radius: box.cornerRadius
        bg: box.color
        visible: box.showFeet && !box.attached.left && box.attached.bottom
    }

    CurvyFoot {
        id: leftTop

        x: box.leftBothX
        y: box.bothTopY
        rotation: 0

        gradientStart: box.gradStart
        gradientEnd: box.gradEnd
        borderColor: box.borderCol

        radius: box.cornerRadius
        bg: box.color
        visible: box.showFeet && !box.attached.left && box.attached.top
    }

    CurvyFoot {
        id: topLeft

        x: box.bothLeftX
        y: box.topBothY
        rotation: 180

        gradientStart: box.gradStart
        gradientEnd: box.gradEnd
        borderColor: box.borderCol

        radius: box.cornerRadius
        bg: box.color
        visible: box.showFeet && !box.attached.top && box.attached.left
    }

    CurvyFoot {
        id: topRight

        x: box.bothRightX
        y: box.topBothY
        rotation: 90

        gradientStart: box.gradStart
        gradientEnd: box.gradEnd
        borderColor: box.borderCol

        radius: box.cornerRadius
        bg: box.color
        visible: box.showFeet && !box.attached.top && box.attached.right
    }

    CurvyFoot {
        id: rightTop

        x: box.rightBothX
        y: box.bothTopY
        rotation: -90

        gradientStart: box.gradStart
        gradientEnd: box.gradEnd
        borderColor: box.borderCol

        radius: box.cornerRadius
        bg: box.color
        visible: box.showFeet && !box.attached.right && box.attached.top
    }

    CurvyFoot {
        id: rightBottom

        x: box.rightBothX
        y: box.bothBottomY
        rotation: 180

        gradientStart: box.gradStart
        gradientEnd: box.gradEnd
        borderColor: box.borderCol

        radius: box.cornerRadius
        bg: box.color
        visible: box.showFeet && !box.attached.right && box.attached.bottom
    }

    CurvyFoot {
        id: bottomRight

        x: box.bothRightX
        y: box.bottomBothY
        rotation: 0

        gradientStart: box.gradStart
        gradientEnd: box.gradEnd
        borderColor: box.borderCol

        radius: box.cornerRadius
        bg: box.color
        visible: box.showFeet && !box.attached.bottom && box.attached.right
    }

    CurvyFoot {
        id: bottomLeft

        x: box.bothLeftX
        y: box.bottomBothY
        rotation: -90

        gradientStart: box.gradStart
        gradientEnd: box.gradEnd
        borderColor: box.borderCol

        radius: box.cornerRadius
        bg: box.color
        visible: box.showFeet && !box.attached.bottom && box.attached.left
    }
}
