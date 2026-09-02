import QtQuick
import QtQuick.Layouts
import QtQuick.VectorImage
import QtQuick.Effects

import "../../../effects"

Widget {
    id: root

    required property url source
    readonly property string eyeColor: "#6A7DFE"

    VectorImage {
        id: image
        anchors.fill: parent
        source: root.source
        fillMode: Image.PreserveAspectFit
        preferredRendererType: VectorImage.CurveRenderer

        layer.enabled: true
        layer.textureSize: Qt.size(width * 4, height * 4) // render at 4x for svg scaling
        layer.effect: NomaiEyeGlow {}
    }
}
