//===========================================================================
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
import Quickshell
import Quickshell.Widgets


// Config
import qs.config
import qs.themes
import qs.components


//  .-------------------------.
//  | .---------------------. |
//  | |    Button Preset    | |
//  | `---------------------' |
//  `-------------------------'

WrapperMouseArea {
    id: button

    // Import properties
    property int btnHeight
    property var btnText
    property var icon
    property var command
    property var hoverColor
    property var beforeCommand: null

    // Config
    height: btnHeight
    cursorShape: Qt.PointingHandCursor
    hoverEnabled: true

    // Acciones
    onClicked: {
        if (beforeCommand) beforeCommand()
        if (command) Quickshell.execDetached(command);
    }


    //  .-------------------------.
    //  | .---------------------. |
    //  | |    Button Layout    | |
    //  | `---------------------' |
    //  `-------------------------'

    Rectangle {
        id: buttonContainer
        color: "transparent"

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
    
        Rectangle {
            id: buttonRectangle

            // Config
            anchors.fill: parent
            color: ThemeManager.colors.base
            radius: itemRadius
            clip: true

            // Decoration
            InnerLine {
                anchors.fill: parent
                lineradius: itemRadius
                linewidth: 1
                linecolor: ThemeManager.colors.surface0
            }

            // Coloring for Hover and Pressed
            Rectangle {
                id: colorOverlay
                anchors.fill: parent
                radius: itemRadius
                color: "transparent"

                Behavior on color {
                    ColorAnimation {
                        duration: 250
                    }
                }
                Behavior on opacity {
                    NumberAnimation {
                        duration: 250
                    }
                }
            }

            // Content 
            Row {
                spacing: 5
                anchors.centerIn: parent

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: icon
                    color: ThemeManager.colors.text
                    font.family: ThemeManager.fonts.icons
                    font.pixelSize: 15
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: btnText
                    color: ThemeManager.colors.text
                    font.family: ThemeManager.fonts.main
                    font.pixelSize: 15
                }

            }
        }

        states: [
            State {
            name: "hovered"
            when: button.containsMouse && !button.pressed
            PropertyChanges {
                target: colorOverlay
                color: hoverColor
                opacity: 0.3 // Hover opacity (30%)
            }
            },
            State {
            name: "pressed"
            when: button.pressed
            PropertyChanges {
                target: colorOverlay
                color: hoverColor
                opacity: 0.8
            }
            }
        ]
    }
}
