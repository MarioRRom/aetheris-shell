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
//  | |   Import Modules    | |
//  | `---------------------' |
//  `-------------------------'

// Quickshell
import QtQuick

// Config
import qs.components
import qs.themes
import qs.services



Row {
    height: parent.height

    spacing: 5

    // Cpu Icon
    SvgIcon {
        icon: "hardware/cpu"
        size: 14
        color: ThemeManager.colors.red
        anchors.verticalCenter: parent.verticalCenter
    }

    //Cpu Usage
    Text {
        text: SystemStatus.cpuUsagePercent + "%"
        color: ThemeManager.colors.text
        font.family: ThemeManager.fonts.main
        font.pixelSize: 14
        anchors.verticalCenter: parent.verticalCenter
    }

    // Ram Icon
    SvgIcon {
        icon: "hardware/memory"
        size: 14
        color: ThemeManager.colors.yellow
        anchors.verticalCenter: parent.verticalCenter
    }

    // Ram Usage
    Text {
        text: SystemStatus.ramUsagePercent + "%"
        color: ThemeManager.colors.text
        font.family: ThemeManager.fonts.main
        font.pixelSize: 14
        anchors.verticalCenter: parent.verticalCenter
    }
}