import QtQuick
import QtQuick.Layouts

import "../panels"

Item {
    id: root

    signal popupRequested(popup: Component)
    signal popupClosed()

    property bool horizontal: true
    readonly property real requestedLength: horizontal ? root.implicitWidth : root.implicitHeight

    // Component currently shown for this widget (reported back by the host)
    property Component openComponent: null

    function isOpenPopup(component) {
        return root.openComponent === component;
    }

    function openPopup(component) {
        if (!isOpenPopup(component))
            popupRequested(component);
    }

    function closePopup() {
        root.openComponent = null;
        popupClosed();
    }

    function togglePopup(component) {
        if (isOpenPopup(component))
            closePopup();
        else
            openPopup(component);
    }


    function popupOpened(component) {
        root.openComponent = component;
    }

    function popupDestroyed(token) {
        root.openComponent = null;
    }

    Layout.fillWidth: !horizontal
    Layout.fillHeight: horizontal
}
