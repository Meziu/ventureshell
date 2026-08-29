import Quickshell
import Quickshell.Wayland
import QtQuick

import "../shapes"

Item {
    id: root

    readonly property string planetsPath: "file:assets/images/outerwilds/planets/"
    property real sunRadius: 100
    property real planetRadius: 50
    property real satelliteRadius: 20
    property real sunStationOrbitDistance: 35
    property real planetOrbitDistance: 200
    property real satelliteOrbitDistance: 30

    property double timeScale: 1000

    // Orbit periods in ms
    property double sunStationOrbitPeriod: 1320000 / timeScale // 22 minutes
    property double twinsOrbitPeriod: 3600000 / timeScale // 1 hour
    property double twinsRotationPeriod: 100000 / timeScale
    property double timberHearthOrbitPeriod: 43200000 / timeScale // 12 hours
    property double brittleHollowOrbitPeriod: 604800000 / timeScale // 1 week
    property double giantsDeepOrbitPeriod: 2592000000 / timeScale // 1 month
    property double darkBrambleOrbitPeriod: 3110400000 / timeScale // 1 year

    anchors {
        top: parent.top
        left: parent.left
        right: parent.right
        bottom: parent.bottom
    }

    Image {
        id: sun
        source: root.planetsPath + "Sun.png"
        fillMode: Image.PreserveAspectFit
        anchors.centerIn: parent

        width: root.sunRadius * 2
        height: width
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

            width: root.planetRadius
            height: width

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
        id: twinsOrbit
        item: sun
        rotationPeriod: root.twinsOrbitPeriod

        Image {
            id: sandFlow
            source: root.planetsPath + "SandFlow.png"
            fillMode: Image.PreserveAspectFit

            width: root.planetRadius
            height: width
            scale: 1.5

            x: root.sunRadius + root.planetOrbitDistance - width / 2
            y: -height / 2

            RotationAnimation on rotation {
                from: 0
                to: 360
                duration: root.twinsRotationPeriod
                loops: Animation.Infinite
                direction: RotationAnimation.Clockwise
            }

            Image {
                id: ashTwin
                source: root.planetsPath + "AshTwin.png"
                fillMode: Image.PreserveAspectFit

                width: root.planetRadius
                height: width

                x: sandFlow.width/2
            }

            Image {
                id: amberTwin
                source: root.planetsPath + "AmberTwin.png"
                fillMode: Image.PreserveAspectFit

                width: root.planetRadius
                height: width

                x: -sandFlow.width/2
            }
        }
    }

    RotationAnchor {
        item: sun
        rotationPeriod: root.timberHearthOrbitPeriod

        Image {
            id: timberHearth
            source: root.planetsPath + "TimberHearth.png"
            fillMode: Image.PreserveAspectFit

            width: root.planetRadius * 2
            height: width

            x: root.sunRadius + root.planetOrbitDistance * 2 - width / 2
            y: -height / 2
        }

        RotationAnchor {
            item: timberHearth
            rotationPeriod: root.sunStationOrbitPeriod / 2

            Image {
                id: attlerock
                source: root.planetsPath + "Attlerock.png"
                fillMode: Image.PreserveAspectFit

                width: root.satelliteRadius * 2
                height: width

                x: timberHearth.width / 2 - width / 2 + root.satelliteOrbitDistance
                y: -height / 2
            }
        }
    }

    RotationAnchor {
        item: sun
        rotationPeriod: root.brittleHollowOrbitPeriod

        Image {
            id: brittleHollow
            source: root.planetsPath + "BrittleHollow.png"
            fillMode: Image.PreserveAspectFit

            width: root.planetRadius * 2
            height: width

            x: root.sunRadius + root.planetOrbitDistance * 3 - width / 2
            y: -height / 2
        }

        RotationAnchor {
            item: brittleHollow
            rotationPeriod: root.sunStationOrbitPeriod / 2

            Image {
                id: hollowLantern
                source: root.planetsPath + "HollowLantern.png"
                fillMode: Image.PreserveAspectFit

                width: root.satelliteRadius * 2
                height: width

                x: brittleHollow.width / 2 - width / 2 + root.satelliteOrbitDistance
                y: -height / 2
            }
        }
    }

    RotationAnchor {
        item: sun
        rotationPeriod: root.giantsDeepOrbitPeriod

        Image {
            id: giantsDeep
            source: root.planetsPath + "GiantsDeep.png"
            fillMode: Image.PreserveAspectFit

            width: root.planetRadius * 2
            height: width

            x: root.sunRadius + root.planetOrbitDistance * 4 - width / 2
            y: -height / 2
        }

        RotationAnchor {
            item: giantsDeep
            rotationPeriod: root.sunStationOrbitPeriod

            Image {
                id: orbitalProbeCannon
                source: root.planetsPath + "OrbitalProbeCannon.png"
                fillMode: Image.PreserveAspectFit

                width: root.satelliteRadius * 2
                height: width

                x: giantsDeep.width / 2 - width / 2 + root.satelliteOrbitDistance
                y: -height / 2

                // Counterbalance the rotation to stay put
                RotationAnimation on rotation {
                    from: 90
                    to: -270
                    duration: 10000
                    loops: Animation.Infinite
                    direction: RotationAnimation.Clockwise
                }
            }
        }
    }

    RotationAnchor {
        item: sun
        rotationPeriod: root.darkBrambleOrbitPeriod

        Image {
            id: darkBramble
            source: root.planetsPath + "DarkBramble.png"
            fillMode: Image.PreserveAspectFit

            width: root.planetRadius * 2
            height: width

            x: root.sunRadius + root.planetOrbitDistance * 5 - width / 2
            y: -height / 2
        }
    }
}
