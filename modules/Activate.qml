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
import QtQuick.Layouts
import Quickshell

// Config
import qs.i18n

ShellRoot {
    id: root

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
                    text: LanguageManager.t("activate.title")
                    color: "#50ffffff"
                    font.pointSize: 22
                }

                Text {
                    text: LanguageManager.t("activate.subtitle")
                    color: "#50ffffff"
                    font.pointSize: 14
                }
            }
        }
    }
}