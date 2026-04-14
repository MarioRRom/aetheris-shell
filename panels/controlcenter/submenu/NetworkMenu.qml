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


ColumnLayout {
    anchors.fill: parent
    anchors.margins: windowMargin
    spacing: windowMargin

    // Header
    RowLayout {
        Layout.fillWidth: true
        spacing: 10
        
        // Back Button
        Rectangle {
            width: 35; height: 35; radius: itemRadius
            color: ThemeManager.colors.base
            Text { text: ""; font.family: ThemeManager.fonts.icons; anchors.centerIn: parent; color: ThemeManager.colors.text; font.pixelSize: 20 }
            MouseArea { anchors.fill: parent; onClicked: root.currentView = "main"; cursorShape: Qt.PointingHandCursor }
        }
        
        Text { 
            text: "Internet"
            color: ThemeManager.colors.text
            font.family: ThemeManager.fonts.main
            font.bold: true
            font.pixelSize: 18
            Layout.alignment: Qt.AlignVCenter
        }

        Rectangle { Layout.fillWidth: true; color: "transparent" }
    }

    // Wi-Fi Banner
    RowLayout {
        Layout.fillWidth: true
        spacing: 0

        // header
        Text {
            text: "Wi-Fi"
            font.family: ThemeManager.fonts.main
            color: ThemeManager.colors.text
            font.bold: true
            font.pixelSize: 15
        }

        // Espaciador
        Rectangle { Layout.fillWidth: true }

        // Wi-Fi Toggle
        SimpleSwitch {
            id: wifiSwitch
            size: 40
            status: Network.wifiEnabled
            action: Network.toggleWifi
        }
    }

    // List Container
    Rectangle {
        Layout.fillWidth: true
        Layout.fillHeight: true
        color: ThemeManager.colors.base
        radius: itemRadius

        // Wifi Desactivado
        Text {
            opacity: !Network.wifiEnabled ? 1 : 0
            Behavior on opacity { NumberAnimation { duration: 300 } }
            visible: opacity > 0

            anchors.centerIn: parent
            text: "Wi-Fi Desactivado"
            color: ThemeManager.colors.subtext0
            font.family: ThemeManager.fonts.main
            font.pixelSize: 15
        }

        // No hay redes disponibles
        Text {
            opacity: Network.wifiEnabled && Network.networkList.length === 0 ? 1 : 0
            Behavior on opacity { NumberAnimation { duration: 300 } }
            visible: opacity > 0

            anchors.centerIn: parent
            text: "No hay redes disponibles"
            color: ThemeManager.colors.subtext0
            font.family: ThemeManager.fonts.main
            font.pixelSize: 15
        }
        
        // Lista de Redes
        Flickable {
            anchors.fill: parent
            anchors.margins: 5
            contentHeight: networkColumm.implicitHeight
            clip: true

            opacity: Network.wifiEnabled ? 1 : 0
            visible: opacity > 0
            Behavior on opacity { NumberAnimation { duration: 300 } }

            ColumnLayout {
                id: networkColumn
                width: parent.width
                spacing: 8

                // Preset Network Cards
                Repeater {
                    id: networkRepeater
                    model: Network.networkList

                    delegate: Rectangle {
                        id: networkCard
                        Layout.fillWidth: true
                        implicitHeight: cardContent.implicitHeight + 20

                        color: ThemeManager.colors.surface0
                        radius: itemRadius - 5

                        //Variables para la UI
                        property bool footerVisible: false
                        property bool textInputVisible: false

                        // Contenido de la card
                        ColumnLayout {
                            id: cardContent
                            anchors {
                                left: parent.left
                                right: parent.right
                                top: parent.top
                                margins: 10
                            }
                            spacing: 8

                            // Nombre de la red y señal
                            RowLayout {
                                Layout.fillWidth: true
                                spacing: 10

                                Text {
                                    text: modelData.name
                                    font.family: ThemeManager.fonts.main
                                    color: ThemeManager.colors.text
                                    font.pixelSize: 14
                                    Layout.fillWidth: true
                                    elide: Text.ElideRight
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: footerVisible = !footerVisible
                                    cursorShape: Qt.PointingHandCursor
                                }

                                Text {
                                    text: Network.networkIcon(modelData)
                                    font.family: ThemeManager.fonts.icons
                                    color: modelData.connected
                                        ? ThemeManager.colors.sky
                                        : ThemeManager.colors.subtext0
                                    font.pixelSize: 25
                                }
                            }

                            // Password Input

                            // Actions (Connect/Disconnect/Forget)
                            RowLayout {
                                id: actionRow
                                spacing: 10
                                visible: footerVisible

                                Text {
                                    text: Network.activeNetwork === modelData ? "Desconectar" : "Conectar"
                                    font.family: ThemeManager.fonts.main
                                    color: Network.activeNetwork === modelData ? ThemeManager.colors.red : ThemeManager.colors.green
                                    font.pixelSize: 12
                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: Network.activeNetwork === modelData ? Network.disconnectFromNetwork(modelData) : Network.connectToNetwork(modelData)
                                        cursorShape: Qt.PointingHandCursor
                                    }
                                }

                                Text {
                                    visible: modelData.known
                                    text: "Olvidar"
                                    font.family: ThemeManager.fonts.main
                                    color: ThemeManager.colors.subtext0
                                    font.pixelSize: 12
                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: Network.forgetNetwork(modelData)
                                        cursorShape: Qt.PointingHandCursor
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    // Activar Scanner al Mostrar el Menu, Desactivarlo al Ocultar
    onVisibleChanged: {
        if (visible) Network.enableScan()
        else Network.disableScan()
    }
}