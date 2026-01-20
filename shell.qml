//===========================================================================
//███╗   ███╗ █████╗ ██████╗ ██╗ ██████╗ ██████╗ ██████╗  ██████╗ ███╗   ███╗
//████╗ ████║██╔══██╗██╔══██╗██║██╔═══██╗██╔══██╗██╔══██╗██╔═══██╗████╗ ████║
//██╔████╔██║███████║██████╔╝██║██║   ██║██████╔╝██████╔╝██║   ██║██╔████╔██║
//██║╚██╔╝██║██╔══██║██╔══██╗██║██║   ██║██╔══██╗██╔══██╗██║   ██║██║╚██╔╝██║
//██║ ╚═╝ ██║██║  ██║██║  ██║██║╚██████╔╝██║  ██║██║  ██║╚██████╔╝██║ ╚═╝ ██║
//╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝ ╚═════╝ ╚═╝  ╚═╝ ╚═╝ ╚═╝ ╚═════╝ ╚═╝     ╚═╝
//                          MarioRRom's Dotfiles
//                 https://github.com/MarioRRom/bspwm-dotfiles
//===========================================================================

//@ pragma Env QSG_RENDER_LOOP=threaded
//@ pragma Env QT_QUICK_FLICKABLE_WHEEL_DECELERATION=10000
//@ pragma UseQApplication

import QtQuick
import Quickshell
import qs.panels
import qs.panels.background
import qs.panels.bar

ShellRoot {
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
