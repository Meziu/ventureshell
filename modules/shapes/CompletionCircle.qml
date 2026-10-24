import QtQuick
import QtQuick.Shapes

import "../theme"

Shape {
    id: circle

    property real completion: 1
    property real radius: 10

    preferredRendererType: Shape.CurveRenderer

    ShapePath {
        strokeWidth: 4
        strokeColor: Theme.shapes.completionCircle.baseColor
        fillColor: "transparent"
        capStyle: ShapePath.RoundCap

        PathAngleArc {
            centerX: circle.width / 2
            centerY: circle.height / 2
            radiusX: circle.radius
            radiusY: circle.radius
            startAngle: -90
            sweepAngle: -circle.completion * 360
        }
    }
}
