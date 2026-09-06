import QtQuick
import QtQuick.Layouts

import "../panels"

Item {
    id: root

    signal panelRequested(Panel panel)

    property bool horizontal: true
    property real requestedLength: horizontal
        ? (Layout.preferredWidth >= 0 ? Layout.preferredWidth : implicitWidth)
        : (Layout.preferredHeight >= 0 ? Layout.preferredHeight : implicitHeight)

    Layout.fillHeight: true
    Layout.fillWidth: true
}
