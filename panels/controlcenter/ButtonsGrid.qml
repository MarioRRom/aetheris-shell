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
import Qt5Compat.GraphicalEffects
import Quickshell
import Quickshell.Widgets

// Globales
import qs.config
import qs.components
import qs.modules
import qs.themes

Rectangle {
    id: gridRoot
    color: "transparent"

    property int gridMargin: 8
    property int gridRadius: 6
    property int iconSize: 38
    property int itemHeight: 56
    implicitHeight: gridLayout.height + (gridMargin * 2)


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
                Quickshell.execDetached(["notify-send", "No Molestar", "funciona"])
            }

            Rectangle {
                radius: gridRadius
                color: ThemeManager.colors.surface0
                Text {
                    anchors.centerIn: parent
                    text: "󱏧"
                    font.family: ThemeManager.fonts.icons
                    font.pixelSize: iconSize
                    color: ThemeManager.colors.text
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