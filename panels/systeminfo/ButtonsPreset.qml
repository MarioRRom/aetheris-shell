//===========================================================================
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
import Quickshell.Widgets


// Globales
import qs.config
import qs.themes
import qs.components


//  .-------------------------.
//  | .---------------------. |
//  | |  Preset de Botones  | |
//  | `---------------------' |
//  `-------------------------'

WrapperMouseArea {
    id: button

    // Importar propiedades
    property int alto
    property var texto
    property var icono
    property var comando
    property var hovercolor

    // Config
    height: alto
    cursorShape: Qt.PointingHandCursor
    hoverEnabled: true

    // Acciones
    onClicked: {
        Quickshell.execDetached(comando);
    }


    //  .-------------------------.
    //  | .---------------------. |
    //  | |  Diseño de Botones  | |
    //  | `---------------------' |
    //  `-------------------------'

    Rectangle {
        id: buttonContainer
        color: "transparent"

        RectangularShadow {
            anchors.fill: parent
            radius: itemRadius
            color: Config.shadows.color

            blur: 3
            offset: Qt.vector2d(1, 1)
            spread: 0.0
            cached: true
        }
    
        Rectangle {
            id: buttonRectangle

            // Config
            anchors.fill: parent
            color: ThemeManager.colors.base
            radius: itemRadius

            // Coloreado para Hover y Pressed
            Rectangle {
                id: colorOverlay
                anchors.fill: parent
                radius: itemRadius
                color: "transparent"

                Behavior on color {
                    ColorAnimation {
                        duration: 250
                    }
                }
                Behavior on opacity {
                    NumberAnimation {
                        duration: 250
                    }
                }
            }

            // Contenido 
            Row {
                spacing: 5
                anchors.centerIn: parent

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: icono
                    color: ThemeManager.colors.text
                    font.family: ThemeManager.fonts.icons
                    font.pixelSize: 15
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: texto
                    color: ThemeManager.colors.text
                    font.family: ThemeManager.fonts.main
                    font.pixelSize: 15
                }

            }
        }

        states: [
            State {
            name: "hovered"
            when: button.containsMouse && !button.pressed
            PropertyChanges {
                target: colorOverlay
                color: hovercolor
                opacity: 0.3 // Opacidad para el hover (30%)
            }
            },
            State {
            name: "pressed"
            when: button.pressed
            PropertyChanges {
                target: colorOverlay
                color: hovercolor
                opacity: 0.8
            }
            }
        ]

        InnerLine {
            anchors.fill: parent
            lineradius: itemRadius
            linewidth: 1
            linecolor: ThemeManager.colors.surface0
        }
    }
}
