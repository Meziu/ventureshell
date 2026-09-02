import QtQuick
import QtQuick.Shapes

LinearGradient {
    x1: 0
    y1: 0
    x2: box.width
    y2: box.height

    GradientStop {
        position: 0.0
        color: Qt.rgba(250 / 255, 179 / 255, 135 / 255, 0.16)
    }
    GradientStop {
        position: 1.0
        color: Qt.rgba(250 / 255, 179 / 255, 135 / 255, 0.05)
    }
}
