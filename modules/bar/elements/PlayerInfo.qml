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

// Config
import qs.services
import qs.themes
import qs.components

Item {
    id: player
    visible: Mpris.status
    anchors.verticalCenter: parent.verticalCenter
    width: 190
    height: parent.height

    property var bar
    property var loader

    // Mouse Actions
    MouseArea {
        id: playerArea
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        cursorShape: Qt.PointingHandCursor

        onClicked: (mouse) => {
            if (mouse.button === Qt.LeftButton) {
                let gx = player.mapToItem(player.bar.contentItem, 0, 0).x

                player.loader.active = !player.loader.active

                if (player.loader.active && player.loader.item) {
                    player.loader.item.globalPos = gx
                }
            } else if (mouse.button === Qt.RightButton) {
                Mpris.playpause()
                player.loader.active = false
            }
        }
    }



    // Media Player Status
    Row {
        anchors.fill: parent
        spacing: 5

        // Media Player Status Icon
        SvgIcon {
            id: statusIcon
            icon: "media/genres"
            size: 18
            color: Mpris.isPaused ? ThemeManager.colors.yellow : ThemeManager.colors.green
            anchors.verticalCenter: parent.verticalCenter

            Behavior on color { ColorAnimation { duration: 200 } }
        }

        // Music Title
        MarqueeText {
            id: playerTitleArea
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width - statusIcon.width - parent.spacing
            height: parent.height
            text: Mpris.title
            color: Mpris.isPaused ? ThemeManager.colors.yellow : ThemeManager.colors.green
            font.family: ThemeManager.fonts.main
            font.pixelSize: 14

            Behavior on color { ColorAnimation { duration: 200 } }
        }
    }
}