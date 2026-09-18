import QtQuick
import QtQuick.Layouts

Item {
    id: root

    property bool fillSpace: false
    property bool persistent: false
    property bool horizontal: true

    anchors.fill: parent
    implicitWidth: 140
    implicitHeight: 100
    clip: true

    signal exited()
}
