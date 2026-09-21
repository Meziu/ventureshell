import QtQuick
import QtQuick.Layouts

import "../../../assetloaders"

ClickableWidget {
    id: root

    visible: text !== ""

    required property string text
    property real fontSize: 14
    property int horizontalAlignment: Text.AlignHCenter
    property int verticalAlignment: Text.AlignVCenter
    property real margins: 4
    property bool elide: wrapMode === Text.NoWrap
    property font font: OuterWildsFont.uiWithSize(fontSize)
    property int wrapMode: Text.NoWrap
    property int textFormat: Text.AutoText

    implicitWidth: textItem.implicitWidth + margins * 2
    implicitHeight: textItem.implicitHeight + margins * 2

    Text {
        id: textItem

        anchors.margins: root.margins
        anchors.fill: parent

        text: root.text
        horizontalAlignment: root.horizontalAlignment
        verticalAlignment: root.verticalAlignment
        elide: root.elide ? Text.ElideRight : Text.ElideNone
        wrapMode: root.wrapMode
        textFormat: root.textFormat

        font: root.font
        color: OuterWildsFont.lightColor
    }
}
