import QtQuick
import QtQuick.Shapes

Item {
    id: foot

    width: radius
    height: radius
    required property real radius
    required property color bg
    required property color gradientStart
    required property color gradientEnd
    required property color borderColor

    // Counter-rotate the local gradient angle so that after this Item's
    // own `rotation` is applied, every foot's gradient reads as part of
    // one continuous 135deg diagonal, matching the island's gradient.
    readonly property real worldAngleDeg: 135
    readonly property real localAngleRad: (worldAngleDeg - foot.rotation) * Math.PI / 180
    readonly property real gDx: Math.sin(localAngleRad)
    readonly property real gDy: -Math.cos(localAngleRad)
    readonly property real halfDiag: foot.radius * Math.SQRT2 / 2
    readonly property real cx: foot.radius / 2
    readonly property real cy: foot.radius / 2

    Shape {
        anchors.fill: parent
        ShapePath {
            fillColor: foot.bg
            strokeWidth: 1
            strokeColor: foot.borderColor
            startX: 0
            startY: 0
            fillGradient: LinearGradient {
                x1: foot.cx - foot.gDx * foot.halfDiag
                y1: foot.cy - foot.gDy * foot.halfDiag
                x2: foot.cx + foot.gDx * foot.halfDiag
                y2: foot.cy + foot.gDy * foot.halfDiag
                GradientStop {
                    position: 0.0
                    color: foot.gradientStart
                }
                GradientStop {
                    position: 1.0
                    color: foot.gradientEnd
                }
            }
            PathLine {
                x: foot.radius
                y: 0
            }
            PathLine {
                x: foot.radius
                y: foot.radius
            }
            PathArc {
                x: 0
                y: 0
                radiusX: foot.radius
                radiusY: foot.radius
                direction: PathArc.Counterclockwise
            }
        }
        preferredRendererType: Shape.CurveRenderer
    }
}
