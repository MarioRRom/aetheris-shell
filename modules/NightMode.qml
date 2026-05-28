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
import Quickshell


Variants {
    id: root
    model: Quickshell.screens
    
    LazyLoader {
        active: true
        required property var modelData

        component: PanelWindow {
            visible: true
            id: bgRoot
            screen: modelData

            // Below everything
            aboveWindows: true
            exclusionMode: ExclusionMode.Ignore
            
            // Fullscreen on each monitor
            anchors {
                top: true
                bottom: true
                left: true
                right: true
            }
            
            color: "transparent"

            // Filtro Naranja Calido
            Rectangle {
                anchors.fill: parent
                color: Qt.rgba(1.0, 0.5, 0.3, 0.15)
            }

            // Dimmer (Brightness - Black with opacity)
            Rectangle {
                anchors.fill: parent
                color: Qt.rgba(0, 0, 0, 0.15)
            }

            mask: Region {}
        }
    }
}