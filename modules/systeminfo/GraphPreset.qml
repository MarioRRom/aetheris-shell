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
import QtQuick.Effects
import QtQuick.Layouts

// Globales
import qs.config
import qs.components
import qs.themes

Rectangle {
    id: root
    anchors.fill: parent
    color: "transparent"

    // Variables
    property var cabecera
    property var acento
    property var icono
    property int porcentaje
    property bool temp

    // Sombreado
    RectangularShadow {
        anchors.fill: parent
        radius: itemRadius
        color: Config.shadows.color

        blur: 3
        offset: Qt.vector2d(1, 1)
        spread: 0.0
        cached: true
    }

    // Background
    Rectangle {
        id: graphContainer
        anchors.fill: parent
        radius: itemRadius
        color: ThemeManager.colors.base
        clip: true
        
        // Decoración
        InnerLine {
            anchors.fill: parent
            lineradius: itemRadius
            linewidth: 1
            linecolor: ThemeManager.colors.surface0
        }
    }

    // Graph Preset
    RowLayout {
        anchors.fill: parent
        anchors.margins: 8
        spacing: 12

        // Cabecera
        Text {
            text: cabecera
            color: ThemeManager.colors.subtext1
            font.family: ThemeManager.fonts.main
            font.pixelSize: 14
            Layout.alignment: Qt.AlignTop
        }

        // Gráfico y Porcentaje
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 0
            
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.maximumHeight: 68
                color: "transparent"

                CircularProgressBar {
                    anchors.centerIn: parent
                    width: parent.height
                    height: parent.height
                    value: porcentaje / 100
                    foregroundColor: acento
                    strokeWidth: 10
                }

                Text {
                    anchors.centerIn: parent
                    text: icono
                    color: ThemeManager.colors.text
                    font.family: ThemeManager.fonts.icons
                    font.pixelSize: parent.height - 35
                }
            }

            Text { // Porcentaje
                text: porcentaje + (temp ? "°C" : "%")
                color: ThemeManager.colors.subtext1
                font.family: ThemeManager.fonts.main
                font.pixelSize: 12
                Layout.alignment: Qt.AlignRight
            }
        }
    }
}