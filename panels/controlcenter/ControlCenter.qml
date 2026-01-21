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


// KHEMIA: El arte de la transmutación primordial. 
// Interfaz diseñada para alterar las variables del entorno. 
// No solo ajusta parámetros; transmuta la realidad física del escritorio 
// desafiando las leyes predeterminadas del sistema.


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
import qs.modules
import qs.themes
import qs.panels.controlcenter.submenu // Importar Submenus


//  .-------------------------.
//  | .---------------------. |
//  | |Ventana ControlCenter| |
//  | `---------------------' |
//  `-------------------------'

PopupWindow {
    id: root

    // Config
    property var bar
    property string currentView: "main" // Variable para cambiar de vista.

    // El Radius de la Ventana se Establece desde la Configuración global.
    property int globalCorners: Config.global.corners
    property int globalMargin: Config.global.margins
    property int cornerRadius: globalCorners - globalMargin
    
    property int windowMargin: 10 // Margen interno.
    property int itemRadius: cornerRadius - windowMargin

    implicitWidth: 310
    implicitHeight: (root.currentView === "main" ? mainLayout.implicitHeight : 454) + (windowMargin * 2) + 10
    
    anchor.window: bar
    anchor.rect.x: (bar.width - width) - (globalMargin - 5) // 5px por el margin en el Contenedor Principal.
    anchor.rect.y: bar.height + (globalMargin - 5) //5px por el Margin del Contenedor Principal.
    
    color: "transparent"

    // Contenedor Principal
    Rectangle {
        id: ccRoot
        anchors.fill: parent
        anchors.margins: 5
        color: "transparent"
        clip: false

        // Sombreado
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

        // Contenido de la ventana
        Rectangle {
            anchors.fill: parent
            radius: cornerRadius
            color: ThemeManager.colors.mantle

            // Decoración
            InnerLine {
                anchors.fill: parent
                lineradius: cornerRadius
                linewidth: 2
                linecolor: ThemeManager.colors.surface0
            }

            // Columna principal
            ColumnLayout {
                id: mainLayout
                visible: root.currentView === "main"
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: windowMargin
                spacing: windowMargin


                // Primera Linea
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
                //  | |   Grid de Botones   | |
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
