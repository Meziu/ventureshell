pragma Singleton

import Quickshell
import QtQuick

Singleton {
    id: root

    readonly property color defaultColor: "#F28B2C"
    readonly property color lightColor: "#F5EAD9"
    readonly property color darkColor: "#2A1B12"
    readonly property color backgroundColor: "#9C4A1C"
    readonly property url sourceLogo: "file:assets/fonts/ow-logo/OUTERwilds-Normal.otf"
    readonly property url sourceUI: "file:assets/fonts/itc-serif-gothic/itc-serif-gothic-extra-bold.otf"
    readonly property font fontUI: loaderUI.font
    readonly property font fontLogo: loaderLogo.font

    function uiWithSize(pointSize) {
        return Qt.font({
            family: fontUI.family,
            weight: fontUI.weight,
            styleName: fontUI.styleName,
            pointSize: pointSize
        });
    }

    function logoWithSize(pointSize) {
        return Qt.font({
            family: fontLogo.family,
            weight: fontLogo.weight,
            styleName: fontLogo.styleName,
            pointSize: pointSize
        });
    }

    /*function withOverrides(overrides) {
        let base = {
            family: font.family,
            weight: font.weight,
            styleName: font.styleName,
            pointSize: font.pointSize
        };
        for (let key in overrides)
            base[key] = overrides[key];
        return Qt.font(base);
    }*/

    FontLoader {
        id: loaderUI
        source: root.sourceUI
    }

    FontLoader {
        id: loaderLogo
        source: root.sourceLogo
    }
}
