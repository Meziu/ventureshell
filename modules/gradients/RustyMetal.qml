import QtQuick
import QtQuick.Shapes

LinearGradient {
    property real width: 0
    property real height: 0

    x1: 0; y1: 0
    x2: width; y2: height
    GradientStop { position: 0.0; color: "#1C1F22" }
    GradientStop { position: 0.7; color: "#26211E" }
    GradientStop { position: 1.0; color: "#3A2418" }
}
