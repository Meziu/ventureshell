import Quickshell.Wayland
import QtQuick

TextWidget {
    clickable: false // What should it do when clicked? i have no idea

    text: ToplevelManager.activeToplevel ? ToplevelManager.activeToplevel.title : ""

    onClicked: {
        if (ToplevelManager.activeToplevel) {
            ToplevelManager.activeToplevel.activate()
        }
    }
}
