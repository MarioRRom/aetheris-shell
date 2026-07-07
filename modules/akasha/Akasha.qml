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

// AKASHA: The terminal of absolute wisdom.
// Centralizes the reception of data and external notifications.
// Transforms the flow of raw information into actionable knowledge
// for the user, operating as Sumeru's neural network.


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
//  | |    Akasha Window    | |
//  | `---------------------' |
//  `-------------------------'

PopupWindow {
    id: root

    // Config
    property var bar

    // Window Radius is set from the global Configuration.
    property int globalCorners: Config.global.corners
    property int globalMargin: Config.global.margins
    property int cornerRadius: globalCorners - globalMargin

    property int windowMargin: 10 // Internal margin.
    property int itemRadius: cornerRadius - windowMargin


    implicitWidth: 680
    implicitHeight: akaContainer.implicitHeight + (windowMargin * 2) + 10
    anchor.window: bar
    anchor.rect.x: (bar.width - width) / 2 // Centered on the Bar.
    anchor.rect.y: bar.height + (globalMargin - 5) // 5px for the Margin of the Main Container.
    color: "transparent"

    // Main Container
    Rectangle {
        id: akaRoot
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

            // Main row
            RowLayout {
                id: akaContainer
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: windowMargin
                spacing: windowMargin


                //  .-------------------------.
                //  | .---------------------. |
                //  | |     Left Block      | |
                //  | `---------------------' |
                //  `-------------------------'

                ColumnLayout {
                    Layout.fillHeight: true
                    Layout.preferredWidth: 320
                    spacing: 10

                    // Notification Box
                    NotificationsBox {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                    }

                    // Footer (Switch and Button)
                    RowLayout {
                        Layout.fillWidth: true
                        height: 40
                        spacing: 10

                        // Do Not Disturb Switch
                        RowLayout {
                            spacing: 10
                            SimpleSwitch {
                                size: 40
                                status: Notifications.dnd
                                action: Notifications.toggleDnd
                            }

                            Text {
                                text: LanguageManager.t("akasha.dnd");
                                color: ThemeManager.colors.text;
                                font.family: ThemeManager.fonts.main
                            }
                        }

                        Item { Layout.fillWidth: true }

                        // Clear Button
                        Rectangle {
                            width: 80; height: 35
                            color: "transparent"


                            //  .-------------------------.
                            //  | .---------------------. |
                            //  | |     Decorations     | |
                            //  | `---------------------' |
                            //  `-------------------------'

                            // Shadow
                            Loader {
                                anchors.fill: parent
                                active: Config.shadows.enabled

                                sourceComponent:RectangularShadow {
                                    anchors.fill: parent
                                    radius: itemRadius
                                    color: Config.shadows.color

                                    blur: 3
                                    offset: Qt.vector2d(1, 1)
                                    spread: 1.0
                                    cached: true
                                }
                            }

                            // Background
                            Rectangle {
                                id: notsClearAll
                                anchors.fill: parent
                                radius: itemRadius
                                color: ThemeManager.colors.base
                                clip: true

                                // Decoration
                                InnerLine {
                                    anchors.fill: parent
                                    lineradius: itemRadius
                                    linewidth: 1
                                    linecolor: ThemeManager.colors.surface0
                                }
                            }

                            // Button Content
                            Text {
                                anchors.centerIn: parent
                                text: LanguageManager.t("akasha.clear")
                                color: ThemeManager.colors.text
                                font.family: ThemeManager.fonts.main
                            }

                            MouseArea {
                                id: clearArea
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                hoverEnabled: true
                                onClicked: Notifications.clearAll()
                            }

                            states: [
                                State {
                                    name: "hover"
                                    when: clearArea.containsMouse && !clearArea.pressed
                                    PropertyChanges {
                                        target: notsClearAll
                                        color: ThemeManager.colors.surface0
                                    }
                                },
                                State {
                                    name: "pressed"
                                    when: clearArea.pressed
                                    PropertyChanges {
                                        target: notsClearAll
                                        color: ThemeManager.colors.surface1
                                    }
                                }
                            ]

                            transitions: Transition {
                                ColorAnimation { duration: 250 }
                            }
                        }
                    }
                }


                //  .-------------------------.
                //  | .---------------------. |
                //  | |     Right Block     | |
                //  | `---------------------' |
                //  `-------------------------'

                // Clock, Calendar, Weather
                ColumnLayout {
                    Layout.alignment: Qt.AlignTop
                    Layout.preferredWidth: 320
                    spacing: 10

                    // Date and Time
                    ColumnLayout {
                        Layout.fillWidth: true
                        Layout.topMargin: -15
                        spacing: -18
                        Text {
                            text: SystemTime.timeFormat
                            font.pixelSize: 60
                            font.bold: true
                            color: ThemeManager.colors.text
                            font.family: ThemeManager.fonts.main
                            Layout.fillWidth: true
                            horizontalAlignment: Text.AlignHCenter
                        }
                        Text {
                            text: SystemTime.dayName
                            font.pixelSize: 35
                            color: ThemeManager.colors.green
                            font.family: ThemeManager.fonts.main
                            Layout.fillWidth: true
                            horizontalAlignment: Text.AlignHCenter
                        }
                    }

                    // Calendar
                    CalendarBox {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 240
                    }

                    // Weather Card
                    WeatherCard {}
                }
            }
        }
    }
}