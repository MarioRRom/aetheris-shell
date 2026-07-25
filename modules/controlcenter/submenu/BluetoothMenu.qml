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

// Config
import qs.components
import qs.i18n
import qs.themes


ColumnLayout {
    id: bluetoothMenu

    property var parentView
    property var backButton
    property var cornerRadius: parentView.itemRadius

    anchors.fill: parent
    anchors.margins: parentView.windowMargin
    spacing: parentView.windowMargin

    // Header
    RowLayout {
        Layout.fillWidth: true
        spacing: 10

        // Back Button
        Rectangle {
            width: 35; height: 35; radius: 12
            color: ThemeManager.colors.surface0
            SvgIcon { icon: "general/chevron-left"; anchors.centerIn: parent; color: ThemeManager.colors.text; size: parent.width }
            MouseArea { anchors.fill: parent; onClicked: bluetoothMenu.backButton(); cursorShape: Qt.PointingHandCursor }
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
        radius: bluetoothMenu.cornerRadius

        Text {
            anchors.centerIn: parent
            text: LanguageManager.t("bluetoothmenu.deviceList")
            color: ThemeManager.colors.subtext0
            font.family: ThemeManager.fonts.main
        }
    }
}