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
import Quickshell.Widgets

// Globales
import qs.themes
import qs.modules

WrapperMouseArea{
    id: controlCenterArea
    height: parent.height -12
    anchors.verticalCenter: parent.verticalCenter
    cursorShape: Qt.PointingHandCursor
    hoverEnabled: true

    onClicked: {
        controlCenterLoader.active = !controlCenterLoader.active
    }
    
    WrapperRectangle {
        id: controlCenterButton
        height: parent.height
        
        color: ThemeManager.colors.base
        radius: 24

        states: [
            State {
                name: "hovered"
                when: controlCenterArea.containsMouse
                PropertyChanges {
                target: controlCenterButton
                color: ThemeManager.colors.surface0
                }
            },
            State {
                name: "pressed"
                when: controlCenterArea.pressed
                PropertyChanges {
                target: controlCenterButton
                color: ThemeManager.colors.surface1
                }
            }
        ]

        Behavior on color {
            ColorAnimation {
                duration: 150
            }
        }

        Row {
            spacing: 3
            leftPadding: 10
            rightPadding: 10
            
            Text {
                text: "󰈀"
                color: ThemeManager.colors.mauve
                font.family: ThemeManager.fonts.icons
                font.pixelSize: 16
                anchors.verticalCenter: parent.verticalCenter
            }
            Text {
                text: Pipewire.icon
                color: Pipewire.muted? ThemeManager.colors.red : ThemeManager.colors.green
                font.family: ThemeManager.fonts.icons
                font.pixelSize: 16
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                text: "󰁹"
                color: ThemeManager.colors.peach
                font.family: ThemeManager.fonts.icons
                font.pixelSize: 16
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
}