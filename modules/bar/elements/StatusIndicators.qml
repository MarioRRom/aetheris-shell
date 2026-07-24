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
import Quickshell.Widgets

// Config
import qs.components
import qs.themes
import qs.services

// Main Container Mouse Area
WrapperMouseArea {
    id: controlCenterArea
    height: parent.height - 12
    anchors.verticalCenter: parent.verticalCenter
    cursorShape: Qt.PointingHandCursor
    hoverEnabled: true

    // icons show text on hover
    property bool revealActive: false

    Timer {
        id: revealTimer
        interval: 1000
        onTriggered: controlCenterArea.revealActive = true
    }

    onContainsMouseChanged: {
        if (containsMouse) {
            revealTimer.restart()
        } else {
            revealTimer.stop()
            revealActive = false
        }
    }

    function revealNow() {
        revealTimer.stop()
        revealActive = true
    }

    // Click action
    onClicked: {
        controlCenterLoader.active = !controlCenterLoader.active
    }

    WrapperRectangle {
        id: controlCenterButton
        height: parent.height

        color: ThemeManager.colors.base
        radius: 24

        states: [
            State {
                name: "hovered"
                when: controlCenterArea.containsMouse
                PropertyChanges {
                    target: controlCenterButton
                    color: ThemeManager.colors.surface0
                }
            },
            State {
                name: "pressed"
                when: controlCenterArea.pressed
                PropertyChanges {
                    target: controlCenterButton
                    color: ThemeManager.colors.surface1
                }
            }
        ]

        Behavior on color {
            ColorAnimation {
                duration: 150
            }
        }

        Row {
            leftPadding: 8
            rightPadding: 8


            //  .-------------------------.
            //  | .---------------------. |
            //  | |     Networking      | |
            //  | `---------------------' |
            //  `-------------------------'
            
            ExpandableStatusItem {
                icon: Network.statusIcon
                color: ThemeManager.colors.mauve
                canReveal: controlCenterArea.revealActive
                valueText: Network.statusText
                maxWidthSample: Network.statusText
            }


            //  .-------------------------.
            //  | .---------------------. |
            //  | |        Audio        | |
            //  | `---------------------' |
            //  `-------------------------'

            ExpandableStatusItem {
                icon: Pipewire.icon
                color: Pipewire.muted ? ThemeManager.colors.red : ThemeManager.colors.green
                canReveal: controlCenterArea.revealActive
                valueText: Pipewire.volumePercent + "%"
                maxWidthSample: "100%"
                onWheelUp: {
                    Pipewire.incrementVolume()
                    controlCenterArea.revealNow()
                }
                onWheelDown: {
                    Pipewire.decrementVolume()
                    controlCenterArea.revealNow()
                }
            }


            //  .-------------------------.
            //  | .---------------------. |
            //  | |       Battery       | |
            //  | `---------------------' |
            //  `-------------------------'

            ExpandableStatusItem {
                icon: "hardware/battery"
                color: ThemeManager.colors.peach
                canReveal: controlCenterArea.revealActive
                valueText: "100%"
                maxWidthSample: "100%"
            }
        }
    }
}