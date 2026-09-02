import QtQuick
import QtQuick.Shapes

LinearGradient {
    x1: 0; y1: 0
    x2: box.width; y2: box.height
    GradientStop { position: 0.0; color: "#1C1F22" }
    GradientStop { position: 0.7; color: "#26211E" }
    GradientStop { position: 1.0; color: "#3A2418" }
}
