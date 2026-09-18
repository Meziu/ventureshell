import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import QtQuick.VectorImage
import QtQuick.Controls
import QtQuick.Effects

import "../paths"
import "../config"
import "../shapes"
import "../effects"
import "../services"

PanelWindow {
    id: root
    anchors {
        top: true
        left: true
        right: true
        bottom: true
    }

    visible: SessionControlService.visible

    property real centerRadius: Config.options.sessionctl.centerRadius
    property real eyeScalePerHundredRadius: Config.options.sessionctl.eyeScalePerHundredRadius
    property real sliceLength: Config.options.sessionctl.slice.length
    property real sliceLengthIncrease: Config.options.sessionctl.slice.lengthIncrease
    property real innerDeadZone: centerRadius - Config.options.sessionctl.innerMouseOvershoot
    property real outerDeadZone: centerRadius + sliceLength + sliceLengthIncrease + Config.options.sessionctl.outerMouseOvershoot

    property int region: -1

    color: "#00000000"

    WlrLayershell.layer: WlrLayer.Overlay
    exclusionMode: ExclusionMode.Ignore

    property var fnList: {
        "lock": SessionControlService.lock,
        "logout": SessionControlService.logout,
        "suspend": SessionControlService.suspend,
        "shutdown": SessionControlService.shutdown,
        "reboot": SessionControlService.reboot,
        "hibernate": SessionControlService.hibernate,
    }

    function executeSessionControl(type: string) {
        const fn = fnList[type];
        if (fn) {
            SessionControlService.hide()
            fn()
        } else {
            console.warn("No command configured for session control:", type);
        }
    }

    Image {
        source: Paths.assets + "/images/outerwilds/backgrounds/StarrySky.png"
        fillMode: Image.PreserveAspectCrop
        opacity: 0.8
    }

    Repeater {
        id: sliceRepeater
        model: ["shutdown", "reboot", "lock", "suspend", "logout"]

        RadialSlice {
            id: slice
            required property int index
            required property string modelData

            property bool isHovered: region == index

            fractions: sliceRepeater.count
            length: isHovered ? root.sliceLength + root.sliceLengthIncrease : root.sliceLength
            innerRadius: root.centerRadius
            margin: 0.2
            rotation: index * 360 / fractions

            Behavior on length {
                NumberAnimation {
                    duration: 150
                    easing.type: Easing.OutQuad
                }
            }

            VectorImage {
                anchors.centerIn: parent
                source: Paths.assets + "/images/session/" + modelData + ".svg"
                scale: 0.8

                preferredRendererType: VectorImage.CurveRenderer
            }
        }
    }

    MouseArea {
        id: sliceMouseArea
        anchors.fill: parent
        anchors.centerIn: parent
        hoverEnabled: true
        cursorShape: region >= 0 ? Qt.PointingHandCursor : Qt.ArrowCursor

        // Prevent layout feedback by checking polar coordinates relative to origin
        onPositionChanged: mouse => {
            let dx = mouse.x - width / 2;
            let dy = -(mouse.y - height / 2);
            let dist = Math.sqrt(dx * dx + dy * dy);

            // Set all as non hovered if pointing the dead center
            if (dist >= root.innerDeadZone && dist <= root.outerDeadZone) {
                let angle = Math.atan2(dx, dy);

                // We add back the offset of the first slice, which is half in the positive side and half in the negative
                let newAngle = angle + (Math.PI / sliceRepeater.count);
                // Map the angles from [0;PI][-PI;0] to [0;2*PI].
                let angleNormal = ((newAngle % (2 * Math.PI)) + (2 * Math.PI)) % (2 * Math.PI);

                region = Math.floor(angleNormal / (2 * Math.PI) * sliceRepeater.count);
            } else {
                region = -1;
            }
        }

        onClicked: mouse => {
            if (region == -1) {
                SessionControlService.hide();
            }
            if (region >= 0) {
                let tempRegion = region
                region = -1
                root.executeSessionControl(sliceRepeater.itemAt(tempRegion).modelData);
            }
        }
    }

    VectorImage {
        id: eye
        anchors.centerIn: parent

        source: Paths.assets + "/images/outerwilds/symbols/Eye-Symbol-Nomai-Vector-Decal.svg"
        fillMode: VectorImage.Stretch

        transformOrigin: Item.Center
        scale: root.eyeScalePerHundredRadius * (root.centerRadius / 100)

        preferredRendererType: VectorImage.CurveRenderer

        layer.enabled: true
        layer.effect: NomaiEyeGlow {}
        layer.smooth: true
        layer.samples: 4

        RotationAnimation on rotation {
            from: 0
            to: 360
            duration: 120000
            loops: Animation.Infinite
            running: true
        }
    }
}
