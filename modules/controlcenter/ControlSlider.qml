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
import QtQuick.Effects

// Config
import qs.config
import qs.components
import qs.themes


Rectangle {
    id: sliderRoot
    color: "transparent"

    property var cornerRadius

    property var icon: "hardware/speaker"
    property var accent: ThemeManager.colors.green
    property var gradientColor: ThemeManager.colors.teal

    property real value: 50
    property var updateCommand: null
    property var muteCommand: null

    Layout.fillWidth: true
    Layout.preferredHeight: 50

    // Shadow
    RectangularShadow {
        anchors.fill: parent
        radius: sliderRoot.cornerRadius
        color: Config.shadows.color

        blur: 3
        offset: Qt.vector2d(1, 1)
        spread: 0.0
        cached: true
    }

    // Background
    Rectangle {
        anchors.fill: parent
        color: ThemeManager.colors.base
        radius: sliderRoot.cornerRadius
        clip: true

        // Decoration
        InnerLine {
            anchors.fill: parent
            lineradius: sliderRoot.cornerRadius
            linewidth: 1
            linecolor: ThemeManager.colors.surface0
        }
    }

    // Slider
    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 15
        anchors.rightMargin: 15
        spacing: 15

        SvgIcon {
            icon: sliderRoot.icon
            size: 24
            color: sliderRoot.accent
            Layout.alignment: Qt.AlignVCenter
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: if (sliderRoot.muteCommand) sliderRoot.muteCommand()
            }
        }

        HorizontalSlider {
            value: sliderRoot.value
            accent: sliderRoot.accent
            gradientColor: sliderRoot.gradientColor
            usePercentage: true
            updateCommand: sliderRoot.updateCommand
        }

        SvgIcon {
            icon: "general/settings"
            size: 24
            color: ThemeManager.colors.text
            Layout.alignment: Qt.AlignVCenter
        }
    }
}