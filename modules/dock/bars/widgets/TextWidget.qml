import QtQuick
import QtQuick.Layouts

import "../../../assetloaders"

ClickableWidget {
    id: root

    required property string text
    property real fontSize: 14
    property int horizontalAlignment: Text.AlignHCenter
    property int verticalAlignment: Text.AlignVCenter
    property real padding: 4
    property bool elide: true
    property font font: OuterWildsFont.uiWithSize(fontSize)

    // Length is AT MINIMUM a square (done for single character text as logos)
    //
    // sometimes the text is wrongly assumed to be smaller and elides
    // This wrongly supercedes the usual requestedLength made with content size, causing visual bugs
    requestedLength: Math.max(Layout.preferredHeight, textMetrics.width + padding * 4)

    implicitWidth: requestedLength
    implicitHeight: textMetrics.height + padding * 2

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
        elide: root.elide ? Text.ElideRight : Text.ElideNone
        padding: root.padding
        clip: true

        font: textMetrics.font
        color: OuterWildsFont.lightColor
    }
}
