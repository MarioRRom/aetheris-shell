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
import QtQuick.Layouts
import Quickshell

ShellRoot {
    Variants {
        // Create the panel once on each monitor.
        model: Quickshell.screens

        PanelWindow {
            id: w

            property var modelData
            screen: modelData

            anchors {
                right: true
                bottom: true
            }

            margins {
                right: 50
                bottom: 50
            }

            implicitWidth: content.width
            implicitHeight: content.height

            color: "transparent"

            // Give the window an empty click mask so all clicks pass through it.
            mask: Region {}

            ColumnLayout {
                id: content

                Text {
                    text: "Activate Linux"
                    color: "#50ffffff"
                    font.pointSize: 22
                }

                Text {
                    text: "Go to Settings to activate Linux"
                    color: "#50ffffff"
                    font.pointSize: 14
                }
            }
        }
    }
}