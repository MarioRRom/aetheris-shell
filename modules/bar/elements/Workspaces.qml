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
import Quickshell
import Quickshell.Widgets

// Config
import qs.themes
import qs.services
import qs.services.bspwm
import qs.services.hyprland

WrapperRectangle {
    color: ThemeManager.colors.base
    anchors.verticalCenter: parent.verticalCenter
    height: parent.height - 12
    radius: 10

    Row {
        leftPadding: 10
        rightPadding: 10

        Loader {
            anchors.verticalCenter: parent.verticalCenter
            active: SystemStatus.desktop === "bspwm"
            sourceComponent: Component {
                BspWorkspaces {
                    monitorName: modelData.name
                }
            }
        }
        Loader {
            anchors.verticalCenter: parent.verticalCenter
            active: SystemStatus.desktop === "hyprland"
            sourceComponent: Component {
                HyprWorkspaces {
                    monitorName: modelData.name
                }
            }
        }
    }
}