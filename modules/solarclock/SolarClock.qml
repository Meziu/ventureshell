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
    property real planetOrbitDistance: 160
    property real satelliteOrbitDistance: 30

    property double timeScale: 1

    // Orbit periods in ms
    property double sunStationOrbitPeriod: 1320000 / timeScale // 22 minutes :P
    property double twinsRotationPeriod: 10000 / timeScale
    property double satelliteOrbitPeriod: 5000 / timeScale

    anchors.fill: parent

    // So that the 0 degree is at the top, like a clock.
    rotation: -90

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
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

        RotationAnimation on rotation {
            from: 0
            to: 360
            duration: root.sunStationOrbitPeriod
            loops: Animation.Infinite
            direction: RotationAnimation.Clockwise
        }

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

        // 1 loop per hour
        rotation: clock.minutes * 6

        Behavior on rotation {
            PropertyAnimation {
                easing.type: Easing.InOutQuad
            }
        }

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

        // The Timber Hearth orbit is completed in 12 hours (like a wall clock)
        rotation: (((clock.hours % 12) * 60 + clock.minutes) / 720) * 360

        // Clockhand-like snap
        Behavior on rotation {
            PropertyAnimation {
                easing.type: Easing.InOutQuad
            }
        }

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

            RotationAnimation on rotation {
                from: 0
                to: 360
                duration: root.satelliteOrbitPeriod
                loops: Animation.Infinite
                direction: RotationAnimation.Clockwise
            }

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

        rotation: (clock.date.getDay() / 7) * 360

        Behavior on rotation {
            PropertyAnimation {
                easing.type: Easing.InOutQuad
            }
        }

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

            RotationAnimation on rotation {
                from: 0
                to: 360
                duration: root.satelliteOrbitPeriod
                loops: Animation.Infinite
                direction: RotationAnimation.Clockwise
            }

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

        rotation: {
            let day = clock.date.getDate();
            //let daysInMonth = Date(clock.date.getFullYear(), clock.date.getMonth()+1, 0).getDate();

            return (day / 31) * 360
        }

        Behavior on rotation {
            PropertyAnimation {
                easing.type: Easing.InOutQuad
            }
        }

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

            RotationAnimation on rotation {
                from: 0
                to: 360
                duration: root.satelliteOrbitPeriod
                loops: Animation.Infinite
                direction: RotationAnimation.Clockwise
            }

            Image {
                id: orbitalProbeCannon
                source: root.planetsPath + "OrbitalProbeCannon.png"
                fillMode: Image.PreserveAspectFit

                width: root.satelliteRadius * 2
                height: width

                x: giantsDeep.width / 2 - width / 2 + root.satelliteOrbitDistance
                y: -height / 2

                rotation: 90
            }
        }
    }

    RotationAnchor {
        item: sun

        rotation: (clock.date.getMonth() / 12) * 360

        Behavior on rotation {
            PropertyAnimation {
                easing.type: Easing.InOutQuad
            }
        }

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
