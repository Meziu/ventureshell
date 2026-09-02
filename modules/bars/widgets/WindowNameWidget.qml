import Quickshell.Wayland
import QtQuick

TextWidget {
    text: ToplevelManager.activeToplevel ? ToplevelManager.activeToplevel.title : ""
    horizontalAlignment: Text.AlignLeft
}
