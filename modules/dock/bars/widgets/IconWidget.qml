import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell

import "../../../effects"

ClickableWidget {
    id: root

    required property string source
    required property real iconSize
    property bool smooth: false
    property int fillMode: Image.PreserveAspectFit
    property int verticalAlignment: Image.AlignVCenter
    property int horizontalAlignment: Image.AlignHCenter
    property Component effect: null

    requestedLength: iconSize

    Image {
        id: image
        anchors.fill: parent
        source: {
            if (root.source === "") return "";
            if (root.source.startsWith("/") || root.source.startsWith("file:") || root.source.startsWith("image:"))
                return root.source;

            return Quickshell.iconPath(root.source, root.source + "-symbolic");
        }

        sourceSize.width: root.iconSize
        sourceSize.height: root.iconSize

        fillMode: root.fillMode
        mipmap: root.smooth
        verticalAlignment: root.verticalAlignment
        horizontalAlignment: root.horizontalAlignment

        layer.enabled: root.effect ? true : false
        layer.textureSize: Qt.size(width * 4, height * 4)
        layer.effect: root.effect
    }
}
