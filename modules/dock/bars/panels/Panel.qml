import QtQuick
import QtQuick.Layouts

Item {
    id: root

    required property bool fillSpace

    property bool horizontal: true
    property real requestedLength: horizontal ? (Layout.preferredWidth >= 0 ? Layout.preferredWidth : implicitWidth) : (Layout.preferredHeight >= 0 ? Layout.preferredHeight : implicitHeight)
    property real requestedSize: horizontal ? (Layout.preferredHeight >= 0 ? Layout.preferredHeight : implicitHeight) : (Layout.preferredWidth >= 0 ? Layout.preferredWidth : implicitWidth)

    Layout.fillHeight: true
    Layout.fillWidth: true
}
