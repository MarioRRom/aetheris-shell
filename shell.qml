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
import Quickshell.Io

// Globales
import qs.config
import qs.panels
import qs.overlays.notifications
import qs.panels.background
import qs.panels.bar
import qs.modules
import qs.modules.hyprland
import qs.modules.bspwm


//  .-------------------------.
//  | .---------------------. |
//  | |     Shell Root      | |
//  | `---------------------' |
//  `-------------------------'

ShellRoot {
    // Obtener el Desktop en Ejecución, para cargar los Sockets.
    property string _session: (Quickshell.env("DESKTOP_SESSION") || Quickshell.env("XDG_CURRENT_DESKTOP") || "").toLowerCase()


    //  .-------------------------.
    //  | .---------------------. |
    //  | |    Shell Configs    | |
    //  | `---------------------' |
    //  `-------------------------'

    // Inicializar Sockets para asegurar que se carguen y apliquen configs
    property bool _initHyprSocket: _session.indexOf("hyprland") !== -1 ? HyprSocket.isActive : false
    property bool _initBspSocket: _session.indexOf("bspwm") !== -1 ? BspSocket.isActive : false


    property bool enableBar: true
    property bool enableBackground: true
    property bool enableActivate: false
    property bool enablePopups: true
    property bool enableNightMode: false


    //  .-------------------------.
    //  | .---------------------. |
    //  | |    Shell Windows    | |
    //  | `---------------------' |
    //  `-------------------------'

    LazyLoader {
        active: enableNightMode

        component: NightMode {
        }
    }

    // Quickshell Background
    // DISCLAIMER. all overlays are connected to this element.
    Background { id: background; isActivated: enableBackground }

    // Quickshell Bar
    TopBar { isActivated: enableBar }

    // Active Linux easter egg
    Loader {
        active: enableActivate

        sourceComponent: Activate {
        }

    }

    // Popup de Notificaciones.
    NotificationsPopup { isActivated: enablePopups; backgroundAnchor: background.backgroundAnchor }
    

    // Fix Stacking para BSPWM
    Process {
        id: fixStacking
        command: ["sh", Qt.resolvedUrl("scripts/fix_stacking.sh").toString().replace("file://", "")]
    }

    // Cargar Picom (X11)
    Loader {
        active: _session.indexOf("bspwm") !== -1
        sourceComponent: Picom {}
    }

    Component.onCompleted: {
        if (_session.indexOf("bspwm") !== -1) {
            fixStacking.running = true
        }
    }
}
