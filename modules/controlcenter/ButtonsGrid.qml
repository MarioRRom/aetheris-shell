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
pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Widgets

// Config
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


    // Shadow
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

        // Decoration
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

        // Grid configuration.
        columns: 4
        rows: 3
        columnSpacing: gridMargin
        rowSpacing: gridMargin


        // Do Not Disturb
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
                SvgIcon {
                    anchors.centerIn: parent
                    icon: Notifications.dnd ? "communicate/notifications-paused" : "communicate/notifications-active"
                    size: iconSize
                    color: Notifications.dnd ? ThemeManager.colors.base : ThemeManager.colors.text
                    Behavior on color { ColorAnimation { duration: 250 } }
                }
            }
        }

        // Night Mode
        WrapperMouseArea {
            Layout.fillWidth: true
            Layout.preferredHeight: itemHeight
            cursorShape: Qt.PointingHandCursor
            visible: true

            onClicked: {
                Quickshell.execDetached(["notify-send", "Night Mode", "works"])
            }

            Rectangle {
                radius: gridRadius
                color: ThemeManager.colors.surface0
                SvgIcon {
                    anchors.centerIn: parent
                    icon: "general/night-light"
                    size: iconSize
                    color: ThemeManager.colors.text
                }
            }
        }

        // Airplane Mode
        WrapperMouseArea {
            Layout.fillWidth: true
            Layout.preferredHeight: itemHeight
            cursorShape: Qt.PointingHandCursor
            visible: true

            onClicked: {
                Quickshell.execDetached(["notify-send", "Airplane Mode", "works"])
            }

            Rectangle {
                radius: gridRadius
                color: ThemeManager.colors.surface0
                SvgIcon {
                    anchors.centerIn: parent
                    icon: "hardware/airplane-mode-off"
                    size: iconSize
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
                Quickshell.execDetached(["notify-send", "Screenshot", "works"])
            }

            Rectangle {
                radius: gridRadius
                color: ThemeManager.colors.surface0
                SvgIcon {
                    anchors.centerIn: parent
                    icon: "general/screenshot"
                    size: iconSize
                    color: ThemeManager.colors.text
                }
            }
        }

        // Power Saving Mode
        WrapperMouseArea {
            Layout.fillWidth: true
            Layout.preferredHeight: itemHeight
            cursorShape: Qt.PointingHandCursor
            visible: true

            onClicked: {
                Quickshell.execDetached(["notify-send", "Power Saving", "works"])
            }

            Rectangle {
                radius: gridRadius
                color: ThemeManager.colors.surface0
                SvgIcon {
                    anchors.centerIn: parent
                    icon: "hardware/battery-saver"
                    size: iconSize
                    color: ThemeManager.colors.text
                }
            }
        }
    }
}