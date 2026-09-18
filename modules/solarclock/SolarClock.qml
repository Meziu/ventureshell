import Quickshell
import Quickshell.Wayland
import QtQuick

import "../shapes"
import "../behaviours"

Item {
    id: root

    readonly property string planetsPath: Paths.assets + "/images/outerwilds/planets/"
    property real sunRadius: 100
    property real planetRadius: 50
    property real satelliteRadius: 20
    property real sunStationOrbitDistance: 35
    property real planetOrbitDistance: 160
    property real satelliteOrbitDistance: 30

    width: root.sunRadius + root.planetOrbitDistance * 12
    height: width

    function crownLength(crownIndex) {
        return root.planetOrbitDistance + 2;
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
        return -2;
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
                sliceOffset: 0.5,
                labels: "Mon,Tue,Wed,Thur,Fri,Sat,Sun"
            },
            {
                slices: clock.daysInMonth,
                sliceOffset: 0.5,
                labels: "index"
            },
            {
                slices: 12,
                sliceOffset: 0.5,
                labels: "Jan,Feb,Mar,Apr,May,Jun,Jul,Aug,Sep,Oct,Nov,Dec"
            }
        ]

        Repeater {
            id: sliceRepeater
            required property int index
            required property int slices
            required property real sliceOffset
            required property string labels
            property bool isHovered: (index === crownMouseArea.crownIndex || crownMouseArea.crownIndex === -1)
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

                opacity: sliceRepeater.isHovered ? 0.3 : 0
                scale: sliceRepeater.isHovered ? 1 : 0.95

                SmoothHoverOpacity on opacity {
                    isHovered: sliceRepeater.isHovered
                }

                SmoothHoverScale on scale {
                    isHovered: sliceRepeater.isHovered
                }
            }
        }
    }

    MouseArea {
        id: crownMouseArea
        anchors.fill: parent
        hoverEnabled: true

        property int rawCrownIndex: -2
        property int crownIndex: -2

        onPositionChanged: mouse => {
            let dx = mouse.x - width / 2;
            let dy = -(mouse.y - height / 2);
            let dist = Math.sqrt(dx * dx + dy * dy);

            let newIndex = root.crownIndexForDistance(dist);
            if (newIndex !== crownMouseArea.rawCrownIndex) {
                crownMouseArea.rawCrownIndex = newIndex;
                settleTimer.restart();
            }
        }

        onExited: {
            settleTimer.stop();
            rawCrownIndex = -2;
            crownIndex = -2;
        }

        Timer {
            id: settleTimer
            interval: 60
            onTriggered: crownMouseArea.crownIndex = crownMouseArea.rawCrownIndex
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

        // --- Sun station: tight orbit around the sun, always facing it ---
        OrbitingBody {
            id: sunStationOrbit
            item: sun
            orbitDistance: root.sunStationOrbitDistance
            size: root.planetRadius
            source: root.planetsPath + "SunStation.png"

            ContinuousSpin on rotation {
                duration: root.sunStationOrbitPeriod
            }

            // Counter-rotate the station image itself so it stays
            // facing the sun as the orbit above carries it around.
            ContinuousSpin {
                target: sunStationOrbit.body
                property: "rotation"
                from: 90
                to: -270
                duration: root.sunStationOrbitPeriod
            }
        }

        OrbitingBody {
            id: twinsOrbit
            item: sun
            rotation: clock.minutes * 6 // 1 loop per hour
            SmoothRotation on rotation {}

            orbitDistance: root.planetOrbitDistance
            size: root.planetRadius
            imageScale: 1.5
            source: root.planetsPath + "SandFlow.png"

            // The twins spin continuously about their shared pivot.
            ContinuousSpin {
                target: twinsOrbit.body
                property: "rotation"
                duration: root.twinsRotationPeriod
            }

            bodyChildren: [
                Image {
                    source: root.planetsPath + "AshTwin.png"
                    fillMode: Image.PreserveAspectFit
                    width: root.planetRadius
                    height: root.planetRadius
                    x: twinsOrbit.body.width / 2
                },
                Image {
                    source: root.planetsPath + "AmberTwin.png"
                    fillMode: Image.PreserveAspectFit
                    width: root.planetRadius
                    height: root.planetRadius
                    x: -twinsOrbit.body.width / 2
                }
            ]
        }

        OrbitingBody {
            id: timberHearthOrbit
            item: sun
            rotation: (((clock.hours % 12) * 60 + clock.minutes) / 720) * 360
            SmoothRotation on rotation {}

            orbitDistance: root.planetOrbitDistance * 2
            size: root.planetRadius * 2
            source: root.planetsPath + "TimberHearth.png"

            OrbitingBody {
                item: timberHearthOrbit.body
                orbitDistance: root.satelliteOrbitDistance
                size: root.satelliteRadius * 2
                source: root.planetsPath + "Attlerock.png"

                ContinuousSpin on rotation {
                    duration: root.satelliteOrbitPeriod
                }
            }
        }

        OrbitingBody {
            id: brittleHollowOrbit
            item: sun
            rotation: ((((clock.date.getDay() + 6) % 7) * 24 + clock.hours) / 168) * 360
            SmoothRotation on rotation {}

            orbitDistance: root.planetOrbitDistance * 3
            size: root.planetRadius * 2
            source: root.planetsPath + "BrittleHollow.png"

            OrbitingBody {
                item: brittleHollowOrbit.body
                orbitDistance: root.satelliteOrbitDistance
                size: root.satelliteRadius * 2
                source: root.planetsPath + "HollowLantern.png"

                ContinuousSpin on rotation {
                    duration: root.satelliteOrbitPeriod
                }
            }
        }

        OrbitingBody {
            id: giantsDeepOrbit
            item: sun
            rotation: (((clock.date.getDate() - 1) * 24 + clock.hours) / (clock.daysInMonth * 24)) * 360
            SmoothRotation on rotation {}

            orbitDistance: root.planetOrbitDistance * 4
            size: root.planetRadius * 2
            source: root.planetsPath + "GiantsDeep.png"

            OrbitingBody {
                item: giantsDeepOrbit.body
                orbitDistance: root.satelliteOrbitDistance
                size: root.satelliteRadius * 2
                source: root.planetsPath + "OrbitalProbeCannon.png"
                imageRotation: 90

                ContinuousSpin on rotation {
                    duration: root.satelliteOrbitPeriod
                }
            }
        }

        OrbitingBody {
            id: darkBrambleOrbit
            item: sun
            rotation: ((clock.date.getMonth() * clock.daysInMonth + clock.date.getDate()) / (12 * clock.daysInMonth)) * 360
            SmoothRotation on rotation {}

            orbitDistance: root.planetOrbitDistance * 5
            size: root.planetRadius * 2
            source: root.planetsPath + "DarkBramble.png"
        }

        OrbitingBody {
            id: quantumOrbit

            function randomPlanet() {
                const candidates = [null, twinsOrbit.body, timberHearthOrbit.body, brittleHollowOrbit.body, giantsDeepOrbit.body, darkBrambleOrbit.body];
                return candidates[Math.floor(Math.random() * candidates.length)];
            }

            item: quantumOrbit.randomPlanet()
            visible: item !== null

            orbitDistance: root.satelliteOrbitDistance
            size: root.satelliteRadius * 2
            source: root.planetsPath + "QuantumMoon.png"
            imageRotation: 90

            ContinuousSpin on rotation {
                from: 180
                to: 540
                duration: root.satelliteOrbitPeriod
            }
        }
    }
}
