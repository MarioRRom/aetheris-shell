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
import QtQuick.Effects
import QtQuick.Layouts

// Config
import qs.config
import qs.components
import qs.themes

Rectangle {
    id: graph
    anchors.fill: parent
    color: "transparent"

    property var cornerRadius

    // Properties
    property var header
    property var accent
    property var icon
    property int percentage
    property bool temp

    // Shadow
    RectangularShadow {
        anchors.fill: parent
        radius: graph.cornerRadius
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
        radius: graph.cornerRadius
        color: ThemeManager.colors.base
        clip: true

        // Decoration
        InnerLine {
            anchors.fill: parent
            lineradius: graph.cornerRadius
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
            text: graph.header
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
                    value: graph.percentage / 100
                    foregroundColor: graph.accent
                    strokeWidth: 10
                }

                SvgIcon {
                    icon: graph.icon
                    color: ThemeManager.colors.text
                    size: parent.height - 35
                    anchors.centerIn: parent
                }
            }

            Text { // Percentage
                text: graph.percentage + (graph.temp ? "°C" : "%")
                color: ThemeManager.colors.subtext1
                font.family: ThemeManager.fonts.main
                font.pixelSize: 12
                Layout.alignment: Qt.AlignRight
            }
        }
    }
}