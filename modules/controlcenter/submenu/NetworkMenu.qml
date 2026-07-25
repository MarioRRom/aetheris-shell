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
//  | |   Import Modules    | |
//  | `---------------------' |
//  `-------------------------'

// Quickshell
pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import Quickshell.Widgets

// Config
import qs.components
import qs.i18n
import qs.services
import qs.themes


ColumnLayout {
    id: networkMenu

    property var parentView
    property var backButton
    property var cornerRadius: parentView.itemRadius
    property var windowMargin: parentView.windowMargin

    anchors.fill: parent
    anchors.margins: windowMargin
    spacing: windowMargin

    // Header
    RowLayout {
        Layout.fillWidth: true
        spacing: 10

        // Back Button
        Rectangle {
            width: 35; height: 35; radius: networkMenu.cornerRadius
            color: ThemeManager.colors.base
            SvgIcon { icon: "general/chevron-left"; anchors.centerIn: parent; color: ThemeManager.colors.text; size: parent.width }
            MouseArea { anchors.fill: parent; onClicked: networkMenu.backButton(); cursorShape: Qt.PointingHandCursor }
        }

        Text {
            text: LanguageManager.t("networkmenu.internet")
            color: ThemeManager.colors.text
            font.family: ThemeManager.fonts.main
            font.bold: true
            font.pixelSize: 18
            Layout.alignment: Qt.AlignVCenter
        }

        Rectangle { Layout.fillWidth: true; color: "transparent" }

        // Toggle Wifi
        Rectangle {
            width: 85; height: 35; radius: networkMenu.cornerRadius
            color: ThemeManager.colors.base
            RowLayout {
                anchors.centerIn: parent
                spacing: 10
                SvgIcon {
                    icon: Network.wifiEnabled ? "hardware/wifi" : "hardware/wifi-off"
                    size: 20
                    color: Network.wifiEnabled ? ThemeManager.colors.green : ThemeManager.colors.text
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

    // Ethernet Card (visible only if a network cable is present)
    Rectangle {
        Layout.fillWidth: true
        implicitHeight: ethernetContent.implicitHeight + 20
        visible: Network.wiredConnected
        color: ThemeManager.colors.base
        radius: networkMenu.cornerRadius

        // Expand/collapse animation
        Behavior on implicitHeight {
            NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
        }

        RowLayout {
            id: ethernetContent
            anchors {
                left: parent.left; right: parent.right
                verticalCenter: parent.verticalCenter
                leftMargin: networkMenu.windowMargin; rightMargin: networkMenu.windowMargin
            }
            spacing: networkMenu.windowMargin

            SvgIcon {
                icon: "hardware/lan"
                size: 26
                color: ThemeManager.colors.mauve
                Layout.alignment: Qt.AlignVCenter
            }

            Text {
                text: LanguageManager.t("controlcenter.ethernet") + Network.wiredSpeed + " Mbps"
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
        radius: networkMenu.cornerRadius

        // WiFi Disabled
        Text {
            opacity: !Network.wifiEnabled ? 1 : 0
            Behavior on opacity { NumberAnimation { duration: 300 } }
            visible: opacity > 0

            anchors.centerIn: parent
            text: LanguageManager.t("networkmenu.wifiDisabled")
            color: ThemeManager.colors.subtext0
            font.family: ThemeManager.fonts.main
            font.pixelSize: 15
        }

        // No networks available
        Text {
            opacity: Network.wifiEnabled && Network.networkList.length === 0 ? 1 : 0
            Behavior on opacity { NumberAnimation { duration: 300 } }
            visible: opacity > 0

            anchors.centerIn: parent
            text: LanguageManager.t("networkmenu.noNetworks")
            color: ThemeManager.colors.subtext0
            font.family: ThemeManager.fonts.main
            font.pixelSize: 15
        }

        // Network list
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

                // Variables for UI
                property string expandedNetwork: ""

                // Network Cards preset
                Repeater {
                    model: Network.networkList

                    delegate: Rectangle {
                        id: networkCard
                        required property var modelData
                        Layout.fillWidth: true
                        implicitHeight: cardContent.implicitHeight + 16
                        clip: true

                        // Expand/collapse animation
                        Behavior on implicitHeight {
                            NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
                        }

                        color: ThemeManager.colors.surface0
                        radius: networkMenu.cornerRadius - 5

                        // Ask user for password
                        property bool awaitingPassword: false

                        // Listen for connectionFailed from this specific network
                        Connections {
                            target: networkCard.modelData
                            function onConnectionFailed(reason) {
                                networkCard.awaitingPassword = true
                                networkColumn.expandedNetwork = networkCard.modelData.name
                            }
                        }

                        // Card content
                        ColumnLayout {
                            id: cardContent
                            anchors {
                                left: parent.left
                                right: parent.right
                                top: parent.top
                                margins: 8
                            }
                            spacing: 8

                            // Network name and signal
                            WrapperMouseArea {
                                Layout.fillWidth: true
                                onClicked: {
                                    networkCard.awaitingPassword = false
                                    networkColumn.expandedNetwork =
                                        networkColumn.expandedNetwork === networkCard.modelData.name
                                            ? "" : networkCard.modelData.name
                                }
                                cursorShape: Qt.PointingHandCursor

                                RowLayout {
                                    spacing: 8

                                    SvgIcon {
                                        icon: Network.isSecured(networkCard.modelData)
                                            ? Network.signalIconLocked(networkCard.modelData)
                                            : Network.signalIcon(networkCard.modelData)
                                        size: 25
                                        color: networkCard.modelData.connected ? ThemeManager.colors.mauve : ThemeManager.colors.subtext0
                                    }

                                    Text {
                                        text: networkCard.modelData.name
                                        font.family: ThemeManager.fonts.main
                                        color: ThemeManager.colors.text
                                        font.pixelSize: 14
                                        Layout.fillWidth: true
                                        elide: Text.ElideRight
                                    }

                                    SvgIcon {
                                        visible: networkCard.modelData.known
                                        icon: "general/save"
                                        size: 20
                                        color: networkCard.modelData.connected ? ThemeManager.colors.mauve : ThemeManager.colors.subtext0
                                    }
                                }
                            }

                            // Password Input
                            ColumnLayout {
                                visible: networkColumn.expandedNetwork === networkCard.modelData.name && networkCard.awaitingPassword
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
                                                    Network.connectToNetwork(networkCard.modelData, text)
                                                    networkColumn.expandedNetwork = ""
                                                    networkCard.awaitingPassword = false
                                                }
                                            }
                                            MouseArea {
                                                anchors.fill: parent
                                                cursorShape: Qt.IBeamCursor
                                                acceptedButtons: Qt.NoButton  // important: don't consume clicks so TextInput keeps working
                                            }
                                        }

                                        SvgIcon {
                                            id: showPassword
                                            property bool checked: false
                                            icon: checked ? "general/visibility" : "general/visibility-off"
                                            size: 16
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
                                        text: LanguageManager.t("networkmenu.connect")
                                        font.family: ThemeManager.fonts.main
                                        font.pixelSize: 12
                                        color: passwordInput.text.length > 0 ? ThemeManager.colors.green : ThemeManager.colors.overlay0
                                        MouseArea {
                                            anchors.fill: parent
                                            enabled: passwordInput.text.length > 0
                                            cursorShape: enabled ? Qt.PointingHandCursor : Qt.ArrowCursor
                                            onClicked: {
                                                Network.connectToNetwork(networkCard.modelData, passwordInput.text)
                                                networkColumn.expandedNetwork = ""
                                                networkCard.awaitingPassword = false
                                            }
                                        }
                                    }

                                    Text {
                                        text: LanguageManager.t("networkmenu.cancel")
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
                                visible: networkColumn.expandedNetwork === networkCard.modelData.name && !networkCard.awaitingPassword

                                Text {
                                    text: Network.activeNetwork === networkCard.modelData ? LanguageManager.t("networkmenu.disconnect") : LanguageManager.t("networkmenu.connect")
                                    font.family: ThemeManager.fonts.main
                                    color: Network.activeNetwork === networkCard.modelData ? ThemeManager.colors.red : ThemeManager.colors.green
                                    font.pixelSize: 12
                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: {
                                            if (Network.activeNetwork === networkCard.modelData) {
                                                Network.disconnectFromNetwork(networkCard.modelData)
                                            } else {
                                                networkCard.awaitingPassword = false
                                                Network.connectToNetwork(networkCard.modelData)
                                            }
                                        }
                                        cursorShape: Qt.PointingHandCursor
                                    }
                                }

                                Text {
                                    visible: networkCard.modelData.known
                                    text: LanguageManager.t("networkmenu.forget")
                                    font.family: ThemeManager.fonts.main
                                    color: ThemeManager.colors.subtext0
                                    font.pixelSize: 12
                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: Network.forgetNetwork(networkCard.modelData)
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

    // Enable Scanner on Menu Show, Disable on Hide
    onVisibleChanged: {
        if (visible) Network.enableScan()
        else Network.disableScan()
    }
}