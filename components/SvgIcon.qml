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
import QtQuick
import Qt5Compat.GraphicalEffects


Item {
    // Config
    // Path relative to assets/icons/, e.g. "hardware/wifi.svg" or "hardware/wifi-filled.svg"
    property string icon: ""

    property int size: 24
    property color color: "transparent"
    property var fillMode: Image.PreserveAspectFit

    // Container
    id: root
    implicitWidth: size
    implicitHeight: size

    // Base icon (no tint applied directly: kept invisible when tinting, used as mask source otherwise)
    Image {
        id: baseIcon
        anchors.fill: parent
        source: root.icon !== "" ? "../assets/icons/" + root.icon + ".svg": ""
        sourceSize.width: root.size
        sourceSize.height: root.size
        fillMode: root.fillMode
        smooth: true
        antialiasing: true
        cache: true
        visible: root.color === "transparent"
    }

    // Recolored version, shown only when a tint color is set
    ColorOverlay {
        anchors.fill: baseIcon
        source: baseIcon
        color: root.color
        visible: root.color !== "transparent"
    }
}