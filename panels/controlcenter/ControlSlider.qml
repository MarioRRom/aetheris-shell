//===========================================================================
//
//
//███╗   ███╗ █████╗ ██████╗ ██╗ ██████╗ ██████╗ ██████╗  ██████╗ ███╗   ███╗
//████╗ ████║██╔══██╗██╔══██╗██║██╔═══██╗██╔══██╗██╔══██╗██╔═══██╗████╗ ████║
//██╔████╔██║███████║██████╔╝██║██║   ██║██████╔╝██████╔╝██║   ██║██╔████╔██║
//██║╚██╔╝██║██╔══██║██╔══██╗██║██║   ██║██╔══██╗██╔══██╗██║   ██║██║╚██╔╝██║
//██║ ╚═╝ ██║██║  ██║██║  ██║██║╚██████╔╝██║  ██║██║  ██║╚██████╔╝██║ ╚═╝ ██║
//╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝ ╚═════╝ ╚═╝  ╚═╝ ╚═╝ ╚═╝ ╚═════╝ ╚═╝     ╚═╝                                                                          
//                          MarioRRom's Dotfiles
//                 https://github.com/MarioRRom/bspwm-dotfiles
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


Rectangle {
    id: sliderRoot
    color: "transparent"

    property var icon: "󰕾"
    property var accent: ThemeManager.colors.green
    property var gradient: ThemeManager.colors.teal

    property real value: 50
    property var updateCommand: null
    property var muteCommand: null

    Layout.fillWidth: true
    Layout.preferredHeight: 50

    // Decoraciones
    RectangularShadow {
        anchors.fill: parent
        radius: itemRadius
        color: Config.shadows.color

        blur: 3
        offset: Qt.vector2d(1, 1)
        spread: 0.0
        cached: true
    }

    Rectangle {
        anchors.fill: parent
        color: ThemeManager.colors.base
        radius: itemRadius
    }

    InnerLine {
        anchors.fill: parent
        lineradius: itemRadius
        linewidth: 1
        linecolor: ThemeManager.colors.surface0
    }
    
    // Slider
    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 15
        anchors.rightMargin: 15
        spacing: 15

        Text {
            text: icon
            font.family: ThemeManager.fonts.icons
            font.pixelSize: 24
            color: accent
            Layout.alignment: Qt.AlignVCenter
            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: if (sliderRoot.muteCommand) sliderRoot.muteCommand()
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.minimumWidth: 10
            height: 19
            radius: 20
            color: ThemeManager.colors.overlay0
            Layout.alignment: Qt.AlignVCenter
            border.width: 2
            border.color: ThemeManager.colors.surface0

            Rectangle {
                height: parent.height
                width: parent.width * (sliderRoot.value / 100)
                radius: 20
                gradient: Gradient {
                    orientation: Gradient.Horizontal
                    GradientStop {
                        position: 0.0
                        color: accent
                    }
                    GradientStop {
                        position: 1.0
                        color: gradient
                    }
                }

                Behavior on width {
                    NumberAnimation {
                        duration: 350
                        easing.type: Easing.OutQuint 
                    }
                }
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor

                function updateValue(mouseX) {
                    var newValue = Math.max(0, Math.min(100, (mouseX / width) * 100));
                    if (sliderRoot.updateCommand) sliderRoot.updateCommand(Math.round(newValue));
                }

                onPressed: (mouse) => updateValue(mouse.x)
                onPositionChanged: (mouse) => updateValue(mouse.x)
            }
        }

        Text {
            text: ""
            font.family: ThemeManager.fonts.icons
            font.pixelSize: 20
            color: ThemeManager.colors.text
            Layout.alignment: Qt.AlignVCenter 
        }
    }
}