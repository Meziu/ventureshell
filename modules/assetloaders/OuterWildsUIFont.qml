pragma Singleton

import Quickshell
import QtQuick

Singleton {
    readonly property string defaultColor: "#F28B2C"
    readonly property string lightColor: "#F5EAD9"
    readonly property string darkColor: "#2A1B12"
    readonly property font font: loader.font

    function withSize(pointSize) {
        return Qt.font({
            family: font.family,
            weight: font.weight,
            styleName: font.styleName,
            pointSize: pointSize
        });
    }

    function withOverrides(overrides) {
        let base = {
            family: font.family,
            weight: font.weight,
            styleName: font.styleName,
            pointSize: font.pointSize
        };
        for (let key in overrides)
            base[key] = overrides[key];
        return Qt.font(base);
    }

    FontLoader {
        id: loader
        source: "file:assets/fonts/itc-serif-gothic/itc-serif-gothic-extra-bold.otf"
    }
}
