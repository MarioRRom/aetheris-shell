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
                            SimpleSwitch {
                                size: 40
                                status: Notifications.dnd
                                action: Notifications.toggleDnd
                            }

                            Text {
                                text: "No Molestar";
                                color: ThemeManager.colors.text;
                                font.family: ThemeManager.fonts.main
                            }
                        }

                        Item { Layout.fillWidth: true }

                        // Botón Limpiar
                        Rectangle {
                            width: 80; height: 35
                            color: "transparent"


                            //  .-------------------------.
                            //  | .---------------------. |
                            //  | |    Decoraciones     | |
                            //  | `---------------------' |
                            //  `-------------------------'

                            // Sombreado
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
                            }

                            // InnerLine
                            InnerLine {
                                anchors.fill: parent
                                lineradius: itemRadius
                                linewidth: 1
                                linecolor: ThemeManager.colors.surface0
                            }

                            // Button Content
                            Text {
                                anchors.centerIn: parent
                                text: "Limpiar"
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