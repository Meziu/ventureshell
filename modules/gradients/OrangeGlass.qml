import QtQuick
import QtQuick.Shapes

LinearGradient {
    property real width: 0
    property real height: 0

    x1: 0; y1: 0
    x2: width; y2: height

    GradientStop {
        position: 0.0
        color: Qt.rgba(250 / 255, 179 / 255, 135 / 255, 0.16)
    }
    GradientStop {
        position: 1.0
        color: Qt.rgba(250 / 255, 179 / 255, 135 / 255, 0.05)
    }
}
