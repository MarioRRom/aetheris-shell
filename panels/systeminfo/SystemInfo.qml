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

// EUTHYMIA: El plano de la conciencia eterna. 
// Monitorea la integridad del hardware y el flujo de energía. 
// Un estado de equilibrio donde el uso de recursos y la potencia 
// se mantienen en una constante inmutable, libre de la erosión del sistema.


//  .-------------------------.
//  | .---------------------. |
//  | |  Importar Modulos   | |
//  | `---------------------' |
//  `-------------------------'

// Quickshell
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell
import Quickshell.Widgets

// Globales
import qs.config
import qs.components
import qs.modules
import qs.themes


//  .-------------------------.
//  | .---------------------. |
//  | | Ventana SystemInfo  | |
//  | `---------------------' |
//  `-------------------------'

PopupWindow {

    // Config
    property var bar

    // El Radius de la Ventana se Establece desde la Configuración global.
    property int globalCorners: Config.global.corners
    property int globalMargin: Config.global.margins
    property int cornerRadius: globalCorners - globalMargin
    
    property int windowMargin: 10 // Margen interno.
    property int itemRadius: cornerRadius - windowMargin


    implicitWidth: 310
    implicitHeight: sysContainer.implicitHeight + (windowMargin * 2) + 10
    anchor.window: bar
    anchor.rect.x: globalMargin - 5 // 5px por el margin en el Contenedor Principal.
    anchor.rect.y: bar.height + (globalMargin - 5) // 5px por el Margin del Contenedor Principal.
    color: "transparent"

    // Contenedor Principal
    Rectangle {
        id: sysRoot
        anchors.fill: parent
        anchors.margins: 5
        color: "transparent"
        clip: false

        // Sombreado
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

        // Contenido de la Ventana
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

                    // Contenido
                    Rectangle {
                        anchors.fill: parent
                        color: ThemeManager.colors.base
                        radius: itemRadius

                        ProfileCard {
                            anchors.fill: parent
                            anchors.margins: 8
                        }
                    }

                    // Decoración
                    InnerLine {
                        anchors.fill: parent
                        lineradius: itemRadius
                        linewidth: 1
                        linecolor: ThemeManager.colors.surface0
                    }
                }

                //  .-------------------------.
                //  | .---------------------. |
                //  | |  Graficos del Syst  | |
                //  | `---------------------' |
                //  `-------------------------'

                RowLayout {
                    spacing: windowMargin
                    Layout.fillWidth: true

                    // Uso de CPU
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 105
                        color: "transparent"

                        GraphPreset {
                            anchors.fill: parent
                            cabecera: "CPU:"
                            acento: ThemeManager.colors.red
                            icono: ""
                            porcentaje: SystemStatus.cpuUsagePercent
                        }
                    }

                    // Uso de RAM
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 105
                        color: "transparent"

                        GraphPreset {
                            anchors.fill: parent
                            cabecera: "RAM:"
                            acento: ThemeManager.colors.yellow
                            icono: ""
                            porcentaje: SystemStatus.ramUsagePercent
                        }
                    }
                }

                RowLayout {
                    spacing: windowMargin

                    // Uso de Disco
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 105
                        color: "transparent"

                        GraphPreset {
                            anchors.fill: parent
                            cabecera: "DSK:"
                            acento: ThemeManager.colors.green
                            icono: ""
                            porcentaje: SystemStatus.diskUsage
                        }
                    }

                    // Temperatura
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 105
                        color: "transparent"

                        GraphPreset {
                            anchors.fill: parent
                            cabecera: "TMP:"
                            acento: ThemeManager.colors.mauve
                            icono: ""
                            porcentaje: SystemStatus.temperature
                            temp: true
                        }
                    }
                }

                //  .-------------------------.
                //  | .---------------------. |
                //  | |  Botónes de Power   | |
                //  | `---------------------' |
                //  `-------------------------'

                RowLayout {
                    spacing: windowMargin

                    // Cerrar Sesión
                    ButtonsPreset {
                        Layout.fillWidth: true
                        alto: 41
                        icono: "󰗽"
                        texto: "Logout"
                        comando: ["bspc", "quit"]
                        hovercolor: ThemeManager.colors.mauve
                    }

                    // Apagar
                    ButtonsPreset {
                        Layout.fillWidth: true
                        alto: 41
                        icono: "⏻"
                        texto: "Shutdown"
                        comando: ["systemctl", "poweroff"]
                        hovercolor: ThemeManager.colors.red
                    }
                }

                RowLayout {
                    spacing: windowMargin

                    // Reiniciar
                    ButtonsPreset {
                        Layout.fillWidth: true
                        alto: 41
                        icono: ""
                        texto: "Reboot"
                        comando: ["systemctl", "reboot"]
                        hovercolor: ThemeManager.colors.peach
                    }

                    // Suspender
                    ButtonsPreset {
                        Layout.fillWidth: true
                        alto: 41
                        icono: ""
                        texto: "Suspend"
                        comando: ["systemctl", "suspend"]
                        hovercolor: ThemeManager.colors.sky
                    }
                }
            }
        }
    }
}