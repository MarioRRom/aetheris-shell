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
import Quickshell
import Quickshell.Services.SystemTray

Row {
    id: systray
    spacing: 6

    property var bar // Bar reference

    Repeater {
        model: SystemTray.items

        Rectangle {
            id: sysItem
            required property var modelData

            width: 20
            height: 20
            color: hoverArea.containsMouse ? "#20FFFFFF" : "transparent"
            radius: 3

            Behavior on color {
                ColorAnimation { duration: 150 }
            }

            Image {
                anchors.centerIn: parent
                width: 16
                height: 16
                source: sysItem.modelData.icon || ""
                smooth: true
                cache: false
            }

            MouseArea {
                id: hoverArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                acceptedButtons: Qt.LeftButton | Qt.RightButton

                onClicked: mouse => {
                    if (mouse.button === Qt.LeftButton) {
                        sysItem.modelData.activate()
                    } else if (mouse.button === Qt.RightButton && sysItem.modelData.hasMenu) {
                        // Calculate position just before opening
                        let globalPos = sysItem.mapToItem(systray.bar.contentItem, 0, 0)
                        menuAnchor.anchor.rect.x = globalPos.x
                        menuAnchor.anchor.rect.y = systray.bar.height
                        menuAnchor.open()
                    }
                }
            }

            QsMenuAnchor {
                id: menuAnchor
                menu: sysItem.modelData.menu
                anchor.window: systray.bar
                // Updated in onClick
            }
        }
    }
}