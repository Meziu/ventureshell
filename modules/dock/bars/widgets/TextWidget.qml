import QtQuick

import "../../../assetloaders"

Widget {
    id: root
    required property string text
    property int horizontalAlignment: Text.AlignHCenter
    property int verticalAlignment: Text.AlignVCenter
    property real padding: 4

    // sometimes the text is wrongly assumed to be smaller and elides
    requestedLength: textMetrics.width + 6

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
        padding: root.padding
        clip: true

        font: textMetrics.font
        color: OuterWildsUIFont.lightColor
    }
}
