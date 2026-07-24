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

//@ pragma Env QT_FFMPEG_DECODING_HW_DEVICE_TYPES=vaapi,vdpau
//@ pragma Env QT_FFMPEG_ENCODING_HW_DEVICE_TYPES=vaapi,vdpau
//@ pragma UseQApplication


//  .-------------------------.
//  | .---------------------. |
//  | |   Import Modules    | |
//  | `---------------------' |
//  `-------------------------'

// Quickshell
pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Io

// Config
import qs.config
import qs.modules
import qs.modules.overlays.notifications
import qs.modules.background
import qs.modules.bar

// WM Integrations
import qs.services.hyprland
import qs.services.bspwm


//  .-------------------------.
//  | .---------------------. |
//  | |     Shell Root      | |
//  | `---------------------' |
//  `-------------------------'

ShellRoot {
    // Session detection
    readonly property string _session: (Quickshell.env("DESKTOP_SESSION") || Quickshell.env("XDG_CURRENT_DESKTOP") || "").toLowerCase()


    //  .-------------------------.
    //  | .---------------------. |
    //  | |    Shell Configs    | |
    //  | `---------------------' |
    //  `-------------------------'

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

    // Notifications Popup.
    NotificationsPopup {
        isActivated: enablePopups
        backgroundAnchor: background.backgroundAnchor
    }


    //  .-------------------------.
    //  | .---------------------. |
    //  | |    X11 Additional   | |
    //  | `---------------------' |
    //  `-------------------------'

    // Fix Stacking for BSPWM
    Process {
        id: fixStacking
        command: ["sh", Qt.resolvedUrl("scripts/fix_stacking.sh").toString().replace("file://", "")]
    }

    // Load Picom (X11)
    Loader {
        active: _session.indexOf("bspwm") !== -1
        sourceComponent: Picom {}
    }


    //  .-------------------------.
    //  | .---------------------. |
    //  | |   WM Integrations   | |
    //  | `---------------------' |
    //  `-------------------------'

    Component.onCompleted: {
        // Hyprland
        if (_session.indexOf("hyprland") !== -1) {
            // Initialize the socket
            HyprSocket.session = _session
        }

        // Bspwm
        if (_session.indexOf("bspwm") !== -1) {
            // Initialize the socket
            BspSocket.session = _session
            // Apply fix for stacking
            fixStacking.running = true
        }
    }
}