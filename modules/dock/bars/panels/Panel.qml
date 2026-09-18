import QtQuick
import QtQuick.Layouts

Item {
    id: root

    required property bool fillSpace
    required property real requestedLength
    required property real requestedSize
    property bool persistent: false
    property bool horizontal: true

    implicitWidth: horizontal ? requestedLength : requestedSize
    implicitHeight: horizontal ? requestedSize : requestedLength

    signal exited()
}
