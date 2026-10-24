import QtQuick
import QtQuick.Shapes

LinearGradient {
    property real width: 0
    property real height: 0

    x1: 0; y1: 0
    x2: width; y2: height
    GradientStop { position: 0.0;  color: "#1A1E21" }
    GradientStop { position: 0.4;  color: "#24292D" }
    GradientStop { position: 0.6;  color: "#262C30" }
    GradientStop { position: 1.0;  color: "#181C1F" }
}
