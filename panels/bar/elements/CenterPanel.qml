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
import qs.modules
import qs.themes


WrapperMouseArea {
    id: centerPanelArea
    height: parent.height -12
    anchors.centerIn: parent
    anchors.verticalCenter: parent.verticalCenter
    cursorShape: Qt.PointingHandCursor
    hoverEnabled: true

    onClicked: {
        akashaLoader.active = !akashaLoader.active

        // Irminsul Animation //
        let gx = centerPanelArea.mapToItem(topBarRoot.contentItem, 0, 0).x
        let centroX = gx + (centerPanelArea.width / 2) 
        irmiPulse.trigger(centroX)
    }

    WrapperRectangle {
        id: centerPanelButton
        height: parent.height
        color: ThemeManager.colors.mantle
        radius: 24

        states: [
            State {
            name: "hovered"
                when: centerPanelArea.containsMouse
                PropertyChanges {
                    target: centerPanelButton
                    color: ThemeManager.colors.base
                }
            },
            State {
                name: "pressed"
                when: centerPanelArea.pressed
                PropertyChanges {
                    target: centerPanelButton
                    color: ThemeManager.colors.surface0
                }
            }
        ]

        Behavior on color {
            ColorAnimation {
                duration: 150
            }
        }

        Row {
            spacing: 5
            leftPadding: 10
            rightPadding: 10

            // Notifications Indicator //
            Text {
                visible: Notifications.history.length > 0
                text: "󰧞"
                color: ThemeManager.colors.text
                font.family: ThemeManager.fonts.icons
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 20
            }

            // System Time //
            Text {
                text: SystemTime.timeFormat
                color: ThemeManager.colors.text
                font.family: ThemeManager.fonts.main
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 17
            }


            // Weather Info //
            Text {
                text: Weather.icon
                color: Weather.color
                font.family: ThemeManager.fonts.icons
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 16
            }

            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: Weather.temperature
                color: Weather.color
                font.family: ThemeManager.fonts.main
                font.pixelSize: 14
            }
        }
    }
}