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
// It doesn't just adjust parameters; it transmutes the physical reality of the desktop 
// defying the system's predetermined laws.


//  .-------------------------.
//  | .---------------------. |
//  | |   Import Modules    | |
//  | `---------------------' |
//  `-------------------------'

// Quickshell
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Qt5Compat.GraphicalEffects
import Quickshell
import Quickshell.Widgets

// Config
import qs.config
import qs.components
import qs.services
import qs.themes
import qs.modules.controlcenter.submenu // Import Submenus


//  .-------------------------.
//  | .---------------------. |
//  | |ControlCenter Window | |
//  | `---------------------' |
//  `-------------------------'

PopupWindow {
    id: root

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
    implicitHeight: (root.currentView === "main" ? mainLayout.implicitHeight : 428) + (windowMargin * 2) + 10
    
    anchor.window: bar
    anchor.rect.x: (bar.width - width) - ((globalMargin + globalWallborder) - 5) // 5px for the margin in the Main Container.
    anchor.rect.y: bar.height + (globalMargin - 5) //5px for the Margin of the Main Container.
    
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
                radius: cornerRadius
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
                id: mainLayout
                visible: root.currentView === "main"
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: windowMargin
                spacing: windowMargin


                // First Line
                RowLayout {
                    spacing: windowMargin
                    Layout.fillWidth: true


                    //  .-------------------------.
                    //  | .---------------------. |
                    //  | |       Internet      | |
                    //  | `---------------------' |
                    //  `-------------------------'

                    NetworkButton {

                    }


                    //  .-------------------------.
                    //  | .---------------------. |
                    //  | |      Bluetooth      | |
                    //  | `---------------------' |
                    //  `-------------------------'

                    BluetoothButton {

                    }
                }


                //  .-------------------------.
                //  | .---------------------. |
                //  | |    Buttons Grid     | |
                //  | `---------------------' |
                //  `-------------------------'
            
                ButtonsGrid {
                    Layout.fillWidth: true
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
                    gradient: ThemeManager.colors.teal
                }

                // Mic
                ControlSlider {
                    Layout.fillWidth: true
                    icon: Pipewire.iconMic
                    value: Pipewire.micVolumePercent
                    updateCommand: Pipewire.setVolumeMicPercent
                    muteCommand: Pipewire.toggleMic
                    accent: ThemeManager.colors.red
                    gradient: ThemeManager.colors.maroon
                }
            }


            //  .-------------------------.
            //  | .---------------------. |
            //  | |   Submenus Import   | |
            //  | `---------------------' |
            //  `-------------------------'

            NetworkMenu {
                visible: root.currentView === "internet"
            }

            BluetoothMenu {
                visible: root.currentView === "bluetooth"
            }
        }
    }
}
