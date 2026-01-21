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


//  .-------------------------.
//  | .---------------------. |
//  | |  Bluetooth Button   | |
//  | `---------------------' |
//  `-------------------------'

Rectangle {
    property bool actived: false


    Layout.fillWidth: true
    Layout.preferredHeight: 62
    color: "transparent" // active is true

    // Cambiar de Vista
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: root.currentView = "internet"
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
                color: actived ? ThemeManager.colors.sapphire : ThemeManager.colors.surface0
            }
            GradientStop { 
                position: 1.0
                color: actived ? ThemeManager.colors.sapphire : ThemeManager.colors.surface1
            }
        }
    }
    
    // Contenido
    RowLayout {
        anchors.centerIn: parent
        width: parent.width - 30
        spacing: 10

        Text {
            text: "󰂲"
            font.family: ThemeManager.fonts.icons
            font.pixelSize: 28
            color: actived ? ThemeManager.colors.mantle : ThemeManager.colors.text
            Layout.alignment: Qt.AlignVCenter
        }
        
        ColumnLayout {
            Layout.alignment: Qt.AlignVCenter
            spacing: 0
            
            Text {
                text: "Bluetooth"
                font.family: ThemeManager.fonts.main
                font.pixelSize: 16
                font.bold: false
                color: actived ? ThemeManager.colors.mantle : ThemeManager.colors.text
            }

            Text {
                text: "Desactivado"
                font.family: ThemeManager.fonts.main
                font.pixelSize: 10
                color: actived ? ThemeManager.colors.mantle : ThemeManager.colors.text
            }
        }
    }
}