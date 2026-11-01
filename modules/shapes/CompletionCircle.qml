import QtQuick
import QtQuick.Shapes

import "../theme"

Shape {
    id: root

    property real strokeWidth: 4
    property color strokeColor: Theme.shapes.completionCircle.baseColor

    property real completion: 1
    property real radius: 10
    property real startAngle: -90
    property real maxSweep: 360
    property bool clockwise: false

    preferredRendererType: Shape.CurveRenderer

    ShapePath {
        strokeWidth: root.strokeWidth
        strokeColor: root.strokeColor
        fillColor: "transparent"
        capStyle: ShapePath.RoundCap

        PathAngleArc {
            centerX: root.width / 2
            centerY: root.height / 2
            radiusX: root.radius
            radiusY: root.radius
            startAngle: root.startAngle
            sweepAngle: (root.clockwise ? 1 : -1) * root.completion * root.maxSweep
        }
    }
}
