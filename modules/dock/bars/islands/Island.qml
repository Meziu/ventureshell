import QtQuick

import "../../../shapes"
import "../widgets"

CurvyBox {
    id: root

    default property list<Widget> widgets
    required property real size
    property bool horizontal: true
    property real minLength: 0
    property real maxLength: 600

    property real transitionTime: 100

    readonly property real length: Math.max(minLength, Math.min(widgetContainer.requestedLength + cornerRadius * 2, maxLength))

    width: horizontal ? length : size
    height: !horizontal ? length : size
    avoidCornersHorizontally: horizontal

    WidgetContainer {
        id: widgetContainer
        horizontal: root.horizontal

        data: widgets
    }

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
}
