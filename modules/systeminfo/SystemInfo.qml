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

// EUTHYMIA: The plane of eternal consciousness.
// Monitors hardware integrity and energy flow.
// Like the alchemical opus, system variables
// remain in an immutable constant, free from the erosion of the system.


//  .-------------------------.
//  | .---------------------. |
//  | |   Import Modules    | |
//  | `---------------------' |
//  `-------------------------'

// Quickshell
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell

// Config
import qs.config
import qs.components
import qs.i18n
import qs.services
import qs.themes


//  .-------------------------.
//  | .---------------------. |
//  | |  SystemInfo Window  | |
//  | `---------------------' |
//  `-------------------------'

PopupWindow {
    id: root

    // Config
    property var bar
    property var closeWidgets: null

    // Window Radius is set from the global Configuration.
    property int globalCorners: Config.global.corners
    property int globalMargin: Config.global.margins
    property int globalWallborder: Config.topBar.state === "maximized" ? Config.global.wallborder : 0
    property int cornerRadius: globalCorners - globalMargin

    property int windowMargin: 10 // Internal margin.
    property int itemRadius: cornerRadius - windowMargin


    implicitWidth: 310
    implicitHeight: sysContainer.implicitHeight + (windowMargin * 2) + 10
    anchor.window: bar
    anchor.rect.x: globalWallborder + (globalMargin - 5) // 5px for the margin in the Main Container.
    anchor.rect.y: bar.height + (globalMargin - 5) // 5px for the Margin of the Main Container.
    color: "transparent"

    // Main Container
    Rectangle {
        id: sysRoot
        anchors.fill: parent
        anchors.margins: 5
        color: "transparent"
        clip: false

        // Shadow
        Loader {
            anchors.fill: parent
            active: Config.shadows.enabled

            sourceComponent:RectangularShadow {
                anchors.fill: parent
                radius: cornerRadius
                color: Config.shadows.color

                blur: 3
                offset: Qt.vector2d(2, 2)
                spread: 1.0
                cached: true
            }
        }

        // Window Content
        Rectangle {
        anchors.fill: parent
        radius: cornerRadius
        color: ThemeManager.colors.mantle
        clip: true

            // Decoration
            InnerLine {
                anchors.fill: parent
                lineradius: cornerRadius
                linewidth: 2
                linecolor: ThemeManager.colors.surface0
            }

            // Main column
            ColumnLayout {
                id: sysContainer
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: windowMargin
                spacing: windowMargin


                //  .-------------------------.
                //  | .---------------------. |
                //  | |    Profile Card     | |
                //  | `---------------------' |
                //  `-------------------------'

                Rectangle {
                    Layout.fillWidth: true
                    height: 96
                    color: "transparent"

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

                    // Content
                    Rectangle {
                        anchors.fill: parent
                        color: ThemeManager.colors.base
                        radius: itemRadius
                        clip: true

                        ProfileCard {
                            anchors.fill: parent
                            anchors.margins: 8
                        }

                        // Decoration
                        InnerLine {
                            anchors.fill: parent
                            lineradius: itemRadius
                            linewidth: 1
                            linecolor: ThemeManager.colors.surface0
                        }
                    }
                }


                //  .-------------------------.
                //  | .---------------------. |
                //  | |    System Graphs    | |
                //  | `---------------------' |
                //  `-------------------------'

                RowLayout {
                    spacing: windowMargin
                    Layout.fillWidth: true

                    // CPU usage
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 105
                        color: "transparent"

                        GraphPreset {
                            anchors.fill: parent
                            header: LanguageManager.t("systeminfo.cpu")
                            accent: ThemeManager.colors.red
                            icon: "hardware/cpu"
                            percentage: SystemStatus.cpuUsagePercent
                        }
                    }

                    // RAM usage
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 105
                        color: "transparent"

                        GraphPreset {
                            anchors.fill: parent
                            header: LanguageManager.t("systeminfo.ram")
                            accent: ThemeManager.colors.yellow
                            icon: "hardware/memory"
                            percentage: SystemStatus.ramUsagePercent
                        }
                    }
                }

                RowLayout {
                    spacing: windowMargin

                    // Disk usage
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 105
                        color: "transparent"

                        GraphPreset {
                            anchors.fill: parent
                            header: LanguageManager.t("systeminfo.dsk")
                            accent: ThemeManager.colors.green
                            icon: "hardware/harddrive"
                            percentage: SystemStatus.diskUsage
                        }
                    }

                    // Temperature
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 105
                        color: "transparent"

                        GraphPreset {
                            anchors.fill: parent
                            header: LanguageManager.t("systeminfo.tmp")
                            accent: ThemeManager.colors.mauve
                            icon: "general/thermometer"
                            percentage: SystemStatus.temperature
                            temp: true
                        }
                    }
                }


                //  .-------------------------.
                //  | .---------------------. |
                //  | |   Power Buttons     | |
                //  | `---------------------' |
                //  `-------------------------'

                RowLayout {
                    spacing: windowMargin

                    // Logout
                    ButtonsPreset {
                        Layout.fillWidth: true
                        btnHeight: 41
                        icon: "general/logout"
                        btnText: LanguageManager.t("systeminfo.logout")
                        command: ["loginctl", "terminate-user", Quickshell.env("USER")]
                        hoverColor: ThemeManager.colors.mauve
                    }

                    // Shutdown
                    ButtonsPreset {
                        Layout.fillWidth: true
                        btnHeight: 41
                        icon: "general/shutdown"
                        btnText: LanguageManager.t("systeminfo.shutdown")
                        command: ["systemctl", "poweroff"]
                        hoverColor: ThemeManager.colors.red
                    }
                }

                RowLayout {
                    spacing: windowMargin

                    // Reboot
                    ButtonsPreset {
                        Layout.fillWidth: true
                        btnHeight: 41
                        icon: "general/restart"
                        btnText: LanguageManager.t("systeminfo.reboot")
                        command: ["systemctl", "reboot"]
                        hoverColor: ThemeManager.colors.peach
                    }

                    // Suspend
                    ButtonsPreset {
                        Layout.fillWidth: true
                        btnHeight: 41
                        icon: "general/suspend"
                        btnText: LanguageManager.t("systeminfo.suspend")
                        command: ["systemctl", "suspend"]
                        hoverColor: ThemeManager.colors.sky
                        beforeCommand: root.closeWidgets
                    }
                }
            }
        }
    }
}