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


//  .-------------------------.
//  | .---------------------. |
//  | |  Importar Módulos   | |
//  | `---------------------' |
//  `-------------------------'

// Quickshell
import QtQuick
import qs.themes


// Preset de un simple Switch, para casos true/false.

// Rectangle principal
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

    // Circulo Interior
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