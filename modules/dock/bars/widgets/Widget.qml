import QtQuick
import QtQuick.Layouts

import "../panels"

Item {
    id: root

    signal panelRequested(Component panelComponent)
    signal menuRequested(Component menuComponent)

    property bool horizontal: true
    required property real requestedLength

    Layout.preferredWidth: horizontal ? requestedLength : -1
    Layout.preferredHeight: !horizontal ? requestedLength : -1

    Layout.fillWidth: !horizontal
    Layout.fillHeight: horizontal
}
