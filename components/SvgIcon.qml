//===========================================================================
//
//
//███╗   ███╗ █████╗ ██████╗ ██╗ ██████╗ ██████╗ ██████╗  ██████╗ ███╗   ███╗
//████╗ ████║██╔══██╗██╔══██╗██║██╔═══██╗██╔══██╗██╔══██╗██╔═══██╗████╗ ████║
//██╔████╔██║███████║██████╔╝██║██║   ██║██████╔╝██████╔╝██║   ██║██╔████╔██║
//██║╚██╔╝██║██╔══██║██╔══██╗██║██║   ██║██╔══██╗██╔══██╗██║   ██║██║╚██╔╝██║
//██║ ╚═╝ ██║██║  ██║██║  ██║██║╚██████╔╝██║  ██║██║  ██║╚██████╔╝██║ ╚═╝ ██║
//╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝ ╚═════╝ ╚═╝  ╚═╝ ╚═╝ ╚═╝ ╚═════╝ ╚═╝     ╚═╝
//                          MarioRRom's Aetheris Shell
//                 https://github.com/MarioRRom/aetheris-shell
//===========================================================================

// A generic icon loader for svg Icons with dynamic recoloring.


//  .-------------------------.
//  | .---------------------. |
//  | |   Import Modules    | |
//  | `---------------------' |
//  `-------------------------'

// Quickshell
pragma ComponentBehavior: Bound
import QtQuick
import Qt5Compat.GraphicalEffects


Item {
    id: iconLoader

    // Config
    property string icon: "" // Path relative to assets/icons/, e.g. "hardware/wifi.svg" or "hardware/wifi-filled.svg"

    property int size: 24
    property color color: "transparent"
    property var fillMode: Image.PreserveAspectFit

    implicitWidth: size
    implicitHeight: size

    // Base icon (no tint applied directly: kept invisible when tinting, used as mask source otherwise)
    Image {
        id: baseIcon
        anchors.fill: parent
        source: iconLoader.icon !== "" ? "../assets/icons/" + iconLoader.icon + ".svg": ""
        sourceSize.width: iconLoader.size
        sourceSize.height: iconLoader.size
        fillMode: iconLoader.fillMode
        smooth: true
        antialiasing: true
        cache: true
        visible: iconLoader.color === "transparent"
    }

    // Recolored version, shown only when a tint color is set
    ColorOverlay {
        anchors.fill: baseIcon
        source: baseIcon
        color: iconLoader.color
        visible: iconLoader.color !== "transparent"
    }
}