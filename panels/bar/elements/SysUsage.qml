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
//  | |  Importar Modulos   | |
//  | `---------------------' |
//  `-------------------------'

// Quickshell
import QtQuick

// Globales
import qs.themes
import qs.modules



Row {
    height: parent.height

    spacing: 5

    // Cpu Icon //
    Text {
        text: ""
        color: ThemeManager.colors.red
        font.family: ThemeManager.fonts.icons
        font.pixelSize: 14
        anchors.verticalCenter: parent.verticalCenter
    }

    //Cpu Usage //
    Text {
        text: SystemStatus.cpuUsagePercent + "%"
        color: ThemeManager.colors.text
        font.family: ThemeManager.fonts.main
        font.pixelSize: 14
        anchors.verticalCenter: parent.verticalCenter
    }

    // Ram Icon //
    Text {
        text: ""
        color: ThemeManager.colors.yellow
        font.family: ThemeManager.fonts.icons
        font.pixelSize: 14
        anchors.verticalCenter: parent.verticalCenter
    }

    // Ram Usage //
    Text {
        text: SystemStatus.ramUsagePercent + "%"
        color: ThemeManager.colors.text
        font.family: ThemeManager.fonts.main
        font.pixelSize: 14
        anchors.verticalCenter: parent.verticalCenter
    }
}