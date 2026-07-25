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
import qs.services
import qs.themes


//  .-------------------------.
//  | .---------------------. |
//  | |   Internet Button   | |
//  | `---------------------' |
//  `-------------------------'

Rectangle {
    id: networkButton

    property var changeView
    property var cornerRadius
    property bool active: Network.wifiEnabled || Network.wiredConnected


    Layout.fillWidth: true
    Layout.preferredHeight: 62
    color: "transparent" // active is true

    // Change View
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: networkButton.changeView()
    }

    // Background
    Rectangle {
        anchors.fill: parent
        radius: networkButton.cornerRadius
        visible: true
        gradient: Gradient {
            GradientStop {
                position: 0.0
                color: networkButton.active ? ThemeManager.colors.mauve : ThemeManager.colors.surface0
            }
            GradientStop {
                position: 1.0
                color: networkButton.active ? ThemeManager.colors.pink : ThemeManager.colors.surface1
            }
        }
    }

    // Content
    RowLayout {
        anchors.centerIn: parent
        width: parent.width - 30
        spacing: 10

        SvgIcon {
            icon: Network.statusIcon
            size: 28
            color: networkButton.active ? ThemeManager.colors.mantle : ThemeManager.colors.text
            Layout.alignment: Qt.AlignVCenter
        }

        ColumnLayout {
            Layout.alignment: Qt.AlignVCenter
            spacing: 0

            Text {
                text: LanguageManager.t("controlcenter.network")
                font.family: ThemeManager.fonts.main
                font.pixelSize: 16
                font.bold: false
                color: networkButton.active ? ThemeManager.colors.mantle : ThemeManager.colors.text
            }

            Text {
                text: Network.statusText
                font.family: ThemeManager.fonts.main
                font.pixelSize: 10
                color: networkButton.active ? ThemeManager.colors.mantle : ThemeManager.colors.text
            }
        }
    }
}