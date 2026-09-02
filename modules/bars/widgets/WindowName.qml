import QtQuick

import "../../assetloaders"

Widget {
    requestedWidth: textMetrics.width

    // To avoid binding loops
    TextMetrics {
        id: textMetrics
        font: OuterWildsUIFont.withSize(14)
        text: root.titleText
    }

    Text {
        id: windowName
        anchors.fill: parent

        text: root.titleText
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight

        font: textMetrics.font
        color: OuterWildsUIFont.defaultColor
    }
}
