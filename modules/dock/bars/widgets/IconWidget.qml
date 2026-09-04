import QtQuick
import QtQuick.Layouts
import QtQuick.Effects

import "../../../effects"

ClickableWidget {
    id: root

    required property url source
    property Component effect: null

    Image {
        id: image
        anchors.fill: parent
        source: root.source
        fillMode: Image.PreserveAspectFit
        mipmap: true

        layer.enabled: root.effect ? true : false
        layer.textureSize: Qt.size(width * 4, height * 4)
        layer.effect: root.effect
    }
}
