import Quickshell
import Quickshell.Wayland
import QtQuick

import "../shapes"

Item {
    id: root
    scale: 0.8

    readonly property string planetsPath: "file:assets/images/outerwilds/planets/"
    property real sunRadius: 150
    property real sunStationOrbitDistance: 40
    property real planetOrbitWidth: 100

    property real timeScale: 50

    // Orbit periods in ms
    property int sunStationOrbitPeriod:     1320000 / timeScale // 22 minutes
    property int twinsOrbitPeriod:          3600000 / timeScale // 1 hour
    property int timberHearthOrbitPeriod:   43200000 / timeScale // 12 hours
    property int brittleHollowOrbitPeriod:  604800000 / timeScale // 1 week
    property int giantsDeepOrbitPeriod:     2592000000 / timeScale // 1 month
    property int darkBrambleOrbitPeriod:    1320000 / timeScale // 1 year

    anchors {
        top: parent.top
        left: parent.left
        right: parent.right
        bottom: parent.bottom
    }

    Image {
        source: "file:assets/images/outerwilds/backgrounds/StarrySky.png"
        anchors.fill: parent
        fillMode: Image.PreserveAspectCrop
        opacity: 1
    }

    Image {
        id: sun
        source: root.planetsPath + "Sun.png"
        fillMode: Image.PreserveAspectFit
        anchors.centerIn: parent

        width: root.sunRadius * 2
        height: root.sunRadius * 2
    }

    Rectangle {
        anchors.centerIn: parent

        border.color: "#FFFFFF"
        color: "transparent"

        width: root.orbitWidth * 6
        height: root.orbitWidth * 6
        radius: root.width / 2
    }

    RotationAnchor {
        item: sun
        rotationPeriod: root.sunStationOrbitPeriod

        Image {
            source: root.planetsPath + "SunStation.png"
            fillMode: Image.PreserveAspectFit

            scale: 0.08
            x: root.sunRadius + root.sunStationOrbitDistance - width / 2
            y: -height / 2

            // Counterbalance and stay looking at the sun
            RotationAnimation on rotation {
                from: 90
                to: -270
                duration: root.sunStationOrbitPeriod
                loops: Animation.Infinite
                direction: RotationAnimation.Clockwise
            }
        }
    }

    RotationAnchor {
        item: sun
        rotationPeriod: root.sunStationOrbitPeriod

        Image {
            id: timberHearth
            source: root.planetsPath + "TimberHearth.png"
            fillMode: Image.PreserveAspectFit

            x: root.sunRadius + root.planetOrbitDistance - width / 2
            y: -height / 2

            scale: 0.15
        }

        RotationAnchor {
            item: timberHearth
            rotationPeriod: root.sunStationOrbitPeriod / 10

            Image {
                id: attlerock
                source: root.planetsPath + "Attlerock.png"
                fillMode: Image.PreserveAspectFit

                x: timberHearth.width/2 - width/2 - 300
                y: -height / 2

                scale: 0.15
            }
        }
    }
}
