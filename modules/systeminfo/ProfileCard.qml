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
import QtQuick.Effects
import Quickshell

// Global
import qs.components
import qs.themes
import qs.services


//  .-------------------------.
//  | .---------------------. |
//  | |    Profile Card     | |
//  | `---------------------' |
//  `-------------------------'

Item {
    anchors.fill: parent
    property int pfpRadius: itemRadius - 8
        
    Row {
        anchors.margins: 50
        anchors.verticalCenter: parent.verticalCenter
        spacing: 14

        // Profile Photo //
        MaskedImage {
            width: 80
            height: 80
            imageRadius: pfpRadius

            imageSource: "file:///home/mario/.face"
        }

        // User Info //
        Column {
            anchors.verticalCenter: parent.verticalCenter
            spacing: 1
            Text {
                text: SystemStatus.username
                color: ThemeManager.colors.green
                font.family: ThemeManager.fonts.main
                font.bold: true
                font.pixelSize: 23
            }
            Text {
                text: "welcome to " + SystemStatus.distro
                color: ThemeManager.colors.subtext1
                font.family: ThemeManager.fonts.main
                font.pixelSize: 14
            }
            Text {
                text: SystemStatus.uptime
                color: ThemeManager.colors.subtext1
                font.family: ThemeManager.fonts.main
                font.pixelSize: 14
            }
        }
    }
}