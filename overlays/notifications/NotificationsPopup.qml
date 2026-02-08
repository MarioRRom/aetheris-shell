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
//  | |  Importar Modulos   | |
//  | `---------------------' |
//  `-------------------------'

// Quickshell
import Quickshell
import QtQuick
import QtQuick.Effects
import QtQuick.Layouts

// Globales
import qs.config
import qs.components
import qs.themes
import qs.modules


// Lazy Loader para no cargar en RAM
// el popup cuando no esta activo.
LazyLoader {
    active: true


    //  .-------------------------.
    //  | .---------------------. |
    //  | | Load Global Config  | |
    //  | `---------------------' |
    //  `-------------------------'
    
    // global Status
    property int globalCorners: Config.global.corners
    property int globalMargin: Config.global.margins
    property int cornerRadius: globalCorners - globalMargin
    
    // bar maximized case
    property int wallborder: Config.global.wallborder
    property string topBarState: Config.topBar.state
    property int totalMargin: topBarState === "maximized" ? wallborder + globalMargin : globalMargin

    // notifications panel settings
    property int outMargin: 5 // Margen externo para el Sombreado.
    property int windowMargin: 10 // Margen interno.
    property int itemRadius: cornerRadius - windowMargin

    
    //  .-------------------------.
    //  | .---------------------. |
    //  | | Notification Popups | |
    //  | `---------------------' |
    //  `-------------------------'

    component: PanelWindow {
        id: notificationsRoot

        // Alinear abajo izquierda
        anchors {
            right: true
            bottom: true
        }

        // Separar del borde global.
        margins {
            right: totalMargin - outMargin
            bottom: totalMargin - outMargin
        }

        // Tamaño dinamico.
        implicitWidth: 400
        implicitHeight: notificationsLayout.height + (outMargin * 2)

        color: "transparent"

        // Columna Principal, para encadenar multiples Notificaciones.
        ColumnLayout {
            id: notificationsLayout
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: outMargin
            

            Repeater {
                id: listRepeater
                model: Math.min(Notifications.popups.length, 3)


                // Contenedor Principal.
                delegate: Rectangle {
                    id: notificationsContainer

                   property int reverseIndex: (listRepeater.model - 1) - index
                   property var notif: Notifications.popups[reverseIndex]
                   property string iconSource: notif ? (notif.image != "" ? notif.image : notif.appIcon) : ""

                    opacity: hoverArea.containsMouse ? 1.0 : (1.0 - (reverseIndex * 0.25))

                    Behavior on opacity { NumberAnimation { duration: 200 } }

                    MouseArea {
                        id: hoverArea
                        visible: notif.actions > []
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: Notifications.activate(notif)
                    }


                    Layout.fillWidth: true
                    Layout.preferredHeight: 100
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
                            radius: cornerRadius
                            color: Config.shadows.color

                            blur: 3
                            offset: Qt.vector2d(2, 2)
                            spread: 1.0
                            cached: true
                        }
                    }

                    // Background
                    Rectangle {
                        anchors.fill: parent
                        radius: cornerRadius
                        color: ThemeManager.colors.mantle
                    }

                    // InnerLine
                    InnerLine {
                        anchors.fill: parent
                        lineradius: cornerRadius
                        linewidth: 2
                        linecolor: ThemeManager.colors.surface0
                    }


                    //  .-------------------------.
                    //  | .---------------------. |
                    //  | | Estructura de Notif | |
                    //  | `---------------------' |
                    //  `-------------------------'
                    
                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: windowMargin
                        spacing: windowMargin


                        // Imagen o bell
                        Text {
                            visible: iconSource == ""
                            text: "󰂚"
                            color: ThemeManager.colors.peach
                            font.family: ThemeManager.fonts.icons
                            font.pixelSize: (parent.height -10 )
                        }
                        MaskedImage {
                            visible: iconSource != ""
                            Layout.preferredHeight: parent.height - 10
                            Layout.preferredWidth: height

                            imageRadius: itemRadius
                            imageSource: iconSource
                        }

                        // Cadenas de Texto
                        ColumnLayout {
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter
                            clip: true
                            spacing: 0
                            
                            // AppName
                            Text {
                                text: notif.appName
                                color: ThemeManager.colors.green
                                font.family: ThemeManager.fonts.main
                                font.pixelSize: 12
                                Layout.fillWidth: true
                                horizontalAlignment: Text.AlignLeft
                            }

                            // Title
                            Text {
                                text: notif.summary
                                color: ThemeManager.colors.text
                                font.family: ThemeManager.fonts.main
                                font.pixelSize: 18
                                Layout.fillWidth: true
                                horizontalAlignment: Text.AlignLeft
                            }

                            // Content
                            Text {
                                text: notif.body
                                color: ThemeManager.colors.text
                                font.family: ThemeManager.fonts.main
                                font.pixelSize: 14
                                Layout.fillWidth: true
                                horizontalAlignment: Text.AlignLeft
                            }
                        }

                        // Close button.}
                        Rectangle {
                            id: closeBtn
                            width: 23
                            height: width
                            color: ThemeManager.colors.surface0
                            radius: 100
                            Layout.alignment: Qt.AlignTop

                            Text {
                                anchors.centerIn: parent
                                text: ""
                                color: ThemeManager.colors.text
                                font.family: ThemeManager.fonts.icons
                                font.pixelSize: 16
                            }

                            MouseArea {
                                id: closeArea
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                hoverEnabled: true
                                onClicked: notif.close()
                            }

                            states: [
                                State {
                                    name: "hover"
                                    when: closeArea.containsMouse && !closeArea.pressed
                                    PropertyChanges {
                                        target: closeBtn
                                        color: ThemeManager.colors.surface1
                                    }
                                },
                                State {
                                    name: "pressed"
                                    when: closeArea.pressed
                                    PropertyChanges {
                                        target: closeBtn
                                        color: ThemeManager.colors.red
                                    }
                                }
                            ]

                            transitions: Transition {
                                ColorAnimation { duration: 250 }
                            }
                        }
                    }
                }
            }
        }
    }
}