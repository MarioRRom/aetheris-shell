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
import QtQuick.Effects
import QtQuick.Layouts

// Config
import qs.config
import qs.components
import qs.themes

Rectangle {
    id: root
    anchors.fill: parent
    color: "transparent"

    // Properties
    property var header
    property var accent
    property var icon
    property int percentage
    property bool temp

    // Shadow
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

        // Decoration
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

        // Header
        Text {
            text: header
            color: ThemeManager.colors.subtext1
            font.family: ThemeManager.fonts.main
            font.pixelSize: 14
            Layout.alignment: Qt.AlignTop
        }

        // Graph and Percentage
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
                    value: percentage / 100
                    foregroundColor: accent
                    strokeWidth: 10
                }

                Text {
                    anchors.centerIn: parent
                    text: icon
                    color: ThemeManager.colors.text
                    font.family: ThemeManager.fonts.icons
                    font.pixelSize: parent.height - 35
                }
            }

            Text { // Percentage
                text: percentage + (temp ? "°C" : "%")
                color: ThemeManager.colors.subtext1
                font.family: ThemeManager.fonts.main
                font.pixelSize: 12
                Layout.alignment: Qt.AlignRight
            }
        }
    }
}