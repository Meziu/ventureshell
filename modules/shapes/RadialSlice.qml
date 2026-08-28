import QtQuick
import QtQuick.Shapes
import QtQuick.Effects

Item {
    id: slice
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottom: parent.verticalCenter
    transformOrigin: Item.Bottom
    width: shape.outerPointX * 2
    height: outerRadius

    property int fractions: 5
    property real length: 150
    property real innerRadius: 300
    property real margin: 0
    readonly property real outerRadius: innerRadius + length

    property color baseColor: "#6A7DFE"
    property bool isHovered: false

    default property alias content: anchorPoint.data

    Item {
        id: anchorPoint
        x: shape.outerPointX
        y: slice.length / 2
        z: 1
        rotation: -slice.rotation
    }

    layer.enabled: true
    layer.effect: MultiEffect {
        autoPaddingEnabled: true
        shadowEnabled: true
        shadowColor: slice.baseColor
        shadowScale: 1.0
        blurMax: 48
        shadowBlur: slice.isHovered ? 1.0 : 0.65
        shadowOpacity: slice.isHovered ? 0.5 : 0.28
        shadowHorizontalOffset: 0
        shadowVerticalOffset: 0

        Behavior on shadowBlur { NumberAnimation { duration: 150; easing.type: Easing.OutQuad } }
        Behavior on shadowOpacity { NumberAnimation { duration: 150; easing.type: Easing.OutQuad } }
    }

    Shape {
        id: innerShape
        anchors.fill: parent
        preferredRendererType: Shape.CurveRenderer

        layer.enabled: true
        layer.effect: MultiEffect {
            autoPaddingEnabled: true
            brightness: slice.isHovered ? 0.2 : 0.08
            saturation: 0.15

            shadowEnabled: true
            shadowColor: slice.baseColor
            shadowScale: 1.0
            blurMax: 24
            shadowBlur: slice.isHovered ? 0.4 : 0.22
            shadowOpacity: slice.isHovered ? 0.85 : 0.55
            shadowHorizontalOffset: 0
            shadowVerticalOffset: 0

            Behavior on brightness { NumberAnimation { duration: 150; easing.type: Easing.OutQuad } }
            Behavior on shadowBlur { NumberAnimation { duration: 150; easing.type: Easing.OutQuad } }
            Behavior on shadowOpacity { NumberAnimation { duration: 150; easing.type: Easing.OutQuad } }
        }

        ShapePath {
            id: shape
            strokeWidth: 1
            strokeColor: Qt.lighter(slice.baseColor, slice.isHovered ? 1.9 : 1.5)

            readonly property real halfAngle: (Math.PI - slice.margin) / slice.fractions
            readonly property real outerPointX: slice.outerRadius * Math.sin(halfAngle)
            readonly property real outerPointY: -slice.outerRadius * Math.cos(halfAngle)
            readonly property real innerPointX: slice.innerRadius * Math.sin(halfAngle)
            readonly property real innerPointY: -slice.innerRadius * Math.cos(halfAngle)

            fillGradient: LinearGradient {
                x1: shape.outerPointX; y1: slice.height
                x2: shape.outerPointX; y2: 0
                GradientStop { position: 0.0;  color: Qt.lighter(slice.baseColor, slice.isHovered ? 2.1 : 1.7) }
                GradientStop { position: 0.12; color: Qt.lighter(slice.baseColor, slice.isHovered ? 1.4 : 1.15) }
                GradientStop { position: 0.5;  color: slice.baseColor }
                GradientStop { position: 1.0;  color: Qt.darker(slice.baseColor, 1.5) }
            }

            startX: 0
            startY: outerPointY + slice.outerRadius

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
}
