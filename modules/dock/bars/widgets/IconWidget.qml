import QtQuick
import QtQuick.Layouts
import QtQuick.Effects

import "../../../effects"

// TODO: Merge this with the IconImage widget from Quickshell to have a singular base widget
ClickableWidget {
    id: root

    required property url source
    required property real iconSize
    property Component effect: null

    requestedLength: iconSize

    Image {
        id: image
        anchors.fill: parent
        source: root.source

        sourceSize.width: root.iconSize
        sourceSize.height: root.iconSize

        fillMode: Image.PreserveAspectFit
        mipmap: true

        layer.enabled: root.effect ? true : false
        layer.textureSize: Qt.size(width * 4, height * 4)
        layer.effect: root.effect
    }
}
