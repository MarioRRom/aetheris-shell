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

ShellRoot {
    // Obtener el Desktop en Ejecución, para cargar los Sockets.
    property string _session: (Quickshell.env("DESKTOP_SESSION") || Quickshell.env("XDG_CURRENT_DESKTOP") || "").toLowerCase()

    // Inicializar Sockets para asegurar que se carguen y apliquen configs
    property bool _initHyprSocket: _session.indexOf("hyprland") !== -1 ? HyprSocket.isActive : false
    property bool _initBspSocket: _session.indexOf("bspwm") !== -1 ? BspSocket.isActive : false


    property bool enableBar: true
    property bool enableBackground: true
    property bool enableNightMode: false

    LazyLoader {
        active: enableNightMode

        component: NightMode {
        }
    }

    // Quickshell Background
    Background { isActivated: enableBackground }

    // Quickshell Bar
    TopBar { isActivated: enableBar }

    Loader {
        active: false

        sourceComponent: Activate {
        }

    }
    
    // Popup de Notificaciones.
    NotificationsPopup {}

    // Fix Stacking para BSPWM
    Process {
        id: fixStacking
        command: ["sh", Qt.resolvedUrl("scripts/fix_stacking.sh").toString().replace("file://", "")]
    }

    Component.onCompleted: {
        if (_session.indexOf("bspwm") !== -1) {
            fixStacking.running = true
        }
    }
}
