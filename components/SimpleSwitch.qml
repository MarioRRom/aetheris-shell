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

// Preset of a simple Switch, for true/false cases.


//  .-------------------------.
//  | .---------------------. |
//  | |   Import Modules    | |
//  | `---------------------' |
//  `-------------------------'

// Quickshell
import QtQuick
import qs.themes

// Main Rectangle
Rectangle {

    // Config
    property int size: 10
    property bool status: false
    property var action

    width: size 
    height: size / 2 
    radius: size
    color: status ? ThemeManager.colors.sky : ThemeManager.colors.surface1

    Behavior on color { ColorAnimation { duration: 250 } }

    // Internal Circle
    Rectangle {
        width: parent.height - 4
        height: parent.height - 4
        radius: size
        color: status ? ThemeManager.colors.surface0 :ThemeManager.colors.text
        Behavior on color { ColorAnimation { duration: 250 } }
        x: status ? (size  - ( height + 2))  : 2
        Behavior on x { NumberAnimation { duration: 250; easing.type: Easing.OutQuad } }
        y: 2
    }

    // Mouse Area
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true
        onClicked: action()
    }
}