import QtQuick

import "../../../shapes"

CurvyBox {
    id: root

    required property real thickness
    property bool horizontal: true
    property real minLength: 0
    property real maxLength: 600

    property real transitionTime: 100

    function totalRequestedLength() {
        let sum = 0;

        for (let i = 0; i < contentChildren.length; i++) {
            if (contentChildren[i].requestedLength) {
                sum += contentChildren[i].requestedLength
            }
        }

        return sum
    }

    readonly property real length: Math.max(minLength, Math.min(totalRequestedLength() + cornerRadius * 2, maxLength))

    width: horizontal ? length : thickness
    height: !horizontal ? length : thickness

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
