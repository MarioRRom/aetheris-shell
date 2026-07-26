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

// KHEMIA: The art of primordial transmutation.
// Interface designed to alter environment variables.
// It doesn't just adjust parameters; it reshapes the desktop environment,
// breaking through the limitations imposed by the system.


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

// Config
import qs.config
import qs.components
import qs.services
import qs.themes

// Submenus
import qs.modules.controlcenter.submenu


//  .-------------------------.
//  | .---------------------. |
//  | |ControlCenter Window | |
//  | `---------------------' |
//  `-------------------------'

PopupWindow {
    id: controlCenter

    // Config
    property var bar
    property string currentView: "main" // Variable to change view.

    // Window Radius is set from the global Configuration.
    property int globalCorners: Config.global.corners
    property int globalMargin: Config.global.margins
    property int globalWallborder: Config.topBar.state === "maximized" ? Config.global.wallborder : 0
    property int cornerRadius: globalCorners - globalMargin

    property int windowMargin: 10 // Internal margin.
    property int itemRadius: cornerRadius - windowMargin

    implicitWidth: 310
    implicitHeight: (controlCenter.currentView === "main" ? mainLayout.implicitHeight : 428) + (windowMargin * 2) + 10

    anchor.window: bar
    anchor.rect.x: (bar.width - width) - ((globalMargin + globalWallborder) - 5) // 5px for the margin in the Main Container.
    anchor.rect.y: bar.height + (globalMargin - 5) // 5px for the Margin of the Main Container.

    color: "transparent"

    // Main Container
    Rectangle {
        id: ccRoot
        anchors.fill: parent
        anchors.margins: 5
        color: "transparent"
        clip: false

        // Shadow
        Loader {
            anchors.fill: parent
            active: Config.shadows.enabled

            sourceComponent: RectangularShadow {
                anchors.fill: parent
                radius: controlCenter.cornerRadius
                color: Config.shadows.color

                blur: 3
                offset: Qt.vector2d(2, 2)
                spread: 1.0
                cached: true
            }
        }

        // Window content
        Rectangle {
            anchors.fill: parent
            radius: controlCenter.cornerRadius
            color: ThemeManager.colors.mantle
            clip: true

            // Decoration
            InnerLine {
                anchors.fill: parent
                lineradius: controlCenter.cornerRadius
                linewidth: 2
                linecolor: ThemeManager.colors.surface0
            }

            // Main column
            ColumnLayout {
                id: mainLayout
                visible: controlCenter.currentView === "main"
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: controlCenter.windowMargin
                spacing: controlCenter.windowMargin


                // First Line
                RowLayout {
                    spacing: controlCenter.windowMargin
                    Layout.fillWidth: true


                    //  .-------------------------.
                    //  | .---------------------. |
                    //  | |       Internet      | |
                    //  | `---------------------' |
                    //  `-------------------------'

                    NetworkButton {
                        changeView: function() { controlCenter.currentView = "internet" }
                        cornerRadius: controlCenter.itemRadius
                    }


                    //  .-------------------------.
                    //  | .---------------------. |
                    //  | |      Bluetooth      | |
                    //  | `---------------------' |
                    //  `-------------------------'

                    BluetoothButton {
                        changeView: function() { controlCenter.currentView = "bluetooth" }
                        cornerRadius: controlCenter.itemRadius
                    }
                }


                //  .-------------------------.
                //  | .---------------------. |
                //  | |    Buttons Grid     | |
                //  | `---------------------' |
                //  `-------------------------'

                ButtonsGrid {
                    Layout.fillWidth: true
                    cornerRadius: controlCenter.itemRadius
                }


                //  .-------------------------.
                //  | .---------------------. |
                //  | |   Control Sliders   | |
                //  | `---------------------' |
                //  `-------------------------'

                // Volume
                ControlSlider {
                    Layout.fillWidth: true;
                    icon: Pipewire.icon
                    value: Pipewire.volumePercent
                    updateCommand: Pipewire.setVolumePercent
                    muteCommand: Pipewire.toggleMute
                    accent: ThemeManager.colors.green
                    gradientColor: ThemeManager.colors.teal
                    cornerRadius: controlCenter.itemRadius
                }

                // Mic
                ControlSlider {
                    Layout.fillWidth: true
                    icon: Pipewire.iconMic
                    value: Pipewire.micVolumePercent
                    updateCommand: Pipewire.setVolumeMicPercent
                    muteCommand: Pipewire.toggleMic
                    accent: ThemeManager.colors.red
                    gradientColor: ThemeManager.colors.maroon
                    cornerRadius: controlCenter.itemRadius
                }
            }


            //  .-------------------------.
            //  | .---------------------. |
            //  | |   Submenus Import   | |
            //  | `---------------------' |
            //  `-------------------------'

            NetworkMenu {
                visible: controlCenter.currentView === "internet"
                backButton: function() { controlCenter.currentView = "main" }
                parentView: controlCenter
            }

            BluetoothMenu {
                visible: controlCenter.currentView === "bluetooth"
                backButton: function() { controlCenter.currentView = "main" }
                parentView: controlCenter
            }
        }
    }
}
