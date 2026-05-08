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

        // Toggle Wifi
        Rectangle {
            width: 85; height: 35; radius: itemRadius
            color: ThemeManager.colors.base
            RowLayout {
                anchors.centerIn: parent
                spacing: 10
                Text {
                    text: Network.wifiEnabled ? "󰤨" : "󰤭"
                    font.family: ThemeManager.fonts.icons
                    color: Network.wifiEnabled ? ThemeManager.colors.green : ThemeManager.colors.text
                    font.pixelSize: 20
                }

                // Wi-Fi Toggle
                SimpleSwitch {
                    id: wifiSwitch
                    size: 35
                    status: Network.wifiEnabled
                    action: Network.toggleWifi
                }
            }
        }
    }

    // Ethernet Card (visible solo si hay cable)
    Rectangle {
        Layout.fillWidth: true
        implicitHeight: ethernetContent.implicitHeight + 20
        visible: Network.wiredConnected
        color: ThemeManager.colors.base
        radius: itemRadius

        // Animación al expandir/contraer
        Behavior on implicitHeight {
            NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
        }

        RowLayout {
            id: ethernetContent
            anchors {
                left: parent.left; right: parent.right
                verticalCenter: parent.verticalCenter
                leftMargin: windowMargin; rightMargin: windowMargin
            }
            spacing: windowMargin

            Text {
                text: "󰈀"
                font.family: ThemeManager.fonts.icons
                font.pixelSize: 26
                color: ThemeManager.colors.mauve
            }

            Text {
                text: "Ethernet " + Network.wiredSpeed + " Mbps"
                font.family: ThemeManager.fonts.main
                font.pixelSize: 14
                font.bold: false
                color: ThemeManager.colors.text
            }

            Rectangle { Layout.fillWidth: true}
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
            contentHeight: networkColumn.implicitHeight
            clip: true

            opacity: Network.wifiEnabled ? 1 : 0
            visible: opacity > 0
            Behavior on opacity { NumberAnimation { duration: 300 } }

            ColumnLayout {
                id: networkColumn
                width: parent.width
                spacing: 8

                // Variables para la UI
                property string expandedNetwork: ""

                // Preset Network Cards
                Repeater {
                    model: Network.networkList

                    delegate: Rectangle {
                        id: networkCard
                        Layout.fillWidth: true
                        implicitHeight: cardContent.implicitHeight + 16
                        clip: true

                        // Animación al expandir/contraer
                        Behavior on implicitHeight {
                            NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
                        }

                        color: ThemeManager.colors.surface0
                        radius: itemRadius - 5

                        // Consultar contraseña al Usuario
                        property bool awaitingPassword: false

                        // Escuchar connectionFailed de esta red específica
                        Connections {
                            target: modelData
                            function onConnectionFailed(reason) {
                                networkCard.awaitingPassword = true
                                networkColumn.expandedNetwork = modelData.name
                            }
                        }

                        // Contenido de la card
                        ColumnLayout {
                            id: cardContent
                            anchors {
                                left: parent.left
                                right: parent.right
                                top: parent.top
                                margins: 8
                            }
                            spacing: 8

                            // Nombre de la red y señal
                            WrapperMouseArea {
                                Layout.fillWidth: true
                                onClicked: {
                                    networkCard.awaitingPassword = false
                                    networkColumn.expandedNetwork =
                                        networkColumn.expandedNetwork === modelData.name
                                            ? "" : modelData.name
                                }
                                cursorShape: Qt.PointingHandCursor

                                RowLayout {
                                    spacing: 8

                                    Text {
                                        text: Network.isSecured(modelData)
                                            ? Network.signalIconLocked(modelData)
                                            : Network.signalIcon(modelData)
                                        font.family: ThemeManager.fonts.icons
                                        color: modelData.connected ? ThemeManager.colors.mauve : ThemeManager.colors.subtext0
                                        font.pixelSize: 25
                                    }

                                    Text {
                                        text: modelData.name
                                        font.family: ThemeManager.fonts.main
                                        color: ThemeManager.colors.text
                                        font.pixelSize: 14
                                        Layout.fillWidth: true
                                        elide: Text.ElideRight
                                    }

                                    Text {
                                        visible: modelData.known
                                        text: ""
                                        font.family: ThemeManager.fonts.icons
                                        color: modelData.connected ? ThemeManager.colors.mauve : ThemeManager.colors.subtext0
                                        font.pixelSize: 20
                                    }
                                }
                            }

                            // Password Input
                            ColumnLayout {
                                visible: networkColumn.expandedNetwork === modelData.name && networkCard.awaitingPassword
                                Layout.fillWidth: true
                                spacing: 6

                                Rectangle {
                                    Layout.fillWidth: true
                                    height: 32
                                    radius: 6
                                    color: ThemeManager.colors.mantle
                                    border.color: ThemeManager.colors.surface1
                                    border.width: 1

                                    RowLayout {
                                        anchors {
                                            left: parent.left; right: parent.right
                                            verticalCenter: parent.verticalCenter
                                            leftMargin: 8; rightMargin: 8
                                        }
                                        spacing: 6

                                        TextInput {
                                            id: passwordInput
                                            Layout.fillWidth: true
                                            echoMode: showPassword.checked ? TextInput.Normal : TextInput.Password
                                            color: ThemeManager.colors.text
                                            font.family: ThemeManager.fonts.main
                                            font.pixelSize: 13
                                            verticalAlignment: TextInput.AlignVCenter
                                            clip: true
                                            onVisibleChanged: if (!visible) text = ""
                                            Keys.onReturnPressed: {
                                                if (text.length > 0) {
                                                    Network.connectToNetwork(modelData, text)
                                                    networkColumn.expandedNetwork = ""
                                                    networkCard.awaitingPassword = false
                                                }
                                            }
                                            MouseArea {
                                                anchors.fill: parent
                                                cursorShape: Qt.IBeamCursor
                                                acceptedButtons: Qt.NoButton  // importante: no consumir clicks para que el TextInput siga funcionando
                                            }
                                        }

                                        Text {
                                            id: showPassword
                                            property bool checked: false
                                            text: checked ? "󰛐" : "󰛑"
                                            font.family: ThemeManager.fonts.icons
                                            font.pixelSize: 16
                                            color: ThemeManager.colors.subtext0
                                            MouseArea {
                                                anchors.fill: parent
                                                onClicked: parent.checked = !parent.checked
                                                cursorShape: Qt.PointingHandCursor
                                            }
                                        }
                                    }
                                }

                                RowLayout {
                                    Layout.fillWidth: true
                                    spacing: 10

                                    Text {
                                        text: "Conectar"
                                        font.family: ThemeManager.fonts.main
                                        font.pixelSize: 12
                                        color: passwordInput.text.length > 0 ? ThemeManager.colors.green : ThemeManager.colors.overlay0
                                        MouseArea {
                                            anchors.fill: parent
                                            enabled: passwordInput.text.length > 0
                                            cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                                            onClicked: {
                                                Network.connectToNetwork(modelData, passwordInput.text)
                                                networkColumn.expandedNetwork = ""
                                                networkCard.awaitingPassword = false
                                            }
                                        }
                                    }

                                    Text {
                                        text: "Cancelar"
                                        font.family: ThemeManager.fonts.main
                                        font.pixelSize: 12
                                        color: ThemeManager.colors.subtext0
                                        MouseArea {
                                            anchors.fill: parent
                                            onClicked: {
                                                networkColumn.expandedNetwork = ""
                                                networkCard.awaitingPassword = false
                                            }
                                            cursorShape: Qt.PointingHandCursor
                                        }
                                    }
                                }
                            }

                            // Actions (Connect/Disconnect/Forget)
                            RowLayout {
                                id: actionRow
                                spacing: 10
                                visible: networkColumn.expandedNetwork === modelData.name && !networkCard.awaitingPassword

                                Text {
                                    text: Network.activeNetwork === modelData ? "Desconectar" : "Conectar"
                                    font.family: ThemeManager.fonts.main
                                    color: Network.activeNetwork === modelData ? ThemeManager.colors.red : ThemeManager.colors.green
                                    font.pixelSize: 12
                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            if (Network.activeNetwork === modelData) {
                                                Network.disconnectFromNetwork(modelData)
                                            } else {
                                                networkCard.awaitingPassword = false
                                                Network.connectToNetwork(modelData)
                                            }
                                        }
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