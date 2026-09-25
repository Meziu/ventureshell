import QtQuick
import QtQuick.Layouts

import "../../../assetloaders"

ClickableWidget {
    id: root

    visible: text !== ""

    required property string text
    property real fontSize: 14
    property color color: OuterWildsFont.lightColor
    property int horizontalAlignment: Text.AlignHCenter
    property int verticalAlignment: Text.AlignVCenter
    property real margins: 4
    property bool elide: wrapMode === Text.NoWrap && !slide
    property font font: OuterWildsFont.uiWithSize(fontSize)
    property int wrapMode: Text.NoWrap
    property int textFormat: Text.AutoText

    // Sliding ("marquee") text, as an alternative to eliding
    property bool slide: false
    property real slideSpeed: 50
    property int slidePauseDuration: 1500
    property bool slideSmoothReturn: true
    readonly property bool overflowing: slide && textItem.implicitWidth > clipItem.width

    implicitWidth: textItem.implicitWidth + margins * 2
    implicitHeight: textItem.implicitHeight + margins * 2

    Item {
        id: clipItem
        x: root.margins
        width: root.width - root.margins * 2
        // When overflowing, size to the text's own natural height (plus a little overhead for safety)
        height: root.overflowing ? textItem.implicitHeight + 2 : (root.height - root.margins * 2)
        y: (root.height - height) / 2
        clip: root.overflowing

        Text {
            id: textItem

            width: root.overflowing ? implicitWidth : clipItem.width
            height: clipItem.height
            x: 0

            text: root.text
            horizontalAlignment: root.overflowing ? Text.AlignLeft : root.horizontalAlignment
            verticalAlignment: root.verticalAlignment
            elide: root.elide ? Text.ElideRight : Text.ElideNone
            wrapMode: root.wrapMode
            textFormat: root.textFormat

            font: root.font
            color: root.color

            SequentialAnimation {
                id: slideAnim
                running: root.overflowing
                loops: Animation.Infinite

                onRunningChanged: if (!running)
                    textItem.x = 0

                PauseAnimation {
                    duration: root.slidePauseDuration
                }
                NumberAnimation {
                    target: textItem
                    property: "x"
                    to: clipItem.width - textItem.implicitWidth
                    duration: Math.abs(clipItem.width - textItem.implicitWidth) / root.slideSpeed * 1000
                    easing.type: Easing.InOutQuad
                }
                PauseAnimation {
                    duration: root.slidePauseDuration
                }
                NumberAnimation {
                    target: textItem
                    property: "x"
                    to: 0
                    duration: root.slideSmoothReturn ? Math.abs(clipItem.width - textItem.implicitWidth) / root.slideSpeed * 1000 : 0
                    easing.type: Easing.InOutQuad
                }
            }
        }
    }

    onTextChanged: {
        textItem.x = 0

        if (root.overflowing) {
            slideAnim.restart()
        }
    }
}
