import QtQuick
import QtQuick.Shapes

LinearGradient {
    x1: 0; y1: 0
    x2: box.width; y2: box.height
    GradientStop { position: 0.0;  color: "#1A1E21" }
    GradientStop { position: 0.4;  color: "#24292D" }
    GradientStop { position: 0.6;  color: "#262C30" }
    GradientStop { position: 1.0;  color: "#181C1F" }
}
