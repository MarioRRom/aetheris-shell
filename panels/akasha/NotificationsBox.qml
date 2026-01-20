//===========================================================================
//
//
//███╗   ███╗ █████╗ ██████╗ ██╗ ██████╗ ██████╗ ██████╗  ██████╗ ███╗   ███╗
//████╗ ████║██╔══██╗██╔══██╗██║██╔═══██╗██╔══██╗██╔══██╗██╔═══██╗████╗ ████║
//██╔████╔██║███████║██████╔╝██║██║   ██║██████╔╝██████╔╝██║   ██║██╔████╔██║
//██║╚██╔╝██║██╔══██║██╔══██╗██║██║   ██║██╔══██╗██╔══██╗██║   ██║██║╚██╔╝██║
//██║ ╚═╝ ██║██║  ██║██║  ██║██║╚██████╔╝██║  ██║██║  ██║╚██████╔╝██║ ╚═╝ ██║
//╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝ ╚═════╝ ╚═╝  ╚═╝ ╚═╝ ╚═╝ ╚═════╝ ╚═╝     ╚═╝                                                                          
//                          MarioRRom's Dotfiles
//                 https://github.com/MarioRRom/bspwm-dotfiles
//===========================================================================

// Quickshell
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects

// Globales
import qs.config
import qs.components
import qs.modules
import qs.themes

Rectangle {
    id: notiRoot
    color: "transparent"

    // Decoraciones
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
        anchors.fill: parent
        color: ThemeManager.colors.base
        radius: itemRadius
    }

    InnerLine {
        anchors.fill: parent
        lineradius: itemRadius
        linewidth: 1
        linecolor: ThemeManager.colors.surface0
    }
    
    // Notification Box
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10

        // Lista de Notificaciones
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            // Estado Sin Notificaciones
            ColumnLayout {
                anchors.centerIn: parent
                spacing: 5
                Text { 
                    text: "󰂚"
                    font.family: ThemeManager.fonts.icons
                    font.pixelSize: 100
                    color: ThemeManager.colors.peach
                    Layout.alignment: Qt.AlignHCenter
                }
                Text {
                    text: "Sin Notificaciones"
                    font.pixelSize: 20
                    color: ThemeManager.colors.surface2
                    font.family: ThemeManager.fonts.main
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }
    }
}