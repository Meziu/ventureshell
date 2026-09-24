pragma Singleton

import Quickshell
import QtQuick

import "../paths"

Singleton {
    id: root

    readonly property color defaultColor: "#F28B2C"
    readonly property color lightColor: "#F5EAD9"
    readonly property color darkColor: "#2A1B12"
    readonly property color backgroundColor: "#9C4A1C"
    readonly property url sourceLogo: Paths.assets + "/fonts/ow-logo/OUTERwilds-Normal.otf"
    readonly property url sourceUI: Paths.assets + "/fonts/itc-serif-gothic/itc-serif-gothic-extra-bold.otf"
    readonly property url sourceSignalscope: Paths.assets + "/fonts/uav-osd-sans/UAV-OSD-Sans-Mono.ttf"
    readonly property font fontUI: loaderUI.font
    readonly property font fontLogo: loaderLogo.font
    readonly property font fontSignalscope: loaderSignalscope.font

    function uiWithSize(pointSize) {
        return uiWithOverrides({"pointSize": pointSize})
    }

    function logoWithSize(pointSize) {
        return logoWithOverrides({"pointSize": pointSize})
    }

    function signalscopeWithSize(pointSize) {
        return signalscopeWithOverrides({"pointSize": pointSize})
    }

    function uiWithOverrides(overrides) {
        let base = {
            family: fontUI.family,
            weight: fontUI.weight,
            styleName: fontUI.styleName
        };
        for (let key in overrides)
            base[key] = overrides[key];
        return Qt.font(base);
    }

    function logoWithOverrides(overrides) {
        let base = {
            family: fontLogo.family,
            weight: fontLogo.weight,
            styleName: fontLogo.styleName
        };
        for (let key in overrides)
            base[key] = overrides[key];
        return Qt.font(base);
    }

    function signalscopeWithOverrides(overrides) {
        let base = {
            family: fontSignalscope.family,
            weight: fontSignalscope.weight,
            styleName: fontSignalscope.styleName
        };
        for (let key in overrides)
            base[key] = overrides[key];
        return Qt.font(base);
    }

    FontLoader {
        id: loaderUI
        source: root.sourceUI
    }

    FontLoader {
        id: loaderLogo
        source: root.sourceLogo
    }

    FontLoader {
        id: loaderSignalscope
        source: root.sourceSignalscope
    }
}
