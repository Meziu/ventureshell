import QtQuick

import "../../assetloaders"

Widget {
    id: root
    required property string text
    property int horizontalAlignment: Text.AlignHCenter
    property int verticalAlignment: Text.AlignVCenter

    // sometimes the text is wrongly assumed to be smaller and elides
    requestedWidth: textMetrics.width + 6

    // To avoid binding loops
    TextMetrics {
        id: textMetrics
        font: OuterWildsUIFont.withSize(14)
        text: root.text
    }

    Text {
        anchors.fill: parent

        text: root.text
        horizontalAlignment: root.horizontalAlignment
        verticalAlignment: root.verticalAlignment
        elide: Text.ElideRight
        clip: true

        font: textMetrics.font
        color: OuterWildsUIFont.defaultColor
    }
}
