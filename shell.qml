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


//@ pragma Env QSG_RENDER_LOOP=threaded
//@ pragma Env QT_QUICK_FLICKABLE_WHEEL_DECELERATION=10000
//@ pragma UseQApplication


//  .-------------------------.
//  | .---------------------. |
//  | |  Importar Modulos   | |
//  | `---------------------' |
//  `-------------------------'

// Quickshell
import QtQuick
import Quickshell

// Globales
import qs.config
import qs.panels
import qs.panels.background
import qs.panels.bar
import qs.modules.hyprland
import qs.modules.bspwm

ShellRoot {

    property string _session: (Quickshell.env("DESKTOP_SESSION") || Quickshell.env("XDG_CURRENT_DESKTOP") || "").toLowerCase()

    // Inicializar Sockets para asegurar que se carguen y apliquen configs
    property bool _initHyprSocket: _session.indexOf("hyprland") !== -1 ? HyprSocket.isActive : false
    property bool _initBspSocket: _session.indexOf("bspwm") !== -1 ? BspSocket.isActive : false

    property bool enableTopBar: true
    property bool enableBackground: true
    property bool enableNightMode: false

    LazyLoader {
        active: enableNightMode

        component: NightMode {
        }
    }

    LazyLoader {
        active: enableBackground

        component: Background {
        }

    }

    LazyLoader {
        active: enableTopBar

        component: TopBar {
        }

    }

    Loader {
        active: false

        sourceComponent: Activate {
        }

    }

}
