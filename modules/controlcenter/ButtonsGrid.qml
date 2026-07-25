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

    property var cornerRadius

    property int gridMargin: 8
    property int gridRadius: 6
    property int iconSize: 38
    property int itemHeight: 56
    implicitHeight: gridLayout.height + (gridMargin * 2)


    // Shadow
    RectangularShadow {
        anchors.fill: parent
        radius: gridRoot.cornerRadius
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
        radius: gridRoot.cornerRadius
        clip: true

        // Decoration
        InnerLine {
            anchors.fill: parent
            lineradius: gridRoot.cornerRadius
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
        anchors.margins: gridRoot.gridMargin

        // Grid configuration.
        columns: 4
        rows: 3
        columnSpacing: gridRoot.gridMargin
        rowSpacing: gridRoot.gridMargin


        // Do Not Disturb
        WrapperMouseArea {
            Layout.fillWidth: true
            Layout.preferredHeight: gridRoot.itemHeight
            cursorShape: Qt.PointingHandCursor
            visible: true

            onClicked: {
                Notifications.toggleDnd()
            }

            Rectangle {
                radius: gridRoot.gridRadius
                color: Notifications.dnd ? ThemeManager.colors.sky : ThemeManager.colors.surface0
                Behavior on color { ColorAnimation { duration: 250 } }
                SvgIcon {
                    anchors.centerIn: parent
                    icon: Notifications.dnd ? "communicate/notifications-paused" : "communicate/notifications-active"
                    size: gridRoot.iconSize
                    color: Notifications.dnd ? ThemeManager.colors.base : ThemeManager.colors.text
                    Behavior on color { ColorAnimation { duration: 250 } }
                }
            }
        }

        // Night Mode
        WrapperMouseArea {
            Layout.fillWidth: true
            Layout.preferredHeight: gridRoot.itemHeight
            cursorShape: Qt.PointingHandCursor
            visible: true

            onClicked: {
                Quickshell.execDetached(["notify-send", "Night Mode", "works"])
            }

            Rectangle {
                radius: gridRoot.gridRadius
                color: ThemeManager.colors.surface0
                SvgIcon {
                    anchors.centerIn: parent
                    icon: "general/night-light"
                    size: gridRoot.iconSize
                    color: ThemeManager.colors.text
                }
            }
        }

        // Airplane Mode
        WrapperMouseArea {
            Layout.fillWidth: true
            Layout.preferredHeight: gridRoot.itemHeight
            cursorShape: Qt.PointingHandCursor
            visible: true

            onClicked: {
                Quickshell.execDetached(["notify-send", "Airplane Mode", "works"])
            }

            Rectangle {
                radius: gridRoot.gridRadius
                color: ThemeManager.colors.surface0
                SvgIcon {
                    anchors.centerIn: parent
                    icon: "hardware/airplane-mode-off"
                    size: gridRoot.iconSize
                    color: ThemeManager.colors.text
                }
            }
        }

        // Screenshot
        WrapperMouseArea {
            Layout.fillWidth: true
            Layout.preferredHeight: gridRoot.itemHeight
            cursorShape: Qt.PointingHandCursor
            visible: true

            onClicked: {
                Quickshell.execDetached(["notify-send", "Screenshot", "works"])
            }

            Rectangle {
                radius: gridRoot.gridRadius
                color: ThemeManager.colors.surface0
                SvgIcon {
                    anchors.centerIn: parent
                    icon: "general/screenshot"
                    size: gridRoot.iconSize
                    color: ThemeManager.colors.text
                }
            }
        }

        // Power Saving Mode
        WrapperMouseArea {
            Layout.fillWidth: true
            Layout.preferredHeight: gridRoot.itemHeight
            cursorShape: Qt.PointingHandCursor
            visible: true

            onClicked: {
                Quickshell.execDetached(["notify-send", "Power Saving", "works"])
            }

            Rectangle {
                radius: gridRoot.gridRadius
                color: ThemeManager.colors.surface0
                SvgIcon {
                    anchors.centerIn: parent
                    icon: "hardware/battery-saver"
                    size: gridRoot.iconSize
                    color: ThemeManager.colors.text
                }
            }
        }
    }
}