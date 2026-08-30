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

    width: root.sunRadius + root.planetOrbitDistance * 12
    height: width

    function crownLength(crownIndex) {
        return root.planetOrbitDistance;
    }

    function crownInnerRadius(crownIndex) {
        return root.sunRadius + root.planetOrbitDistance * (crownIndex + 1) - root.planetRadius * 1.5;
    }

    function crownOuterRadius(crownIndex) {
        return crownInnerRadius(crownIndex) + crownLength(crownIndex);
    }

    // Given a distance from center, return which crown index it falls in, or -1.
    function crownIndexForDistance(dist) {
        if (dist <= root.sunRadius) {
            return -1;
        }
        for (let i = 0; i < crownRepeater.count; i++) {
            if (dist >= crownInnerRadius(i) && dist <= crownOuterRadius(i)) {
                return i;
            }
        }
        return -1;
    }

    property double timeScale: 1

    // Orbit periods in ms
    property double sunStationOrbitPeriod: 1320000 / timeScale // 22 minutes :P
    property double twinsRotationPeriod: 10000 / timeScale
    property double satelliteOrbitPeriod: 5000 / timeScale

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
        readonly property int daysInMonth: new Date(clock.date.getFullYear(), clock.date.getMonth() + 1, 0).getDate()
    }

    Repeater {
        id: crownRepeater

        model: [
            {
                slices: 4,
                sliceOffset: 0.5,
                labels: "0-15,15-30,30-45,45-59"
            },
            {
                slices: 12,
                sliceOffset: 1,
                labels: "index"
            },
            {
                slices: 7,
                sliceOffset: 0,
                labels: "Mon,Tue,Wed,Thur,Fri,Sat,Sun"
            },
            {
                slices: clock.daysInMonth,
                sliceOffset: 0,
                labels: "index"
            },
            {
                slices: 12,
                sliceOffset: 0,
                labels: "Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec"
            }
        ]

        Repeater {
            id: sliceRepeater
            required property int index
            required property int slices
            required property real sliceOffset
            required property string labels
            property bool isHovered: false
            model: slices

            RadialSlice {
                id: slice
                required property int index

                fractions: sliceRepeater.count
                length: root.crownLength(sliceRepeater.index)
                innerRadius: root.crownInnerRadius(sliceRepeater.index)
                margin: 0
                rotation: (this.index + sliceRepeater.sliceOffset) * 360 / fractions

                Text {
                    anchors.centerIn: parent
                    text: {
                        if (sliceRepeater.labels === "index") {
                            return slice.index + 1;
                        } else {
                            return sliceRepeater.labels.split(",")[slice.index];
                        }
                    }
                    font.pixelSize: 36
                    font.bold: true
                }

                visible: opacity > 0
                opacity: sliceRepeater.isHovered ? 1 : 0
                scale: sliceRepeater.isHovered ? 1 : 0.95

                Behavior on opacity {
                    NumberAnimation {
                        duration: sliceRepeater.isHovered ? 140 : 320
                        easing.type: sliceRepeater.isHovered ? Easing.OutQuad : Easing.InQuad
                    }
                }

                Behavior on scale {
                    NumberAnimation {
                        duration: sliceRepeater.isHovered ? 140 : 280
                        easing.type: sliceRepeater.isHovered ? Easing.OutBack : Easing.InQuad
                        easing.overshoot: 1.1
                    }
                }
            }
        }
    }

    MouseArea {
        id: sliceMouseArea
        anchors.fill: parent
        hoverEnabled: true
        property int crownIndex: 0

        onPositionChanged: mouse => {
            let dx = mouse.x - width / 2;
            let dy = -(mouse.y - height / 2);
            let dist = Math.sqrt(dx * dx + dy * dy);

            crownIndex = root.crownIndexForDistance(dist);

            for (let i = 0; i < crownRepeater.count; i++) {
                let item = crownRepeater.itemAt(i);
                if (item == null) {
                    break;
                }
                item.isHovered = (i === crownIndex);
            }
        }
    }

    Item {
        // So that the 0 degree is at the top, like a clock.
        rotation: -90
        anchors.fill: parent

        Image {
            id: sun
            source: root.planetsPath + "Sun.png"
            fillMode: Image.PreserveAspectFit
            anchors.centerIn: parent

            width: root.sunRadius * 2
            height: width
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

                    x: sandFlow.width / 2
                }

                Image {
                    id: amberTwin
                    source: root.planetsPath + "AmberTwin.png"
                    fillMode: Image.PreserveAspectFit

                    width: root.planetRadius
                    height: width

                    x: -sandFlow.width / 2
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

            rotation: (((clock.date.getDay() + 6) % 7) / 7) * 360

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

            rotation: ((clock.date.getDate() - 1) / clock.daysInMonth) * 360

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

        RotationAnchor {
            id: quantumOrbit

            function randomPlanet() {
                let choice = Math.floor(Math.random() * 6);

                if (choice === 0) {
                    return null
                } else if (choice === 1) {
                    return sandFlow
                } else if (choice === 2) {
                    return timberHearth
                } else if (choice === 3) {
                    return brittleHollow
                } else if (choice === 4) {
                    return giantsDeep
                } else if (choice === 5) {
                    return darkBramble
                }
            }

            item: randomPlanet()
            visible: item == null ? false : true

            RotationAnimation on rotation {
                from: 180
                to: 540
                duration: root.satelliteOrbitPeriod
                loops: Animation.Infinite
                direction: RotationAnimation.Clockwise
            }

            Image {
                id: quantumMoon
                source: root.planetsPath + "QuantumMoon.png"
                fillMode: Image.PreserveAspectFit

                width: root.satelliteRadius * 2
                height: width

                x: quantumOrbit.item ? quantumOrbit.item.width / 2 - width / 2 + root.satelliteOrbitDistance : 0
                y: -height / 2

                rotation: 90
            }
        }
    }
}
