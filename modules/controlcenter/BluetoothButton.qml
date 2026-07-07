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

// Config
import qs.components
import qs.i18n
import qs.themes


//  .-------------------------.
//  | .---------------------. |
//  | |  Bluetooth Button   | |
//  | `---------------------' |
//  `-------------------------'

Rectangle {
    property bool isActive: false


    Layout.fillWidth: true
    Layout.preferredHeight: 62
    color: "transparent" // active is true

    // Change View
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: root.currentView = "bluetooth"
    }

    // Background
    Rectangle {
        id: background
        anchors.fill: parent
        radius: itemRadius
        visible: true
        gradient: Gradient {
            GradientStop {
                position: 0.0
                color: isActive ? ThemeManager.colors.sapphire : ThemeManager.colors.surface0
            }
            GradientStop {
                position: 1.0
                color: isActive ? ThemeManager.colors.sapphire : ThemeManager.colors.surface1
            }
        }
    }

    // Content
    RowLayout {
        anchors.centerIn: parent
        width: parent.width - 30
        spacing: 10

        SvgIcon {
            icon: "hardware/bluetooth"
            size: 28
            color: isActive ? ThemeManager.colors.mantle : ThemeManager.colors.text
        }

        ColumnLayout {
            Layout.alignment: Qt.AlignVCenter
            spacing: 0

            Text {
                text: LanguageManager.t("controlcenter.bluetooth")
                font.family: ThemeManager.fonts.main
                font.pixelSize: 16
                font.bold: false
                color: isActive ? ThemeManager.colors.mantle : ThemeManager.colors.text
            }

            Text {
                text: LanguageManager.t("bluetoothmenu.disabled")
                font.family: ThemeManager.fonts.main
                font.pixelSize: 10
                color: isActive ? ThemeManager.colors.mantle : ThemeManager.colors.text
            }
        }
    }
}