import QtQuick
import QtQuick.Layouts

import "../../../assetloaders"

ClickableWidget {
    id: root
    required property string text
    property int horizontalAlignment: Text.AlignHCenter
    property int verticalAlignment: Text.AlignVCenter
    property real padding: 4
    property font font: OuterWildsFont.uiWithSize(14)

    // Length is AT MINIMUM a square (done for single character text as logos)
    readonly property real length: Math.max(Layout.preferredHeight, textMetrics.width + padding * 2)

    // sometimes the text is wrongly assumed to be smaller and elides
    // This wrongly supercedes the usual requestedLength made with content size, causing visual bugs
    requestedLength: root.length
    Layout.preferredWidth: root.requestedLength

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
