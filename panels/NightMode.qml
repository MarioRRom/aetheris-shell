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

            // Abajo de todo
            aboveWindows: true
            exclusionMode: ExclusionMode.Ignore
            
            // Fullscreen en cada monitor
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

            // Dimmer (Brillo - Negro con opacidad)
            Rectangle {
                anchors.fill: parent
                color: Qt.rgba(0, 0, 0, 0.15)
            }

            mask: Region {}
        }
    }
}