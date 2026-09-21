import QtQuick
import Quickshell

import "../../../shapes"
import "../widgets"
import "../panels"
import ".."

CurvyBox {
    id: root

    default property list<Widget> widgets

    required property real size
    required property ShellScreen screen
    required property int position
    required property bool horizontal
    required property bool widgetsFillIsland
    property real minLength: 0
    property real maxLength: 1000

    readonly property bool isTop: (root.position & Position.Top) !== 0
    readonly property bool isBottom: (root.position & Position.Bottom) !== 0
    readonly property bool isLeft: (root.position & Position.Left) !== 0
    readonly property bool isRight: (root.position & Position.Right) !== 0
    readonly property bool isHCenter: !(root.position & Position.Left) && !(root.position & Position.Right)
    readonly property bool isVCenter: !(root.position & Position.Top) && !(root.position & Position.Bottom)

    property real transitionTime: 180

    protrusionSide: Position.opposite(Position.cardinal(position, horizontal))

    property bool animateProtrusionPosition: false

    readonly property real popupMainLength: popupLoader.item ? (horizontal ? popupLoader.requestedLength : popupLoader.requestedSize) : 0
    readonly property real popupCrossSize: popupLoader.item ? (horizontal ? popupLoader.requestedSize : popupLoader.requestedLength) : 0

    property bool popupFillsSpace: false

    property real currentTargetCenter: 0
    property real additionalLength: 0

    function calculateTargetCenter(widget: Widget): real {
        // Can't work after the item gets destroyed
        if (popupFillsSpace)
            return root.length / 2;

        const wPos = root.horizontal ? (widgetContainer.x + widget.x + widget.width / 2) : (widgetContainer.y + widget.y + widget.height / 2);

        const halfLen = root.popupMainLength / 2;
        return Math.max(halfLen, Math.min(wPos, root.length - halfLen));
    }

    readonly property real baseMainLength: Math.max(widgetContainer.requestedLength, popupLoader.item ? popupMainLength : 0)

    function calculateAdditionalLength(widget: Widget): real {
        if (!popupLoader.item || !widget)
            return 0;

        if (popupLoader.item.fillSpace) {
            return Math.max(0, popupMainLength - widgetContainer.requestedLength);
        }

        // Widget center relative to the widgetContainer origin
        const localWPos = root.horizontal ? (widget.x + widget.width / 2) : (widget.y + widget.height / 2);
        const containerLen = widgetContainer.requestedLength;
        const halfPopup = popupMainLength / 2;

        // Where the popup wants its start and end edges to be relative to widgetContainer
        const desiredStart = localWPos - halfPopup;
        const desiredEnd = localWPos + halfPopup;

        // Check if island ends are pinned/attached
        const startAttached = root.horizontal ? (root.attached.left || root.isLeft) : (root.attached.top || root.isTop);
        const endAttached = root.horizontal ? (root.attached.right || root.isRight) : (root.attached.bottom || root.isBottom);

        // Compute overflow beyond the widget container boundaries
        const startOverflow = Math.max(0, -desiredStart);
        const endOverflow = Math.max(0, desiredEnd - containerLen);

        let added = 0;

        // If an edge is unattached, allow the island to expand in that direction
        if (!startAttached)
            added += startOverflow;
        if (!endAttached)
            added += endOverflow;

        // If BOTH ends are attached/pinned, the island cannot expand outwards,
        // so we guarantee the base diff is added if popup exceeds container.
        if (startAttached && endAttached) {
            added = Math.max(0, popupMainLength - containerLen);
        }

        return added;
    }

    readonly property real length: Math.max(minLength, Math.min(baseMainLength + additionalLength + cornerRadius * 2, maxLength))

    WidgetContainer {
        id: widgetContainer

        anchors {
            top: isTop || (!horizontal && widgetsFillIsland) ? parent.top : undefined
            bottom: isBottom || (!horizontal && widgetsFillIsland) ? parent.bottom : undefined
            left: isLeft || (horizontal && widgetsFillIsland) ? parent.left : undefined
            right: isRight || (horizontal && widgetsFillIsland) ? parent.right : undefined
            horizontalCenter: horizontal && isHCenter && (!widgetsFillIsland) ? parent.horizontalCenter : undefined
            verticalCenter: !horizontal && isVCenter && (!widgetsFillIsland) ? parent.verticalCenter : undefined
        }

        horizontal: root.horizontal
        widgets: root.widgets

        onPopupRequested: (widget, panelComponent) => {
            root.showPopup(widget, panelComponent);
        }

        // TODO: Hacky calculations that have no actual roots in reality
        width: (horizontal ? requestedLength : size - cornerMargins * 4)
        height: (horizontal ? size : requestedLength - cornerMargins * 4) - anchors.margins * 2
    }
    property alias widgetContainer: widgetContainer

    protrusionContent: Loader {
        id: popupLoader

        anchors.fill: parent

        property real requestedPosition: root.currentTargetCenter - (root.protrusionLength / 2)
        property real requestedLength: popupLoader.item ? popupLoader.item.implicitWidth : 0
        property real requestedSize: popupLoader.item ? popupLoader.item.implicitHeight : 0

        onLoaded: {
            popupLoader.item.exited.connect(() => {
                root.hidePopup(true);
            });
        }
    }

    function showPopup(widget: Widget, component: Component) {
        if (!component)
            return;

        if (popupLoader.sourceComponent === component) {
            hidePopup(false);
            return;
        }

        // Animate the protrusion sliding over only when swapping between
        // two already-open popups, not on a fresh open.
        animateProtrusionPosition = (popupLoader.item !== null);

        currentTargetCenter = Qt.binding(() => calculateTargetCenter(widget));
        additionalLength = Qt.binding(() => calculateAdditionalLength(widget));

        popupLoader.sourceComponent = component;
        popupFillsSpace = popupLoader.item.fillSpace;
    }

    // `force` allows overriding persistence for explicit user intents.
    function hidePopup(force = false) {
        if (!force && popupLoader.item && popupLoader.item.persistent)
            return;

        animateProtrusionPosition = false;
        popupLoader.sourceComponent = undefined;
    }

    property bool popupOpen: popupLoader.sourceComponent !== null

    // Evaluates true only if a popup is open AND it isn't persistent.
    // Used by the bar level to determine if a generic Hyprland focus grab is necessary.
    readonly property bool requiresFocusGrab: popupLoader.sourceComponent !== null && (!popupLoader.item || !popupLoader.item.persistent)

    width: horizontal ? length : size
    height: !horizontal ? length : size
    cornerMarginsHorizontal: horizontal

    Behavior on width {
        NumberAnimation {
            duration: transitionTime
            easing.type: Easing.OutCubic
        }
    }
    Behavior on height {
        NumberAnimation {
            duration: transitionTime
            easing.type: Easing.OutCubic
        }
    }
    Behavior on protrusionPosition {
        enabled: root.animateProtrusionPosition
        NumberAnimation {
            duration: transitionTime
            easing.type: Easing.OutCubic
        }
    }
    Behavior on protrusionLength {
        NumberAnimation {
            duration: transitionTime
            easing.type: Easing.OutCubic
        }
    }
    Behavior on protrusionDepth {
        NumberAnimation {
            duration: transitionTime
            easing.type: Easing.OutCubic
        }
    }
}
