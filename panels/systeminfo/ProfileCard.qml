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
import Qt5Compat.GraphicalEffects

// Global
import qs.themes
import qs.modules


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
        Rectangle { 
            width: 80
            height: 80
            color: "transparent"

            Image {
                anchors.fill: parent
                fillMode: Image.PreserveAspectCrop
                source: "file:///home/mario/.face"
                
                layer.enabled: true
                layer.effect: OpacityMask {
                    maskSource: bgMask
                }

                Rectangle {
                    id: bgMask
                    anchors.fill: parent
                    radius: pfpRadius
                    visible: false
                }
            }
            
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