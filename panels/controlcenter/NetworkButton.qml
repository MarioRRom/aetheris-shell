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
//  | |   Internet Button   | |
//  | `---------------------' |
//  `-------------------------'

Rectangle {
    property bool actived: true


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
        anchors.fill: parent
        radius: itemRadius
        visible: true
        gradient: Gradient {
            GradientStop {
                position: 0.0
                color: actived ? ThemeManager.colors.mauve : ThemeManager.colors.surface0
            }
            GradientStop { 
                position: 1.0
                color: actived ? ThemeManager.colors.pink : ThemeManager.colors.surface1
            }
        }
    }
    
    // Contenido
    RowLayout {
        anchors.centerIn: parent
        width: parent.width - 30
        spacing: 10

        Text {
            text: "󰖩"
            font.family: ThemeManager.fonts.icons
            font.pixelSize: 28
            color: actived ? ThemeManager.colors.mantle : ThemeManager.colors.text
            Layout.alignment: Qt.AlignVCenter
        }
        
        ColumnLayout {
            Layout.alignment: Qt.AlignVCenter
            spacing: 0
            
            Text {
                text: "Internet"
                font.family: ThemeManager.fonts.main
                font.pixelSize: 16
                font.bold: false
                color: actived ? ThemeManager.colors.mantle : ThemeManager.colors.text
            }

            Text {
                text: "Conectado"
                font.family: ThemeManager.fonts.main
                font.pixelSize: 10
                color: actived ? ThemeManager.colors.mantle : ThemeManager.colors.text
            }
        }
    }
}