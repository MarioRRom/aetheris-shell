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
import QtQuick.Layouts
import QtQuick.Effects
import Qt5Compat.GraphicalEffects
import Quickshell
import Quickshell.Widgets

// Globales
import qs.config
import qs.components
import qs.services
import qs.themes

Rectangle {
    id: gridRoot
    color: "transparent"

    property int gridMargin: 8
    property int gridRadius: 6
    property int iconSize: 38
    property int itemHeight: 56
    implicitHeight: gridLayout.height + (gridMargin * 2)


    // Sombreado
    RectangularShadow {
        anchors.fill: parent
        radius: itemRadius
        color: Config.shadows.color

        blur: 3
        offset: Qt.vector2d(1, 1)
        spread: 0.0
        cached: true
    }

    // Background
    Rectangle {
        anchors.fill: parent
        color: ThemeManager.colors.base
        radius: itemRadius
        clip: true

        // Decoración
        InnerLine {
            anchors.fill: parent
            lineradius: itemRadius
            linewidth: 1
            linecolor: ThemeManager.colors.surface0
        }
    }

    

    // Grid
    GridLayout {
        id: gridLayout
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: gridMargin

        // Configuracion del grid.
        columns: 4
        rows: 3
        columnSpacing: gridMargin
        rowSpacing: gridMargin


        // No Molestar
        WrapperMouseArea {
            Layout.fillWidth: true
            Layout.preferredHeight: itemHeight
            cursorShape: Qt.PointingHandCursor
            visible: true

            onClicked: {
                Notifications.toggleDnd()
            }

            Rectangle {
                radius: gridRadius
                color: Notifications.dnd ? ThemeManager.colors.sky : ThemeManager.colors.surface0
                Behavior on color { ColorAnimation { duration: 250 } }
                Text {
                    anchors.centerIn: parent
                    text: "󱏧"
                    font.family: ThemeManager.fonts.icons
                    font.pixelSize: iconSize
                    color: Notifications.dnd ? ThemeManager.colors.base : ThemeManager.colors.text
                    Behavior on color { ColorAnimation { duration: 250 } }
                }
            }
        }

        // Modo Noche
        WrapperMouseArea {
            Layout.fillWidth: true
            Layout.preferredHeight: itemHeight
            cursorShape: Qt.PointingHandCursor
            visible: true

            onClicked: {
                Quickshell.execDetached(["notify-send", "Modo Noche", "funciona"])
            }

            Rectangle {
                radius: gridRadius
                color: ThemeManager.colors.surface0
                Text {
                    anchors.centerIn: parent
                    text: ""
                    font.family: ThemeManager.fonts.icons
                    font.pixelSize: iconSize
                    color: ThemeManager.colors.text
                }
            }
        }

        // Modo Avión
        WrapperMouseArea {
            Layout.fillWidth: true
            Layout.preferredHeight: itemHeight
            cursorShape: Qt.PointingHandCursor
            visible: true

            onClicked: {
                Quickshell.execDetached(["notify-send", "Modo Avión", "funciona"])
            }

            Rectangle {
                radius: gridRadius
                color: ThemeManager.colors.surface0
                Text {
                    anchors.centerIn: parent
                    text: "󰀞" //"󰀝"
                    font.family: ThemeManager.fonts.icons
                    font.pixelSize: iconSize
                    color: ThemeManager.colors.text
                }
            }
        }

        // Screenshot
        WrapperMouseArea {
            Layout.fillWidth: true
            Layout.preferredHeight: itemHeight
            cursorShape: Qt.PointingHandCursor
            visible: true

            onClicked: {
                Quickshell.execDetached(["notify-send", "Screenshot", "funciona"])
            }

            Rectangle {
                radius: gridRadius
                color: ThemeManager.colors.surface0
                Text {
                    anchors.centerIn: parent
                    text: "󱣴"
                    font.family: ThemeManager.fonts.icons
                    font.pixelSize: iconSize
                    color: ThemeManager.colors.text
                }
            }
        }

        // Modo Ahorro de Energia
        WrapperMouseArea {
            Layout.fillWidth: true
            Layout.preferredHeight: itemHeight
            cursorShape: Qt.PointingHandCursor
            visible: true

            onClicked: {
                Quickshell.execDetached(["notify-send", "Ahorro de Energia", "funciona"])
            }

            Rectangle {
                radius: gridRadius
                color: ThemeManager.colors.surface0
                Text {
                    anchors.centerIn: parent
                    text: "󰌪"
                    font.family: ThemeManager.fonts.icons
                    font.pixelSize: iconSize
                    color: ThemeManager.colors.text
                }
            }
        }
    }
}