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


// AKASHA: La terminal de la sabiduría absoluta. 
// Centraliza la recepción de datos y notificaciones externas. 
// Transforma el flujo de información cruda en conocimiento procesable 
// para el usuario, operando como la red neuronal de Sumeru.


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
//  | |   Ventana Akasha    | |
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


    implicitWidth: 680
    implicitHeight: akaContainer.implicitHeight + (windowMargin * 2) + 10
    anchor.window: bar
    anchor.rect.x: (bar.width - width) / 2 // Centrado en la Barra.
    anchor.rect.y: bar.height + (globalMargin - 5) // 5px por el Margin del Contenedor Principal.
    color: "transparent"

    // Contenedor Principal
    Rectangle {
        id: akaRoot
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

            // Row principal
            RowLayout {
                id: akaContainer
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: windowMargin
                spacing: windowMargin

                //  .-------------------------.
                //  | .---------------------. |
                //  | |   Bloque Izquierdo  | |
                //  | `---------------------' |
                //  `-------------------------'

                ColumnLayout {
                    Layout.fillHeight: true
                    Layout.preferredWidth: 320
                    spacing: 10

                    // Caja de Notificaciones
                    NotificationsBox {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                    }

                    // Footer (Switch y Botón)
                    RowLayout {
                        Layout.fillWidth: true
                        height: 40
                        spacing: 10

                        // Switch No Molestar
                        RowLayout {
                            spacing: 10
                            Rectangle {
                                width: 40; height: 20
                                radius: 10
                                color: ThemeManager.colors.surface1
                                Rectangle {
                                    width: 16; height: 16
                                    radius: 8
                                    color: ThemeManager.colors.text
                                    anchors.verticalCenter: parent.verticalCenter
                                    x: 2
                                }
                            }
                            Text { text: "No Molestar"; color: ThemeManager.colors.text; font.family: ThemeManager.fonts.main }
                        }

                        Item { Layout.fillWidth: true }

                        // Botón Limpiar
                        Rectangle {
                            width: 80; height: 35
                            radius: 12
                            color: ThemeManager.colors.base
                            Text {
                                anchors.centerIn: parent
                                text: "Limpiar"
                                color: ThemeManager.colors.text
                                font.family: ThemeManager.fonts.main
                            }
                        }
                    }
                }

                //  .-------------------------.
                //  | .---------------------. |
                //  | |    Bloque Derecho   | |
                //  | `---------------------' |
                //  `-------------------------'
                // Reloj, Calendario, Clima

                ColumnLayout {
                    Layout.alignment: Qt.AlignTop
                    Layout.preferredWidth: 320
                    spacing: 10

                    // Fecha y Hora
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
                            text: Qt.formatDate(new Date(), "dddd")
                            font.pixelSize: 35
                            color: ThemeManager.colors.green
                            font.family: ThemeManager.fonts.main
                            Layout.fillWidth: true
                            horizontalAlignment: Text.AlignHCenter
                        }
                    }

                    // Calendario
                    CalendarBox {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 240
                    }

                    // Tarjeta de Clima
                    WeatherCard {

                    }
                }
            }
        }
    }
}