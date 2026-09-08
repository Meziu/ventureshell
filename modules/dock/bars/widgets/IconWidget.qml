import QtQuick
import QtQuick.Layouts
import QtQuick.Effects

import "../../../effects"

ClickableWidget {
    id: root

    required property url source
    property Component effect: null

    // TODO: smarter than this please
    requestedLength: horizontal ? height : width

    Image {
        id: image
        anchors.fill: parent
        source: root.source
        sourceSize.width: 128
        sourceSize.height: 128
        fillMode: Image.PreserveAspectFit
        mipmap: true

        layer.enabled: root.effect ? true : false
        layer.textureSize: Qt.size(width * 4, height * 4)
        layer.effect: root.effect
    }
}
