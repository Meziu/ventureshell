import QtQuick
import QtQuick.Shapes

Shape {
    id: slice
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottom: parent.verticalCenter

    transformOrigin: Item.Bottom

    width: shape.outerPointX * 2
    height: outerRadius

    preferredRendererType: Shape.CurveRenderer

    // Number of slices in a full circle
    property int fractions: 5
    // Length of the slice (straight length from bottom left corner to top left corner)
    property real length: 150
    // Radius of the bottom arc
    property real innerRadius: 300
    // Side margin (reducing the actual size). Measured in radians.
    property real margin: 0
    readonly property real outerRadius: innerRadius + length

    default property alias content: anchorPoint.data

    // The mathematical center of the slice
    Item {
        id: anchorPoint
        x: shape.outerPointX

        // Center vertically within the slice's drawn thickness
        y: slice.length / 2

        // Counteract the rotation
        rotation: -slice.rotation

        // 0-size means children can just use anchors.centerIn: parent
        //width: 0
        //height: 0
    }

    ShapePath {
        id: shape
        strokeWidth: 4
        fillColor: "#6A7DFE"

        // QML coordinates have the y pointing downwards, so we negate the y for simplicity
        readonly property real halfAngle: (Math.PI - slice.margin) / slice.fractions
        readonly property real outerPointX: slice.outerRadius * Math.sin(halfAngle)
        readonly property real outerPointY: -slice.outerRadius * Math.cos(halfAngle)
        readonly property real innerPointX: slice.innerRadius * Math.sin(halfAngle)
        readonly property real innerPointY: -slice.innerRadius * Math.cos(halfAngle)

        // Starting at the outer left corner
        startX: 0
        startY: outerPointY + slice.outerRadius
        // The arcs have a length of 2*pi*radius / fractions
        //
        // The radius of the top arc has to be the radius of the bottom arc + slice length
        PathArc {
            x: 2 * shape.outerPointX
            y: shape.outerPointY + slice.outerRadius
            radiusX: slice.outerRadius
            radiusY: slice.outerRadius
            direction: PathArc.Clockwise
        }
        PathLine {
            x: shape.innerPointX + shape.outerPointX
            y: shape.innerPointY + slice.outerRadius
        }
        PathArc {
            x: -shape.innerPointX + shape.outerPointX
            y: shape.innerPointY + slice.outerRadius
            radiusX: slice.innerRadius
            radiusY: slice.innerRadius
            direction: PathArc.Counterclockwise
        }
        PathLine {
            x: shape.startX
            y: shape.startY
        }
    }
}
