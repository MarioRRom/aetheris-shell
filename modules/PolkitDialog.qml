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
import QtQuick
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Controls
import Quickshell

// Config
import qs.i18n
import qs.themes
import Quickshell.Services.Polkit


//  .-------------------------.
//  | .---------------------. |
//  | |   Polkit Dialog     | |
//  | `---------------------' |
//  `-------------------------'

Window {
    id: root
    flags: Qt.Dialog | Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint
    visible: polkitAgent.isActive
    width: 400
    height: 220
    color: ThemeManager.colors.mantle

    // Polkit Agent
    PolkitAgent {
        id: polkitAgent
    }

    // Main Layout
    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 24
        spacing: 16

        // Header / Message
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 4

            Text {
                Layout.fillWidth: true
                text: polkitAgent.flow?.message ?? ""
                color: ThemeManager.colors.text
                font.family: ThemeManager.fonts.main
                font.pixelSize: 14
                font.bold: true
                wrapMode: Text.WordWrap
            }

            Text {
                Layout.fillWidth: true
                text: polkitAgent.flow?.supplementaryMessage ?? ""
                color: ThemeManager.colors.subtext0
                font.family: ThemeManager.fonts.main
                font.pixelSize: 12
                visible: text !== ""
                wrapMode: Text.WordWrap
            }
        }

        Item { Layout.fillHeight: true }

        // Password Input
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 36
            radius: 6
            color: ThemeManager.colors.base
            border.color: ThemeManager.colors.surface1
            border.width: 1

            TextInput {
                id: passwordInput
                anchors.fill: parent
                anchors.leftMargin: 10
                anchors.rightMargin: 10
                verticalAlignment: TextInput.AlignVCenter
                color: ThemeManager.colors.text
                font.family: ThemeManager.fonts.main
                font.pixelSize: 14
                echoMode: TextInput.Password
                focus: true
                clip: true
                onAccepted: submitPassword()
            }
        }

        // Error Message
        Text {
            Layout.fillWidth: true
            text: LanguageManager.t("polkit.failed")
            color: ThemeManager.colors.red
            font.family: ThemeManager.fonts.main
            font.pixelSize: 11
            visible: polkitAgent.flow?.failed ?? false
        }

        // Buttons
        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            Item { Layout.fillWidth: true }

            Button {
                id: cancelBtn
                text: LanguageManager.t("polkit.cancel")
                highlighted: false
                onClicked: polkitAgent.flow?.cancelAuthenticationRequest()

                background: Rectangle {
                    radius: 6
                    color: cancelBtn.hovered ? ThemeManager.colors.surface0 : ThemeManager.colors.base
                }
                contentItem: Text {
                    text: cancelBtn.text
                    color: ThemeManager.colors.text
                    font.family: ThemeManager.fonts.main
                    font.pixelSize: 13
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }

            Button {
                id: okBtn
                text: LanguageManager.t("polkit.ok")
                enabled: passwordInput.text.length > 0 || !(polkitAgent.flow?.isResponseRequired ?? true)
                highlighted: true
                onClicked: submitPassword()

                background: Rectangle {
                    radius: 6
                    color: okBtn.hovered ? ThemeManager.colors.mauve : ThemeManager.colors.pink
                }
                contentItem: Text {
                    text: okBtn.text
                    color: ThemeManager.colors.mantle
                    font.family: ThemeManager.fonts.main
                    font.pixelSize: 13
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
    }

    // Close on Escape
    Shortcut {
        sequence: "Escape"
        onActivated: polkitAgent.flow?.cancelAuthenticationRequest()
    }

    // Focus password input when dialog appears
    onVisibleChanged: {
        if (visible) {
            passwordInput.forceActiveFocus()
        }
    }

    // Submit password
    function submitPassword() {
        if (passwordInput.text.length > 0 || !(polkitAgent.flow?.isResponseRequired ?? true)) {
            polkitAgent.flow?.submit(passwordInput.text)
            passwordInput.text = ""
        }
    }
}