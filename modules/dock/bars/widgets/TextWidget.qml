import QtQuick

import "../../../assetloaders"

Widget {
    id: root
    required property string text
    property int horizontalAlignment: Text.AlignHCenter
    property int verticalAlignment: Text.AlignVCenter
    property real padding: 4
    property font font: OuterWildsFont.uiWithSize(14)

    // sometimes the text is wrongly assumed to be smaller and elides
    requestedLength: textMetrics.width + padding * 2

    // To avoid binding loops
    TextMetrics {
        id: textMetrics
        font: root.font
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
        color: OuterWildsFont.lightColor
    }
}
