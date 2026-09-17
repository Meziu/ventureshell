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
    property bool elide: wrapMode === Text.NoWrap
    property font font: OuterWildsFont.uiWithSize(fontSize)
    property int wrapMode: Text.NoWrap
    property int textFormat: Text.PlainText

    requestedLength: wrapMode === Text.NoWrap
        ? Math.max(Layout.preferredHeight, textMetrics.width + padding * 4)
        : 0

    implicitWidth: requestedLength > 0 ? requestedLength : textMetrics.width + padding * 2
    implicitHeight: textMetrics.height + padding * 2

    TextMetrics {
        id: textMetrics
        font: root.font
        text: root.text
    }

    Text {
        width: root.width
        height: root.height

        text: root.text
        horizontalAlignment: root.horizontalAlignment
        verticalAlignment: root.verticalAlignment
        elide: root.elide ? Text.ElideRight : Text.ElideNone
        padding: root.padding
        wrapMode: root.wrapMode
        textFormat: root.textFormat
        clip: true

        font: textMetrics.font
        color: OuterWildsFont.lightColor
    }
}
