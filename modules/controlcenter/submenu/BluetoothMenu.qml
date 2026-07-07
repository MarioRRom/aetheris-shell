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
            width: 35; height: 35; radius: 12
            color: ThemeManager.colors.surface0
            SvgIcon { icon: "general/chevron-left"; anchors.centerIn: parent; color: ThemeManager.colors.text; size: parent.width }
            MouseArea { anchors.fill: parent; onClicked: root.currentView = "main"; cursorShape: Qt.PointingHandCursor }
        }

        Text {
            text: LanguageManager.t("bluetoothmenu.bluetooth")
            color: ThemeManager.colors.text
            font.family: ThemeManager.fonts.main
            font.bold: true
            font.pixelSize: 18
            Layout.alignment: Qt.AlignVCenter
        }
    }

    // List Container
    Rectangle {
        Layout.fillWidth: true
        Layout.fillHeight: true
        color: ThemeManager.colors.base
        radius: itemRadius

        Text {
            anchors.centerIn: parent
            text: LanguageManager.t("bluetoothmenu.deviceList")
            color: ThemeManager.colors.subtext0
            font.family: ThemeManager.fonts.main
        }
    }
}