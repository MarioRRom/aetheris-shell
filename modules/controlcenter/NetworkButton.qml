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
import QtQuick.Effects
import Qt5Compat.GraphicalEffects
import Quickshell
import Quickshell.Widgets

// Config
import qs.config
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
    property bool active: Network.wifiEnabled || Network.wiredConnected


    Layout.fillWidth: true
    Layout.preferredHeight: 62
    color: "transparent" // active is true

    // Change View
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: root.currentView = "internet"
    }
    
    // Background
    Rectangle {
        anchors.fill: parent
        radius: itemRadius
        visible: true
        gradient: Gradient {
            GradientStop {
                position: 0.0
                color: active ? ThemeManager.colors.mauve : ThemeManager.colors.surface0
            }
            GradientStop { 
                position: 1.0
                color: active ? ThemeManager.colors.pink : ThemeManager.colors.surface1
            }
        }
    }
    
    // Content
    RowLayout {
        anchors.centerIn: parent
        width: parent.width - 30
        spacing: 10

        Text {
            text: Network.statusIcon
            font.family: ThemeManager.fonts.icons
            font.pixelSize: 28
            color: active ? ThemeManager.colors.mantle : ThemeManager.colors.text
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
                color: active ? ThemeManager.colors.mantle : ThemeManager.colors.text
            }

            Text {
                text: Network.statusText
                font.family: ThemeManager.fonts.main
                font.pixelSize: 10
                color: active ? ThemeManager.colors.mantle : ThemeManager.colors.text
            }
        }
    }
}