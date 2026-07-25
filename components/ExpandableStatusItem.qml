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

// An expandable status item that shows an icon and a text when hovered over.
// It can also handle mouse wheel events to trigger actions like volume control.


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

WrapperMouseArea {
    id: statusItem

    // Variables
    required property string icon
    required property string valueText
    required property string maxWidthSample
    required property bool canReveal

    // Appearance
    property color color: ThemeManager.colors.text
    property int iconSize: 18
    property int animationDuration: 550

    cursorShape: Qt.PointingHandCursor
    anchors.verticalCenter: parent.verticalCenter
    hoverEnabled: true
    acceptedButtons: Qt.NoButton

    // Wheel Signals (optional).
    signal wheelUp()
    signal wheelDown()

    onWheel: (wheel) => {
        if (wheel.angleDelta.y > 0) {
            statusItem.wheelUp()
        } else if (wheel.angleDelta.y < 0) {
            statusItem.wheelDown()
        }
        wheel.accepted = true
    }


    //  .-------------------------.
    //  | .---------------------. |
    //  | |     Status Item     | |
    //  | `---------------------' |
    //  `-------------------------'

    Row {
        spacing: 0
        leftPadding: 2
        rightPadding: 2
        anchors.verticalCenter: parent.verticalCenter

        // Status Icon
        SvgIcon {
            icon: statusItem.icon
            color: statusItem.color
            size: statusItem.iconSize
            anchors.verticalCenter: parent.verticalCenter
        }


        //  .-------------------------.
        //  | .---------------------. |
        //  | | Expandable Section  | |
        //  | `---------------------' |
        //  `-------------------------'

        Text {
            id: valueLabel
            text: statusItem.valueText
            font.pixelSize: 12
            font.family: ThemeManager.fonts.main
            color: statusItem.color
            anchors.verticalCenter: parent.verticalCenter
            clip: true

            TextMetrics {
                id: maxWidthMetrics
                font: valueLabel.font
                text: statusItem.maxWidthSample
            }

            width: (statusItem.containsMouse && statusItem.canReveal) ? maxWidthMetrics.width : 0
            opacity: (statusItem.containsMouse && statusItem.canReveal) ? 1 : 0

            Behavior on width {
                NumberAnimation { duration: statusItem.animationDuration; easing.type: Easing.OutCubic }
            }
            Behavior on opacity {
                NumberAnimation { duration: statusItem.animationDuration; easing.type: Easing.OutCubic }
            }
        }
    }
}