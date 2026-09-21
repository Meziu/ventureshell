import QtQuick
import QtQuick.Layouts

import "../panels"

Item {
    id: root

    signal popupRequested(popup: Component)

    property bool horizontal: true
    readonly property real requestedLength: horizontal ? root.implicitWidth : root.implicitHeight

    Layout.fillWidth: !horizontal
    Layout.fillHeight: horizontal
}
