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
import qs.themes
import qs.services
import qs.services.bspwm
import qs.services.hyprland

WrapperRectangle {
    id: root
    
    property string monitorName

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
                    monitorName: root.monitorName
                }
            }
        }
        Loader {
            anchors.verticalCenter: parent.verticalCenter
            active: SystemStatus.desktop === "hyprland"
            sourceComponent: Component {
                HyprWorkspaces {
                    monitorName: root.monitorName
                }
            }
        }
    }
}