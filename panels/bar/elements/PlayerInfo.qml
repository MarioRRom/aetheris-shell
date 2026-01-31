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

// Globales
import qs.modules
import qs.themes
Item {
    id: player
    visible: Mpris.status
    anchors.verticalCenter: parent.verticalCenter
    width: 190
    height: parent.height
    
    // Mouse Actions //
    MouseArea {
        id: playerArea
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        cursorShape: Qt.PointingHandCursor

        onClicked: (mouse) => {
            if (mouse.button === Qt.LeftButton) {
                let gx = player.mapToItem(topBarRoot.contentItem, 0, 0).x

                conPlayerLoader.active = !conPlayerLoader.active

                if (conPlayerLoader.active && conPlayerLoader.item) {
                    conPlayerLoader.item.globalPos = gx
                }
            } else if (mouse.button === Qt.RightButton) {
                Mpris.playpause()
            }
        }
    }

    

    // Media Player Status //
    Row {
        anchors.fill: parent
        spacing: 5

        // Media Player Status Icon //
        Text {
            id: statusIcon
            anchors.verticalCenter: parent.verticalCenter
            text: "󰎆"
            color: Mpris.isPaused ? ThemeManager.colors.yellow : ThemeManager.colors.green
            font.family: ThemeManager.fonts.icons
            font.pixelSize: 16

            Behavior on color { ColorAnimation { duration: 200 } }
        }

        // Music Title //
        Rectangle {
            id: playerTitleArea
            anchors.verticalCenter: parent.verticalCenter
            

            width: parent.width - statusIcon.width - parent.spacing
            height: parent.height

            color: "transparent"
            clip: true
            
            Text {
                id: titleText
                anchors.verticalCenter: parent.verticalCenter
                text: Mpris.title
                color: Mpris.isPaused ? ThemeManager.colors.yellow : ThemeManager.colors.green
                font.family: ThemeManager.fonts.main
                font.pixelSize: 14

                Behavior on color { ColorAnimation { duration: 200 } }
                x: 0
            }

            SequentialAnimation {
                id: marqueeAnimation
                loops: Animation.Infinite
                running: titleText.paintedWidth > 160
                PauseAnimation {
                    duration: 1000
                }
                NumberAnimation {
                    target: titleText
                    property: "x"
                    from: 0
                    to: 160 - titleText.paintedWidth
                    duration: 8000
                }
                PauseAnimation {
                    duration: 1000
                }
                NumberAnimation {
                    target: titleText
                    property: "x"
                    from: 160 - titleText.paintedWidth
                    to: 0
                    duration: 8000
                }
            }

            Connections {
                target: titleText
                function onTextChanged() {
                marqueeAnimation.stop();
                titleText.x = 0;
                if (titleText.paintedWidth > 160) {
                    marqueeAnimation.start();
                }
                }
            }
        }
    }
}